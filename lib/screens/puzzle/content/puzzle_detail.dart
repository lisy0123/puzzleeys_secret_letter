import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/widgets/text_setting.dart';

class PuzzleDetail extends StatefulWidget {
  const PuzzleDetail({super.key});

  @override
  State<PuzzleDetail> createState() => _PuzzleDetailState();
}

class _PuzzleDetailState extends State<PuzzleDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(100.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sideButton(iconName: 'clock', text: '05:12:38', context: context),
              _sideButton(iconName: 'alarm', text: '신고하기', context: context),
            ],
          ),
          SizedBox(height: 16.0.h),
          TextSetting.textPuzzleContent(
              text:
                  '속 내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ내요요용ㅇㄹㅁ',
              context: context),
          SizedBox(height: 16.0.h),
          _sideButton(iconName: 'puzzle', text: '135', context: context),
        ],
      ),
    );
  }

  Widget _sideButton({
    required String iconName,
    required String text,
    required BuildContext context,
  }) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/imgs/bar_$iconName.svg',
          height: 120.0.w,
        ),
        SizedBox(width: 24.0.w),
        TextSetting.textListIconTitle(text: text, context: context),
      ],
    );
  }
}
