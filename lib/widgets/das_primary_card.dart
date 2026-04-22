import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPrimaryCard extends StatelessWidget {
  final double? width;
  final double? height;
  final String title;
  final String value;
  final IconData icon;
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final List<Color> gradientColors;
  final BorderRadiusGeometry borderRadius;
  final Color titleColor;
  final Color valueColor;
  final Color iconBackgroundColor;
  final Color iconColor;

  const DashboardPrimaryCard({
    super.key,
    this.width,
    this.height,
    required this.title,
    required this.value,
    required this.icon,
    this.child,
    this.padding = const EdgeInsets.all(18),
    this.gradientColors = const [
      Color(0xff111C34),
      Color(0xff55637E),
    ],
    this.borderRadius = const BorderRadius.all(Radius.circular(22)),
    this.titleColor = Colors.white70,
    this.valueColor = Colors.white,
    this.iconBackgroundColor = const Color.fromRGBO(255, 255, 255, .12),
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const Spacer(),
              Text(
                title.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
          if (child != null) ...[
            const SizedBox(height: 14),
            child!,
          ],
        ],
      ),
    );
  }
}