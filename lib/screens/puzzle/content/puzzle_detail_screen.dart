import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/writing/puzzle_writing_screen.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';

class PuzzleDetailScreen extends StatefulWidget {
  final int index;
  final Color puzzleColor;
  final String puzzleState;

  const PuzzleDetailScreen({
    super.key,
    required this.index,
    required this.puzzleColor,
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
      child: Stack(
        children: [
          GestureDetector(onTap: () => Navigator.pop(context)),
          Padding(
            padding: EdgeInsets.all(200.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPuzzleDetails(context),
                SizedBox(height: 200.0.w),
                CustomButton(
                  iconName: 'btn_mail',
                  iconTitle: '답 장',
                  onTap: () => PuzzleScreenHandler.navigateScreen(
                    barrierColor: Colors.white.withOpacity(0.8),
                    child: PuzzleWritingScreen(),
                    context: context,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPuzzleDetails(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => IconDialog(
        iconName: 'get',
        puzzleColor: widget.puzzleColor,
      ).buildDialog(context),
      child: Container(
        height: 3000.0.w,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 100.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTopContent(context),
            SizedBox(height: 100.0.w),
            _buildMidContent(),
            SizedBox(height: 100.0.w),
            PuzzleScreenHandler().buildIconButton(
              iconName: 'bar_puzzle',
              text: '135',
              onTap: () => IconDialog(
                iconName: 'get',
                puzzleColor: widget.puzzleColor,
              ).buildDialog(context),
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PuzzleScreenHandler().buildSideText(
          iconName: 'btn_clock',
          text: '05:12:38',
          context: context,
        ),
        PuzzleScreenHandler().buildIconButton(
          iconName: 'btn_alarm',
          text: '신고하기',
          onTap: () => IconDialog(iconName: 'alarm').buildDialog(context),
          context: context,
        ),
      ],
    );
  }

  Widget _buildMidContent() {
    return Container(
      alignment: Alignment.center,
      height: 2300.0.w,
      child: RawScrollbar(
        thumbColor: widget.puzzleColor,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 60.0.w),
            child: Text(
              '수 500자, 한동안 일기를 쭉 써오다가 요즘 일기를 쓰지 않고 있었는데 오늘부터 다시 쓰기로 했어.날 다시 잡아서 균글자수 500자, 한동안 일기를 쭉 써오다가 요즘 일기를 쓰지 않고 있었는데 오늘부터 다시 쓰기로 했어.날 다시 잡아서 균글자수 500자, 한동안 일기를 쭉 써오다가 요즘 일기를 쓰지 않고 있었는데 오늘부터 다시 쓰기로 했어.날 다시 잡아서 균글자수 500자, 한동안 일기를 쭉 써오다가 요즘 일기를 쓰지 않고 있었는데 오늘부터 다시 쓰기로 했어.날 다시 잡아서 균글자수 500자, 한동안 일기를 쭉 써오다가 요즘 일기를 쓰지 않고 있었는데 오늘부터 다시 쓰기로 했어.날 다시 잡아서 균글자수 500자, 한동안 일기를 쭉 써오다가 요즘 일기를 쓰지 않고 있었는데 오늘부터 다시 쓰기로 했어.날 다시 잡아서 균글자수 500자, 한동안 글자수수수수기로 했어.동안 글자수수수수기로 했어.시 쓰기로 했어.날 다시 잡아서 균글자수 500자, 한동안 일기를 쭉 써오다가 00자, 한동일기를 쭉 써오다가',
              // '${widget.puzzleState} - ${widget.index}\n500자',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
        ),
      ),
    );
  }
}
