import 'package:flutter/material.dart';

class CustomRatingStars extends StatelessWidget {
  final double rating;
  final bool enabled;
  final double size;
  final ValueChanged<int>? onChanged;

  const CustomRatingStars({
    super.key,
    required this.rating,
    this.enabled = false,
    this.size = 22,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final isSelected = starValue <= rating.round();

        return GestureDetector(
          onTap: enabled && onChanged != null
              ? () => onChanged!(starValue)
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Icon(
              Icons.star_rounded,
              size: size,
              color: isSelected
                  ? const Color(0xffF9A800)
                  : const Color(0xffCBD0D8),
            ),
          ),
        );
      }),
    );
  }
}