import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class CustomAccessoriesRentalCard extends StatelessWidget {
  final String orderNumber;
  final String productName;
  final String purchasedDate;
  final String price;
  final String imageUrl;
  final VoidCallback? onViewDetails;
  final VoidCallback? onAccept;
  final VoidCallback? onDelete;

  const CustomAccessoriesRentalCard({
    super.key,
    required this.orderNumber,
    required this.productName,
    required this.purchasedDate,
    required this.price,
    required this.imageUrl,
    this.onViewDetails,
    this.onAccept,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342.w,
      height: 230.h,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // الجزء العلوي: الصورة والبيانات
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة المنتج (Product Image)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    imageUrl,
                    width: 104.w,
                    height: 104.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 104.w,
                      height: 104.h,
                      color: AppColor.backhedar,
                      child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                // التفاصيل (Details)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // رقم الطلب
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          orderNumber,
                          style: GoogleFonts.manrope(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF3A485B),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // اسم المنتج
                      Text(
                        productName,
                        style: GoogleFonts.manrope(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primary, // 191C1E
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      // تاريخ الشراء
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Purchased: $purchasedDate",
                          style: GoogleFonts.manrope(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400, // Regular
                            color: AppColor.bcolorsmalltitle, // 45464D
                          ),
                        ),
                      ),
                      const Spacer(),
                      // السعر
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          price,
                          style: GoogleFonts.manrope(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800, // ExtraBold
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // الجزء السفلي: الأزرار وأيقونة الحذف
          Row(
            children: [
              if (onViewDetails != null)
                _buildButton(
                  text: "View Details",
                  onTap: onViewDetails!,
                  isPrimary: false,
                ),
              if (onViewDetails != null && onAccept != null)
                SizedBox(width: 12.w),
              if (onAccept != null)
                _buildButton(
                  text: "Accept",
                  onTap: onAccept!,
                  isPrimary: true,
                ),
              const Spacer(),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFBA1A1A),
                    size: 24,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 123.w,
        height: 46.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: isPrimary ? null : Border.all(color: AppColor.colorbackexport),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              text,
              style: GoogleFonts.manrope(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isPrimary ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


