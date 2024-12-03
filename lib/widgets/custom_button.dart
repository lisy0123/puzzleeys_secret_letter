import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/box_decoration_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/text_setting.dart';

class CustomButton extends StatefulWidget {
  final String iconName;
  final String iconTitle;

  const CustomButton({
    super.key,
    required this.iconName,
    required this.iconTitle,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
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
          Navigator.pop(context);
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Container(
        width: 700.0.w,
        height: 60.0.h,
        decoration: BoxDecorationSetting.boxDecorationButton(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/imgs/bar_${widget.iconName}.svg',
                  height: 40.0.h,
                ),
                TextSetting.textListIconTitle(
                  text: '${widget.iconTitle}',
                  context: context,
                ),
              ],
            ),
            Container(
              color: _isPressed
                  ? ColorSetting.colorBase.withOpacity(0.2)
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
