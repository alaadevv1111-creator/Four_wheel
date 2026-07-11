import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomUploadCard extends StatelessWidget {
  const CustomUploadCard({
    super.key,
    required this.onTap,
    required this.selectedFile,
    required this.isUploading,
    required this.title,
    required this.subtitle,
    EdgeInsetsGeometry? padding,
    this.iconPath,
    this.icon = Icons.cloud_upload_outlined,
    this.backgroundColor = const Color(0xFFF7F8FA),
    this.backgroundImage,
    this.backgroundImageOpacity = 0.25,
    double? height,
  })  : padding = padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        height = height ?? 220;

  final VoidCallback onTap;
  final Rxn<PlatformFile> selectedFile;
  final RxBool isUploading;
  final String title;
  final EdgeInsetsGeometry padding;
  final String? iconPath;
  final IconData icon;
  final String subtitle;
  final Color backgroundColor;
  final String? backgroundImage;
  final double backgroundImageOpacity;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(24.r),
              color: const Color(0xFFDDE2EA),
              strokeWidth: 1.4,
              dashPattern: const [6, 4],
              padding: EdgeInsets.zero,
            ),
            child: Container(
              width: double.infinity,
              height: height.h,
              padding: EdgeInsets.symmetric(
                horizontal: (padding as EdgeInsets).horizontal / 2,
                vertical: padding.vertical / 2,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(24.r),
                image: backgroundImage == null
                    ? null
                    : DecorationImage(
                  image: AssetImage(backgroundImage!),
                  fit: BoxFit.cover,
                  opacity: backgroundImageOpacity,
                ),
              ),
              child: Obx(() {
                final file = selectedFile.value;
                final loading = isUploading.value;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52.w,
                      height: 52.h,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: loading
                            ? SizedBox(
                          width: 22.w,
                          height: 22.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                            : iconPath != null
                            ? Image.asset(
                          iconPath!,
                          width: 28.w,
                          height: 28.h,
                          fit: BoxFit.contain,
                        )
                            : Icon(
                          icon,
                          size: 28.sp,
                          color: const Color(0xFF5D6D86),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: Text(
                        file == null ? title : file.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontSize: 16.sp,
                          color: const Color(0xFF191C1E),
                        ),
                      ),
                    ),

                    SizedBox(height: 7.h),

                    Text(
                      file == null ? subtitle : 'File selected successfully',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        color: const Color(0xFF4E5664),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}