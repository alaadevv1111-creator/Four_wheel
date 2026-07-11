import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class CustomCarsRentalCard extends StatelessWidget {
  final String orderNumber;
  final String imageUrl;
  final String dateRange;
  final String carName;
  final String price;
  final String customerName;
  final String customerAvatarUrl;
  final VoidCallback onViewDetails;
  final VoidCallback? onAccept;
  final VoidCallback? onDelete; // تم جعلها nullable

  const CustomCarsRentalCard({
    super.key,
    required this.orderNumber,
    required this.imageUrl,
    required this.dateRange,
    required this.carName,
    required this.price,
    required this.customerName,
    required this.customerAvatarUrl,
    required this.onViewDetails,
    this.onDelete, // تم إزالة required
    this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. الصورة في الأعلى
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 160.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 160.h,
                width: double.infinity,
                color: AppColor.backhedar,
                child: const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // 2. رقم الطلب والتاريخ (جنب بعض)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    orderNumber,
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    dateRange,
                    style: GoogleFonts.manrope(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.bcolorsmalltitle,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),

          // 3. اسم السيارة والسعر (جنب بعض)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    carName,
                    style: GoogleFonts.manrope(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.cardprim2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    price,
                    style: GoogleFonts.manrope(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // 4. بيانات العميل
          Row(
            children: [
              CircleAvatar(
                radius: 14.r,
                backgroundImage: NetworkImage(customerAvatarUrl),
                backgroundColor: AppColor.backhedar,
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    customerName,
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      color: AppColor.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // 5. الأزرار
          Row(
            children: [
              _buildButton(
                text: "View Details",
                onTap: onViewDetails,
                isBlack: false,
              ),
              if (onAccept != null) ...[
                SizedBox(width: 12.w),
                _buildButton(
                  text: "Accept",
                  onTap: onAccept!,
                  isBlack: true,
                ),
              ],
              // عرض أيقونة الحذف فقط إذا لم تكن null
              if (onDelete != null) ...[
                const Spacer(),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColor.favoriteRed,
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onTap,
    required bool isBlack,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 123.w,
        height: 46.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isBlack ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: isBlack ? null : Border.all(color: AppColor.secondary),
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
                color: isBlack ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}