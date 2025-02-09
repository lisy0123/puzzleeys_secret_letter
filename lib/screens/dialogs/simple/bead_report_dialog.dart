import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/bead_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_overlay.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_simple_dialog.dart';

class BeadReportDialog extends StatelessWidget {
  final String puzzleId;
  final PuzzleType puzzleType;

  const BeadReportDialog({
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
    final BeadProvider beadProvider = context.read<BeadProvider>();

    try {
      beadProvider.updateLoading(setLoading: true);
      final PuzzleProvider puzzleProvider = context.read<PuzzleProvider>();

      CustomOverlay.show(text: MessageStrings.reportOverlay, context: context);
      final response = await _fetchResponse(puzzleType, puzzleId);

      if (response['code'] == 200 && response['result'] != null) {
        final String isExist = response['result'] as String;

        if (isExist == 'Y') {
          puzzleProvider.updateShuffle(true);
          puzzleProvider.initializeColors(puzzleType);
        }
      }

      beadProvider.updateLoading(setLoading: false);
      if (context.mounted) Navigator.pop(context);
    } catch (error) {
      beadProvider.updateLoading(setLoading: false);
      if (context.mounted) Navigator.pop(context);

      throw Exception('Error reporting post: $error');
    }
  }

  Future<Map<String, dynamic>> _fetchResponse(
    PuzzleType puzzleType,
    String puzzleId,
  ) async {
    final url = {
      PuzzleType.global: '/api/bead/global_report/$puzzleId',
      PuzzleType.subject: '/api/bead/subject_report/$puzzleId',
      PuzzleType.personal: '/api/bead/personal_report/$puzzleId',
    }[puzzleType]!;
    return await apiRequest(url, ApiType.post);
  }
}
