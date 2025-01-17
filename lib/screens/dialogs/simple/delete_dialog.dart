import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
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
    try {
      if (context.mounted) Navigator.pop(context);
      // TODO: api
      final responseData =
          await apiRequest('/api/post/global/$puzzleId', ApiType.delete);
      if (responseData['code'] == 200) {
        print("vvv");
      }
    } catch (error) {
      throw Exception('Error deleting global post: $error');
    }
  }
}
