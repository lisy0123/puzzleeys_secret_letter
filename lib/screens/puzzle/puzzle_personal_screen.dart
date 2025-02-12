import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/providers/check_screen_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/screens/loading/puzzle_loading_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/background/puzzle_background.dart';
import 'package:tuple/tuple.dart';

class PuzzlePersonalScreen extends StatefulWidget {
  const PuzzlePersonalScreen({super.key});

  @override
  State<PuzzlePersonalScreen> createState() => _PuzzlePersonalScreenState();
}

class _PuzzlePersonalScreenState extends State<PuzzlePersonalScreen> {
  late final CheckScreenProvider _checkProvider;

  @override
  void initState() {
    _checkProvider = context.read<CheckScreenProvider>();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkProvider.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PuzzleProvider, Tuple2<bool, List<Map<String, dynamic>>>>(
      selector: (context, provider) =>
          Tuple2(provider.isLoading, provider.puzzleList),
      builder: (context, data, child) {
        final isLoading = data.item1;
        final puzzleList = data.item2;

        if (isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkProvider.toggleCheck(true);
          });
          return PuzzleLoadingScreen();
        }
        return PuzzleBackground(
          puzzleType: PuzzleType.personal,
          puzzleList: puzzleList,
        );
      },
    );
  }
}
