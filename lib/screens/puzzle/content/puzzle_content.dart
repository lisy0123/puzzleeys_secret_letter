import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/providers/read_puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_content_handler.dart';
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

class _PuzzleContentState extends State<PuzzleContent>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Color?>? _animation;
  bool? isExist;

  @override
  void initState() {
    super.initState();
    _updateExistState();
  }

  void _updateExistState() {
    bool exist = _isPuzzleExist();
    if (isExist != exist) {
      setState(() {
        isExist = exist;
      });
      if (!exist) {
        _initializeAnimation();
      } else {
        _animation = AlwaysStoppedAnimation(widget.puzzleData['color']);
      }
    }
  }

  bool _isPuzzleExist() {
    if (widget.puzzleType == PuzzleType.personal) {
      final String puzzleId = widget.puzzleData['id'] ?? '';
      if (puzzleId.isNotEmpty) {
        return context.read<ReadPuzzleProvider>().isExist(puzzleId);
      }
    }
    return true;
  }

  void _initializeAnimation() {
    if (_controller == null) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      )..repeat(reverse: true);

      _animation = ColorTween(
        begin: widget.puzzleData['color'],
        end: Color.lerp(widget.puzzleData['color'], Colors.white, 0.7)!,
      ).animate(CurvedAnimation(parent: _controller!, curve: Curves.easeInOut));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rotationAngle = (widget.row % 2 == widget.column % 2) ? pi / 2 : pi;
    context.watch<ReadPuzzleProvider>().readIds;
    _updateExistState();

    return LayoutId(
      id: widget.index,
      child: GestureDetector(
        onTap: () => PuzzleContentHandler.handler(
          index: widget.index,
          puzzleType: widget.puzzleType,
          puzzleData: widget.puzzleData,
          context: context,
        ),
        child: Transform.rotate(
          angle: rotationAngle,
          child: AnimatedBuilder(
            animation: _animation ??
                AlwaysStoppedAnimation(widget.puzzleData['color']),
            builder: (context, child) {
              final Color puzzleColor = isExist == true
                  ? widget.puzzleData['color']
                  : _animation?.value ?? widget.puzzleData['color'];

              return CustomPaint(
                size: Size(widget.puzzleHeight, widget.puzzleHeight),
                painter: BoardPuzzle(
                  puzzleColor: puzzleColor,
                  scaleFactor: widget.scaleFactor,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
