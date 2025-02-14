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
  final bool disable;

  const CustomButton({
    super.key,
    required this.iconName,
    required this.iconTitle,
    this.iconTopTitle = '',
    required this.onTap,
    this.width = 630.0,
    this.height = 240.0,
    this.iconHeight = 34.0,
    this.borderStroke = 2.0,
    this.disable = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05)
        .chain(
          CurveTween(curve: Curves.fastOutSlowIn),
        )
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapState(bool pressed) {
    setState(() {
      _isPressed = pressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) async {
        _handleTapState(true);
        await _controller.forward();
        await _controller.reverse();
      },
      onTapUp: (_) {
        _handleTapState(false);
        widget.onTap();
      },
      onTapCancel: () => _handleTapState(false),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        child: _buildButtonContent(),
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
      ),
    );
  }

  Widget _buildButtonContent() {
    return Container(
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
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Container(color: _overlayColor());
            },
          ),
        ],
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
    return (_isPressed || widget.disable)
        ? CustomColors.colorBase.withValues(alpha: 0.2)
        : Colors.transparent;
  }
}
