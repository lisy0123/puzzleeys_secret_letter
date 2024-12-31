import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/colors.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_content.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/background/puzzle_config.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_scale_provider.dart';

class PuzzleBackground extends StatefulWidget {
  final String puzzleState;

  const PuzzleBackground({
    super.key,
    required this.puzzleState,
  });

  @override
  State<PuzzleBackground> createState() => _PuzzleBackgroundState();
}

class _PuzzleBackgroundState extends State<PuzzleBackground> {
  late Offset _dragOffset = Offset.zero;
  late List<Color> _cachedColors;

  @override
  void initState() {
    super.initState();
    _initializeColors();
  }

  void _initializeColors() {
    final List<Color> colors = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      CustomColors.colorPink,
      CustomColors.colorRed,
      CustomColors.colorOrange,
      CustomColors.colorYellow,
      CustomColors.colorGreen,
      CustomColors.colorSkyBlue,
      CustomColors.colorBlue,
      CustomColors.colorPurple,
    ];
    _cachedColors = List.generate(
      8 * 18,
      (_) => colors[Random().nextInt(colors.length)],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = context.watch<PuzzleScaleProvider>().scaleFactor;
    final PuzzleConfig config = PuzzleConfig(
      scaleFactor: scaleFactor,
      puzzleWidth: 900.0.w,
      puzzleHeight: 545.0.w,
      horizontalSpacing: -375.0.w,
      verticalSpacing: -20.0.w,
      itemsPerRow: 8,
      totalRows: 18,
    );

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _dragOffset = _calculateNewOffset(details.delta, config);
        });
      },
      child: CustomMultiChildLayout(
        delegate: PuzzleLayoutDelegate(
          config: config,
          dragOffset: _dragOffset,
        ),
        children: List.generate(
          config.totalItems,
          (index) => PuzzleContent(
            row: index ~/ config.itemsPerRow,
            column: index % config.itemsPerRow,
            index: index,
            puzzleHeight: config.puzzleHeight,
            scaleFactor: scaleFactor,
            puzzleState: widget.puzzleState,
            puzzleColor: _cachedColors[index],
          ),
        ),
      ),
    );
  }

  Offset _calculateNewOffset(Offset delta, PuzzleConfig config) {
    final double maxDragX = config.maxDragDistanceX;
    final double maxDragY = config.maxDragDistanceY;
    final Offset newOffset = _dragOffset + delta;

    return Offset(
      newOffset.dx.clamp(-maxDragX, maxDragX),
      newOffset.dy.clamp(-maxDragY, maxDragY),
    );
  }
}

class PuzzleLayoutDelegate extends MultiChildLayoutDelegate {
  final PuzzleConfig config;
  final Offset dragOffset;

  PuzzleLayoutDelegate({
    required this.config,
    required this.dragOffset,
  });

  @override
  void performLayout(Size size) {
    final Offset startOffset = config.calculateStartOffset(size, dragOffset);

    for (int index = 0; index < config.totalItems; index++) {
      final Offset itemPosition =
          config.calculateItemPosition(index, startOffset);

      if (hasChild(index)) {
        layoutChild(
          index,
          BoxConstraints.tight(Size(
            config.puzzleWidth * config.scaleFactor,
            config.puzzleHeight * config.scaleFactor,
          )),
        );
        positionChild(index, itemPosition);
      }
    }
  }

  @override
  bool shouldRelayout(PuzzleLayoutDelegate oldDelegate) {
    return config != oldDelegate.config || dragOffset != oldDelegate.dragOffset;
  }
}
