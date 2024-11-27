import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/widgets/box_decoration_setting.dart';
import 'package:puzzleeys_secret_letter/component/var_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/home_button.dart';
import 'package:puzzleeys_secret_letter/widgets/text_setting.dart';

class HomeStatusBar extends StatelessWidget {
  const HomeStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMainBarBox(context),
        _buildMainBar(
          myGradientColors: VarSetting.myGradientColors,
          context: context,
        ),
      ],
    );
  }

  Widget _buildMainBarBox(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 44.0.h,
      margin: EdgeInsets.only(left: 300.0.w, right: 80.0.w, top: 14.0.h),
      decoration: BoxDecorationSetting.boxDecorationShadowBorder(),
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
        const HomeButton(iconName: 'setting'),
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
          onTap: () => HomeButton().onTap(context),
          child: Container(
            margin: EdgeInsets.only(left: 80.0.w),
            width: 72.0.h,
            height: 72.0.h,
            decoration: BoxDecorationSetting.boxDecorationPuzzleBead(
              gradientColors: myGradientColors,
            ),
          ),
        ),
        SizedBox(width: 16.0.h),
        SvgPicture.asset(
          'assets/imgs/bar_puzzle.svg',
          height: 30.0.h,
        ),
        SizedBox(width: 4.0.h),
        TextSetting.textPuzzleNums(
          puzzleNums: VarSetting.puzzleNums,
          context: context,
        ),
      ],
    );
  }
}
