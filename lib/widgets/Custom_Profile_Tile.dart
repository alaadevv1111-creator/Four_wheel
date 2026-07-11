import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/colors.dart';

class CustomProfileTile extends StatelessWidget {
  final IconData? leadingIcon;
  final String? leadingPath;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color? color;
  final Widget? trailing;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final bool showCard;

  const CustomProfileTile({
    super.key,
    this.leadingIcon,
    this.leadingPath,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.color,
    this.trailing,
    this.titleFontSize,
    this.titleFontWeight,
    this.showCard = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color mainTextColor = color ?? AppColor.primary;
    final Color subTextColor = color ?? AppColor.bcolorsmalltitle;
    final Color iconColor = color ?? AppColor.cardprim;

    // Adjusting vertical padding to match CustomEditableCard height when showCard is true
    // CustomEditableCard has vertical: 20.h but has two lines of text + SizedBox(8.h)
    // Here we increase it to 28.h to achieve similar visual height for a single line tile.
    Widget content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: showCard ? 28.h : 20.h,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: showCard ? const Color(0xFFF1F5F9) : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: showCard
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: leadingPath != null
                ? SvgPicture.asset(
                    leadingPath!,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    width: 20.sp,
                    height: 20.sp,
                  )
                : Icon(leadingIcon ?? Icons.info, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleFontSize ?? 16.sp,
                    fontWeight: titleFontWeight ?? FontWeight.w500,
                    color: mainTextColor,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: subTextColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null)
            trailing ??
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14.sp,
                  color: const Color(0xFFC6C6CD),
                ),
        ],
      ),
    );

    if (showCard) {
      return Container(
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12.r),
            child: content,
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        highlightColor: onTap == null ? Colors.transparent : null,
        splashColor: onTap == null ? Colors.transparent : null,
        child: content,
      ),
    );
  }
}
