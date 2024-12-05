import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/component/var_setting.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/list_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/puzzle_dialog.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';
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
      onTap: () => buildDialog(context),
      child: Container(
        margin: _getIconMargin(),
        child: SvgPicture.asset(
          'assets/imgs/icon_$iconName.svg',
          height: 30.0.h,
        ),
      ),
    );
  }

  EdgeInsets _getIconMargin() {
    return EdgeInsets.only(
      right: iconName == 'setting' ? 140.0.w : 60.0.w,
    );
  }

  void buildDialog(BuildContext context) {
    showDialog(
      barrierColor: overlapped ? Colors.transparent : Colors.black54,
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(
          horizontal: _getSideEdgeInset(),
        ),
        content: SizedBox(
          width: 1400.0.w,
          height: _getDialogHeight(),
          child: Stack(
            alignment: Alignment.topCenter,
            children: _buildDialogContent(context),
          ),
        ),
      ),
    );
  }

  double _getSideEdgeInset() {
    return iconName == "list" ? 300.0.w : 160.0.w;
  }

  double _getDialogHeight() {
    switch (iconName) {
      case 'setting':
      case 'bead':
        return 2400.0.w;
      case 'list':
        return 1600.0.w;
      default:
        return 2000.0.w;
    }
  }

  void test(BuildContext context) {}

  List<Widget> _buildDialogContent(BuildContext context) {
    return ([
      Container(
        margin: EdgeInsets.only(top: 16.0.h),
        decoration: BoxDecorationSetting.boxDecorationShadowBorder(
          circular: 5,
          color: ColorSetting.colorPaper,
        ),
      ),
      SvgPicture.asset(
        'assets/imgs/background_tape.svg',
        height: 42.0.h,
      ),
      _buildDialogTitle(context),
      _buildDialogBody(context),
    ]);
  }

  Widget _buildDialogTitle(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 48.0.h),
        TextSetting.textIconTitle(
          text: VarSetting.iconNameLists[iconName],
          context: context,
        ),
        SizedBox(height: 16.0.h),
        DottedDivider(
          dashWidth: 30.0.w,
          dashSpace: 20.0.w,
          thickness: 6.0.w,
          padding: 80.0.w,
        ),
      ],
    );
  }

  Widget _buildDialogBody(BuildContext context) {
    final Map<String, Function(BuildContext)> contentBuilders = {
      'list': ListDialog.screen,
      'puzzle': PuzzleDialog.screen,
    };

    return Container(
      margin: EdgeInsets.only(top: 100.0.h, right: 80.0.w, left: 80.0.w),
      child: contentBuilders[iconName]?.call(context),
    );
  }
}
