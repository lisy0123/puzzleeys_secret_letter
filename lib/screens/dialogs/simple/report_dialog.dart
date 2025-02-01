import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_overlay.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_simple_dialog.dart';

class ReportDialog extends StatelessWidget {
  final String puzzleId;
  final PuzzleType puzzleType;

  const ReportDialog({
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
      CustomOverlay.show(
        text: MessageStrings.reportOverlay,
        context: context,
      );
      await _fetchResponse(puzzleType, puzzleId);
      if (context.mounted) {
        context.read<PuzzleProvider>().updateShuffle(true);
        context.read<PuzzleProvider>().initializeColors(puzzleType);
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (error) {
      throw Exception('Error reporting post: $error');
    }
  }

  Future<Map<String, dynamic>> _fetchResponse(
    PuzzleType puzzleType,
    String puzzleId,
  ) async {
    final url = {
      PuzzleType.global: '/api/post/global_report/$puzzleId',
      PuzzleType.subject: '/api/post/subject_report/$puzzleId',
      PuzzleType.personal: '/api/post/personal_report/$puzzleId',
    }[puzzleType]!;
    return await apiRequest(url, ApiType.post);
  }
}
