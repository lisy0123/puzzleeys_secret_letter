import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/component/var_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/box_decoration_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/dotted_divider.dart';
import 'package:puzzleeys_secret_letter/widgets/text_setting.dart';

class HomeButton extends StatelessWidget {
  final String iconName;

  const HomeButton({
    super.key,
    this.iconName = "",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: _build(),
    );
  }

  Widget _build() {
    if (iconName == 'setting') {
      return Container(
        margin: EdgeInsets.only(right: 140.0.w),
        child: SvgPicture.asset(
          'assets/imgs/icon_setting.svg',
          height: 28.0.h,
        ),
      );
    } else {
      return Container(
        decoration: BoxDecorationSetting.boxDecorationIcon(),
        child: SvgPicture.asset(
          'assets/imgs/icon_home_$iconName.svg',
          height: 260.0.w,
        ),
      );
    }
  }

  void onTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.only(right: 56.0.w, left: 56.0.w),
          content: SizedBox(
            height: (iconName == "setting") ? 3000.0.w : 2400.0.w,
            child: Stack(
              alignment: Alignment.topCenter,
              children: _drawContent(context),
              // children: _onTapContent()._drawContent(context),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _drawContent(BuildContext context) {
    return ([
      Container(
        margin: EdgeInsets.only(top: 16.0.h),
        decoration: BoxDecorationSetting.boxDecorationHomeAlertDialog(),
      ),
      SvgPicture.asset(
        'assets/imgs/background_tape.svg',
        height: 42.0.h,
      ),
      _drawContentTitle(context),
    ]);
  }

  Widget _drawContentTitle(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 48.0.h),
        Container(
          child: TextSetting.textIconTitle(
            text: VarSetting.iconNameLists[iconName],
            context: context,
          ),
        ),
        SizedBox(height: 16.0.h),
        DottedDivider(
          dashWidth: 6.0.h,
          dashSpace: 6.0.h,
          thickness: 1.0.h,
          padding: 18.0.h,
        ),
      ],
    );
  }
}
