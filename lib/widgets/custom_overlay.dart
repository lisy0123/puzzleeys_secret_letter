import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/widgets/tilted_puzzle.dart';

class CustomOverlay {
  static final List<OverlayEntry> _overlayEntries = [];

  static void show({
    required String text,
    int delayed = 1500,
    bool puzzleVis = false,
    int puzzleNum = 1,
    required BuildContext context,
  }) {
    final overlay = Overlay.of(context);

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
    _overlayEntries.add(overlayEntry);

    Future.delayed(Duration(milliseconds: delayed), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
        _overlayEntries.remove(overlayEntry);
      }
    });
  }

  static Widget _buildContent({
    required String text,
    required bool puzzleVis,
    required int puzzleNum,
    required BuildContext context,
  }) {
    final String puzzleNumString =
        (puzzleNum > 0) ? '+${puzzleNum.toString()}' : puzzleNum.toString();

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
                angle: -45 * pi / 180,
                child: CustomPaint(
                  size: Size(190.0.w, 190.0.w),
                  painter: TiltedPuzzlePiece(
                    puzzleColor: Colors.white,
                    strokeWidth: 1,
                  ),
                ),
              ),
              SizedBox(width: 10.0.w),
              Text(
                puzzleNumString,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 74.0.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(width: 60.0.w),
            ],
          ),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 74.0.sp,
            fontFamily: 'NANUM',
            fontWeight: FontWeight.w900,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
