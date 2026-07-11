import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:four_wheels/models/service_requestordermodel.dart';
import 'package:four_wheels/screens/detiles_requestmechanic.dart';
import 'package:four_wheels/services/services_api.dart';
import 'package:four_wheels/models/avilabel_model.dart';

class RequestMechanicController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  final selectedDate = Rxn<DateTime>();
  final selectedTime = Rxn<TimeOfDay>();

  final adminPendingRequests = <ServiceRequestModel>[].obs;
  final adminActiveRequests = <ServiceRequestModel>[].obs;
  final adminCompletedRequests = <ServiceRequestModel>[].obs;

  final availableMechanics = <AvailableMechanicModel>[].obs;
  final selectedMechanic = Rxn<AvailableMechanicModel>();

  final mechanicTasks = <ServiceRequestModel>[].obs;
  final selectedRequest = Rxn<ServiceRequestModel>();

  final isLoading = false.obs;

  String get dateText {
    if (selectedDate.value == null) return 'mm/dd/yy';

    final date = selectedDate.value!;
    return '${date.month}/${date.day}/${date.year}';
  }

  String get apiDateText {
    if (selectedDate.value == null) return '';

    final date = selectedDate.value!;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  String get timeText {
    if (selectedTime.value == null) return '--:--';

    final time = selectedTime.value!;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  int get adminPendingCount => adminPendingRequests.length;
  int get adminActiveCount => adminActiveRequests.length;
  int get adminCompletedCount => adminCompletedRequests.length;

  void pickDate(BuildContext context) async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    final DateTime? date = await showDatePicker(
      context: context,
      firstDate: tomorrow,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: tomorrow,
    );

    if (date != null) {
      selectedDate.value = date;
    }
  }

  void pickTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      selectedTime.value = time;
    }
  }

  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    if (value.trim().length < 7) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  Future<void> submitRequest() async {
    if (formKey.currentState?.validate() != true) return;

    if (selectedDate.value == null) {
      Get.snackbar(
        'Missing Date',
        'Please select preferred date',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedTime.value == null) {
      Get.snackbar(
        'Missing Time',
        'Please select preferred time',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await createMechanicRequest(
      phone: phoneController.text,
      location: locationController.text,
      preferredDate: apiDateText,
      preferredTime: timeText,
      description: descriptionController.text,
      name: fullNameController.text,
    );
  }

  Future<void> createMechanicRequest({
    required String phone,
    required String location,
    required String preferredDate,
    required String preferredTime,
    required String description,
    required String name,
  }) async {
    isLoading.value = true;

    try {
      final result = await ServiceApi.createService(
        phone: phone.trim(),
        location: location.trim(),
        preferredDate: preferredDate.trim(),
        preferredTime: preferredTime.trim(),
        description: description.trim(),
        name: name.trim(),
      );

      print('CREATE REQUEST RESULT: $result');

      if (result['success'] == true) {
        Get.snackbar(
          'Success',
          result['message'] ?? 'Request sent successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        final request = _requestFromResponse(
          result: result,
          phone: phone,
          location: location,
          preferredDate: preferredDate,
          preferredTime: preferredTime,
          description: description,
          name: name,
        );

        Get.to(
              () => ServiceRequestDetailsScreen(
            request: request,
          ),
        );
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Request failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  ServiceRequestModel _requestFromResponse({
    required Map<String, dynamic> result,
    required String phone,
    required String location,
    required String preferredDate,
    required String preferredTime,
    required String description,
    required String name,
  }) {
    final responseData = result['data'];
    final responseMap = _asMap(responseData);

    if (responseMap != null) {
      final innerData = _asMap(responseMap['data']);
      if (innerData != null) {
        return ServiceRequestModel.fromJson(innerData);
      }

      final requestData = _asMap(responseMap['request']);
      if (requestData != null) {
        return ServiceRequestModel.fromJson(requestData);
      }

      final serviceData = _asMap(responseMap['service']);
      if (serviceData != null) {
        return ServiceRequestModel.fromJson(serviceData);
      }

      if (responseMap['id'] != null) {
        return ServiceRequestModel.fromJson(responseMap);
      }
    }

    return ServiceRequestModel(
      id: '',
      name: name,
      phone: phone,
      serviceName: 'General Maintenance',
      serviceType: 'General Maintenance',
      description: description,
      problemDescription: description,
      status: 'pending',
      scheduledAt: '$preferredDate $preferredTime:00',
      date: preferredDate,
      time: preferredTime,
      location: location,
      customerName: name,
      customerPhone: phone,
    );
  }

  Future<void> loadAdminRequests(String status) async {
    isLoading.value = true;

    try {
      final apiStatus = status.trim().toLowerCase();

      if (apiStatus == 'pending') {
        final result = await ServiceApi.getAdminServices(status: 'pending');

        if (result['success'] == true) {
          adminPendingRequests.assignAll(
            _extractRequestList(result['data']),
          );

          print('ADMIN PENDING COUNT: ${adminPendingRequests.length}');
        }

        return;
      }

      if (apiStatus == 'active') {
        final activeResult = await ServiceApi.getAdminServices(
          status: 'active',
        );

        final inProgressResult = await ServiceApi.getAdminServices(
          status: 'inprogress',
        );

        final allRequests = <ServiceRequestModel>[];

        if (activeResult['success'] == true) {
          allRequests.addAll(_extractRequestList(activeResult['data']));
        }

        if (inProgressResult['success'] == true) {
          allRequests.addAll(_extractRequestList(inProgressResult['data']));
        }

        final uniqueRequests = <String, ServiceRequestModel>{};

        for (final request in allRequests) {
          uniqueRequests[request.id] = request;
        }

        adminActiveRequests.assignAll(uniqueRequests.values.toList());

        print('ADMIN IN PROGRESS COUNT: ${adminActiveRequests.length}');
        return;
      }

      if (apiStatus == 'completed') {
        final result = await ServiceApi.getAdminServices(status: 'completed');

        if (result['success'] == true) {
          adminCompletedRequests.assignAll(
            _extractRequestList(result['data']),
          );

          print('ADMIN COMPLETED COUNT: ${adminCompletedRequests.length}');
        }

        return;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAllAdminRequests() async {
    await loadAdminRequests('pending');
    await loadAdminRequests('active');
    await loadAdminRequests('completed');
  }

  Future<void> deleteAdminServiceRequest(ServiceRequestModel request) async {
    isLoading.value = true;

    try {
      final result = await ServiceApi.deleteAdminService(
        serviceId: request.apiId,
      );

      if (result['success'] == true) {
        Get.snackbar(
          'Deleted',
          result['message'] ?? 'Service request deleted',
          snackPosition: SnackPosition.BOTTOM,
        );

        await loadAllAdminRequests();
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Delete failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMechanicTasks() async {
    isLoading.value = true;

    try {
      final result = await ServiceApi.getMechanicJobs();

      if (result['success'] == true) {
        mechanicTasks.assignAll(
          _extractRequestList(result['data']),
        );

        print('MECHANIC TASKS COUNT: ${mechanicTasks.length}');
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to load mechanic tasks',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMechanicTaskDetails(String taskId) async {
    isLoading.value = true;

    try {
      final result = await ServiceApi.getMechanicJobDetails(
        jobId: int.parse(taskId),
      );

      if (result['success'] == true) {
        selectedRequest.value = _extractObject(result['data']);
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Failed to load task details',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startRepair(String taskId) async {
    isLoading.value = true;

    try {
      final result = await ServiceApi.startRepair(
        jobId: int.parse(taskId),
      );

      if (result['success'] == true) {
        Get.snackbar(
          'Started',
          result['message'] ?? 'Repair started',
          snackPosition: SnackPosition.BOTTOM,
        );

        await loadMechanicTasks();
        await loadMechanicTaskDetails(taskId);
        await loadAllAdminRequests();
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Start repair failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeTask(String taskId) async {
    isLoading.value = true;

    try {
      final result = await ServiceApi.completeJob(
        jobId: int.parse(taskId),
      );

      if (result['success'] == true) {
        Get.snackbar(
          'Completed',
          result['message'] ?? 'Task completed',
          snackPosition: SnackPosition.BOTTOM,
        );

        await loadMechanicTasks();
        await loadMechanicTaskDetails(taskId);
        await loadAllAdminRequests();
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Complete task failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  List<ServiceRequestModel> get mechanicActiveTasks {
    return mechanicTasks.where((task) {
      return task.isActive || task.isPending;
    }).toList();
  }

  List<ServiceRequestModel> get mechanicCompletedTasks {
    return mechanicTasks.where((task) {
      return task.isCompleted;
    }).toList();
  }

  Future<void> loadAvailableMechanics(String scheduledAt) async {
    availableMechanics.clear();
    selectedMechanic.value = null;

    final result = await ServiceApi.getAvailableMechanics(
      scheduledAt: scheduledAt,
    );

    if (result['success'] == true) {
      availableMechanics.assignAll(
        _extractMechanicList(result['data']),
      );

      print('AVAILABLE MECHANICS COUNT: ${availableMechanics.length}');
    } else {
      Get.snackbar(
        'Error',
        result['message'] ?? 'Failed to load available mechanics',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> openAcceptDialog(ServiceRequestModel request) async {
    final scheduledDate = request.date.isNotEmpty
        ? request.date
        : request.scheduledAt.split(' ').first.split('T').first;

    if (scheduledDate.isEmpty) {
      Get.snackbar(
        'Error',
        'Scheduled date not found',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await loadAvailableMechanics(scheduledDate);

    if (availableMechanics.isEmpty) {
      Get.snackbar(
        'Error',
        'No available mechanics',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Choose Mechanic'),
        content: Obx(
              () => DropdownButton<AvailableMechanicModel>(
            isExpanded: true,
            value: selectedMechanic.value,
            hint: const Text('Select mechanic'),
            items: availableMechanics.map((mechanic) {
              return DropdownMenuItem<AvailableMechanicModel>(
                value: mechanic,
                child: Text(mechanic.name),
              );
            }).toList(),
            onChanged: (value) {
              selectedMechanic.value = value;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          Obx(
                () => ElevatedButton(
              onPressed: selectedMechanic.value == null
                  ? null
                  : () {
                acceptRequestWithMechanic(
                  request: request,
                  mechanicId: selectedMechanic.value!.id,
                );
              },
              child: const Text('Accept'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> acceptRequestWithMechanic({
    required ServiceRequestModel request,
    required int mechanicId,
  }) async {
    isLoading.value = true;

    try {
      final result = await ServiceApi.acceptService(
        serviceId: request.apiId,
        mechanicId: mechanicId,
      );

      if (result['success'] == true) {
        Get.back();

        Get.snackbar(
          'Success',
          result['message'] ?? 'Mechanic assigned successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        await loadAllAdminRequests();
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Accept failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  ServiceRequestModel? _extractObject(dynamic data) {
    final map = _asMap(data);

    if (map == null) return null;

    final innerData = _asMap(map['data']);
    if (innerData != null) {
      return ServiceRequestModel.fromJson(innerData);
    }

    final serviceData = _asMap(map['service']);
    if (serviceData != null) {
      return ServiceRequestModel.fromJson(serviceData);
    }

    final requestData = _asMap(map['request']);
    if (requestData != null) {
      return ServiceRequestModel.fromJson(requestData);
    }

    if (map['id'] != null) {
      return ServiceRequestModel.fromJson(map);
    }

    return null;
  }

  List<ServiceRequestModel> _extractRequestList(dynamic data) {
    final list = _extractList(data);

    return list
        .map((item) => _asMap(item))
        .whereType<Map<String, dynamic>>()
        .map((item) => ServiceRequestModel.fromJson(item))
        .toList();
  }

  List<AvailableMechanicModel> _extractMechanicList(dynamic data) {
    final list = _extractList(data);

    return list
        .map((item) => _asMap(item))
        .whereType<Map<String, dynamic>>()
        .map((item) => AvailableMechanicModel.fromJson(item))
        .toList();
  }

  List _extractList(dynamic data) {
    final map = _asMap(data);

    if (data is List) return data;

    if (map != null) {
      if (map['data'] is List) {
        return map['data'];
      }

      final inner = _asMap(map['data']);
      if (inner != null && inner['data'] is List) {
        return inner['data'];
      }

      if (map['services'] is List) {
        return map['services'];
      }

      if (map['requests'] is List) {
        return map['requests'];
      }

      if (map['jobs'] is List) {
        return map['jobs'];
      }
    }

    return [];
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}