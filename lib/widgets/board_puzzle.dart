import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';

class BoardPuzzle extends CustomPainter {
  final Color puzzleColor;
  final double strokeWidth;

  BoardPuzzle({
    required this.puzzleColor,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final double scaleX = width / 152;
    final double scaleY = height / 92;

    final path = Path()
      ..moveTo(31.297 * scaleX, 59.147 * scaleY)
      ..lineTo(31.297 * scaleX, 91 * scaleY)
      ..lineTo(63.448 * scaleX, 91 * scaleY)
      ..cubicTo(70.662 * scaleX, 91 * scaleY, 68.667 * scaleX, 87.916 * scaleY,
          67.964 * scaleX, 85.107 * scaleY)
      ..cubicTo(67.429 * scaleX, 82.964 * scaleY, 62.071 * scaleX,
          78.679 * scaleY, 65.286 * scaleX, 69.282 * scaleY)
      ..cubicTo(68.316 * scaleX, 60.425 * scaleY, 83.501 * scaleX,
          59.147 * scaleY, 86.386 * scaleX, 69.282 * scaleY)
      ..cubicTo(89.272 * scaleX, 79.417 * scaleY, 83.871 * scaleX,
          79.518 * scaleY, 82.429 * scaleX, 85.309 * scaleY)
      ..cubicTo(81.274 * scaleX, 89.74 * scaleY, 87.452 * scaleX, 91 * scaleY,
          89.376 * scaleX, 91 * scaleY)
      ..lineTo(120.703 * scaleX, 91 * scaleY)
      ..lineTo(120.703 * scaleX, 60.595 * scaleY)
      ..cubicTo(120.703 * scaleX, 57.699 * scaleY, 122.435 * scaleX,
          52.776 * scaleY, 129.36 * scaleX, 56.251 * scaleY)
      ..cubicTo(138.016 * scaleX, 60.595 * scaleY, 144.57 * scaleX,
          57.699 * scaleY, 146.013 * scaleX, 56.251 * scaleY)
      ..cubicTo(147.455 * scaleX, 54.803 * scaleY, 151 * scaleX, 50.46 * scaleY,
          151 * scaleX, 46.116 * scaleY)
      ..cubicTo(151 * scaleX, 41.773 * scaleY, 148.354 * scaleX,
          35.981 * scaleY, 146.013 * scaleX, 34.415 * scaleY)
      ..cubicTo(141.684 * scaleX, 31.519 * scaleY, 134.197 * scaleX,
          32.213 * scaleY, 129.36 * scaleX, 35.981 * scaleY)
      ..cubicTo(124.75 * scaleX, 39.571 * scaleY, 120.703 * scaleX,
          36.893 * scaleY, 120.703 * scaleX, 33.838 * scaleY)
      ..lineTo(120.703 * scaleX, 1.233 * scaleY)
      ..lineTo(85.79 * scaleX, 1.233 * scaleY)
      ..cubicTo(83.386 * scaleX, 2.198 * scaleY, 81.585 * scaleX,
          4.997 * scaleY, 85.048 * scaleX, 8.472 * scaleY)
      ..cubicTo(88.51 * scaleX, 11.947 * scaleY, 89.376 * scaleX,
          16.676 * scaleY, 89.376 * scaleX, 18.607 * scaleY)
      ..cubicTo(89.376 * scaleX, 22.467 * scaleY, 87.562 * scaleX,
          30.973 * scaleY, 77.175 * scaleX, 30.973 * scaleY)
      ..cubicTo(64.191 * scaleX, 30.973 * scaleY, 63.119 * scaleX,
          20.055 * scaleY, 63.119 * scaleX, 18.607 * scaleY)
      ..cubicTo(63.119 * scaleX, 17.159 * scaleY, 63.119 * scaleX,
          15.711 * scaleY, 67.447 * scaleX, 8.472 * scaleY)
      ..cubicTo(70.91 * scaleX, 2.68 * scaleY, 65.043 * scaleX, 1.233 * scaleY,
          61.677 * scaleX, 1.233 * scaleY)
      ..lineTo(31.297 * scaleX, 1.233 * scaleY)
      ..lineTo(31.297 * scaleX, 24.399 * scaleY)
      ..cubicTo(32.071 * scaleX, 35.822 * scaleY, 31.297 * scaleX,
          38.501 * scaleY, 25.526 * scaleX, 37.43 * scaleY)
      ..cubicTo(22.636 * scaleX, 36.894 * scaleY, 18.07 * scaleX,
          29.744 * scaleY, 6.893 * scaleX, 34.215 * scaleY)
      ..cubicTo(1.536 * scaleX, 36.357 * scaleY, 1 * scaleX, 42.786 * scaleY,
          1 * scaleX, 46.116 * scaleY)
      ..cubicTo(1 * scaleX, 49.012 * scaleY, 2.443 * scaleX, 55.383 * scaleY,
          8.213 * scaleX, 57.699 * scaleY)
      ..cubicTo(15.427 * scaleX, 60.595 * scaleY, 19.755 * scaleX,
          57.699 * scaleY, 25.526 * scaleX, 54.803 * scaleY)
      ..cubicTo(30.142 * scaleX, 52.487 * scaleY, 31.297 * scaleX,
          56.743 * scaleY, 31.297 * scaleX, 59.147 * scaleY)
      ..close();

    final paintFill = Paint()
      ..color = puzzleColor
      ..style = PaintingStyle.fill;

    final paintStroke = Paint()
      ..color = CustomColors.colorBase.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
