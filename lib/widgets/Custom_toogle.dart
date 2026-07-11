import 'package:flutter/material.dart';

/// توجل مخصص بشكل iOS-style، بنفس تصميم توجلات التطبيق الحالية
/// بس بلون كحلي (0xff111827) عند التفعيل بدل الموف/البنفسجي.
///
/// [value]      الحالة الحالية (مفعّل/مطفي)
/// [onChanged]  بيرجع null إذا بدك التوجل يكون مقفول (disabled) - مفيد
///              لحالة "لو مختار سائق، لازم يضل مفعّل إجباري وما يقدر يطفيه"
class CustomToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  static const Color activeColor = Color(0xff111827); // كحلي بدل الموف
  static const Color inactiveColor = Color(0xffE4E7EC);
  static const double width = 46;
  static const double height = 26;

  const CustomToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLocked = onChanged == null;

    return GestureDetector(
      onTap: isLocked ? null : () => onChanged!(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        width: width,
        height: height,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          alignment:
          value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: height - 6,
            height: height - 6,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}