import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/background/puzzle_config.dart';

class PuzzleOffsetProvider with ChangeNotifier {
  Offset _dragOffset = Offset.zero;
  Offset get dragOffset => _dragOffset;

  void updateOffset(Offset delta, PuzzleConfig config) {
    _dragOffset = _calculateNewOffset(delta, config);
    notifyListeners();
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
