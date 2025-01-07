import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/screens/loading/puzzle_loading_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/background/puzzle_background.dart';

class PuzzleGlobalScreen extends StatefulWidget {
  const PuzzleGlobalScreen({super.key});

  @override
  State<PuzzleGlobalScreen> createState() => _PuzzleGlobalScreenState();
}

class _PuzzleGlobalScreenState extends State<PuzzleGlobalScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PuzzleProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return PuzzleLoadingScreen(
            text: MessageStrings.loadingMessages[LoadingType.setting]!,
          );
        }
        return PuzzleBackground(
          puzzleType: PuzzleType.global,
          colors: provider.colors,
        );
      },
    );
  }
}

