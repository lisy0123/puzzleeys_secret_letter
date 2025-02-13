import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/providers/bar_provider.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/widgets/tilted_puzzle.dart';

class CustomOverlay {
  static OverlayEntry? _currentOverlay;
  static bool _hasUpdated = false;

  static void show({
    required String text,
    bool puzzleVis = false,
    int puzzleNum = 1,
    required BuildContext context,
  }) {
    final overlay = Overlay.of(context);

    _removeCurrentOverlay();
    _hasUpdated = false;

    final overlayEntry = OverlayEntry(
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height - 1600.0.w,
        ),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 100.0.w),
              padding:
                  EdgeInsets.symmetric(vertical: puzzleVis ? 30.0.w : 80.0.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _buildContent(
                text: text,
                puzzleVis: puzzleVis,
                puzzleNum: puzzleNum,
                context: context,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    _currentOverlay = overlayEntry;

    Future.delayed(const Duration(milliseconds: 4000), () {
      _removeCurrentOverlay();
    });
  }

  static void _removeCurrentOverlay() {
    if (_currentOverlay != null) {
      _currentOverlay!.remove();
      _currentOverlay = null;
    }
  }

  static Widget _buildContent({
    required String text,
    required bool puzzleVis,
    required int puzzleNum,
    required BuildContext context,
  }) {
    final String puzzleNumString =
        (puzzleNum > 0) ? '+${puzzleNum.toString()}' : puzzleNum.toString();

    if (puzzleVis && !_hasUpdated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<BarProvider>().updatePuzzleNum(puzzleNum);
        _hasUpdated = true;
      });
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (puzzleVis)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 60.0.w),
              Transform.rotate(
                angle: -pi / 4,
                child: CustomPaint(
                  size: Size(190.0.w, 190.0.w),
                  painter: TiltedPuzzlePiece(
                    puzzleColor: Colors.white,
                    strokeWidth: 1,
                  ),
                ),
              ),
              SizedBox(width: 10.0.w),
              CustomText.overlayText(puzzleNumString, fontFamily: true),
              SizedBox(width: 60.0.w),
            ],
          ),
        CustomText.overlayText(text),
      ],
    );
  }
}
