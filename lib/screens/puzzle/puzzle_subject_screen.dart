import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_background.dart';

class PuzzleSubjectScreen extends StatelessWidget {
  const PuzzleSubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PuzzleBackground(),
      ],
    );
  }
}
