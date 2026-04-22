import 'package:flutter/material.dart';
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
      height: widget.height ?? 55,
      decoration: BoxDecoration(
        color: AppColor.backtxt,
        borderRadius: BorderRadius.circular(32),
      ),

      child: Row(
        children: [
          const SizedBox(width: 12),


          if (widget.icon != null)
            Icon(widget.icon, color: AppColor.iconColor),

          const SizedBox(width: 10),


          Expanded(
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
              textAlignVertical: TextAlignVertical.center,
            obscureText: widget.isPassword?isHidden:false,
            decoration: InputDecoration(
              hintText: widget.hint,
                border: InputBorder.none,
              isCollapsed: true,
              hintStyle: GoogleFonts.manrope(
                  color: AppColor.textHint,
                  fontSize: 16,
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
                isHidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColor.iconColor,
              ),
            ),

          const SizedBox(width: 12),
        ],
      ),
    );
  }
}