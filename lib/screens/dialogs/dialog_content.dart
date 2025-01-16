import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/dialog_enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/styles/box_decorations.dart';
import 'package:puzzleeys_secret_letter/widgets/dotted_divider.dart';

class DialogContent {
  final String iconName;
  final int? index;
  final String? puzzleId;
  final Color? puzzleColor;
  final String? puzzleText;
  final Map<String, dynamic>? puzzleData;
  final PuzzleType? puzzleType;
  final bool simpleDialog;

  const DialogContent({
    required this.iconName,
    this.index,
    this.puzzleId,
    this.puzzleColor,
    this.puzzleText,
    this.puzzleData,
    this.puzzleType,
    required this.simpleDialog,
  });

  List<Widget> buildContent(BuildContext context) {
    return ([
      Container(
        margin: EdgeInsets.only(top: 18.0.h),
        decoration: BoxDecorations.shadowBorder(
          circular: 5,
          color: CustomColors.colorPaper,
        ),
      ),
      SvgPicture.asset(
        'assets/imgs/background_tape.svg',
        height: 42.0.h,
      ),
      if (!simpleDialog) _buildTitle(context),
      _buildBody(context),
    ]);
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 48.0.h),
        CustomText.textDialogTitle(
          text: CustomStrings.dialogNameLists[iconName]!,
          context: context,
        ),
        SizedBox(height: 16.0.h),
        DottedDivider(
          dashWidth: 40.0.w,
          dashSpace: 20.0.w,
          thickness: 6.0.w,
          padding: 60.0.w,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    final Widget dialogContent = DialogEnums(
      iconName: iconName,
      index: index,
      puzzleId: puzzleId,
      puzzleColor: puzzleColor,
      puzzleText: puzzleText,
      puzzleData: puzzleData,
      puzzleType: puzzleType,
    );

    return Container(
      margin: EdgeInsets.only(top: simpleDialog ? 40.0.h : 90.0.h),
      child: Padding(
        padding: EdgeInsets.all(60.0.w),
        child: dialogContent,
      ),
    );
  }
}
