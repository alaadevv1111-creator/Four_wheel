import 'package:get/get.dart';
import 'package:four_wheels/models/emp_model.dart';
import 'package:four_wheels/services/employye_service.dart';

class EmployeeController extends GetxController {
  final employees = <EmployeeModel>[].obs;
  final selectedEmployee = Rxn<EmployeeModel>();

  final selectedFilterIndex = 0.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final totalEmployeesCount = 0.obs;
  final activeEmployeesCount = 0.obs;

  @override
  void onReady() {
    super.onReady();
    loadEmployees();
    loadEmployeeStats();
  }

  Future<void> loadEmployees() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await EmployeeService.showEmployees();
      print('LOAD EMPLOYEES RESULT: $result');

      if (result['success'] == true) {
        final list = _extractEmployeesList(result['data']);

        final loadedEmployees = list.map((item) {
          return EmployeeModel.fromJson(item);
        }).toList();

        employees.assignAll(loadedEmployees);

        print('EMPLOYEES COUNT: ${employees.length}');
      } else {
        errorMessage.value =
            result['message'] ?? result['massage'] ?? 'Failed to load employees';

        // Get.snackbar(
        //   'Error',
        //   errorMessage.value,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('LOAD EMPLOYEES ERROR: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List _extractEmployeesList(dynamic data) {
    if (data is List) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      if (data['data'] is List) {
        return data['data'];
      }

      if (data['employees'] is List) {
        return data['employees'];
      }

      if (data['data'] is Map<String, dynamic>) {
        final inner = data['data'];

        if (inner['data'] is List) {
          return inner['data'];
        }

        if (inner['employees'] is List) {
          return inner['employees'];
        }

        if (inner['data'] is Map<String, dynamic>) {
          final inner2 = inner['data'];

          if (inner2['data'] is List) {
            return inner2['data'];
          }

          if (inner2['employees'] is List) {
            return inner2['employees'];
          }
        }
      }
    }

    return [];
  }

  Future<void> loadEmployeeDetails(String id) async {
    final result = await EmployeeService.getEmployeeDetails(id);

    // مهم جداً: لو المستخدم تنقّل لموظف تاني قبل ما يوصل الرد،
    // لازم نتجاهل هالرد القديم عشان ما يكتب بيانات غلط فوق الموظف الحالي.
    if (selectedEmployee.value?.id != id) {
      print('IGNORED STALE RESPONSE FOR ID: $id (current is ${selectedEmployee.value?.id})');
      return;
    }

    if (result['success'] == true) {
      final body = result['data'];

      dynamic empData = body;

      if (body is Map<String, dynamic>) {
        // body['data'] هو الكائن الكامل والصحيح (فيه id المستخدم + driver + employee).
        // ما منحفر أكتر جوا empData['employee'] لأنه هاد كائن فرعي بـ id مختلف
        // (employee table id) وما فيه بيانات الرخصة (driver)، وحفرنا القديم كان
        // عم يستبدل الكائن الصح بهاد الناقص ويخرب استخراج الرخصة.
        empData = body['data'] ?? body['employee'] ?? body;
      }

      if (empData is Map<String, dynamic>) {
        final employee = EmployeeModel.fromJson(empData);

        // فحص إضافي بعد فك الـ JSON: لو الـ id يلي رجع مش نفسه المطلوب، تجاهل.
        if (employee.id != id) {
          print('IGNORED MISMATCHED RESPONSE. requested=$id got=${employee.id}');
          return;
        }

        // فحص أخير قبل الكتابة الفعلية (تحسباً لتنقّل حصل أثناء فك الـ JSON)
        if (selectedEmployee.value?.id != id) {
          return;
        }

        selectedEmployee.value = employee;

        final index = employees.indexWhere((e) => e.id == employee.id);
        if (index != -1) {
          employees[index] = employee;
          employees.refresh();
        }

        print('DETAIL LICENSE PATH: ${employee.drivingLicensePath}');
      }
    }
  }

  Future<void> fetchEmployees() async {
    await loadEmployees();
  }

  void changeFilter(int index) {
    selectedFilterIndex.value = index;
    searchQuery.value = '';
  }

  void changeSearch(String value) {
    searchQuery.value = value.trim();
  }

  List<EmployeeModel> get filteredEmployees {
    List<EmployeeModel> result = employees.toList();

    if (selectedFilterIndex.value == 1) {
      result = result
          .where((employee) => employee.role.toLowerCase().trim() == 'driver')
          .toList();
    } else if (selectedFilterIndex.value == 2) {
      result = result
          .where((employee) => employee.role.toLowerCase().trim() == 'mechanic')
          .toList();
    }

    final query = searchQuery.value.toLowerCase();

    if (query.isNotEmpty) {
      result = result
          .where((employee) => employee.name.toLowerCase().contains(query))
          .toList();
    }

    return result;
  }

  String get searchHint {
    if (selectedFilterIndex.value == 1) {
      return 'Search drivers...';
    } else if (selectedFilterIndex.value == 2) {
      return 'Search mechanics...';
    } else {
      return 'Search all personnel...';
    }
  }

  void selectEmployee(EmployeeModel employee) {
    selectedEmployee.value = employee;
  }

  void addEmployee(EmployeeModel employee) {
    employees.add(employee);
    selectedEmployee.value = employee;
    employees.refresh();
  }
  Future<void> loadEmployeeStats() async {
    final totalResult = await EmployeeService.getTotalEmployees();
    if (totalResult['success'] == true) {
      totalEmployeesCount.value = int.tryParse(totalResult['total'].toString()) ?? 0;
    }

    final activeResult = await EmployeeService.getActiveEmployees();
    if (activeResult['success'] == true) {
      activeEmployeesCount.value = int.tryParse(activeResult['active'].toString()) ?? 0;
    }
  }

  Future<void> updateEmployee(EmployeeModel updatedEmployee) async {
    final index = employees.indexWhere(
          (employee) => employee.id == updatedEmployee.id,
    );

    if (index != -1) {
      employees[index] = updatedEmployee;
    }

    selectedEmployee.value = updatedEmployee;
    employees.refresh();
  }

  Future<void> deleteEmployee(String id) async {
    final result = await EmployeeService.deleteEmployee(id);

    if (result['success'] == true) {
      employees.removeWhere((emp) => emp.id == id);

      Get.snackbar(
        'Deleted',
        result['message']?.toString().isNotEmpty == true
            ? result['message'].toString()
            : 'Employee deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      await loadEmployees();
    } else {
      Get.snackbar(
        'Error',
        result['message'] ?? 'Failed to delete employee',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}