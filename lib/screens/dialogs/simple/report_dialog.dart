import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
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
    if (context.mounted) Navigator.pop(context);
    try {
      // TODO: add api in server side.
      final responseData = await _fetchResponse(puzzleType, puzzleId);
      if (responseData['code'] == 200) {
        if (context.mounted) Navigator.pop(context);
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
