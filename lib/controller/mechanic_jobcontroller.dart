import 'package:get/get.dart';

import 'package:four_wheels/models/mechanic_jobmodel.dart';
import 'package:four_wheels/services/mechanic_jobService.dart';

class MechanicJobsController extends GetxController {
  final jobs = <MechanicJobModel>[].obs;
  final ratedCustomerJobs = <String, int>{}.obs;

  final isLoading = false.obs;
  final selectedTabIndex = 0.obs;

  final tabs = [
    'Current',
    'In Progress',
    'Completed',
  ];

  @override
  void onInit() {
    super.onInit();
    loadJobs();
  }

  List<MechanicJobModel> get filteredJobs {
    final index = selectedTabIndex.value;

    return jobs.where((job) {
      if (index == 0) {
        return job.isPending;
      }

      if (index == 1) {
        return job.isInProgress;
      }

      return job.isCompleted;
    }).toList();
  }

  Future<void> loadJobs() async {
    isLoading.value = true;

    try {
      final result = await MechanicJobService.getJobs();

      if (result['success'] == true) {
        final list = result['jobs'];

        if (list is List<MechanicJobModel>) {
          jobs.assignAll(list);

          // نعبّي ratedCustomerJobs من بيانات السيرفر نفسها (لو رجّعت
          // customerRating فعلي) - هيك حتى لو التطبيق اتقفل وفتح من
          // جديد، التقييمات القديمة بتظهر عرض ثابت صح.
          for (final job in list) {
            if (job.customerRating != null) {
              ratedCustomerJobs[job.id] = job.customerRating!;
            }
          }
        } else {
          jobs.clear();
        }
      } else {
        jobs.clear();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  Future<bool> startJob(String id) async {
    final result = await MechanicJobService.startJob(id);

    if (result['success'] == true) {
      final index = jobs.indexWhere((job) => job.id == id);

      if (index != -1) {
        // القيمة الحقيقية الراجعة من الباك إند هي 'inprogress' (بدون فاصل)
        jobs[index] = jobs[index].copyWith(status: 'inprogress');
        jobs.refresh();
      }

      await loadJobs();
      return true;
    }

    Get.snackbar(
      'Error',
      result['message'] ?? 'Failed to start job',
      snackPosition: SnackPosition.BOTTOM,
    );

    return false;
  }

  Future<bool> completeJob(String id) async {
    final result = await MechanicJobService.completeJob(id);

    if (result['success'] == true) {
      final index = jobs.indexWhere((job) => job.id == id);

      if (index != -1) {
        jobs[index] = jobs[index].copyWith(status: 'completed');
        jobs.refresh();
      }

      await loadJobs();
      return true;
    }

    Get.snackbar(
      'Error',
      result['message'] ?? 'Failed to complete job',
      snackPosition: SnackPosition.BOTTOM,
    );

    return false;
  }

  Future<MechanicJobModel?> getJobDetails(String id) async {
    final result = await MechanicJobService.getJobDetails(id);

    if (result['success'] == true && result['job'] is MechanicJobModel) {
      return result['job'];
    }

    return null;
  }

  // ============================================================
  // مطابق تماماً لنمط My Orders/الدرايفر: نقفل فوراً جوا الكنترولر
  // (ratedCustomerJobs) بدل ما نعتمد بس على job.customerRating يلي
  // بيضيع لو الشاشة انسكرت وفتحت من جديد وGetX مسح الكنترولر القديم.
  // ============================================================
  Future<bool> rateCustomer({
    required String jobId,
    required int rating,
  }) async {
    if (ratedCustomerJobs.containsKey(jobId)) {
      Get.snackbar(
        'Rating Closed',
        'You can rate this customer only once after completion.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // نقفل فوراً بدون انتظار السيرفر
    ratedCustomerJobs[jobId] = rating;

    final index = jobs.indexWhere((job) => job.id == jobId);
    if (index != -1) {
      jobs[index] = jobs[index].copyWith(customerRating: rating);
      jobs.refresh();
    }

    final result = await MechanicJobService.rateCustomer(
      jobId: jobId,
      rating: rating,
    );

    if (result['success'] != true) {
      Get.snackbar(
        'Error',
        result['message']?.toString().isNotEmpty == true
            ? result['message'].toString()
            : 'Failed to submit rating',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    return true;
  }
}