import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/screens/loading/puzzle_loading_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/background/puzzle_background.dart';

class PuzzleSubjectScreen extends StatefulWidget {
  const PuzzleSubjectScreen({super.key});

  @override
  State<PuzzleSubjectScreen> createState() => _PuzzleSubjectScreenState();
}

class _PuzzleSubjectScreenState extends State<PuzzleSubjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PuzzleProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return PuzzleLoadingScreen();
        }
        return PuzzleBackground(
          puzzleType: PuzzleType.subject,
          puzzleList: provider.puzzleList,
        );
      },
    );
  }
}
