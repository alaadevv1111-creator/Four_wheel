import 'package:get/get.dart';

import 'package:four_wheels/models/driver_bookingmodel.dart';
import 'package:four_wheels/services/Booking_service.dart';

class DriverTasksController extends GetxController {
  final pendingTasks = <DriverBookingTaskModel>[].obs;
  final inProgressTasks = <DriverBookingTaskModel>[].obs;
  final completedTasks = <DriverBookingTaskModel>[].obs;
  final ratedTrips = <String, int>{}.obs;

  final selectedTabIndex = 0.obs;
  final isLoading = false.obs;

  // "Current" بدل "Pending" لمطابقة التصميم - الـ badge جوا الكارد
  // ("PENDING") ضل متل ما هو، بس اسم التاب نفسه تغيّر.
  final tabs = [
    'Current',
    'In Progress',
    'Completed',
  ];

  @override
  void onInit() {
    super.onInit();
    loadPendingTasks();
    _syncRatingsFromTasks(); // ← أضيفي هذا السطر
  }

  List<DriverBookingTaskModel> get currentTasks {
    if (selectedTabIndex.value == 0) return pendingTasks;
    if (selectedTabIndex.value == 1) return inProgressTasks;
    return completedTasks;
  }

  Future<void> changeTab(int index) async {
    selectedTabIndex.value = index;

    if (index == 0) {
      await loadPendingTasks();
    } else if (index == 1) {
      await loadInProgressTasks();
    } else {
      await loadCompletedTasks();
    }
  }

  Future<void> refreshCurrentTab() async {
    await changeTab(selectedTabIndex.value);
  }

  Future<void> loadPendingTasks() async {
    await _loadTasks(
      apiStatus: 'active',
      target: pendingTasks,
    );
  }

  Future<void> loadInProgressTasks() async {
    await _loadTasks(apiStatus: 'in_progress', target: inProgressTasks);
  }

  Future<void> loadCompletedTasks() async {
    await _loadTasks(
      apiStatus: 'completed',
      target: completedTasks,
    );

    // إعادة تحميل التقييمات من الـ tasks بعد التحميل
    for (var task in completedTasks) {
      if (task.tripRating != null) {
        ratedTrips[task.id] = task.tripRating!;
      }
    }
  }

  Future<void> _loadTasks({
    required String apiStatus,
    required RxList<DriverBookingTaskModel> target,
  }) async {
    isLoading.value = true;

    try {
      final result = await BookingService.getDriverBookings(
        status: apiStatus,
      );

      if (result['success'] == true) {
        final bookings = result['bookings'];

        if (bookings is List<DriverBookingTaskModel>) {
          target.assignAll(bookings);
        } else {
          target.clear();
        }
      } else {
        target.clear();

        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to load trips',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> startTrip(String id) async {
    if (isLoading.value) return false;

    isLoading.value = true;

    try {
      final result = await BookingService.startDriverBooking(id: id);

      if (result['success'] == true) {
        pendingTasks.removeWhere((item) => item.id == id);

        await loadPendingTasks();
        await loadInProgressTasks();

        selectedTabIndex.value = 1;

        Get.snackbar(
          'Success',
          result['message'] ?? 'Trip started',
          snackPosition: SnackPosition.BOTTOM,
        );

        return true;
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to start trip',
          snackPosition: SnackPosition.BOTTOM,
        );

        return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> completeTrip(String id) async {
    if (isLoading.value) return false;

    isLoading.value = true;

    try {
      final result = await BookingService.completeDriverBooking(id: id);

      if (result['success'] == true) {
        inProgressTasks.removeWhere((item) => item.id == id);

        await loadInProgressTasks();
        await loadCompletedTasks();

        selectedTabIndex.value = 2;

        Get.snackbar(
          'Success',
          result['message'] ?? 'Trip completed',
          snackPosition: SnackPosition.BOTTOM,
        );

        return true;
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to complete trip',
          snackPosition: SnackPosition.BOTTOM,
        );

        return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // نفس نمط My Orders / الميكانيكي بالضبط: نقفل فوراً جوا الكنترولر
  // (ratedTrips) بدل ما نعتمد على حالة الشاشة المحلية أو على
  // task.tripRating يلي بيضيع لما تسكّري الصفحة وترجعي تفتحيها.
  // ============================================================
  Future<bool> rateTrip({
    required DriverBookingTaskModel task,
    required int rating,
  }) async {
    if (ratedTrips.containsKey(task.id) || task.tripRating != null) {
      Get.snackbar('Already Rated', 'You have already rated this trip.');
      return false;
    }

    if (!_canRate(task)) {
      Get.snackbar('Rating Closed', '24 hours rating period has expired.');
      return false;
    }

    // حفظ محلي فوري
    ratedTrips[task.id] = rating;

    // تحديث المهمة في completedTasks
    final index = completedTasks.indexWhere((item) => item.id == task.id);
    if (index != -1) {
      completedTasks[index] = completedTasks[index].copyWith(tripRating: rating);
      completedTasks.refresh();
    }

    // إرسال للسيرفر
    final result = await BookingService.rateUserByDriver(
      id: task.id,
      rating: rating,
    );

    if (result['success'] == true) {
      Get.snackbar('Success', 'Rating submitted successfully');
      return true;
    } else {
      // rollback لو فشل
      ratedTrips.remove(task.id);
      Get.snackbar('Error', result['message'] ?? 'Failed to save rating');
      return false;
    }
  }
  String _displayStatus(String status) {
    final value = status.toLowerCase().trim();

    if (value == 'in_progress') {
      return 'In progress';
    }

    if (value == 'completed') {
      return 'Completed';
    }

    if (value == 'rejected' || value == 'cancelled' || value == 'canceled') {
      return 'Rejected';
    }

    // 'pending' و 'active' (الأدمن وافق بس الدرايفر لسا ما بلش) كلاهما Pending
    return 'Pending';
  }

  bool _canRate(DriverBookingTaskModel task) {
    // لو قيّم قبل هيك، ممنوع يقيم مرة ثانية
    if (task.tripRating != null) return false;

    // لو الباك رجّع completed_at، نطبق شرط 24 ساعة
    if (task.completedAt != null) {
      final diff = DateTime.now().difference(task.completedAt!);
      return diff.inHours < 24;
    }

    // لو لسه عامل Complete الآن والباك ما رجّع completed_at فورًا
    // نخلي التقييم يمر لأن الزر أصلاً ما بظهر إلا بعد complete
    return true;
  }
  void _syncRatingsFromTasks() {
    for (var task in completedTasks) {
      if (task.tripRating != null) {
        ratedTrips[task.id] = task.tripRating!;
      }
    }
  }
}