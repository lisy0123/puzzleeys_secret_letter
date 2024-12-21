import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/tilted_puzzle.dart';

class MissionDialog extends StatelessWidget {
  const MissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _build(context),
        Utils.dialogDivider(),
        _build(context),
        Utils.dialogDivider(),
        _build(context),
        Utils.dialogDivider(),
        _build(context),
        Utils.dialogDivider(),
        _build(context),
      ],
    );
  }

  Widget _build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText.textContent(text: '누적 출석일 9999일!', context: context),
          SizedBox(width: 40.0.w),
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 40.0.w),
                child: Transform.rotate(
                  angle: pi / 2,
                  child: CustomPaint(
                    size: Size(200.0.w, 200.0.w),
                    painter: TiltedPuzzlePiece(
                      puzzleColor: Colors.white,
                      strokeWidth: 1.5,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 90.0.w,
                left: 170.0.w,
                child: CustomText.textContentTitle(
                  text: 9.toString(),
                  stroke: true,
                  context: context,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
