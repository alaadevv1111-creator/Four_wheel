import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'no_license.dart' show DriverDialogColors;

/// نتيجة إضافة رخصة جديدة
class AddedLicenseResult {
  final String licenseNumber;
  final File imageFile;

  AddedLicenseResult({
    required this.licenseNumber,
    required this.imageFile,
  });
}

/// ديالوج "Add Driving License"
/// بيرجع AddedLicenseResult عند الحفظ الناجح، أو null إذا Cancel.
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 30,
                offset: const Offset(0, 12),
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
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: DriverDialogColors.navy,
                ),
              ),
              const SizedBox(height: 20),

              _label('License Number'),
              const SizedBox(height: 8),
              TextField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                maxLength: 14,
                style: GoogleFonts.manrope(fontSize: 13.5),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Enter 14-digit license number',
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 13,
                    color: DriverDialogColors.textGrey,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    const BorderSide(color: DriverDialogColors.navy),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              _label('License Image'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: DriverDialogColors.bgGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'اختيار ملف',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: DriverDialogColors.navy,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _pickedImage == null
                              ? 'لم يتِم اختيار أيّ ملف'
                              : _pickedImage!.path.split('/').last,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: DriverDialogColors.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_errorText != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorText!,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xffF04438),
                  ),
                ),
              ],

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _onSave,
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              DriverDialogColors.gold,
                              DriverDialogColors.goldDark,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'Save',
                          style: GoogleFonts.manrope(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: DriverDialogColors.navy,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context, null),
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              DriverDialogColors.navy,
                              DriverDialogColors.navyLight,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.manrope(
                            fontSize: 13.5,
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
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: DriverDialogColors.navy,
      ),
    );
  }
}