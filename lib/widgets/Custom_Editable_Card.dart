import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomEditableCard extends StatefulWidget {
  final String label;
  final String value;
  final Function(String) onSave;
  final bool isEditable;

  const CustomEditableCard({
    super.key,
    required this.label,
    required this.value,
    required this.onSave,
    this.isEditable = true,
  });

  @override
  State<CustomEditableCard> createState() => _CustomEditableCardState();
}

class _CustomEditableCardState extends State<CustomEditableCard> {
  bool isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant CustomEditableCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // تحديث نص الحقل إذا تغيرت القيمة القادمة من الـ Controller (مثلاً بعد تحميل الـ API)
    if (oldWidget.value != widget.value && !isEditing) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isEditing ? _buildEditMode() : _buildDisplayMode(),
    );
  }

  Widget _buildDisplayMode() {
    return Container(
      key: const ValueKey(1),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.bcolorsmalltitle,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  widget.value.isEmpty ? "Loading..." : widget.value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primary,
                  ),
                ),
              ],
            ),
          ),
          if (widget.isEditable)
            IconButton(
              onPressed: () {
                setState(() {
                  _controller.text = widget.value;
                  isEditing = true;
                });
              },
              icon: Icon(Icons.edit_outlined, color: AppColor.cardprim, size: 15.sp),
            ),
        ],
      ),
    );
  }

  Widget _buildEditMode() {
    return Container(
      key: const ValueKey(2),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isEditing = false;
                      });
                    },
                    child: Icon(Icons.close, color: const Color(0xFFBA1A1A), size: 15.sp),
                  ),
                  SizedBox(width: 20.w),
                  GestureDetector(
                    onTap: () {
                      widget.onSave(_controller.text);
                      setState(() {
                        isEditing = false;
                      });
                    },
                    child: Icon(Icons.check, color: const Color(0xFF38485D), size: 18.sp),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: TextField(
              controller: _controller,
              autofocus: true,
              style: TextStyle(fontSize: 16.sp, color: AppColor.primary, fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter new value...",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
