import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/writing_provider.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/request/user_request.dart';
import 'package:puzzleeys_secret_letter/utils/storage/secure_storage_utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_overlay.dart';

class CompletePuzzle {
  final OverlayType overlayType;
  final PuzzleType puzzleType;
  final Map<String, dynamic> puzzleData;
  final int? sendDays;
  final BuildContext context;

  const CompletePuzzle({
    required this.overlayType,
    required this.puzzleType,
    required this.puzzleData,
    this.sendDays,
    required this.context,
  });

  void post() async {
    try {
      // TODO: api
      final responseData = await _fetchResponse();
      if (responseData['code'] == 200 && context.mounted) {
        context.read<WritingProvider>().updateOpacity();
        Navigator.popUntil(context, (route) => route.isFirst);
        CustomOverlay.show(
          text: MessageStrings.overlayMessages[overlayType]![1],
          puzzleVis: true,
          puzzleNum: MessageStrings.overlayMessages[overlayType]![0],
          context: context,
        );
      }
    } catch (error) {
      throw Exception('Error posting puzzle: $error');
    }
  }

  Future<Map<String, dynamic>> _fetchResponse() async {
    final urlMap = {
      PuzzleType.global: '/api/post/global',
      PuzzleType.subject: '/api/post/subject',
    };
    final String url = urlMap[puzzleType] ?? '/api/post/personal';

    String? userId = await SecureStorageUtils.get('userId');
    if (userId == null) {
      (userId, _) = await UserRequest.reloadUserData();
    }

    final Map<String, String> body = Map<String, String>.from(puzzleData);
    if (puzzleType == PuzzleType.reply) {
      body['sender_id'] = userId;
      body['receiver_id'] = puzzleData['receiver_id'];
      body['parent_post_color'] = puzzleData['parent_post_color'];
      body['parent_post_type'] = puzzleData['parent_post_type'];
    } else if (puzzleType == PuzzleType.me) {
      final sendAt =
          DateTime.now().toUtc().add(Duration(hours: sendDays! * 24));
      body['sender_id'] = userId;
      body['receiver_id'] = userId;
      body['created_at'] = _formatDate(sendAt);
    } else if (puzzleType == PuzzleType.personal) {
      body['sender_id'] = userId;
    } else {
      body['author_id'] = userId;
    }

    return await apiRequest(
      url,
      ApiType.post,
      headers: {'Content-Type': 'application/json'},
      bodies: body,
    );
  }

  String _formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS');
    String formattedDate = formatter.format(dateTime);
    return '$formattedDate+00';
  }
}
