import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomUploadCard extends StatelessWidget {
  const CustomUploadCard({
    super.key,
    required this.onTap,
    this.selectedFile,
    this.isUploading,
    this.sectionTitle = 'VERIFICATION DOCUMENTS',
    this.title = 'Upload ID or License',
    this.subtitle = 'Drag and drop or click to browse',
    this.iconPath,
    this.icon = Icons.cloud_upload_outlined,
    this.backgroundColor = const Color(0xFFF7F8FA),
    this.backgroundImage,
    this.backgroundImageOpacity = 1.0,
    this.height = 185,
  });

  final VoidCallback onTap;

  final Rxn<PlatformFile>? selectedFile;
  final RxBool? isUploading;

  final String sectionTitle;
  final String title;
  final String subtitle;

  final String? iconPath;
  final IconData icon;

  final Color backgroundColor;
  final String? backgroundImage;
  final double backgroundImageOpacity;

  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: Color(0xFF7D8DA8),
          ),
        ),

        const SizedBox(height: 12),

        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: const Radius.circular(24),
              color: const Color(0xFFDDE2EA),
              strokeWidth: 1.4,
              dashPattern: const [6, 4],
              padding: EdgeInsets.zero,
            ),
            child: Container(
              width: double.infinity,
              height: height,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(24),
                image: backgroundImage == null
                    ? null
                    : DecorationImage(
                  image: AssetImage(backgroundImage!),
                  fit: BoxFit.cover,
                  opacity: backgroundImageOpacity,
                ),
              ),
              child: _buildContent(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Obx(() {
      final fileName = selectedFile?.value?.name;
      final loading = isUploading?.value ?? false;

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: loading
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : iconPath != null
                  ? Image.asset(
                iconPath!,
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              )
                  : Icon(
                icon,
                size: 28,
                color: const Color(0xFF5D6D86),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            fileName ?? title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF191C1E),
            ),
          ),

          const SizedBox(height: 7),

          Text(
            fileName == null ? subtitle : 'File selected successfully',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4E5664),
            ),
          ),
        ],
      );
    });
  }
}