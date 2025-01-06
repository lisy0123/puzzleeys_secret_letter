import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/utils/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/color_match.dart';

class PuzzleProvider extends ChangeNotifier {
  List<Color> _colors = List.filled(8 * 18, Colors.white);
  bool _isLoading = false;
  PuzzleType _currentPuzzleType = PuzzleType.global;

  List<Color> get colors => _colors;
  bool get isLoading => _isLoading;

  Future<void> initializeColors(PuzzleType puzzleType) async {
    if (_currentPuzzleType == puzzleType && !_isLoading) return;

    _currentPuzzleType = puzzleType;
    _isLoading = true;
    notifyListeners();

    _colors = List.filled(8 * 18, Colors.white);
    notifyListeners();

    final puzzleResponse = await _fetchPuzzleResponse(puzzleType);
    final puzzleList = puzzleResponse['result'] as List<dynamic>;

    await _refreshPuzzleColors(puzzleList);
    _isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> _fetchPuzzleResponse(PuzzleType puzzleType) async {
    final url = {
      PuzzleType.global: '/api/post/global',
      PuzzleType.subject: '/api/post/subject',
      PuzzleType.personal: '/api/post/personal',
    }[puzzleType]!;
    return await apiRequest(url, ApiType.get);
  }

  Future<void> _refreshPuzzleColors(List<dynamic> puzzleList) async {
    final updatedColors = List<Color>.from(_colors);
    final indexes = List.generate(_colors.length, (index) => index)..shuffle();

    for (int i = 0; i < puzzleList.length; i++) {
      final color = ColorMatch(stringColor: puzzleList[i]['color'])();
      updatedColors[indexes[i]] = color;
    }

    _updateColors(updatedColors);
  }

  void _updateColors(List<Color> newColors) {
    if (!_listEquals(_colors, newColors)) {
      _colors = newColors;
      notifyListeners();
    }
  }

  bool _listEquals(List<Color> list1, List<Color> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
