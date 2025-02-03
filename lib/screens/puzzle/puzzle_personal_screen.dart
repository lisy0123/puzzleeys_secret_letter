import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/providers/check_screen_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/screens/loading/puzzle_loading_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/background/puzzle_background.dart';

class PuzzlePersonalScreen extends StatefulWidget {
  const PuzzlePersonalScreen({super.key});

  @override
  State<PuzzlePersonalScreen> createState() => _PuzzlePersonalScreenState();
}

class _PuzzlePersonalScreenState extends State<PuzzlePersonalScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CheckScreenProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PuzzleProvider, bool>(
      selector: (context, provider) => provider.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<CheckScreenProvider>().toggleCheck(true);
          });
          return PuzzleLoadingScreen();
        }
        return PuzzleBackground(
          puzzleType: PuzzleType.personal,
          puzzleList: context.read<PuzzleProvider>().puzzleList,
        );
      },
    );
  }
}
