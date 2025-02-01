import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_personal_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_detail_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_writing_screen.dart';
import 'package:puzzleeys_secret_letter/widgets/board_puzzle.dart';

class PuzzleContent extends StatefulWidget {
  final int row;
  final int column;
  final int index;
  final double puzzleHeight;
  final double scaleFactor;
  final PuzzleType puzzleType;
  final Map<String, dynamic> puzzleData;

  const PuzzleContent({
    super.key,
    required this.row,
    required this.column,
    required this.index,
    required this.puzzleHeight,
    required this.scaleFactor,
    required this.puzzleType,
    required this.puzzleData,
  });

  @override
  State<PuzzleContent> createState() => _PuzzleContentState();
}

class _PuzzleContentState extends State<PuzzleContent> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await context.read<PuzzlePersonalProvider>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    final rotationAngle = (widget.row % 2 == widget.column % 2) ? pi / 2 : pi;

    return LayoutId(
      id: widget.index,
      child: GestureDetector(
        onTap: _onTap,
        child: RepaintBoundary(
          child: Transform.rotate(
            angle: rotationAngle,
            child: CustomPaint(
              size: Size(widget.puzzleHeight, widget.puzzleHeight),
              painter: BoardPuzzle(
                // TODO: check personal
                puzzleColor: widget.puzzleData['color'],
                scaleFactor: widget.scaleFactor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap() {
    final Color puzzleColor = widget.puzzleData['color'];

    if (puzzleColor == Colors.white) {
      _whitePuzzle();
    } else if (puzzleColor == Colors.white.withValues(alpha: 0.8)) {
      BuildDialog.show(
        iconName: 'puzzleSubject',
        puzzleText: widget.puzzleData['title'].replaceAll(r'\n', '\n'),
        puzzleColor: widget.puzzleData['color'],
        context: context,
      );
    } else {
      _detailPuzzle();
    }
  }

  void _whitePuzzle() {
    final String hasSubject = context.watch<PuzzleProvider>().hasSubject;

    if (widget.puzzleType == PuzzleType.personal) {
      BuildDialog.show(
        iconName: 'putWho',
        simpleDialog: true,
        context: context,
      );
    } else if (widget.puzzleType == PuzzleType.subject && hasSubject == 'Y') {
      BuildDialog.show(
        iconName: 'isExists',
        simpleDialog: true,
        context: context,
      );
    } else {
      PuzzleScreenHandler.navigateScreen(
        barrierColor: Colors.white70,
        child: PuzzleWritingScreen(
          puzzleType: widget.puzzleType,
          index: widget.index,
          reply: false,
        ),
        context: context,
      );
    }
  }

  void _detailPuzzle() {
    if (widget.puzzleType == PuzzleType.personal) {
      // TODO: check personal
    }

    PuzzleScreenHandler.navigateScreen(
      barrierColor: widget.puzzleData['color'].withValues(alpha: 0.8),
      child: PuzzleDetailScreen(
        index: widget.index,
        puzzleData: widget.puzzleData,
        puzzleType: widget.puzzleType,
      ),
      context: context,
    );
  }
}
