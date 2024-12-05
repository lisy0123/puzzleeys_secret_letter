import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/widgets/box_decoration_setting.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: 160.0.w,
        left: 160.0.w,
        bottom: 160.0.h,
        top: 140.0.h,
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecorationSetting.boxDecorationShadowBorder(),
        child: const Text('1. 상점\n2. 퍼즐색 바꾸기'),
      ),
    );
  }
}
