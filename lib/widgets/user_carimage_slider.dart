import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarDetailsImageSlider extends StatelessWidget {
  final List<String> images;
  final RxInt currentIndex;
  final ValueChanged<int> onPageChanged;

  const CarDetailsImageSlider({
    super.key,
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 455.h,
          width: double.infinity,
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return _buildImage(images[index]);
            },
          ),
        ),

        Positioned(
          bottom: 26.h,
          left: 0,
          right: 0,
          child: Obx(
                () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                final isSelected = currentIndex.value == index;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: isSelected ? 9.w : 7.w,
                  height: isSelected ? 9.h : 7.h,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.45),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String image) {
    if (image.startsWith('http')) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    if (image.isNotEmpty) {
      return Image.file(
        File(image),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xffE5E7EB),
      child: Icon(
        Icons.directions_car_filled_outlined,
        size: 70.sp,
        color: const Color(0xff94A3B8),
      ),
    );
  }
}