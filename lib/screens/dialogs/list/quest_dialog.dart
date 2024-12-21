import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';

class QuestDialog extends StatelessWidget {
  const QuestDialog({super.key});

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
                child: SvgPicture.asset(
                  'assets/imgs/quest_dia.svg',
                  height: 200.0.w,
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
