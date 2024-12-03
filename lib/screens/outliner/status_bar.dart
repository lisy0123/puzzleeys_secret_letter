import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/widgets/box_decoration_setting.dart';
import 'package:puzzleeys_secret_letter/component/var_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_ui.dart';
import 'package:puzzleeys_secret_letter/screens/list/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/widgets/text_setting.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomUi.buildWhiteBox(
          context: context,
          height: 44.0,
          left: 300.0,
        ),
        _buildMainBar(
          myGradientColors: VarSetting.myGradientColors,
          context: context,
        ),
      ],
    );
  }

  Widget _buildMainBar({
    required List<Color> myGradientColors,
    required BuildContext context,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildMainBarLeft(
          myGradientColors: myGradientColors,
          context: context,
        ),
        Row(
          children: [
            const IconDialog(iconName: 'list'),
            const IconDialog(iconName: 'setting'),
          ],
        ),
      ],
    );
  }

  Widget _buildMainBarLeft({
    required List<Color> myGradientColors,
    required BuildContext context,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => IconDialog(iconName: "2").onTap(context),
          child: Container(
            margin: EdgeInsets.only(left: 80.0.w),
            width: 72.0.h,
            height: 72.0.h,
            decoration: BoxDecorationSetting.boxDecorationPuzzleBead(
              gradientColors: myGradientColors,
            ),
          ),
        ),
        SizedBox(width: 80.0.w),
        SvgPicture.asset(
          'assets/imgs/bar_puzzle.svg',
          height: 30.0.h,
        ),
        SizedBox(width: 30.0.w),
        TextSetting.textPuzzleNums(
          puzzleNums: VarSetting.puzzleNums,
          context: context,
        ),
        SizedBox(width: 80.0.w),
        SvgPicture.asset(
          'assets/imgs/bar_dia.svg',
          height: 30.0.h,
        ),
        SizedBox(width: 30.0.w),
        TextSetting.textPuzzleNums(
          puzzleNums: VarSetting.diaNums,
          context: context,
        ),
      ],
    );
  }
}
