import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/vars.dart';
import 'package:puzzleeys_secret_letter/providers/bead_provider.dart';
import 'package:puzzleeys_secret_letter/providers/bar_provider.dart';
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
          height: 220.0,
          left: 240.0,
          top: 18.0,
          child: _buildMainBar(context),
        ),
        Selector<BeadProvider, List<Color>>(
          selector: (_, provider) => provider.beadColor,
          builder: (_, gradientColors, __) {
            return GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 40.0.w),
                width: 360.0.w,
                height: 360.0.w,
                decoration: BoxDecorations.bead(gradientColors: gradientColors),
              ),
              onTap: () => BuildDialog.show(iconName: 'bead', context: context),
            );
          },
        ),
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
    return Selector<BarProvider, int>(
      selector: (_, provider) => provider.puzzleNums,
      builder: (_, puzzleNums, __) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/imgs/bar_puzzle.svg', height: 32.0.h),
            SizedBox(width: 30.0.w),
            CustomText.textTopBarNums(puzzleNums: puzzleNums, context: context),
            SizedBox(width: 80.0.w),
            SvgPicture.asset('assets/imgs/bar_dia.svg', height: 32.0.h),
            SizedBox(width: 30.0.w),
            CustomText.textTopBarNums(
              puzzleNums: CustomVars.diaNums,
              context: context,
            ),
          ],
        );
      },
    );
  }
}
