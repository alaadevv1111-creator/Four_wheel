import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class AccessoryCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String price;
  final double averageRating;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onViewDetails;

  const AccessoryCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.averageRating,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
    this.onViewDetails,
  });

  @override
  State<AccessoryCard> createState() => _AccessoryCardState();
}

class _AccessoryCardState extends State<AccessoryCard> {
  // متغير داخلي لحفظ حالة المفضلة
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  // لتحديث الحالة الداخلية إذا تغيرت القيمة القادمة من الخارج
  @override
  void didUpdateWidget(covariant AccessoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      _isFavorite = widget.isFavorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 185.w,
        height: 330.h,
        decoration: BoxDecoration(
          color: AppColor.cardBg,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                  child: Image.network(
                    widget.imageUrl,
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180.h,
                      width: double.infinity,
                      color: const Color(0xFFF1F5F9),
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: const Color(0xFF64748B),
                          size: 40.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFavorite = !_isFavorite; // تحديث الواجهة فوراً
                      });
                      if (widget.onFavoriteTap != null) {
                        widget.onFavoriteTap!(); // استدعاء الدالة الخارجية لتحديث البيانات بقاعدة البيانات أو السيرفر
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: const BoxDecoration(
                        color: AppColor.cardBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? AppColor.favoriteRed : AppColor.textMuted,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.manrope(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primary,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: 16.sp,
                                  color: widget.averageRating == 0 ? Colors.grey : const Color(0xFFFFB000),
                                ),
                                SizedBox(width: 2.w),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    widget.averageRating == 0 ? "NEW" : widget.averageRating.toStringAsFixed(1),
                                    style: GoogleFonts.manrope(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: widget.averageRating == 0 ? Colors.grey : AppColor.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.price,
                            style: GoogleFonts.manrope(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColor.cardprim,
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: widget.onViewDetails,
                      child: Container(
                        width: double.infinity,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6E8EA),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "View Details",
                          style: GoogleFonts.manrope(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}