import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_screen_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/screens/loading/puzzle_loading_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/background/puzzle_background.dart';
import 'package:tuple/tuple.dart' show Tuple2;

class PuzzleScreen extends StatelessWidget {
  final PuzzleType puzzleType;
  final bool useCheck;

  const PuzzleScreen({
    super.key,
    required this.puzzleType,
    this.useCheck = false,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<PuzzleProvider, Tuple2<bool, List<Map<String, dynamic>>>>(
      selector: (_, provider) =>
          Tuple2(provider.isLoading, provider.puzzleList),
      builder: (_, data, __) {
        final isLoading = data.item1;
        final puzzleList = data.item2;

        if (isLoading) {
          if (useCheck) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<PuzzleScreenProvider>().screenCheckToggle(true);
            });
          }
          return PuzzleLoadingScreen();
        }
        return PuzzleBackground(puzzleType: puzzleType, puzzleList: puzzleList);
      },
    );
  }
}

class PuzzleGlobalScreen extends StatelessWidget {
  const PuzzleGlobalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PuzzleScreen(puzzleType: PuzzleType.global);
  }
}

class PuzzleSubjectScreen extends StatelessWidget {
  const PuzzleSubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PuzzleScreen(puzzleType: PuzzleType.subject);
  }
}

class PuzzlePersonalScreen extends StatelessWidget {
  const PuzzlePersonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PuzzleScreen(puzzleType: PuzzleType.personal, useCheck: true);
  }
}
