import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/widgets/box_decoration_setting.dart';
import 'package:puzzleeys_secret_letter/component/var_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_ui.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/styles/text_setting.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomUi(
          height: 200.0,
          left: 200.0,
          top: 14.0,
          child: _buildMainBar(context),
        ),
        _buildBead(VarSetting.myGradientColors, context),
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
        TextSetting.textTopBarNums(
          puzzleNums: VarSetting.puzzleNums,
          context: context,
        ),
        SizedBox(width: 80.0.w),
        SvgPicture.asset(
          'assets/imgs/bar_dia.svg',
          height: 30.0.h,
        ),
        SizedBox(width: 30.0.w),
        TextSetting.textTopBarNums(
          puzzleNums: VarSetting.diaNums,
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
        decoration: BoxDecorationSetting.boxDecorationBead(
          myGradientColors: myGradientColors,
        ),
      ),
    );
  }
}
