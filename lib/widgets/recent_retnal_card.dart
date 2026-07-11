import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentRentalItemCard extends StatelessWidget {
  final String image;
  final String title;
  final String name;
  final String date;
  final String price;

  const RecentRentalItemCard({
    super.key,
    required this.image,
    required this.title,
    required this.name,
    required this.date,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: image.startsWith('http')
                  ? Image.network(
                image,
                width: 78.w,
                height: 78.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 78.w,
                  height: 78.h,
                  color: Colors.grey[100],
                  child: Icon(
                    Icons.directions_car,
                    color: Colors.grey,
                  ),
                ),
              )
                  : Image.asset(
                image,
                width: 78.w,
                height: 78.h,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(width: 16.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w800)),
                  SizedBox(height: 2.h),
                  Text(name,
                      style: TextStyle(
                          fontSize: 12.sp, color: const Color(0xff9CA3AF))),
                  SizedBox(height: 10.h),
                  Text(date,
                      style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1)),
                  SizedBox(height: 3.h),
                  Text(price,
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Icon(
                Icons.check_circle,
                color: const Color(0xff31C48D),
                size: 22.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}