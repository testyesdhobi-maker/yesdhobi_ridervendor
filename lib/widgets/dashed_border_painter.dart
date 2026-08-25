import 'dart:math';
import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;
  final bool isCircle;

  DashedBorderPainter({
    this.color = const Color(0xFF3045E8),
    this.strokeWidth = 1.5,
    this.dashWidth = 6.0,
    this.dashSpace = 4.0,
    this.borderRadius = 12.0,
    this.isCircle = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    if (isCircle) {
      final double radius = size.width / 2;
      final double circumference = 2 * pi * radius;
      final int dashCount = (circumference / (dashWidth + dashSpace)).floor();
      final double angleStep = 2 * pi / dashCount;

      for (int i = 0; i < dashCount; i++) {
        final double startAngle = i * angleStep;
        final double sweepAngle = angleStep * (dashWidth / (dashWidth + dashSpace));
        canvas.drawArc(
          Rect.fromCircle(center: Offset(radius, radius), radius: radius),
          startAngle,
          sweepAngle,
          false,
          paint,
        );
      }
    } else {
      final path = Path();
      
      // Draw rounded rectangle path
      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

      final dashPath = Path();
      final metrics = path.computeMetrics();
      for (final metric in metrics) {
        double distance = 0.0;
        while (distance < metric.length) {
          final double length = min(dashWidth, metric.length - distance);
          dashPath.addPath(
            metric.extractPath(distance, distance + length),
            Offset.zero,
          );
          distance += dashWidth + dashSpace;
        }
      }
      canvas.drawPath(dashPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.isCircle != isCircle;
  }
}
