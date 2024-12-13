import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/background/puzzle_background.dart';

class PuzzleSubjectScreen extends StatelessWidget {
  const PuzzleSubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const  String puzzleState = 'Subject';

    return const Stack(
      children: [
        PuzzleBackground(
          puzzleState: puzzleState,
        ),
      ],
    );
  }
}
