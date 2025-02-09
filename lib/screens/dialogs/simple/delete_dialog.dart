import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/delete_dialog_provider.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_simple_dialog.dart';

class DeleteDialog extends StatelessWidget {
  final String puzzleId;

  const DeleteDialog({super.key, required this.puzzleId});

  @override
  Widget build(BuildContext context) {
    return CustomSimpleDialog(
      text: MessageStrings.deleteMessage,
      iconName: 'btn_trash',
      iconTitle: CustomStrings.deleteLong,
      onTap: () => _onTap(context),
    );
  }

  void _onTap(BuildContext context) async {
    final DeleteDialogProvider deleteProvider =
        context.read<DeleteDialogProvider>();

    try {
      deleteProvider.updateLoading(setLoading: true);
      await apiRequest('/api/post/global/$puzzleId', ApiType.delete);

      deleteProvider.updateLoading(setLoading: false);
      if (context.mounted) Navigator.pop(context);
    } catch (error) {
      deleteProvider.updateLoading(setLoading: false);
      if (context.mounted) Navigator.pop(context);

      throw Exception('Error deleting global post: $error');
    }
  }
}
