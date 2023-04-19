import 'package:common/constants/constants_colors.dart';
import 'package:flutter/material.dart';

class CustomPaintBadge extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = kMainColor
      ..strokeCap = StrokeCap.round;

    const double radius = 5;
    const double width = 2;
    Path path = Path()
      ..moveTo(0, width)
      ..lineTo(0, 43 - width)
      ..arcToPoint(
        const Offset(width, 43),
        radius: const Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(18 - width, 35)
      ..arcToPoint(
        const Offset(18 + width, 35),
        radius: const Radius.circular(radius),
      )
      ..lineTo(36 - width, 43)
      ..arcToPoint(
        const Offset(36, 43 - width),
        radius: const Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(36, width)
      ..arcToPoint(
        const Offset(36 - width, 0),
        radius: const Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(width, 0)
      ..arcToPoint(
        const Offset(0, width),
        radius: const Radius.circular(radius),
        clockwise: false,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
