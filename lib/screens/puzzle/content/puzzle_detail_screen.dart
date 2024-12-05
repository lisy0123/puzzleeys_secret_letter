import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/widgets/text_setting.dart';

class PuzzleDetailScreen extends StatefulWidget {
  final int index;
  final String puzzleState;

  const PuzzleDetailScreen({
    super.key,
    required this.index,
    required this.puzzleState,
  });

  @override
  State<PuzzleDetailScreen> createState() => _PuzzleDetailScreenState();
}

class _PuzzleDetailScreenState extends State<PuzzleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.all(260.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopContent(context),
          SizedBox(height: 60.0.w),
          _buildPuzzleDetails(context),
          SizedBox(height: 60.0.w),
          _buildIconButton(
            iconName: 'puzzle',
            text: '135',
            onTap: () => IconDialog(iconName: 'puzzle').buildDialog(context),
            context: context,
          ),
        ],
      ),
    );
  }

  Row _buildTopContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildSideText(iconName: 'clock', text: '05:12:38', context: context),
        _buildIconButton(
          iconName: 'alarm',
          text: '신고하기',
          onTap: () => IconDialog(iconName: 'alarm').buildDialog(context),
          context: context,
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required String iconName,
    required String text,
    required Function onTap,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: _buildSideText(iconName: iconName, text: text, context: context),
    );
  }

  Widget _buildSideText({
    required String iconName,
    required String text,
    required BuildContext context,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/imgs/bar_$iconName.svg',
          height: 120.0.w,
        ),
        SizedBox(width: 30.0.w),
        TextSetting.textIconButton(text: text, context: context),
      ],
    );
  }

  Widget _buildPuzzleDetails(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => IconDialog(iconName: 'puzzle').buildDialog(context),
      child: Container(
        alignment: Alignment.center,
        height: 1800.0.w,
        child: TextSetting.textDisplay(
          text: '글자수 240자\n${widget.puzzleState} - ${widget.index}',
          context: context,
        ),
      ),
    );
  }
}