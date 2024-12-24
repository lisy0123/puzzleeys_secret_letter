import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';

class CustomButton extends StatefulWidget {
  final String iconName;
  final String iconTitle;
  final String iconTopTitle;
  final Function onTap;
  final double width;
  final double height;
  final double iconHeight;
  final double borderStroke;

  const CustomButton({
    super.key,
    required this.iconName,
    required this.iconTitle,
    this.iconTopTitle = '',
    required this.onTap,
    this.width = 620.0,
    this.height = 240.0,
    this.iconHeight = 34.0,
    this.borderStroke = 2.0,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  late bool _isPressed = false;

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
        width: widget.width.w,
        height: widget.height.w,
        decoration: _buttonDecoration(widget.borderStroke),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.iconTopTitle != '')
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText.textSmall(
                    text: widget.iconTopTitle,
                    context: context,
                  ),
                  _buildRowContent(context),
                ],
              ),
            if (widget.iconTopTitle == '') _buildRowContent(context),
            Container(
              color: _overlayColor(),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buttonDecoration(double borderStroke) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      color: Colors.white,
      border: Border.all(
        color: CustomColors.colorBase,
        width: borderStroke,
      ),
    );
  }

  Widget _buildRowContent(BuildContext context) {
    return Row(
      mainAxisAlignment: (widget.iconTopTitle == '')
          ? MainAxisAlignment.spaceEvenly
          : MainAxisAlignment.center,
      children: [
        if (widget.iconName != 'none')
          SvgPicture.asset(
            'assets/imgs/${widget.iconName}.svg',
            height: widget.iconHeight.h,
          ),
        if (widget.iconTopTitle != '') SizedBox(width: 30.0.w),
        CustomText.textDisplay(text: widget.iconTitle, context: context),
      ],
    );
  }

  Color _overlayColor() {
    return _isPressed
        ? CustomColors.colorBase.withValues(alpha: 0.2)
        : Colors.transparent;
  }
}
