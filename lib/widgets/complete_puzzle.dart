import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/puzzle/puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/providers/writing_provider.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/request/user_request.dart';
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
      final puzzleProvider = context.read<PuzzleProvider>();

      CustomOverlay.show(
        text: MessageStrings.overlayMessages[overlayType]![1],
        puzzleVis: true,
        puzzleNum: MessageStrings.overlayMessages[overlayType]![0],
        context: context,
      );
      await _fetchResponse();
      puzzleProvider.updateShuffle(true);
      await puzzleProvider.initializeColors(puzzleType);
      if (context.mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
        context.read<WritingProvider>().updateOpacity();
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
    final String userId = await UserRequest.getUserId();

    final Map<String, String> bodies = {...puzzleData};
    final Map<String, String> headers = {'Content-Type': 'application/json'};

    switch (puzzleType) {
      case PuzzleType.reply:
        bodies.addAll({
          'sender_id': userId,
          'receiver_id': puzzleData['receiver_id'],
          'parent_post_color': puzzleData['parent_post_color'],
          'parent_post_type': puzzleData['parent_post_type'],
        });
        break;
      case PuzzleType.me:
        final sendAt =
            DateTime.now().toUtc().add(Duration(hours: sendDays! * 24));
        bodies.addAll({
          'sender_id': userId,
          'receiver_id': userId,
          'created_at': _formatDate(sendAt),
        });
        break;
      case PuzzleType.personal:
        bodies['sender_id'] = userId;
        break;
      default:
        bodies['author_id'] = userId;
    }

    return await apiRequest(
      url,
      ApiType.post,
      headers: headers,
      bodies: bodies,
    );
  }

  String _formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS');
    String formattedDate = formatter.format(dateTime);
    return '$formattedDate+00';
  }
}
