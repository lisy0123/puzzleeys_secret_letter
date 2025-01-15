import 'dart:async';
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
      'author_id': null,
      'receiver_id': null,
      'sender_id': null,
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
    while (true) {
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
          'author_id': null,
          'receiver_id': null,
          'sender_id': null,
          'puzzle_count': null,
          'created_at': null,
        },
      );
      notifyListeners();

      final session = Supabase.instance.client.auth.currentSession;
      if (session?.accessToken == null) {
        updateShuffle(true);
        return;
      }

      try {
        _updateLoading(true);
        _currentPuzzleType = puzzleType;

        final puzzleResponse = await _fetchPuzzleResponse(puzzleType);
        if (puzzleResponse['code'] == 200) {
          final puzzleList = puzzleResponse['result'] as List<dynamic>;
          _refreshPuzzles(puzzleList, puzzleType);
        }
        updateShuffle(false);
        _updateLoading(false);
        break;
      } catch (error) {
        updateShuffle(true);
        if (error.toString().contains('Invalid or expired JWT')) {
          await waitForSession();
        } else {
          _updateLoading(false);
          throw Exception('Error initializing puzzle: $error');
        }
      }
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

  void _refreshPuzzles(List<dynamic> puzzleData, PuzzleType puzzleType) {
    final updatedPuzzleList = List<Map<String, dynamic>>.from(_puzzleList);
    final indexes = List.generate(_puzzleList.length, (index) => index);

    if (puzzleType == PuzzleType.global) {
      indexes.shuffle();
    }

    final getTargetIndex = puzzleType == PuzzleType.global
        ? (int i) => indexes[i]
        : (int i) => puzzleData[i]['puzzle_index'];

    for (int i = 0; i < puzzleData.length; i++) {
      final targetIndex = getTargetIndex(i);
      final updatedItem = updatedPuzzleList[targetIndex];

      updatedPuzzleList[targetIndex] = {
        ...updatedItem,
        'id': puzzleData[i]['id'],
        'title': puzzleData[i]['title'],
        'content': puzzleData[i]['content'],
        'color': ColorMatch(stringColor: puzzleData[i]['color'])(),
        'author_id': puzzleData[i]['author_id'],
        'receiver_id': puzzleData[i]['receiver_id'],
        'sender_id': puzzleData[i]['sender_id'],
        'puzzle_count': puzzleData[i]['puzzle_count'],
        'created_at': puzzleData[i]['created_at'],
      };
    }

    _puzzleList = updatedPuzzleList;
    notifyListeners();
  }

  void _updateLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }
}
