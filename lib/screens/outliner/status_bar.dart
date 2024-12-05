import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/widgets/box_decoration_setting.dart';
import 'package:puzzleeys_secret_letter/component/var_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_ui.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
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
          top: 14.0,
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
            IconDialog(iconName: 'list'),
            IconDialog(iconName: 'setting'),
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
        _buildBead(myGradientColors, context),
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

  Widget _buildBead(List<Color> myGradientColors, BuildContext context) {
    return GestureDetector(
      onTap: () => IconDialog(iconName: "bead").buildDialog(context),
      child: Container(
        margin: EdgeInsets.only(left: 80.0.w),
        width: 72.0.h,
        height: 72.0.h,
        decoration: BoxDecorationSetting.boxDecorationBead(
          myGradientColors: myGradientColors,
        ),
      ),
    );
  }
}
