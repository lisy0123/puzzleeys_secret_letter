import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/vars.dart';
import 'package:puzzleeys_secret_letter/styles/box_decorations.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_shapes.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomBox(
          height: 200.0,
          left: 200.0,
          top: 14.0,
          child: _buildMainBar(context),
        ),
        _buildBead(CustomVars.myGradientColors, context),
      ],
    );
  }

  Widget _buildMainBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 200.0.w, right: 100.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildMainBarLeft(context),
          IconDialog(iconName: 'list'),
        ],
      ),
    );
  }

  Widget _buildMainBarLeft(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/imgs/bar_puzzle.svg',
          height: 30.0.h,
        ),
        SizedBox(width: 30.0.w),
        CustomText.textTopBarNums(
          puzzleNums: CustomVars.puzzleNums,
          context: context,
        ),
        SizedBox(width: 80.0.w),
        SvgPicture.asset(
          'assets/imgs/bar_dia.svg',
          height: 30.0.h,
        ),
        SizedBox(width: 30.0.w),
        CustomText.textTopBarNums(
          puzzleNums: CustomVars.diaNums,
          context: context,
        ),
      ],
    );
  }

  Widget _buildBead(List<Color> myGradientColors, BuildContext context) {
    return GestureDetector(
      onTap: () => IconDialog(iconName: 'bead').buildDialog(context),
      child: Container(
        margin: EdgeInsets.only(left: 40.0.w),
        width: 320.0.w,
        height: 320.0.w,
        decoration: BoxDecorations.bead(
          myGradientColors: myGradientColors,
        ),
      ),
    );
  }
}
