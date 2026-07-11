import 'package:flutter/material.dart';
import 'package:four_wheels/widgets/fleet_card.dart';
import 'package:four_wheels/constants/colors.dart';
import 'package:four_wheels/controller/dsa_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:four_wheels/widgets/custom_bttom_navbar.dart';
import 'package:four_wheels/widgets/stuff_search.dart';
import 'package:four_wheels/widgets/custom_floutingbut2.dart';
import 'Add_employee.dart';
import 'package:four_wheels/widgets/EmployeeCard.dart';
import 'package:four_wheels/controller/emp_control.dart';
import 'package:four_wheels/screens/employy_details.dart';
import 'package:four_wheels/widgets/admin_notifiBell.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/widgets/ProfileAvatar.dart';
import 'package:four_wheels/screens/Profile_admin_sitting.dart';
import 'package:four_wheels/screens/General_admin_sitting.dart';

class EmployeeMangmentScreen extends StatefulWidget {
  const EmployeeMangmentScreen({super.key});

  @override
  State<EmployeeMangmentScreen> createState() =>
      _EmployeeMangmentScreenState();
}

class _EmployeeMangmentScreenState extends State<EmployeeMangmentScreen> {
  final TextEditingController searchController = TextEditingController();
  late final EmployeeController empController;
  late final DashbordController controller;

  @override
  void initState() {
    super.initState();

    empController = Get.isRegistered<EmployeeController>()
        ? Get.find<EmployeeController>()
        : Get.put(EmployeeController(), permanent: true);

 controller = Get.isRegistered<DashbordController>()
        ? Get.find<DashbordController>()
        : Get.put(DashbordController(), permanent: true);



    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.updateIndexByRoute();
      await empController.loadEmployees();
      await empController.loadEmployeeStats();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.backchart,

      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: AppColor.secondary,
        title: Padding(
          padding: EdgeInsets.only(left: 24),
          child: Text(
            "Employee",
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions:  [
          AdminNotificationBell(
            initialType: 'employees',
            showFilters: false,
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: GestureDetector(
              onTap: () => Get.to(() => const generalprofilescreen()),
              child: ProfileAvatar(radius: 18.r, fontSize: 12.sp,),
            ),
          ),


        ],
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Obx(() => FleetSupportCard(
                    activeToday: empController.activeEmployeesCount.value.toString(),
                    onStandby: (empController.totalEmployeesCount.value - empController.activeEmployeesCount.value)
                        .clamp(0, 999)
                        .toString(),
                  )),

                  const SizedBox(height: 20),

                  Obx(
                        () => StaffFilterSearch(
                      selectedIndex:
                      empController.selectedFilterIndex.value,
                      onFilterChanged: (index) {
                        empController.changeFilter(index);
                        searchController.clear();
                      },
                      searchController: searchController,
                      onSearchChanged: empController.changeSearch,
                      hintText: empController.searchHint,
                    ),
                  ),

                   SizedBox(height: 20),

                  Obx(() {
                    if (empController.isLoading.value) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final employees = empController.filteredEmployees;

                    if (employees.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: Text(
                            'No employees found',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              color: const Color(0xff6B7280),
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: employees.map((employee) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: EmployeeCard(
                            name: employee.name,
                            role: employee.role,
                            status: employee.status,
                            employeeId: employee.id,
                            imageUrl: employee.imageUrl,
                            onTap: () async{
                              empController.selectEmployee(employee);
                              await empController.loadEmployeeDetails(employee.id);
                              Get.to(() => const EmployyDetailsScreen());
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }),

                   SizedBox(height: 100),
                ],
              ),
            ),
          ),

          Positioned(
            right: 10,
            bottom: 30,
            child: CustomFloatingButton2(
              onTab: () async {
                await Get.to(() => AddEmployeeScreen());
                await empController.loadEmployees();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Add Employee",
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Obx(
            () => CustomBottomNavBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
        ),
      ),
    );
  }
}