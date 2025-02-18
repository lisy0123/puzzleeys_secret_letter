import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/bead_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/utils/request/fetch_request.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_overlay.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_simple_dialog.dart';

class ReportBeadDialog extends StatelessWidget {
  final String puzzleId;
  final PuzzleType puzzleType;

  const ReportBeadDialog({
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
      final responseData = await FetchRequest.report(
        puzzleType: puzzleType,
        puzzleId: puzzleId,
        router: 'bead',
      );

      if (responseData['code'] == 200) {
        final data = responseData['result'] as Map<String, dynamic>;
        final bool isExist = data['isExist'];
        final String beadColor = data['beadColor'];

        beadProvider.updateColorForBead(beadColor, isAdding: false);
        if (isExist) {
          puzzleProvider.updateShuffle(true);
          await puzzleProvider.initializeColors(puzzleType);
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
}
