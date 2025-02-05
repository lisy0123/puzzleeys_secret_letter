import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/screens/loading/puzzle_loading_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/background/puzzle_background.dart';
import 'package:tuple/tuple.dart';

class PuzzleGlobalScreen extends StatefulWidget {
  const PuzzleGlobalScreen({super.key});

  @override
  State<PuzzleGlobalScreen> createState() => _PuzzleGlobalScreenState();
}

class _PuzzleGlobalScreenState extends State<PuzzleGlobalScreen> {
  @override
  Widget build(BuildContext context) {
    return Selector<PuzzleProvider, Tuple2<bool, List<Map<String, dynamic>>>>(
      selector: (context, provider) =>
          Tuple2(provider.isLoading, provider.puzzleList),
      builder: (context, data, child) {
        final isLoading = data.item1;
        final puzzleList = data.item2;

        if (isLoading) {
          return PuzzleLoadingScreen();
        }
        return PuzzleBackground(
          puzzleType: PuzzleType.global,
          puzzleList: puzzleList,
        );
      },
    );
  }
}
