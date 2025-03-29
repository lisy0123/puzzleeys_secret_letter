import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/ads/ad_manager.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart' show PuzzleType;
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/delete_dialog_provider.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_overlay.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_simple_dialog.dart';

class DeletePostDialog extends StatelessWidget {
  final String puzzleId;
  final PuzzleType puzzleType;

  const DeletePostDialog({
    super.key,
    required this.puzzleId,
    required this.puzzleType,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSimpleDialog(
      text: MessageStrings.deleteMessage,
      iconName: 'btn_ad',
      iconTitle: CustomStrings.deleteLong,
      onTap: () async {
        await AdManager().showRewardedAd(() => _onTap(context));
      },
    );
  }

  void _onTap(BuildContext context) async {
    final PuzzleProvider puzzleProvider = context.read<PuzzleProvider>();
    final DeleteDialogProvider deleteProvider =
        context.read<DeleteDialogProvider>();

    try {
      deleteProvider.updateLoading(setLoading: true);

      final url = {
        PuzzleType.global: '/api/post/global_delete/$puzzleId',
        PuzzleType.subject: '/api/post/subject_delete/$puzzleId',
        PuzzleType.personal: '/api/post/personal_delete/$puzzleId',
      }[puzzleType]!;
      await apiRequest(url, ApiType.delete);

      deleteProvider.updateLoading(setLoading: false);
      if (context.mounted) {
        Navigator.pop(context);
        CustomOverlay.show(
          text: OverlayStrings.deleteOverlay,
          context: context,
        );
      }

      puzzleProvider.updateShuffle(true);
      await puzzleProvider.initializeColors(puzzleType);
    } catch (error) {
      deleteProvider.updateLoading(setLoading: false);
      if (context.mounted) Navigator.pop(context);

      throw Exception('Error deleting post: $error');
    }
  }
}
