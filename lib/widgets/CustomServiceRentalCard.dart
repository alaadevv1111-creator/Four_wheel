import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomOrderCard extends StatelessWidget {
  final String orderNumber;
  final String title;
  final String dateTime;
  final String location;
  final VoidCallback? onViewDetails;
  final VoidCallback? onAccept;
  final VoidCallback? onDelete;

  const CustomOrderCard({
    super.key,
    required this.orderNumber,
    required this.title,
    required this.dateTime,
    required this.location,
    this.onViewDetails,
    this.onAccept,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358.w,
      height: 248.h,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Number
          Text(
            orderNumber,
            style: GoogleFonts.manrope(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400, // Regular
              color: const Color(0xFF45464D),
            ),
          ),
          SizedBox(height: 8.h),
          // Title
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF191C1E),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 16.h),
          // Date & Time
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 18.sp, color: const Color(0xFF45464D)),
              SizedBox(width: 12.w),
              Text(
                dateTime,
                style: GoogleFonts.manrope(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400, // Regular
                  color: const Color(0xFF45464D),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Location
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 20.sp, color: const Color(0xFF45464D)),
              SizedBox(width: 10.w),
              Text(
                location,
                style: GoogleFonts.manrope(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400, // Regular
                  color: const Color(0xFF45464D),
                ),
              ),
            ],
          ),
          const Spacer(),
          // Action Buttons
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
                    size: 26,
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
          border: isPrimary ? null : Border.all(color: const Color(0xFFE6E8EA)),
        ),
        child: Text(
          text,
          style: GoogleFonts.manrope(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isPrimary ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

// --- مثال للاختبار (Example for Testing) ---
class CustomOrderCardExample extends StatelessWidget {
  const CustomOrderCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text("Service Order Cards")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("الحالة الأولى: مع زر Accept", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10.h),
              CustomOrderCard(
                orderNumber: "#SR-9204",
                title: "Brake System Inspection",
                dateTime: "Oct 24, 2023 • 09:30 AM",
                location: "Downtown Service Hub, NY",
                onViewDetails: () {},
                onAccept: () {},
                onDelete: () {},
              ),
              SizedBox(height: 40.h),
              const Text("الحالة الثانية: بدون زر Accept", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10.h),
              CustomOrderCard(
                orderNumber: "#SR-9204",
                title: "Brake System Inspection",
                dateTime: "Oct 24, 2023 • 09:30 AM",
                location: "Downtown Service Hub, NY",
                onViewDetails: () {},
                onDelete: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}