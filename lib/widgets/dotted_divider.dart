import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';

class DottedDivider extends StatelessWidget {
  final double dashWidth;
  final double dashSpace;
  final Color color;
  final double thickness;
  final Axis axis;
  final double padding;

  const DottedDivider({
    super.key,
    required this.dashWidth,
    required this.dashSpace,
    this.color = CustomColors.colorBase,
    required this.thickness,
    this.axis = Axis.horizontal,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _getPadding(),
      child: CustomPaint(
        size: _getSize(),
        painter: _DottedLinePainter(
          dashWidth: dashWidth,
          dashSpace: dashSpace,
          color: color,
          thickness: thickness,
          isHorizontal: axis == Axis.horizontal,
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    return axis == Axis.horizontal
        ? EdgeInsets.symmetric(horizontal: padding)
        : EdgeInsets.symmetric(vertical: padding);
  }

  Size _getSize() {
    return axis == Axis.horizontal
        ? Size(double.infinity, thickness)
        : Size(thickness, double.infinity);
  }
}

class _DottedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;
  final Color color;
  final double thickness;
  final bool isHorizontal;

  _DottedLinePainter({
    required this.dashWidth,
    required this.dashSpace,
    required this.color,
    required this.thickness,
    required this.isHorizontal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness;

    final totalLength = isHorizontal ? size.width : size.height;
    final dashCount = (totalLength / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final startOffset = i * (dashWidth + dashSpace);
      final start = isHorizontal
          ? Offset(startOffset, size.height / 2)
          : Offset(size.width / 2, startOffset);
      final end = isHorizontal
          ? Offset(startOffset + dashWidth, size.height / 2)
          : Offset(size.width / 2, startOffset + dashWidth);

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
