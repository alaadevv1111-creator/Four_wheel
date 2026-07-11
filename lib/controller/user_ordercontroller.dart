import 'package:flutter/material.dart';
import 'package:four_wheels/models/service_ordermodel.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:four_wheels/models/booking_review.dart';
import 'package:four_wheels/models/user_ordermodel.dart';
import 'package:four_wheels/models/service_requestordermodel.dart';
import 'package:four_wheels/services/Booking_service.dart';
import 'package:four_wheels/models/admin_accecoryorder.dart';
import 'package:four_wheels/services/admin_accsesoryorder.dart';
import 'package:four_wheels/models/user_accisorryorder.dart';
import 'package:four_wheels/services/user_accsissorderservice.dart';
import 'package:four_wheels/services/employye_service.dart';

class UserOrdersController extends GetxController {
  final searchController = TextEditingController();
  final adminAccessoryOrders = <AdminAccessoryOrderModel>[].obs; // خاص بشاشة الأدمن
  final userAccessoryOrders = <UserAccessoryOrderModel>[].obs; // خاص بشاشة اليوزر
  final selectedCategoryIndex = 0.obs; // Car Rental
  final selectedStatusIndex = 0.obs; // Pending
  final searchText = ''.obs;
  final selectedMechanicId = ''.obs;
  final isLoading = false.obs;

  final categoryTabs = [
    'Car Rentals',
    'Accessorise',
    'Services',
  ];

  final statusTabs = [
    'Pending',
    'In progress',
    'Completed',
  ];

