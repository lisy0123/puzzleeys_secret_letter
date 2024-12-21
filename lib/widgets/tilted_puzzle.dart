import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';

class TiltedPuzzle extends StatelessWidget {
  final Color puzzleColor;

  const TiltedPuzzle({super.key, required this.puzzleColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(600.0.w, 600.0.w),
      painter: TiltedPuzzlePiece(puzzleColor: puzzleColor),
    );
  }
}

class TiltedPuzzlePiece extends CustomPainter {
  final Color puzzleColor;
  final double strokeWidth;

  TiltedPuzzlePiece({required this.puzzleColor, this.strokeWidth = 2.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = puzzleColor
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.miter
      ..strokeCap = StrokeCap.butt;

    final path = Path()
      ..moveTo(size.width * 0.6338, size.height * 0.7536)
      ..lineTo(size.width * 0.5724, size.height * 0.815)
      ..lineTo(size.width * 0.4837, size.height * 0.9037)
      ..lineTo(size.width * 0.3681, size.height * 0.7881)
      ..cubicTo(size.width * 0.334, size.height * 0.7541, size.width * 0.3409,
          size.height * 0.7336, size.width * 0.3546, size.height * 0.72)
      ..cubicTo(size.width * 0.3682, size.height * 0.7064, size.width * 0.4091,
          size.height * 0.7335, size.width * 0.4500, size.height * 0.6654)
      ..cubicTo(size.width * 0.4909, size.height * 0.5971, size.width * 0.4025,
          size.height * 0.5224, size.width * 0.3412, size.height * 0.5565)
      ..cubicTo(size.width * 0.2800, size.height * 0.5907, size.width * 0.3002,
          size.height * 0.6111, size.width * 0.2797, size.height * 0.6452)
      ..cubicTo(size.width * 0.2634, size.height * 0.6725, size.width * 0.2411,
          size.height * 0.6611, size.width * 0.2321, size.height * 0.6521)
      ..lineTo(size.width * 0.1028, size.height * 0.5228)
      ..lineTo(size.width * 0.2461, size.height * 0.3796)
      ..cubicTo(size.width * 0.2597, size.height * 0.3659, size.width * 0.2747,
          size.height * 0.3346, size.width * 0.2257, size.height * 0.3183)
      ..cubicTo(size.width * 0.1644, size.height * 0.2980, size.width * 0.1509,
          size.height * 0.2571, size.width * 0.1509, size.height * 0.2435)
      ..cubicTo(size.width * 0.1509, size.height * 0.2299, size.width * 0.1510,
          size.height * 0.1889, size.width * 0.1715, size.height * 0.1685)
      ..cubicTo(size.width * 0.1919, size.height * 0.1481, size.width * 0.2124,
          size.height * 0.1412, size.width * 0.2464, size.height * 0.1480)
      ..cubicTo(size.width * 0.2805, size.height * 0.1547, size.width * 0.3213,
          size.height * 0.1819, size.width * 0.3212, size.height * 0.2228)
      ..cubicTo(size.width * 0.3212, size.height * 0.2636, size.width * 0.3552,
          size.height * 0.2704, size.width * 0.3620, size.height * 0.2636)
      ..lineTo(size.width * 0.3893, size.height * 0.2363)
      ..lineTo(size.width * 0.5258, size.height * 0.0999)
      ..lineTo(size.width * 0.6618, size.height * 0.2359)
      ..cubicTo(size.width * 0.6686, size.height * 0.2518, size.width * 0.6740,
          size.height * 0.2836, size.width * 0.6413, size.height * 0.2836)
      ..cubicTo(size.width * 0.6086, size.height * 0.2837, size.width * 0.5822,
          size.height * 0.3019, size.width * 0.5732, size.height * 0.3109)
      ..cubicTo(size.width * 0.5550, size.height * 0.3292, size.width * 0.5308,
          size.height * 0.3778, size.width * 0.5798, size.height * 0.4268)
      ..cubicTo(size.width * 0.6410, size.height * 0.4880, size.width * 0.6887,
          size.height * 0.4402, size.width * 0.6956, size.height * 0.4334)
      ..cubicTo(size.width * 0.7024, size.height * 0.4266, size.width * 0.7092,
          size.height * 0.4198, size.width * 0.7229, size.height * 0.3652)
      ..cubicTo(size.width * 0.7339, size.height * 0.3216, size.width * 0.7683,
          size.height * 0.3425, size.width * 0.7842, size.height * 0.3584)
      ..lineTo(size.width * 0.9067, size.height * 0.4808)
      ..lineTo(size.width * 0.7975, size.height * 0.5899)
      ..cubicTo(size.width * 0.7657, size.height * 0.6127, size.width * 0.7143,
          size.height * 0.6622, size.width * 0.7633, size.height * 0.6785)
      ..cubicTo(size.width * 0.8246, size.height * 0.6989, size.width * 0.8450,
          size.height * 0.7057, size.width * 0.8586, size.height * 0.7465)
      ..cubicTo(size.width * 0.8694, size.height * 0.7792, size.width * 0.8494,
          size.height * 0.8192, size.width * 0.8380, size.height * 0.8351)
      ..cubicTo(size.width * 0.8244, size.height * 0.8487, size.width * 0.7876,
          size.height * 0.8719, size.width * 0.7494, size.height * 0.8557)
      ..cubicTo(size.width * 0.7018, size.height * 0.8352, size.width * 0.6950,
          size.height * 0.8012, size.width * 0.6815, size.height * 0.7603)
      ..cubicTo(size.width * 0.6706, size.height * 0.7277, size.width * 0.6452,
          size.height * 0.7422, size.width * 0.6338, size.height * 0.7536)
      ..close();

    canvas.drawPath(path, paint);

    paint
      ..style = PaintingStyle.stroke
      ..color = CustomColors.colorBase;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TiltedPuzzlePiece oldDelegate) {
    return oldDelegate.puzzleColor != puzzleColor;
  }
}
