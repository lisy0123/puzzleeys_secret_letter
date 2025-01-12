import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_writing_screen.dart';
import 'package:puzzleeys_secret_letter/providers/writing_provider.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/utils/color_match.dart';
import 'package:puzzleeys_secret_letter/utils/timer_util.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_button.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_overlay.dart';
import 'package:puzzleeys_secret_letter/widgets/tilted_puzzle.dart';

class PuzzleDetailScreen extends StatefulWidget {
  final int index;
  final Map<String, dynamic> puzzleData;
  final PuzzleType puzzleType;

  const PuzzleDetailScreen({
    super.key,
    required this.index,
    required this.puzzleData,
    required this.puzzleType,
  });

  @override
  State<PuzzleDetailScreen> createState() => _PuzzleDetailScreenState();
}

class _PuzzleDetailScreenState extends State<PuzzleDetailScreen> {
  late TimerUtil timerUtil;
  StreamSubscription<String>? _timerSubscription;
  String _remainingTime = '00:00:00';
  Color _puzzleButtonColor = Colors.white;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WritingProvider>().updateOpacity(setToInitial: true);
    });

    timerUtil = TimerUtil(widget.puzzleData['created_at']);
    _timerSubscription = timerUtil.timeStream.listen((remainingTime) {
      if (_remainingTime != remainingTime) {
        setState(() {
          _remainingTime = remainingTime;
        });
      }
    });

    // TODO: check puzzle exist, and decide to color or not.
  }

  @override
  void dispose() {
    _timerSubscription?.cancel();
    timerUtil.dispose();
    super.dispose();
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
                      _buildPuzzleDetails(widget.puzzleData),
                      SizedBox(height: 200.0.w),
                      _buildReplyButton(),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(key: ValueKey('hidden')),
    );
  }

  Widget _buildPuzzleDetails(Map<String, dynamic> puzzleData) {
    return GestureDetector(
      onDoubleTap: _getPuzzle,
      child: Container(
        height: 3000.0.w,
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 60.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTopContent(),
            SizedBox(height: 40.0.w),
            _buildMidContent(),
            SizedBox(height: 20.0.w),
            _buildBottomContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PuzzleScreenHandler().buildSideText(
          iconName: 'btn_clock',
          text: _remainingTime,
          context: context,
        ),
        PuzzleScreenHandler().buildIconButton(
          iconName: 'btn_alarm',
          text: CustomStrings.alarm,
          onTap: () => BuildDialog.show(iconName: 'alarm', context: context),
          context: context,
        ),
      ],
    );
  }

  Widget _buildMidContent() {
    return Container(
      alignment: Alignment.center,
      height: 2320.0.w,
      child: RawScrollbar(
        radius: Radius.circular(10),
        thumbColor: ColorMatch(baseColor: widget.puzzleData['color'])(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 60.0.w),
            child: Text(
              widget.puzzleData['content'].replaceAll(r'\n', '\n'),
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomContent() {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 10.0.w),
      constraints: BoxConstraints(),
      onPressed: _getPuzzle,
      icon: SizedBox(
        width: 600.0.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: -pi / 4,
              child: CustomPaint(
                size: Size(220.0.w, 220.0.w),
                painter: TiltedPuzzlePiece(
                  puzzleColor: _puzzleButtonColor,
                  strokeWidth: 1.5,
                ),
              ),
            ),
            SizedBox(width: 40.0.w),
            CustomText.textDisplay(
              text: widget.puzzleData['puzzle_count'].toString(),
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  void _getPuzzle() {
    if (_puzzleButtonColor == Colors.white) {
      CustomOverlay.show(
        text: MessageStrings.overlayMessages[OverlayType.getPuzzle]![1],
        puzzleVis: true,
        puzzleNum: MessageStrings.overlayMessages[OverlayType.getPuzzle]![0],
        context: context,
      );
      setState(() {
        _puzzleButtonColor = widget.puzzleData['color'];
      });
    } else {
      CustomOverlay.show(
        text: MessageStrings.puzzleExistOverlay,
        context: context,
      );
    }
  }

  Widget _buildReplyButton() {
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
