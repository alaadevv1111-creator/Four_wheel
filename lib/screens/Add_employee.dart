import 'package:flutter/material.dart';
import 'package:four_wheels/constants/colors.dart';
import 'package:four_wheels/controller/dsa_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/widgets/uplode_doc.dart';
import 'package:four_wheels/controller/uplod_controller.dart';
import 'package:get/get.dart';
import 'package:four_wheels/widgets/custom_textfield.dart';
import 'package:four_wheels/widgets/custom_button.dart';
import 'package:four_wheels/widgets/custom_bttom_navbar.dart';
import 'package:four_wheels/controller/Addemp_Controller.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final UploadController upcontroller = Get.put(UploadController());

  final DashbordController dashboardController =
  Get.isRegistered<DashbordController>()
      ? Get.find<DashbordController>()
      : Get.put(DashbordController(), permanent: true);

  final AddEmployeeController empcontroller = Get.put(AddEmployeeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Text(
          "Add Employee",
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: const [],
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 120.h),
          child: _buildMainFormContainer(),
        ),
      ),
      bottomNavigationBar: Obx(
            () => CustomBottomNavBar(
          currentIndex: dashboardController.currentIndex.value,
          onTap: dashboardController.changeIndex,
        ),
      ),
    );
  }

  Widget _buildMainFormContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 100.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 40.r,
            spreadRadius: 0,
            offset: Offset(0, 20.h),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormHeader(),
          SizedBox(height: 34.h),
          _buildLabel('FULL NAME'),
          SizedBox(height: 12.h),
          Obx(
                () => CustomTextField(
              controller: empcontroller.fullNameController,
              hint: 'e.g. Julian Aether',
              errorText: empcontroller.nameError.value,
              onChanged: empcontroller.validateName,
            ),
          ),
          SizedBox(height: 26.h),
          _buildLabel('PHONE NUMBER'),
          SizedBox(height: 12.h),
          Obx(
                () => CustomTextField(
              hint: '+1 (555) 000-0000',
              controller: empcontroller.phoneController,
              keyboardType: TextInputType.phone,
              errorText: empcontroller.phoneError.value,
              onChanged: empcontroller.validatePhone,
            ),
          ),
          SizedBox(height: 28.h),

          _buildLabel('EMAIL'),
          SizedBox(height: 12.h),
          Obx(
                () => CustomTextField(
              hint: 'example@email.com',
              controller: empcontroller.emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: empcontroller.emailError.value,
              onChanged: empcontroller.validateEmail,
            ),
          ),
          SizedBox(height: 28.h),
          _buildLabel('ASSIGN ROLE'),
          SizedBox(height: 12.h),
          _buildRoleDropdown(),
          SizedBox(height: 30.h),

          Obx(() {
            final isDriver =
                empcontroller.selectedRole.value.trim().toLowerCase() == 'driver';

            if (!isDriver) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 26.h),
                CustomUploadCard(
                  selectedFile: upcontroller.selectedFile,
                  onTap: upcontroller.pickFile,
                  isUploading: upcontroller.isUploading,
                  subtitle: 'Drag and drop or click to browse',
                  title: 'Upload ID or License',
                  iconPath: 'assets/images/uplodico.png',
                ),
              ],
            );
          }),

          SizedBox(height: 40.h),
          Obx(
                () => CustomButton(
              text: empcontroller.isLoading.value ? 'Saving' : 'Save Employee',
              textcolor: Colors.white,
              gradient: AppColor.primaryGradient,
              onTap: () {
                print('ADD BUTTON CLICKED');
                print('IMAGE PATH: ${upcontroller.imagePath.value}');

                if (empcontroller.isLoading.value) return;

                empcontroller.saveEmployee(
                  drivingLicensePath: upcontroller.imagePath.value,
                );
              },
            ),
          ),
          SizedBox(height: 30.h),
          CustomButton(
            textcolor: Colors.black,
            text: 'Cancle',
            onTap: () => Get.back(),
            color: Colors.black.withOpacity(0.045),
          ),
        ],
      ),
    );
  }

  Widget _buildFormHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Employee Profile',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            height: 1.2,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF191C1E),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Onboard a new member to the Aether fleet\nmanagement system.',
          style: GoogleFonts.manrope(
            fontSize: 14.sp,
            height: 1.45,
            color: const Color(0xFF45464D),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 11.sp,
        letterSpacing: 1.4,
        color: const Color(0xFF75859D),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Obx(
          () => Container(
        height: 55.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: AppColor.backtxt,
          borderRadius: BorderRadius.circular(32.r),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: empcontroller.selectedRole.value,
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: const Color(0xFF64748B),
              size: 24.sp,
            ),
            style: GoogleFonts.manrope(
              fontSize: 16.sp,
              color: const Color(0xFF191C1E),
            ),
            items: empcontroller.roles.map((role) {
              return DropdownMenuItem<String>(
                value: role,
                child: Text(
                  role,
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    color: const Color(0xFF191C1E),
                  ),
                ),
              );
            }).toList(),
            onChanged: empcontroller.changeRole,
          ),
        ),
      ),
    );
  }
}