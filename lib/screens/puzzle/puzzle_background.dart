import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_content.dart';
import 'package:puzzleeys_secret_letter/styles/color_setting.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_ui.dart';

class PuzzleBackground extends StatefulWidget {
  const PuzzleBackground({super.key});

  @override
  State<PuzzleBackground> createState() => _PuzzleBackgroundState();
}

class _PuzzleBackgroundState extends State<PuzzleBackground> {
  Offset _dragOffset = Offset.zero;
  double _scaleFactor = 1.0;

  void _toggleScale() {
    setState(() {
      if (_scaleFactor == 1.0) {
        _scaleFactor = 0.75;
      } else if (_scaleFactor == 0.75) {
        _scaleFactor = 0.5;
      } else {
        _scaleFactor = 1.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double puzzleWidth = 900.0.w;
    final double puzzleHeight = 600.0.h;
    final double horizontalSpacing = -375.0.w;
    final double verticalSpacing = -485.0.h;
    const int itemsPerRow = 10;
    const int totalRows = 18;

    return Stack(
      children: [
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _dragOffset = _calculateNewOffset(
                currentOffset: _dragOffset,
                delta: details.delta,
                puzzleWidth: puzzleWidth,
                puzzleHeight: puzzleHeight,
                horizontalSpacing: horizontalSpacing,
                verticalSpacing: verticalSpacing,
              );
            });
          },
          child: Container(
            color: ColorSetting.colorBase,
            child: CustomMultiChildLayout(
              delegate: PuzzleLayoutDelegate(
                itemsPerRow: itemsPerRow,
                totalRows: totalRows,
                puzzleWidth: puzzleWidth,
                puzzleHeight: puzzleHeight,
                horizontalSpacing: horizontalSpacing,
                verticalSpacing: verticalSpacing,
                dragOffset: _dragOffset,
                scaleFactor: _scaleFactor,
              ),
              children: List.generate(totalRows * itemsPerRow, (index) {
                final int row = index ~/ itemsPerRow;
                final int column = index % itemsPerRow;

                return PuzzleContent(
                  row: row,
                  column: column,
                  index: index,
                  puzzleHeight: puzzleHeight,
                  scaleFactor: _scaleFactor,
                );
              }),
            ),
          ),
        ),
        Positioned(
          bottom: 150.0.h,
          left: 140.0.w,
          width: 260.0.w,
          height: 260.0.w,
          child: CustomUiCircle(
            svgImage: 'cir_zoom',
            onTap: () => _toggleScale(),
          ),
        ),
        Positioned(
          bottom: 150.0.h,
          right: 140.0.w,
          width: 260.0.w,
          height: 260.0.w,
          child: CustomUiCircle(
            svgImage: 'cir_shuffle',
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Offset _calculateNewOffset({
    required Offset currentOffset,
    required Offset delta,
    required double puzzleWidth,
    required double puzzleHeight,
    required double horizontalSpacing,
    required double verticalSpacing,
  }) {
    final double maxDragX =
        (puzzleWidth + horizontalSpacing) * _scaleFactor * 4;
    final double maxDragY = (puzzleHeight + verticalSpacing) * _scaleFactor * 6;
    final double minDragX = -maxDragX;
    final double minDragY = -maxDragY;

    final Offset newOffset = currentOffset + delta;

    return Offset(
      newOffset.dx.clamp(minDragX, maxDragX),
      newOffset.dy.clamp(minDragY, maxDragY),
    );
  }
}

class PuzzleLayoutDelegate extends MultiChildLayoutDelegate {
  final int itemsPerRow;
  final int totalRows;
  final double puzzleWidth;
  final double puzzleHeight;
  final double horizontalSpacing;
  final double verticalSpacing;
  final Offset dragOffset;
  final double scaleFactor;

  PuzzleLayoutDelegate({
    required this.itemsPerRow,
    required this.totalRows,
    required this.puzzleWidth,
    required this.puzzleHeight,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.dragOffset,
    required this.scaleFactor,
  });

  @override
  void performLayout(Size size) {
    final double scaledPuzzleWidth =
        (itemsPerRow - 1) * (puzzleWidth + horizontalSpacing) * scaleFactor +
            puzzleWidth * scaleFactor;
    final double scaledPuzzleHeight =
        (totalRows - 1) * (puzzleHeight + verticalSpacing) * scaleFactor +
            puzzleHeight * scaleFactor;

    final double startX = (size.width - scaledPuzzleWidth) / 2 + dragOffset.dx;
    final double startY =
        (size.height - scaledPuzzleHeight) / 2 + dragOffset.dy;

    for (int index = 0; index < totalRows * itemsPerRow; index++) {
      final int row = index ~/ itemsPerRow;
      final int column = index % itemsPerRow;

      final double dx =
          startX + column * (puzzleWidth + horizontalSpacing) * scaleFactor;
      final double dy =
          startY + row * (puzzleHeight + verticalSpacing) * scaleFactor;

      if (hasChild(index)) {
        layoutChild(
          index,
          BoxConstraints.tight(
              Size(puzzleWidth * scaleFactor, puzzleHeight * scaleFactor)),
        );
        positionChild(index, Offset(dx, dy));
      }
    }
  }

  @override
  bool shouldRelayout(PuzzleLayoutDelegate oldDelegate) {
    return itemsPerRow != oldDelegate.itemsPerRow ||
        totalRows != oldDelegate.totalRows ||
        puzzleWidth != oldDelegate.puzzleWidth ||
        puzzleHeight != oldDelegate.puzzleHeight ||
        horizontalSpacing != oldDelegate.horizontalSpacing ||
        verticalSpacing != oldDelegate.verticalSpacing ||
        dragOffset != oldDelegate.dragOffset ||
        scaleFactor != oldDelegate.scaleFactor;
  }
}
