import 'package:flutter/material.dart';

class PuzzleConfig {
  final double scaleFactor;
  final double puzzleWidth;
  final double puzzleHeight;
  final double horizontalSpacing;
  final double verticalSpacing;
  final int itemsPerRow;
  final int totalRows;

  PuzzleConfig({
    required this.scaleFactor,
    required this.puzzleWidth,
    required this.puzzleHeight,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.itemsPerRow,
    required this.totalRows,
  });

  int get totalItems => itemsPerRow * totalRows;

  double get maxDragDistanceX =>
      (puzzleWidth + horizontalSpacing) * scaleFactor * 4;

  double get maxDragDistanceY =>
      (puzzleHeight + verticalSpacing) * scaleFactor * 7;

  Offset calculateStartOffset(Size containerSize, Offset dragOffset) {
    final double scaledWidth = _scaledTotalWidth;
    final double scaledHeight = _scaledTotalHeight;

    final double startX =
        (containerSize.width - scaledWidth) / 2 + dragOffset.dx;
    final double startY =
        (containerSize.height - scaledHeight) / 2 + dragOffset.dy;

    return Offset(startX, startY);
  }

  Offset calculateItemPosition(int index, Offset startOffset) {
    final int row = index ~/ itemsPerRow;
    final int column = index % itemsPerRow;

    final double dx = startOffset.dx +
        column * (puzzleWidth + horizontalSpacing) * scaleFactor;
    final double dy =
        startOffset.dy + row * (puzzleHeight + verticalSpacing) * scaleFactor;

    return Offset(dx, dy);
  }

  double get _scaledTotalWidth =>
      (itemsPerRow - 1) * (puzzleWidth + horizontalSpacing) * scaleFactor +
          puzzleWidth * scaleFactor;

  double get _scaledTotalHeight =>
      (totalRows - 1) * (puzzleHeight + verticalSpacing) * scaleFactor +
          puzzleHeight * scaleFactor;
}