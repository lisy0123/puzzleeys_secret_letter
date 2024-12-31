import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';
import 'package:puzzleeys_secret_letter/widgets/tilted_puzzle.dart';

class PuzzleLoadingScreen extends StatefulWidget {
  final String text;

  const PuzzleLoadingScreen({super.key, required this.text});

  @override
  State<PuzzleLoadingScreen> createState() => _PuzzleLoadingScreenState();
}

class _PuzzleLoadingScreenState extends State<PuzzleLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation.value),
                  child: Transform.rotate(
                    angle: -pi / 4,
                    child: CustomPaint(
                      size: Size(280.0.w, 280.0.w),
                      painter: TiltedPuzzlePiece(puzzleColor: Colors.white),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 40.0.w),
            CustomText.textDisplay(
              text: widget.text,
              stroke: true,
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}
