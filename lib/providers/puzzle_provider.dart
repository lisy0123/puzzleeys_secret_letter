import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/utils/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/color_match.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PuzzleProvider extends ChangeNotifier {
  List<Color> _colors = List.filled(8 * 18, Colors.white);
  PuzzleType? _currentPuzzleType;
  bool _isLoading = false;
  bool _isShuffle = false;

  List<Color> get colors => _colors;
  bool get isLoading => _isLoading;
  bool get isShuffle => _isShuffle;

  void updateShuffle(bool value) {
    if (_isShuffle != value) {
      _isShuffle = value;
      notifyListeners();
    }
  }

  Future<void> initializeColors(PuzzleType puzzleType) async {
    if (!_isShuffle && _currentPuzzleType == puzzleType && !_isLoading) {
      return;
    }

    try {
      _colors = List.filled(8 * 18, Colors.white);
      notifyListeners();

      if (!await _hasValidToken()) return;

      _updateLoading(true);
      _currentPuzzleType = puzzleType;

      final puzzleResponse = await _fetchPuzzleResponse(puzzleType);
      if (puzzleResponse['code'] == 200) {
        final puzzleList = puzzleResponse['result'] as List<dynamic>;
        _refreshPuzzleColors(puzzleList, puzzleType);
      } else {
        debugPrint('Error: ${puzzleResponse['message']}');
      }
    } catch (error) {
      debugPrint('Error initializing puzzle: $error');
    } finally {
      _updateLoading(false);
      updateShuffle(false);
    }
  }

  Future<Map<String, dynamic>> _fetchPuzzleResponse(
      PuzzleType puzzleType) async {
    final url = {
      PuzzleType.global: '/api/post/global',
      PuzzleType.subject: '/api/post/subject',
      PuzzleType.personal: '/api/post/personal',
    }[puzzleType]!;
    return await apiRequest(url, ApiType.get);
  }

  void _refreshPuzzleColors(List<dynamic> puzzleList, PuzzleType puzzleType) {
    final updatedColors = List<Color>.from(_colors);
    final indexes = List.generate(_colors.length, (index) => index);

    if (puzzleType == PuzzleType.global) {
      indexes.shuffle();
    }

    for (int i = 0; i < puzzleList.length; i++) {
      final color = ColorMatch(stringColor: puzzleList[i]['color'])();
      final targetIndex = (puzzleType == PuzzleType.global)
          ? indexes[i]
          : puzzleList[i]['puzzle_index'];
      updatedColors[targetIndex] = color;
    }

    if (!listEquals(_colors, updatedColors)) {
      _colors = updatedColors;
      notifyListeners();
    }
  }

  Future<bool> _hasValidToken() async {
    final token = Supabase.instance.client.auth.currentSession?.accessToken;
    return token != null;
  }

  void _updateLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }
}
