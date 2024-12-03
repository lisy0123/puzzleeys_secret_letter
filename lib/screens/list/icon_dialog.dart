import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/component/var_setting.dart';
import 'package:puzzleeys_secret_letter/screens/list/list_screen.dart';
import 'package:puzzleeys_secret_letter/widgets/box_decoration_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/dotted_divider.dart';
import 'package:puzzleeys_secret_letter/widgets/text_setting.dart';

class IconDialog extends StatelessWidget {
  final String iconName;
  final bool overlapped;

  const IconDialog({
    super.key,
    required this.iconName,
    this.overlapped = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: _buildIcon(),
    );
  }

  Widget _buildIcon() {
    return Container(
      margin: iconName == 'setting'
          ? EdgeInsets.only(right: 140.0.w)
          : EdgeInsets.only(right: 60.0.w),
      child: SvgPicture.asset(
        'assets/imgs/icon_$iconName.svg',
        height: 30.0.h,
      ),
    );
  }

  void onTap(BuildContext context) {
    showDialog(
      barrierColor: overlapped ? Colors.transparent : Colors.black54,
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.only(
            top: 0,
            bottom: 0,
            right: 160.0.w,
            left: 160.0.w,
          ),
          content: SizedBox(
            height: (iconName == "setting" ||
                    iconName == "2" ||
                    iconName == "8" ||
                    iconName == "1")
                ? 2800.0.w
                : 2200.0.w,
            child: Stack(
              alignment: Alignment.topCenter,
              children: _drawContent(context),
            ),
          ),
        );
      },
    );
  }

  void test(BuildContext context) {}

  List<Widget> _drawContent(BuildContext context) {
    final Map<String, Function> contentLists = {
      'list': ListScreen.listScreen,
      'setting': test,
      'bead': test,
    };

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
      Container(
        margin: EdgeInsets.only(top: 100.0.h, right: 80.0.w, left: 80.0.w),
        child: contentLists[iconName]?.call(context),
      ),
    ]);
  }

  Widget _drawContentTitle(BuildContext context) {
    final String iconTitle;
    if (iconName == "setting") {
      iconTitle = "8";
    } else {
      iconTitle = iconName;
    }

    return Column(
      children: [
        SizedBox(height: 48.0.h),
        Container(
          child: TextSetting.textIconTitle(
            text: VarSetting.iconNameLists[iconTitle],
            context: context,
          ),
        ),
        SizedBox(height: 16.0.h),
        DottedDivider(
          dashWidth: 30.0.w,
          dashSpace: 20.0.w,
          thickness: 1.0.h,
          padding: 80.0.w,
        ),
      ],
    );
  }
}
