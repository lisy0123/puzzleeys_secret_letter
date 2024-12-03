import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/puzzle_background.dart';

class PuzzlePersonalScreen extends StatelessWidget {
  const PuzzlePersonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PuzzleBackground(),
      ],
    );
  }
}
