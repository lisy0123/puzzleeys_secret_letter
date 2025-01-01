import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/background/puzzle_background.dart';

class PuzzleGlobalScreen extends StatefulWidget {
  const PuzzleGlobalScreen({super.key});

  @override
  State<PuzzleGlobalScreen> createState() => _PuzzleGlobalScreenState();
}

class _PuzzleGlobalScreenState extends State<PuzzleGlobalScreen> {
  @override
  Widget build(BuildContext context) {

    return const Stack(
      children: [
        PuzzleBackground(
          puzzleType: PuzzleType.global,
        ),
      ],
    );
  }
}