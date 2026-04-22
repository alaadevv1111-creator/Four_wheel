import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardInfoCard extends StatelessWidget {
  final double? width;
  final double? height;
  final String title;
  final String value;
  final IconData icon;
  final Widget? bottomWidget;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;

  const DashboardInfoCard({
    super.key,
    this.width,
    this.height,
    required this.title,
    required this.value,
    required this.icon,
    this.bottomWidget,
    this.padding = const EdgeInsets.all(18),
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(22)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xffF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: const Color(0xff6B7280),
                ),
              ),
              const Spacer(),
              Text(
                title.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff9CA3AF),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: const Color(0xff111827),
            ),
          ),
          if (bottomWidget != null) ...[
            const SizedBox(height: 14),
            bottomWidget!,
          ],
        ],
      ),
    );
  }
}