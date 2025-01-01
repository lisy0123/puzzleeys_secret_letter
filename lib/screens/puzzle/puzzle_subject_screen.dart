import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/background/puzzle_background.dart';

class PuzzleSubjectScreen extends StatelessWidget {
  const PuzzleSubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return const Stack(
      children: [
        PuzzleBackground(
          puzzleType: PuzzleType.subject,
        ),
      ],
    );
  }
}
