import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// [InfoCard] هي ويدجت مخصصة لعرض بطاقة معلومات صغيرة (مثل الكمية أو السعر).
/// تُستخدم لتوحيد شكل عرض البيانات الرقمية في صفحة تفاصيل المنتج.
class InfoCard extends StatelessWidget {
  final String title; // عنوان المعلومة (مثال: "INVENTORY")
  final String value; // قيمة المعلومة (مثال: "42")
  final String? unit; // وحدة القياس (مثال: "units") - اختياري
  final bool isPrice; // هل هذه القيمة تمثل سعراً؟ (لإضافة علامة $)
  final double? width; // عرض البطاقة (افتراضي 163)
  final double? height; // ارتفاع البطاقة (افتراضي 128)

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    this.isPrice = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 163.w,
      height: height ?? 128.h,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // تسمية المعلومة العلوية (تباعد أحرف 1.2 كما هو مطلوب في التصميم)
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 12.sp,
              fontWeight: FontWeight.normal,
              color: AppColor.bcolorsmalltitle,
              letterSpacing: 1.2,
            ),
          ),
          // عرض القيمة مع الوحدة أو رمز العملة
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (isPrice)
                Text(
                  "\$ ",
                  style: GoogleFonts.manrope(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.normal,
                    color: AppColor.bcolorsmalltitle,
                  ),
                ),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: GoogleFonts.manrope(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.normal,
                      color: AppColor.primary,
                    ),
                  ),
                ),
              ),
              if (unit != null)
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Text(
                    unit!,
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      color: AppColor.bcolorsmalltitle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
