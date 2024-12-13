import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';
import 'package:puzzleeys_secret_letter/styles/box_decorations.dart';

class CustomBox extends StatelessWidget {
  final double height;
  final double left;
  final double top;
  final Widget child;

  const CustomBox({
    super.key,
    this.height = 440.0,
    this.left = 40.0,
    this.top = 0.0,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: height.w,
      margin: EdgeInsets.only(left: left.w, right: 40.0.w, top: top.h),
      decoration: BoxDecorations.shadowBorder(),
      child: child,
    );
  }
}

class CustomCircle extends StatefulWidget {
  final String svgImage;
  final Function onTap;

  const CustomCircle({
    super.key,
    required this.svgImage,
    required this.onTap,
  });

  @override
  State<CustomCircle> createState() => _CustomCircleState();
}

class _CustomCircleState extends State<CustomCircle> {
  bool _isPressed = false;

  void _handleTapState(bool pressed) {
    setState(() {
      _isPressed = pressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _handleTapState(true),
      onTapUp: (_) {
        _handleTapState(false);
        widget.onTap();
      },
      onTapCancel: () => _handleTapState(false),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxDecorations.shadow()],
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          'assets/imgs/${widget.svgImage}.svg',
          width: 260.0.w,
          colorFilter: ColorFilter.mode(
            _isPressed
                ? CustomColors.colorBase.withOpacity(0.2)
                : Colors.transparent,
            BlendMode.srcATop,
          ),
        ),
      ),
    );
  }
}
