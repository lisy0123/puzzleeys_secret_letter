import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/background/puzzle_background.dart';

class PuzzleSubjectScreen extends StatelessWidget {
  const PuzzleSubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String puzzleState = 'Subject';

    return Stack(
      children: [
        PuzzleBackground(
          puzzleState: puzzleState,
        ),
      ],
    );
  }
}
