import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';

class InfoButton extends StatelessWidget {
  final Function onTap;
  final bool dismissible;
  final bool isFaded;

  const InfoButton({
    super.key,
    required this.onTap,
    this.dismissible = true,
    this.isFaded = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          barrierDismissible: dismissible,
          context: context,
          builder: (_) => onTap(),
        );
      },
      child: SvgPicture.asset(
        'assets/imgs/icon_question.svg',
        height: isFaded ? 28.0.h : 32.0.h,
        colorFilter: isFaded
            ? ColorFilter.mode(
                CustomColors.colorBase.withValues(alpha: 0.7), BlendMode.srcIn)
            : null,
      ),
    );
  }
}
