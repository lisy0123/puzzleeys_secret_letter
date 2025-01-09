import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/utils/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/color_match.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PuzzleProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _puzzleList = List<Map<String, dynamic>>.generate(
    9 * 18,
    (index) => {
      'id': null,
      'puzzle_index': index,
      'title': null,
      'content': null,
      'color': Colors.white,
      'receiver_id': null,
      'views': null,
      'puzzle_count': null,
      'created_at': null,
    },
  );
  PuzzleType? _currentPuzzleType;
  bool _isLoading = false;
  bool _isShuffle = false;

  List<Map<String, dynamic>> get puzzleList => _puzzleList;
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

    _puzzleList = List<Map<String, dynamic>>.generate(
      9 * 18,
      (index) => {
        'id': null,
        'puzzle_index': index,
        'title': null,
        'content': null,
        'color': Colors.white,
        'receiver_id': null,
        'puzzle_count': null,
        'created_at': null,
      },
    );
    notifyListeners();

    try {
      _waitForSession();
      _updateLoading(true);
      _currentPuzzleType = puzzleType;

      final puzzleResponse = await _fetchPuzzleResponse(puzzleType);
      if (puzzleResponse['code'] == 200) {
        final puzzleList = puzzleResponse['result'] as List<dynamic>;
        _refreshPuzzles(puzzleList, puzzleType);
      }
      updateShuffle(false);
    } catch (error) {
      updateShuffle(true);
      debugPrint('Error initializing puzzle: $error');
      return;
    } finally {
      _updateLoading(false);
    }
  }

  Future<void> _waitForSession() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      return;
    }
    await Supabase.instance.client.auth.onAuthStateChange
        .firstWhere((data) => data.session != null);
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

  void _refreshPuzzles(List<dynamic> puzzleData, PuzzleType puzzleType) {
    final updatedPuzzleList = List<Map<String, dynamic>>.from(_puzzleList);
    final indexes = List.generate(_puzzleList.length, (index) => index);

    if (puzzleType == PuzzleType.global) {
      indexes.shuffle();
    }

    for (int i = 0; i < puzzleData.length; i++) {
      final targetIndex = (puzzleType == PuzzleType.global)
          ? indexes[i]
          : puzzleData[i]['puzzle_index'];

      updatedPuzzleList[targetIndex] = {
        ...updatedPuzzleList[targetIndex],
        'id': puzzleData[i]['id'],
        'title': puzzleData[i]['title'],
        'content': puzzleData[i]['content'],
        'color': ColorMatch(stringColor: puzzleData[i]['color'])(),
        'receiver_id': puzzleData[i]['receiver_id'],
        'puzzle_count': puzzleData[i]['puzzle_count'],
        'created_at': puzzleData[i]['created_at'],
      };
    }

    if (!listEquals(_puzzleList, updatedPuzzleList)) {
      _puzzleList = updatedPuzzleList;
      notifyListeners();
    }
  }

  void _updateLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }
}
