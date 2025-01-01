import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/styles/box_decorations.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late double height;
    final heightDivide =
        MediaQuery.of(context).size.height / MediaQuery.of(context).size.width;
    if (heightDivide > 2.37) {
      height = 1400.0.w;
    } else if (heightDivide > 2.16) {
      height = 1600.0.w;
    } else {
      height = 1400.0.w;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 120.0.w),
      width: MediaQuery.of(context).size.width - 200.0.w,
      height: MediaQuery.of(context).size.height - height,
      decoration: BoxDecorations.shadowBorder(),
      child: Center(
        child: CustomText.textDialogTitle(text: '준비 중...', context: context),
      ),
    );
  }
}
