import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';
import 'package:puzzleeys_secret_letter/styles/text_setting.dart';

class CustomButton extends StatefulWidget {
  final String iconName;
  final String iconTitle;
  final Function onTap;

  const CustomButton({
    super.key,
    required this.iconName,
    required this.iconTitle,
    required this.onTap,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
          widget.onTap();
        });
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        width: 600.0.w,
        height: 240.0.w,
        decoration: _buttonDecoration(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/imgs/${widget.iconName}.svg',
                  height: 34.0.h,
                ),
                SizedBox(width: 40.0.w,),
                TextSetting.textDisplay(
                  text: widget.iconTitle,
                  context: context,
                ),
              ],
            ),
            Container(
              color:_overlayColor(),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buttonDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      color: Colors.white,
      border: Border.all(
        color: ColorSetting.colorBase,
        width: 2,
      ),
    );
  }

  Color _overlayColor() {
    return _isPressed
        ? ColorSetting.colorBase.withOpacity(0.2)
        : Colors.transparent;
  }
}
