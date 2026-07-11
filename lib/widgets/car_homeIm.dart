import 'dart:io';

import 'package:flutter/material.dart';
import 'package:four_wheels/constants/colors.dart';

class CarHeroImage extends StatelessWidget {
  const CarHeroImage({
    super.key,
    required this.imagePath,
    this.badgeText = 'ACTIVE FLEET',
    this.defaultImg = 'assets/images/Addcar.png',
  });

  final String imagePath;
  final String badgeText;
  final String defaultImg;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 272,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              child: _buildImage(),
            ),
          ),

          Positioned(
            left: 24,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xffE5EAF0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: AppColor.primaryDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (imagePath.trim().isEmpty) {
      return _defaultImage();
    }

    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: double.infinity,
        height: 272,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _defaultImage();
        },
      );
    }

    return Image.file(
      File(imagePath),
      width: double.infinity,
      height: 272,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _defaultImage();
      },
    );
  }

  Widget _defaultImage() {
    return Image.asset(
      defaultImg,
      width: double.infinity,
      height: 272,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: double.infinity,
          height: 272,
          color: Color(0xffE5EAF0),
          child: Icon(
            Icons.directions_car_filled_outlined,
            size: 70,
            color: Color(0xff8A94A6),
          ),
        );
      },
    );
  }
}