import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/background/puzzle_background.dart';

class PuzzlePersonalScreen extends StatelessWidget {
  const PuzzlePersonalScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return const Stack(
      children: [
        PuzzleBackground(
          puzzleType: PuzzleType.personal,
        ),
      ],
    );
  }
}
