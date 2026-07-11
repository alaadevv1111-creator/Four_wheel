import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'no_lisencedailog.dart' show DriverDialogColors;

class AddedLicenseResult {
  final String licenseNumber;
  final File imageFile;

  AddedLicenseResult({
    required this.licenseNumber,
    required this.imageFile,
  });
}

class AddDrivingLicenseDialog extends StatefulWidget {
  const AddDrivingLicenseDialog({super.key});

  static Future<AddedLicenseResult?> show(BuildContext context) {
    return showDialog<AddedLicenseResult>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const AddDrivingLicenseDialog(),
    );
  }

  @override
  State<AddDrivingLicenseDialog> createState() =>
      _AddDrivingLicenseDialogState();
}

class _AddDrivingLicenseDialogState extends State<AddDrivingLicenseDialog> {
  final TextEditingController _numberController = TextEditingController();
  File? _pickedImage;
  String? _errorText;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _pickedImage = File(file.path));
    }
  }

  void _onSave() {
    final number = _numberController.text.trim();

    if (number.length != 14) {
      setState(() => _errorText = 'License number must be 14 digits');
      return;
    }

    if (_pickedImage == null) {
      setState(() => _errorText = 'Please select a license image');
      return;
    }

    Navigator.pop(
      context,
      AddedLicenseResult(licenseNumber: number, imageFile: _pickedImage!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 440.w),
        child: Container(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 22.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 30.r,
                offset: Offset(0, 12.h),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Driving License',
                style: GoogleFonts.manrope(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w800,
                  color: DriverDialogColors.navy,
                ),
              ),
              SizedBox(height: 20.h),

              _label('License Number'),
              SizedBox(height: 8.h),
              TextField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                maxLength: 14,
                style: GoogleFonts.manrope(fontSize: 13.5.sp),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Enter 14-digit license number',
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 13.sp,
                    color: DriverDialogColors.textGrey,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 14.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide:
                    const BorderSide(color: DriverDialogColors.navy),
                  ),
                ),
              ),

              SizedBox(height: 18.h),

              _label('License Image'),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: DriverDialogColors.bgGrey,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'اختيار ملف',
                          style: GoogleFonts.manrope(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: DriverDialogColors.navy,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          _pickedImage == null
                              ? 'لم يتِم اختيار أيّ ملف'
                              : _pickedImage!.path.split('/').last,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: 12.sp,
                            color: DriverDialogColors.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_errorText != null) ...[
                SizedBox(height: 10.h),
                Text(
                  _errorText!,
                  style: GoogleFonts.manrope(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xffF04438),
                  ),
                ),
              ],

              SizedBox(height: 22.h),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _onSave,
                      child: Container(
                        height: 48.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              DriverDialogColors.gold,
                              DriverDialogColors.goldDark,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Text(
                          'Save',
                          style: GoogleFonts.manrope(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w800,
                            color: DriverDialogColors.navy,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context, null),
                      child: Container(
                        height: 48.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              DriverDialogColors.navy,
                              DriverDialogColors.navyLight,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.manrope(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
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
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: DriverDialogColors.navy,
      ),
    );
  }
}