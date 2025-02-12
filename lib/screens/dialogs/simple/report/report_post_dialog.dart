import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/utils/request/fetch_request.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_overlay.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_simple_dialog.dart';

class ReportPostDialog extends StatelessWidget {
  final String puzzleId;
  final PuzzleType puzzleType;

  const ReportPostDialog({
    super.key,
    required this.puzzleId,
    required this.puzzleType,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSimpleDialog(
      text: MessageStrings.reportMessage,
      iconName: 'btn_alarm',
      iconTitle: CustomStrings.report,
      onTap: () => _onTap(context),
    );
  }

  void _onTap(BuildContext context) async {
    try {
      final PuzzleProvider puzzleProvider = context.read<PuzzleProvider>();

      CustomOverlay.show(text: MessageStrings.reportOverlay, context: context);
      await FetchRequest.report(
        puzzleType: puzzleType,
        puzzleId: puzzleId,
        router: 'post',
      );

      puzzleProvider.updateShuffle(true);
      puzzleProvider.initializeColors(puzzleType);

      if (context.mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (error) {
      if (context.mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }

      throw Exception('Error reporting post: $error');
    }
  }
}