  final ratedAccessoryOrders = <String, int>{}.obs;
  final ratedCarOrders = <String, int>{}.obs;
  final ratedDriverOrders = <String, int>{}.obs;
  final ratedServiceOrders = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentOrders();
  }

  final serviceOrders = <ServiceOrderModel>[].obs;

  final orders = <UserOrderModel>[].obs;

  // ============ ADMIN ACCESSORY ORDERS ============

  Future<void> loadAccessoryOrders() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        AdminAccessoryOrderService.getOrdersByStatus('pending'),
        AdminAccessoryOrderService.getOrdersByStatus('active'),
        AdminAccessoryOrderService.getOrdersByStatus('completed'),
      ]);

      final List<AdminAccessoryOrderModel> merged = [];

      for (final result in results) {
        if (result['success'] == true) {
          merged.addAll(result['orders'] as List<AdminAccessoryOrderModel>);
        }
      }

      adminAccessoryOrders.assignAll(merged);
    } catch (e) {
      debugPrint("Load Accessory Orders Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void changeCategory(int index) {
    selectedCategoryIndex.value = index;
    loadCurrentOrders();
  }

  void changeStatus(int index) {
    selectedStatusIndex.value = index;
    if (selectedCategoryIndex.value != 1) {
      loadCurrentOrders();
    }
    // القسم 1 (Accessories) ما يحتاج إعادة جلب - الفلترة محلية
  }

  void onSearchChanged(String value) {
    searchText.value = value;
  }

  void showCarRentalPending() {
    selectedCategoryIndex.value = 0;
    selectedStatusIndex.value = 0;
  }

  void showCancelServiceAlert(String id) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xffFFF2CC),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xffB45309),
                  size: 34,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Cancel Order?',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff101828),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Are you sure you want to cancel this service order?',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff64748B),
                ),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xffF1F2F4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'No, Keep',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xff101828),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back(); // يسكر alert
                        cancelServiceOrder(id);
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xff334155),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'Yes, Cancel',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> cancelServiceOrder(
      String id, {
        bool popPage = false,
      }) async {
    final result = await BookingService.cancelUserServiceOrder(id: id);

    if (result['success'] == true) {
      serviceOrders.removeWhere((order) => order.id == id);

      if (popPage) {
        Get.back();
      }

      Get.snackbar(
        'Order Cancelled',
        result['message']?.toString().isNotEmpty == true
            ? result['message'].toString()
            : 'Your service order has been cancelled.',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadServiceOrders();
    } else {
      Get.snackbar(
        'Error',
        result['message'] ?? 'Failed to cancel service order',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void showCancelAccessoryAlert(String id) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xffFFF2CC),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xffB45309),
                  size: 34,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Cancel Order?',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff101828),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Are you sure you want to cancel this accessory order?',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff64748B),
                ),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xffF1F2F4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'No, Keep',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xff101828),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back(); // يسكر alert

                        adminAccessoryOrders.removeWhere(
                              (order) => order.id == id,
                        );

                        Get.back(); // يرجع من صفحة التفاصيل

                        Get.snackbar(
                          'Order Cancelled',
                          'Your accessory order has been cancelled.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xff334155),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'Yes, Cancel',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> loadCurrentOrders() async {
    if (selectedCategoryIndex.value == 0) {
      await loadRentalOrders();
    } else if (selectedCategoryIndex.value == 1) {
      await loadAccessoryOrders();
    } else if (selectedCategoryIndex.value == 2) {
      await loadServiceOrders();
    }
  }

  String get _selectedApiStatus {
    if (selectedStatusIndex.value == 0) return 'pending';
    if (selectedStatusIndex.value == 1) return 'active';
    return 'completed';
  }

  // خاص بطلبات الخدمة بس - الباك إند بيستخدم 'inprogress' (بدون فاصل)
  // لهاي تحديداً، مش 'active' متل الحجوزات.
  String get _selectedServiceApiStatus {
    if (selectedStatusIndex.value == 0) return 'pending';
    if (selectedStatusIndex.value == 1) return 'inprogress';
    return 'completed';
  }

  String _displayStatus(String status) {
    final value = status.toLowerCase().trim();

    if (value == 'in_progress' || value == 'inprogress' || value == 'in progress') {
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

  // خاصة بطلبات الخدمة (Services) بس - "active" (قبول الأدمن) لسا Pending
  // لليوزر، وبس "in_progress" (الميكانيكي دوس Start Repair فعلياً) بتصير
  // "In progress".
  // مصحح: تأكد إنه الباك إند بيستخدم 'active' كقيمة فعلية بعد ما الميكانيكي
  // يدوس Start Repair (نفس القيمة المستخدمة بكل الحجوزات بالنظام)، مش
  // 'in_progress' حرفياً - فلازم 'active' هون تتحسب In Progress.
  // خاص بطلبات الخدمة (Services) بس - "active" (قبول الأدمن) لسا Pending
  // لليوزر، وبس "inprogress" (الميكانيكي دوس Start Repair فعلياً) بتصير
  String _displayServiceStatus(String status) {
    final value = status.toLowerCase().trim();

    if (value == 'inprogress' || value == 'in_progress' || value == 'in progress') {
      return 'In progress';
    }
    if (value == 'completed') return 'Completed';
    if (value == 'rejected' || value == 'cancelled' || value == 'canceled') return 'Rejected';

    // 'pending' و 'active' كلاهما لسا Pending لليوزر
    return 'Pending';
  }

  Future<void> loadRentalOrders() async {
    isLoading.value = true;

    try {
      List<Map<String, dynamic>> allOrders = [];

      if (selectedStatusIndex.value == 0) {
        // Pending tab: pending (الأدمن لسا ما وافق) + active (وافق بس الدرايفر لسا ما بلش)
        final pendingResult = await BookingService.getUserRentalOrders(status: 'pending');
        final activeResult = await BookingService.getUserRentalOrders(status: 'active');

        if (pendingResult['success'] == true) {
          final list = pendingResult['orders'];
          if (list is List) allOrders.addAll(list.whereType<Map<String, dynamic>>());
        }
        if (activeResult['success'] == true) {
          final list = activeResult['orders'];
          if (list is List) allOrders.addAll(list.whereType<Map<String, dynamic>>());
        }
      } else if (selectedStatusIndex.value == 1) {
        // In progress tab: الدرايفر فعلياً دوس Start
        // ⚠️ جربت الاحتمالين الشائعين "in_progress" و "inprogress" -
        // احذف يلي مش مستخدم عندك بالباك اند فعلياً
        final results = await Future.wait([
          BookingService.getUserRentalOrders(status: 'in_progress'),
          BookingService.getUserRentalOrders(status: 'inprogress'),
        ]);

        for (final result in results) {
          if (result['success'] == true) {
            final list = result['orders'];
            if (list is List) allOrders.addAll(list.whereType<Map<String, dynamic>>());
          }
        }
      } else {
        final result = await BookingService.getUserRentalOrders(status: 'completed');
        if (result['success'] == true) {
          final list = result['orders'];
          if (list is List) allOrders.addAll(list.whereType<Map<String, dynamic>>());
        }
      }

      orders.assignAll(allOrders.map(_rentalOrderFromJson).toList());
    } catch (e) {
      debugPrint("Load Rental Orders Error: $e");
      orders.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // فلترة "Services" لليوزر:
  // - تاب Pending: نجمع pending + active (يعني قبل ما الميكانيكي يبلش)
  // - تاب In progress: بس in_progress (الميكانيكي فعلياً دوس Start Repair)
  // - تاب Completed: زي ما هي
  // ============================================================
  Future<void> loadServiceOrders() async {
    isLoading.value = true;

    try {
      List<Map<String, dynamic>> allOrders = [];

      if (selectedStatusIndex.value == 0) {
        // Pending tab: pending (لسا الأدمن ما وافق) + active (وافق بس الميكانيكي لسا ما بلش)
        final pendingResult =
        await BookingService.getUserServiceOrders(status: 'pending');
        final activeResult =
        await BookingService.getUserServiceOrders(status: 'active');

        if (pendingResult['success'] == true) {
          final list = pendingResult['orders'];
          if (list is List) {
            allOrders.addAll(list.whereType<Map<String, dynamic>>());
          }
        }
        if (activeResult['success'] == true) {
          final list = activeResult['orders'];
          if (list is List) {
            allOrders.addAll(list.whereType<Map<String, dynamic>>());
          }
        }
      } else {
        // In progress / Completed tabs: نداء واحد بحسب التاب
        final result = await BookingService.getUserServiceOrders(
          status: _selectedServiceApiStatus,
        );
        if (result['success'] == true) {
          final list = result['orders'];
          if (list is List) {
            allOrders.addAll(list.whereType<Map<String, dynamic>>());
          }
        }
      }

      // بما إنه الباك إند بيرجع بس mechanic_id (رقم) مش الكائن الكامل،
      // لازم نجيب بيانات كل ميكانيكي منفصل قبل ما نبني الموديل.
      final Map<String, Map<String, dynamic>> mechanicsCache = {};

      for (final orderJson in allOrders) {
        final mechanicId = orderJson['mechanic_id']?.toString() ?? '';
        if (mechanicId.isEmpty || mechanicId == 'null') continue;
        if (mechanicsCache.containsKey(mechanicId)) continue;

        try {
          final empData =
          await EmployeeService.getEmployeeDetails(mechanicId);
          if (empData != null) {
            mechanicsCache[mechanicId] = empData;
          }
        } catch (e) {
          debugPrint('Failed loading mechanic $mechanicId: $e');
        }
      }

      // ندمج بيانات الميكانيكي داخل الـ order قبل ما ننشئ الموديل
      final enriched = allOrders.map((json) {
        final mechanicId = json['mechanic_id']?.toString() ?? '';
        if (mechanicId.isNotEmpty && mechanicsCache.containsKey(mechanicId)) {
          json['mechanic'] = mechanicsCache[mechanicId];
        }
        return json;
      }).toList();

      serviceOrders.assignAll(enriched.map(_serviceOrderFromJson).toList());
    } catch (e) {
      debugPrint("Load Service Orders Error: $e");
      serviceOrders.clear();
    } finally {
      isLoading.value = false;
    }
  }

  UserOrderModel _rentalOrderFromJson(Map<String, dynamic> json) {
    final car = json['car'];

    Map<String, dynamic> carMap = {};
    if (car is Map<String, dynamic>) {
      carMap = car;
    }

    final brand = carMap['brand']?.toString() ?? '';
    final model = carMap['model']?.toString() ?? '';
    final carName = '$brand $model'.trim();

    return UserOrderModel(
      id: json['id']?.toString() ?? '',
      category: 'Car Rentals',
      status: _displayStatus(json['status']?.toString() ?? ''),
      carImage: carMap['image']?.toString() ?? '',
      carName: carName.isEmpty ? 'Car Rental' : carName,
      rentalId: '#RW-${json['id']?.toString() ?? ''}',
      totalPrice: _money(json['total_price']),
      pickupDate: _formatDate(json['start_date']),
      pickupTime: _formatTime(json['start_date']),
      returnDate: _formatDate(json['end_date']),
      returnTime: _formatTime(json['end_date']),
      location: json['pickup_location']?.toString() ?? '',
      duration: _rentalDuration(
        json['start_date'],
        json['end_date'],
      ),
    );
  }

  String _rentalDuration(dynamic start, dynamic end) {
    final startDate = DateTime.tryParse(start?.toString() ?? '');
    final endDate = DateTime.tryParse(end?.toString() ?? '');

    if (startDate == null || endDate == null) return '-';

    final days = endDate.difference(startDate).inDays;

    if (days <= 0) return '1 Day';
    if (days == 1) return '1 Day';

    return '$days Days';
  }

  ServiceOrderModel _serviceOrderFromJson(Map<String, dynamic> json) {
    // نجرب كل الأسماء المحتملة للحقل بدون ما نفترض واحد بعينه
    final mechanicRaw = json['mechanic'] ??
        json['assigned_mechanic'] ??
        json['employee'] ??
        json['assigned_employee'] ??
        json['mechanic_info'] ??
        json['mechanic_data'];

    Map<String, dynamic> mechanicMap = {};
    if (mechanicRaw is Map<String, dynamic>) {
      mechanicMap = mechanicRaw;
    }

    final mechanicName = mechanicMap['name']?.toString() ??
        mechanicMap['full_name']?.toString() ??
        mechanicMap['employee_name']?.toString() ??
        '';

    // نجرب كل الأسماء المحتملة للصورة كمان
    final mechanicImage = mechanicMap['image']?.toString() ??
        mechanicMap['image_url']?.toString() ??
        mechanicMap['photo']?.toString() ??
        mechanicMap['avatar']?.toString() ??
        mechanicMap['profile_image']?.toString() ??
        '';

    final rating = mechanicMap['rating']?.toString() ??
        mechanicMap['average_rating']?.toString() ??
        mechanicMap['stars']?.toString() ??
        '';

    final experience = mechanicMap['experience']?.toString() ??
        mechanicMap['years_experience']?.toString() ??
        mechanicMap['years_of_experience']?.toString() ??
        mechanicMap['exp_years']?.toString() ??
        '';

    String mechanicInfo = '';

    if (rating.isNotEmpty && experience.isNotEmpty) {
      mechanicInfo = '★ $rating • $experience Years Exp.';
    } else if (rating.isNotEmpty) {
      mechanicInfo = '★ $rating';
    } else if (experience.isNotEmpty) {
      mechanicInfo = '$experience Years Exp.';
    }

    return ServiceOrderModel(
      id: json['id']?.toString() ?? '',
      requestNumber: '#SRV-${json['id']?.toString() ?? ''}',
      serviceName: json['service_type']?.toString() ?? 'Service Request',
      date: _formatDate(json['scheduled_at']),
      time: _formatTime(json['scheduled_at']),
      location: json['location']?.toString() ?? '',
      status: _displayServiceStatus(json['status']?.toString() ?? ''),
      problemDescription: json['problem_description']?.toString() ?? '',
      vehicleModel: json['vehicle_model']?.toString() ?? '',
      mechanicName: mechanicName,
      mechanicImage: mechanicImage,
      mechanicInfo: mechanicInfo,
    );
  }

  String _formatDate(dynamic value) {
    if (value == null) return '-';

    final date = DateTime.tryParse(value.toString());
    if (date == null) return value.toString();

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(dynamic value) {
    if (value == null) return '-';

    final date = DateTime.tryParse(value.toString());
    if (date == null) return '';

    int hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';

    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }

    return '$hour:$minute $period';
  }

  String _money(dynamic value) {
    if (value == null) return '\$0.00';

    final number = double.tryParse(value.toString());

    if (number == null) {
      final text = value.toString();
      return text.startsWith('\$') ? text : '\$$text';
    }

    return '\$${number.toStringAsFixed(2)}';
  }

  void addCarRentalOrder({
    required BookingReviewModel review,
    required String totalPrice,
  }) {
    final order = UserOrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: 'Car Rentals',
      status: 'Pending',
      carImage: review.car.image?.toString() ?? '',
      carName: review.car.name?.toString() ?? review.car.model?.toString() ?? '',
      rentalId: _generateRentalId(),
      totalPrice: totalPrice,
      pickupDate: review.pickupDate,
      pickupTime: review.pickupTime,
      returnDate: review.returnDate,
      returnTime: review.returnTime,
    );

    orders.insert(0, order);
    showCarRentalPending();
  }

  List<UserOrderModel> get filteredOrders {
    final selectedCategory =
    categoryTabs[selectedCategoryIndex.value].trim().toLowerCase();

    final selectedStatus =
    statusTabs[selectedStatusIndex.value].trim().toLowerCase();

    final search = searchText.value.trim().toLowerCase();

    List<UserOrderModel> result = orders.where((order) {
      return order.category.trim().toLowerCase() == selectedCategory &&
          order.status.trim().toLowerCase() == selectedStatus;
    }).toList();

    if (search.isNotEmpty) {
      result = result.where((order) {
        return order.rentalId.toLowerCase().contains(search) ||
            order.carName.toLowerCase().contains(search);
      }).toList();
    }

    return result;
  }

  // فلترة طلبات الأدمن (adminAccessoryOrders)
  List<AdminAccessoryOrderModel> get filteredAccessoryOrders {
    if (selectedStatusIndex.value == 0) {
      return adminAccessoryOrders
          .where((o) => o.status.toLowerCase() == 'pending')
          .toList();
    } else if (selectedStatusIndex.value == 1) {
      return adminAccessoryOrders
          .where((o) => o.status.toLowerCase() == 'active')
          .toList();
    } else {
      return adminAccessoryOrders
          .where((o) => o.status.toLowerCase() == 'completed')
          .toList();
    }
  }

  // بما إنه loadServiceOrders هلق بتفلتر من السيرفر مباشرة حسب التاب،
  // منرجع serviceOrders زي ما هي (كلها أصلاً مطابقة للتاب الحالي).
  List<ServiceOrderModel> get filteredServiceOrders {
    return serviceOrders;
  }

  void showCancelCarRentalAlert(String id) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xffFFF2CC),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xffB45309),
                  size: 34,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Cancel Booking?',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff101828),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Are you sure you want to cancel this booking?',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff64748B),
                ),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xffF1F2F4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'No, Keep',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xff101828),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back(); // يسكر alert
                        cancelCarRentalOrder(id);
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xff334155),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'Yes, Cancel',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> cancelCarRentalOrder(
      String id, {
        bool popPage = false,
      }) async {
    final result = await BookingService.cancelUserRentalOrder(id: id);

    if (result['success'] == true) {
      orders.removeWhere((order) => order.id == id);

      if (popPage) {
        Get.back();
      }

      Get.snackbar(
        'Booking Cancelled',
        result['message']?.toString().isNotEmpty == true
            ? result['message'].toString()
            : 'Your booking has been cancelled.',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadRentalOrders();
    } else {
      Get.snackbar(
        'Error',
        result['message'] ?? 'Failed to cancel booking',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void acceptRentalOrder(String id) {
    final index = orders.indexWhere((order) => order.id == id);

    if (index == -1) return;

    orders[index] = orders[index].copyWith(
      status: 'In Progress',
    );

    orders.refresh();

    Get.snackbar(
      'Order Accepted',
      'Rental order has been moved to In Progress.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void completeRentalOrder(String id) {
    final index = orders.indexWhere((order) => order.id == id);

    if (index == -1) return;

    orders[index] = orders[index].copyWith(
      status: 'Completed',
    );

    orders.refresh();

    Get.snackbar(
      'Order Completed',
      'Rental order has been completed.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showDeleteRentalOrderAlert(String id) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xffFEE2E2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Color(0xffDC2626),
                  size: 34,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Delete Order?',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff101828),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Are you sure you want to delete this rental order?',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff64748B),
                ),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xffF1F2F4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'No, Keep',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xff101828),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();

                        orders.removeWhere((order) => order.id == id);

                        Get.snackbar(
                          'Order Deleted',
                          'Rental order has been deleted.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xffDC2626),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'Yes, Delete',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void showDeleteOrderAlert({
    required String title,
    required String message,
    required VoidCallback onDelete,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xffFEE2E2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Color(0xffDC2626),
                  size: 34,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff101828),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff64748B),
                ),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xffF1F2F4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'No, Keep',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xff101828),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        onDelete();
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xffDC2626),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'Yes, Delete',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // ============ ADMIN ACCESSORY ORDER ACTIONS ============

  Future<void> acceptAccessoryOrder(String id) async {
    final result = await AdminAccessoryOrderService.updateOrderStatus(
      id: id,
      status: 'active',
    );
    if (result['success'] == true) {
      final index = adminAccessoryOrders.indexWhere((o) => o.id == id);
      if (index != -1) {
        adminAccessoryOrders[index] =
            adminAccessoryOrders[index].copyWith(status: 'active');
        adminAccessoryOrders.refresh();
      }
      Get.snackbar(
        'Order Accepted',
        result['message'] ?? 'Order moved to In Progress',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        result['message'] ?? 'Failed to accept order',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> completeAccessoryOrder(String id) async {
    final result = await AdminAccessoryOrderService.updateOrderStatus(
      id: id,
      status: 'completed',
    );
    if (result['success'] == true) {
      final index = adminAccessoryOrders.indexWhere((o) => o.id == id);
      if (index != -1) {
        adminAccessoryOrders[index] =
            adminAccessoryOrders[index].copyWith(status: 'completed');
        adminAccessoryOrders.refresh();
      }
      Get.snackbar(
        'Order Completed',
        result['message'] ?? 'Order completed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        result['message'] ?? 'Failed to complete order',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void showDeleteAccessoryOrderAlert(String id) {
    showDeleteOrderAlert(
      title: 'Delete Order?',
      message: 'Are you sure you want to delete this accessory order?',
      onDelete: () async {
        final result = await AdminAccessoryOrderService.deleteOrder(id);
        if (result['success'] == true) {
          adminAccessoryOrders.removeWhere((o) => o.id == id);
          Get.snackbar(
            'Order Deleted',
            result['message'] ?? 'Accessory order has been deleted.',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Error',
            result['message'] ?? 'Failed to delete order',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
    );
  }

  // ============ SERVICE ORDERS ============

  void acceptServiceOrder(String id) {
    final index = serviceOrders.indexWhere((order) => order.id == id);

    if (index == -1) return;

    serviceOrders[index] = serviceOrders[index].copyWith(
      status: 'In progress',
    );

    serviceOrders.refresh();

    Get.snackbar(
      'Order Accepted',
      'Service order has been moved to In progress.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void completeServiceOrder(String id) {
    final index = serviceOrders.indexWhere((order) => order.id == id);

    if (index == -1) return;

    serviceOrders[index] = serviceOrders[index].copyWith(
      status: 'Completed',
    );

    serviceOrders.refresh();

    Get.snackbar(
      'Order Completed',
      'Service order has been completed.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void deleteServiceOrder(String id) {
    serviceOrders.removeWhere((order) => order.id == id);

    Get.snackbar(
      'Order Deleted',
      'Service order has been deleted.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showDeleteServiceOrderAlert(String id) {
    showDeleteOrderAlert(
      title: 'Delete Order?',
      message: 'Are you sure you want to delete this service order?',
      onDelete: () {
        serviceOrders.removeWhere((order) => order.id == id);

        Get.snackbar(
          'Order Deleted',
          'Service order has been deleted.',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  // ============ USER ACCESSORY ORDERS (My Orders) ============

  Future<void> loadUserAccessoryOrders() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        UserAccessoryOrderService.getOrdersByStatus('pending'),
        UserAccessoryOrderService.getOrdersByStatus('active'),
        UserAccessoryOrderService.getOrdersByStatus('completed'),
        UserAccessoryOrderService.getOrdersByStatus('rejected'),
      ]);

      final List<UserAccessoryOrderModel> merged = [];
      for (final result in results) {
        if (result['success'] == true) {
          merged.addAll(result['orders'] as List<UserAccessoryOrderModel>);
        }
      }

      userAccessoryOrders.assignAll(merged);
    } catch (e) {
      debugPrint("Load User Accessory Orders Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<UserAccessoryOrderModel> get filteredUserAccessoryOrders {
    if (selectedStatusIndex.value == 0) {
      return userAccessoryOrders
          .where((o) => o.status.toLowerCase() == 'pending')
          .toList();
    } else if (selectedStatusIndex.value == 1) {
      return userAccessoryOrders
          .where((o) => o.status.toLowerCase() == 'active')
          .toList();
    } else {
      return userAccessoryOrders
          .where((o) => o.status.toLowerCase() == 'completed')
          .toList();
    }
  }

  void showCancelUserAccessoryAlert(String id) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xffFFF2CC),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xffB45309),
                  size: 34,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Cancel Order?',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff101828),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Are you sure you want to cancel this accessory order?',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff64748B),
                ),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xffF1F2F4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'No, Keep',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xff101828),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Get.back();
                        final result =
                        await UserAccessoryOrderService.cancelOrder(id);
                        if (result['success'] == true) {
                          userAccessoryOrders.removeWhere((o) => o.id == id);
                          Get.back();
                          Get.snackbar(
                            'Order Cancelled',
                            'Your accessory order has been cancelled.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          Get.snackbar(
                            'Error',
                            result['message'] ?? 'Failed to cancel order',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xff334155),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'Yes, Cancel',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  String _generateRentalId() {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    return '#RJ-${time.substring(time.length - 4)}';
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
