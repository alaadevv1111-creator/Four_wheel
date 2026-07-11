import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';

class DashedBorderPainter extends CustomPainter {
  final Color? color;
  final double? strokeWidth;
  final double? borderRadius;

  DashedBorderPainter({
    this.color,
    this.strokeWidth,
    this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color ?? AppColor.borderGray
      ..strokeWidth = strokeWidth ?? 1.5
      ..style = PaintingStyle.stroke;

    const double dashWidth = 6;
    const double dashSpace = 4;
    
    final RRect rRect = RRect.fromLTRBR(
      0, 
      0, 
      size.width, 
      size.height, 
      Radius.circular(borderRadius ?? 12).r
    );
    
    final Path path = Path()..addRRect(rRect);

    final Path dashedPath = Path();
    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        dashedPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
