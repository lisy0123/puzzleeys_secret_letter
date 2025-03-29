import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/ads/ad_manager.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/bead_provider.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_overlay.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_simple_dialog.dart';

class DeleteBeadDialog extends StatelessWidget {
  final Map<String, dynamic> puzzleData;

  const DeleteBeadDialog({super.key, required this.puzzleData});

  @override
  Widget build(BuildContext context) {
    return CustomSimpleDialog(
      text: MessageStrings.deleteBeadMessage,
      iconName: 'btn_ad',
      iconTitle: CustomStrings.deleteLong,
      onTap: () async {
        await AdManager().showRewardedAd(() => _onTap(context));
      },
    );
  }

  void _onTap(BuildContext context) async {
    final BeadProvider beadProvider = context.read<BeadProvider>();

    try {
      beadProvider.updateLoading(setLoading: true);
      await apiRequest('/api/bead/${puzzleData['index']}', ApiType.delete);
      beadProvider.updateColorForBead(puzzleData['color'], isAdding: false);
      beadProvider.removePuzzleFromBead(puzzleData['id']);

      beadProvider.updateLoading(setLoading: false);
      if (context.mounted) {
        Navigator.pop(context);
        CustomOverlay.show(
          text: OverlayStrings.deleteOverlay,
          context: context,
        );
      }
    } catch (error) {
      beadProvider.updateLoading(setLoading: false);
      if (context.mounted) Navigator.pop(context);

      throw Exception('Error deleting bead post: $error');
    }
  }
}
