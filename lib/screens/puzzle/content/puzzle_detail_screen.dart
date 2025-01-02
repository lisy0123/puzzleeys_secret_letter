import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_writing_screen.dart';
import 'package:puzzleeys_secret_letter/providers/writing_provider.dart';
import 'package:puzzleeys_secret_letter/utils/color_match.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';

class PuzzleDetailScreen extends StatefulWidget {
  final int index;
  final Color puzzleColor;
  final PuzzleType puzzleType;

  const PuzzleDetailScreen({
    super.key,
    required this.index,
    required this.puzzleColor,
    required this.puzzleType,
  });

  @override
  State<PuzzleDetailScreen> createState() => _PuzzleDetailScreenState();
}

class _PuzzleDetailScreenState extends State<PuzzleDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WritingProvider>().updateOpacity(setToInitial: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double opacity = context.watch<WritingProvider>().opacity;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: opacity > 0.0
          ? Stack(
              key: const ValueKey('visible'),
              children: [
                GestureDetector(onTap: () => Navigator.pop(context)),
                Padding(
                  padding: EdgeInsets.only(
                    left: 200.0.w,
                    right: 200.0.w,
                    top: (MediaQuery.of(context).size.height - 760.0.h) / 2,
                  ),
                  child: Column(
                    children: [
                      _buildPuzzleDetails(context),
                      SizedBox(height: 200.0.w),
                      _buildReplyButton(context),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(key: ValueKey('hidden')),
    );
  }

  Widget _buildPuzzleDetails(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => BuildDialog.show(
        iconName: 'get',
        puzzleColor: widget.puzzleColor,
        context: context,
      ),
      child: Container(
        height: 3000.0.w,
        decoration: BoxDecoration(
          color: widget.puzzleColor.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 60.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTopContent(context),
            SizedBox(height: 100.0.w),
            _buildMidContent(context),
            SizedBox(height: 100.0.w),
            _buildBottomContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
      child: Row(
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
            text: CustomStrings.alarm,
            onTap: () => BuildDialog.show(iconName: 'alarm', context: context),
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildMidContent(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 2300.0.w,
      child: RawScrollbar(
        thumbColor: ColorMatch(widget.puzzleColor)(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 60.0.w),
            child: Text(
              // '수 500자, 한동안 일기를 쭉 써오다가 요즘 일기를 쓰지 않고 있었는데 오늘부터 다시 쓰기로 했어.날 다시 잡아서 균글자수 500자, 한동안 일기를 쭉 써오다가 요즘 일기를 쓰지 않고 있었는데 오늘부터 다시 쓰기로 했어.날 다시 잡아서 균글자수 500자, 한동안 일기를 쭉 써오다가 요즘 일기를 쓰지 않고 있었는데 오늘부터 다시 쓰기로 했어.날 다시 잡아서 균글자수 500자, 한동안 일기를 쭉 써오다가 요즘 일기를 쓰지 않고 있었는데 오늘부터 다시 쓰기로 했어.날 다시 잡아서 균글자수 500자, 한동안 일기를 쭉 써오다가 요즘 일기를 쓰지 않고 있었는데 오늘부터 다시 쓰기로 했어.날 다시 잡아서 균글자수 500자, 한동안 일기를 쭉 써오다가 요즘 일기를 쓰지 않고 있었는데 오늘부터 다시 쓰기로 했어.날 다시 잡아서 균글자수 500자, 한동안 글자수수수수기로 했어.동안 글자수수수수기로 했어.시 쓰기로 했어.날 다시 잡아서 균글자수 500자, 한동안 일기를 쭉 써오다가 00자, 한동일기를 쭉 써오다가',
              '${widget.puzzleType} - ${widget.index}',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomContent(BuildContext context) {
    return PuzzleScreenHandler().buildIconButton(
      iconName: 'bar_puzzle',
      text: '135',
      onTap: () => BuildDialog.show(
        iconName: 'get',
        puzzleColor: widget.puzzleColor,
        context: context,
      ),
      context: context,
    );
  }

  Widget _buildReplyButton(BuildContext context) {
    return CustomButton(
      iconName: 'btn_mail',
      iconTitle: CustomStrings.reply,
      onTap: () {
        PuzzleScreenHandler.navigateScreen(
          barrierColor: Colors.white38,
          child: PuzzleWritingScreen(puzzleType: widget.puzzleType),
          context: context,
        );
        context.read<WritingProvider>().updateOpacity();
      },
    );
  }
}
