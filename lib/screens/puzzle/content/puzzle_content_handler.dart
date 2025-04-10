import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/ads/ad_manager.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/read_puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/screens/dialogs/icon_dialog.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_main_screen.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_writing_screen.dart';

class PuzzleContentHandler {
  static void handler({
    required PuzzleType puzzleType,
    required Map<String, dynamic> puzzleData,
    required BuildContext context,
  }) {
    final Color puzzleColor = puzzleData['color'];

    if (puzzleColor == Colors.white) {
      _handleWhitePuzzle(puzzleType, context);
    } else if (puzzleColor == Colors.white.withValues(alpha: 0.8)) {
      _showInterstitialAd();
      BuildDialog.show(
        iconName: 'puzzleSubject',
        puzzleText: puzzleData['title'].replaceAll(r'\n', '\n'),
        puzzleColor: puzzleColor,
        context: context,
      );
    } else {
      _showInterstitialAd();
      if (puzzleType == PuzzleType.personal) {
        context.read<ReadPuzzleProvider>().markAsRead(puzzleData['id']);
      }
      PuzzleScreenHandler.navigateScreen(
        barrierColor: puzzleColor.withValues(alpha: 0.8),
        child: PuzzleMainScreen(puzzleData: puzzleData, puzzleType: puzzleType),
        context: context,
      );
    }
  }

  static void _showInterstitialAd() async {
    await AdManager().showInterstitialAd();
  }

  static void _handleWhitePuzzle(PuzzleType puzzleType, BuildContext context) {
    final bool hasSubject =
        Provider.of<PuzzleProvider>(context, listen: false).hasSubject;

    if (puzzleType == PuzzleType.personal) {
      _showDialog('putWho', context);
    } else if (puzzleType == PuzzleType.subject && hasSubject) {
      _showDialog('isExists', context);
    } else {
      PuzzleScreenHandler.navigateScreen(
        barrierColor: Colors.white70,
        child: PuzzleWritingScreen(puzzleType: puzzleType, reply: false),
        context: context,
      );
    }
  }

  static void _showDialog(String iconName, context) {
    BuildDialog.show(iconName: iconName, simpleDialog: true, context: context);
  }
}
