import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/screens/loading/puzzle_loading_screen.dart';
import 'package:puzzleeys_secret_letter/styles/custom_text.dart';

class LoadingDialog extends StatelessWidget {
  final Future<List<Map<String, dynamic>>?> futureData;
  final Widget buildErrorText;
  final Widget Function(List<Map<String, dynamic>> data) buildItem;

  const LoadingDialog({
    super.key,
    required this.futureData,
    required this.buildErrorText,
    required this.buildItem,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return PuzzleLoadingScreen(overlay: false);
        }
        if (snapshot.hasError) {
          return _buildErrorText(snapshot.error, context);
        }
        final data = snapshot.data;
        if (data == null || data.isEmpty) {
          return _buildErrorText(null, context);
        } else {
          return buildItem(data);
        }
      },
    );
  }

  Widget _buildErrorText(Object? error, BuildContext context) {
    if (error != null) {
      return Center(
        child: CustomText.textContent(text: 'Error: $error', context: context),
      );
    }
    return buildErrorText;
  }
}
