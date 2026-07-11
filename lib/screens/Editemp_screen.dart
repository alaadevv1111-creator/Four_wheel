import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/constants/colors.dart';
import 'package:four_wheels/controller/EditEmp_controller.dart';
import 'package:four_wheels/widgets/custom_button.dart';
import 'package:four_wheels/widgets/custom_textfield.dart';
import 'package:four_wheels/widgets/emp_avater.dart';

class EditEmployeeScreen extends StatefulWidget {
  const EditEmployeeScreen({super.key});

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  late final EditEmployeeController editController;

  @override
  void initState() {
    super.initState();
    editController = Get.put(EditEmployeeController());
  }

  @override
  void dispose() {
    Get.delete<EditEmployeeController>();
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
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: const Color(0xff111827),
            size: 20.sp,
          ),
        ),
        title: Text(
          "Edit Employee",
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xff111827),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
          child: Column(
            children: [
              _buildAvatarSection(),

              SizedBox(height: 28.h),

              _buildInfoCard(),

              SizedBox(height: 22.h),

              _buildRoleStatusCard(),

              SizedBox(height: 42.h),

              Obx(
                    () => CustomButton(
                  onTap: () {
                    if (editController.isLoading.value) return;
                    editController.saveChanges();
                  },
                  width: double.infinity,
                  height: 54.h,
                  textcolor: Colors.white,
                  text: editController.isLoading.value
                      ? "Saving..."
                      : "Save Changes",
                  gradient: AppColor.primaryGradient,
                ),
              ),

              SizedBox(height: 20.h),

              GestureDetector(
                onTap: () => Get.back(),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff566276),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    final employee = editController.empController.selectedEmployee.value;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Obx(
                  () => EmployeeAvatar(
                imagePath: editController.uploadController.imagePath.value,
                size: 118,
                isCircle: true,
                onEditTap: editController.pickEmployeeImage,
              ),
            ),

            Positioned(
              right: 4.w,
              bottom: 7.h,
              child: GestureDetector(
                onTap: () {
                  editController.pickEmployeeImage();
                },
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: const Color(0xff202A3D),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3.w,
                    ),
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 17.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        Text(
          "Employee ID: ${employee?.id ?? '-'}",
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xff45464D),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 22.h),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldTitle("Full Name"),

          SizedBox(height: 9.h),

          Obx(
                () => CustomTextField(
              hint: "Full Name",
              controller: editController.fullNameController,
              errorText: editController.nameError.value,
              onChanged: editController.validateName,
              height: 48.h,
            ),
          ),

          SizedBox(height: 22.h),

          _fieldTitle("Phone Number"),

          SizedBox(height: 9.h),

          Obx(
                () => CustomTextField(
              hint: "+1 (555) 000-0000",
              controller: editController.phoneController,
              keyboardType: TextInputType.phone,
              errorText: editController.phoneError.value,
              onChanged: editController.validatePhone,
              height: 48.h,
            ),
          ),

          SizedBox(height: 22.h),

          _fieldTitle("Email"),

          SizedBox(height: 9.h),

          Obx(
                () => CustomTextField(
              hint: "Email",
              controller: editController.emailController,
              keyboardType: TextInputType.emailAddress,
              errorText: editController.emailError.value,
              onChanged: editController.validateEmail,
              height: 48.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleStatusCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 22.h),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldTitle("Role"),

          SizedBox(height: 9.h),

          _buildRoleDropdown(),

          SizedBox(height: 28.h),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Status",
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff191C1E),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    Text(
                      "Manage active availability",
                      style: GoogleFonts.poppins(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff566276),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10.w),

              _buildStatusSwitch(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Obx(
          () => Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColor.backtxt,
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: editController.roles.contains(editController.selectedRole.value)
                ? editController.selectedRole.value
                : null,
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xff566276),
            ),
            style: GoogleFonts.poppins(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff191C1E),
            ),
            items: editController.roles.map((role) {
              return DropdownMenuItem<String>(
                value: role,
                child: Text(
                  role[0].toUpperCase() + role.substring(1),
                ),
              );
            }).toList(),
            onChanged: editController.changeRole,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSwitch() {
    return Obx(() {
      final isActive = editController.isActive.value;

      return Container(
        height: 38.h,
        padding: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          color: const Color(0xffF1F3F6),
          borderRadius: BorderRadius.circular(19.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _statusOption(
              title: "Active",
              selected: isActive,
              onTap: () => editController.changeStatus(true),
            ),
            _statusOption(
              title: "Inactive",
              selected: !isActive,
              onTap: () => editController.changeStatus(false),
            ),
          ],
        ),
      );
    });
  }

  Widget _statusOption({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32.h,
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: selected
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.r,
              offset: Offset(0, 3.h),
            ),
          ]
              : null,
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 11.5.sp,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected
                ? const Color(0xff191C1E)
                : const Color(0xff566276),
          ),
        ),
      ),
    );
  }

  Widget _fieldTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xff45464D),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.035),
          blurRadius: 22.r,
          offset: Offset(0, 10.h),
        ),
      ],
    );
  }
}