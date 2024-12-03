import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/box_decoration_setting.dart';

class CustomUi {
  static Widget buildWhiteBox({
    required BuildContext context,
    double height = 100.0,
    double left = 40.0,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height.h,
      margin: EdgeInsets.only(left: left.w, right: 40.0.w, top: 14.0.h),
      decoration: BoxDecorationSetting.boxDecorationShadowBorder(),
    );
  }
}

class CustomUiCircle extends StatefulWidget {
  final String svgImage;
  final Function onTap;

  const CustomUiCircle({
    super.key,
    required this.svgImage,
    required this.onTap,
  });

  @override
  State<CustomUiCircle> createState() => _CustomUiCircleState();
}

class _CustomUiCircleState extends State<CustomUiCircle> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
          widget.onTap();
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Container(
        decoration: BoxDecorationSetting.boxDecorationIcon().copyWith(
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          'assets/imgs/${widget.svgImage}.svg',
          width: 260.0.w,
          colorFilter: ColorFilter.mode(
            _isPressed
                ? ColorSetting.colorBase.withOpacity(0.2)
                : Colors.transparent,
            BlendMode.srcATop,
          ),
        ),
      ),
    );
  }
}
