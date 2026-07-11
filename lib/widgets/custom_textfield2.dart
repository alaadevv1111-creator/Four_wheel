import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final IconData? icon;
  final double? width;
  final double? height;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Color? backgroundColor;
  final double? borderRadius;
  final Color? hintColor;
  final Color? textColor;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.hint,
    this.icon,
    this.width,
    this.height,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.backgroundColor,
    this.borderRadius,
    this.hintColor,
    this.textColor,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height,
      constraints: BoxConstraints(
        minHeight: widget.height ?? 55.h,
      ),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColor.backtxt,
        borderRadius: BorderRadius.circular((widget.borderRadius ?? 32).r),
      ),
      padding: EdgeInsets.symmetric(vertical: (widget.maxLines ?? 1) > 1 ? 12.h : 0),
      child: Row(
        crossAxisAlignment: (widget.maxLines ?? 1) > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(width: 12.w),
          if (widget.icon != null)
            Padding(
              padding: EdgeInsets.only(top: (widget.maxLines ?? 1) > 1 ? 4.h : 0),
              child: Icon(widget.icon, color: AppColor.iconColor, size: 22.sp),
            ),
          if (widget.icon != null) SizedBox(width: 10.w),
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              validator: widget.validator,
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              textAlignVertical: TextAlignVertical.center,
              obscureText: widget.isPassword ? isHidden : false,
              style: GoogleFonts.manrope(
                fontSize: 16.sp,
                color: widget.textColor ?? Colors.black,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                border: InputBorder.none,
                isCollapsed: true,
                hintStyle: GoogleFonts.manrope(
                  color: widget.hintColor ?? AppColor.textHint,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
          if (widget.isPassword)
            GestureDetector(
              onTap: () {
                setState(() {
                  isHidden = !isHidden;
                });
              },
              child: Icon(
                isHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColor.iconColor,
                size: 22.sp,
              ),
            ),
          SizedBox(width: 12.w),
        ],
      ),
    );
  }
}
