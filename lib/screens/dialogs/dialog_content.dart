import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/component/var_setting.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/cancel_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/list_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/get_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/put/put_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/sent_dialog.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';
import 'package:puzzleeys_secret_letter/styles/text_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/box_decoration_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/dotted_divider.dart';

class DialogContent {
  final String iconName;
  final Color puzzleColor;
  final bool simpleDialog;

  const DialogContent({
    required this.iconName,
    required this.puzzleColor,
    required this.simpleDialog,
  });

  List<Widget> buildContent(BuildContext context) {
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
      if (!simpleDialog)
        _buildTitle(context),
      _buildBody(context),
    ]);
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 48.0.h),
        TextSetting.textDialogTitle(
          text: VarSetting.iconNameLists[iconName]!,
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

  Widget _buildBody(BuildContext context) {
    final Widget dialogContent;
    switch (iconName) {
      case 'list':
        dialogContent = ListDialog();
        break;
      case 'get':
        dialogContent = GetDialog(puzzleColor: puzzleColor);
        break;
      case 'cancel':
        dialogContent = CancelDialog();
        break;
      case 'put':
        return PutDialog(puzzleColor: puzzleColor);
      case 'sent':
        dialogContent = SentDialog();
        break;
      default:
        dialogContent = Placeholder();
    }

    return Container(
      margin: EdgeInsets.only(top: simpleDialog ? 40.0.h : 90.0.h),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.0.w, horizontal: 100.0.w),
        child: dialogContent,
      ),
    );
  }
}
