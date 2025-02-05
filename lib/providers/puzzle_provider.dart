import 'dart:async';
import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/color_match.dart';
import 'package:puzzleeys_secret_letter/utils/request/user_request.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PuzzleProvider extends ChangeNotifier {
  final int rows = 9;
  final int cols = 18;
  late String userId;

  List<Map<String, dynamic>> _puzzleList = [];
  PuzzleType? _currentPuzzleType;
  bool _isLoading = false;
  bool _isShuffle = false;
  String _hasSubject = '';

  List<Map<String, dynamic>> get puzzleList => _puzzleList;
  bool get isLoading => _isLoading;
  bool get isShuffle => _isShuffle;
  String get hasSubject => _hasSubject;

  PuzzleProvider() {
    _initialize();
  }

  void _initialize() {
    _puzzleList = List<Map<String, dynamic>>.generate(
      rows * cols,
      (index) => _emptyPuzzle(index),
    );
    notifyListeners();
  }

  void initializeHasSubject() async {
    final stored = await SharedPreferencesUtils.get('hasSubject');
    _hasSubject = stored ?? '';
    notifyListeners();
    userId = await UserRequest.getUserId();
  }

  Map<String, dynamic> _emptyPuzzle(int index) {
    return {
      'id': null,
      'puzzle_index': index,
      'title': null,
      'content': null,
      'color': Colors.white,
      'author_id': null,
      'receiver_id': null,
      'sender_id': null,
      'created_at': null,
      'parent_post_type': null,
      'parent_post_color': null,
      'read': false,
    };
  }

  Future<void> initializeColors(PuzzleType puzzleType) async {
    if (!_isShuffle && _currentPuzzleType == puzzleType && !_isLoading) {
      return;
    }

    while (true) {
      _initialize();

      final currentSession = Supabase.instance.client.auth.currentSession;
      if (currentSession == null) {
        updateShuffle(true);
        return;
      }
      _updateLoading(true);

      try {
        _currentPuzzleType = puzzleType;

        final puzzleResponse = await _fetchPuzzleResponse(puzzleType);
        if (puzzleResponse['code'] == 200) {
          final puzzleList = puzzleResponse['result'] as List<dynamic>;
          _refreshPuzzles(puzzleList, puzzleType);
          updateShuffle(false);
        } else {
          updateShuffle(true);
        }
        _updateLoading(false);
        break;
      } catch (error) {
        updateShuffle(true);
        if (error.toString().contains('Invalid or expired JWT')) {
          await Utils.waitForSession();
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
        }[puzzleType] ??
        '/api/post/personal';
    return await apiRequest(url, ApiType.get);
  }

  void _refreshPuzzles(List<dynamic> puzzleData, PuzzleType puzzleType) async {
    final updatedPuzzleList = List<Map<String, dynamic>>.from(_puzzleList);
    final indexes = List.generate(_puzzleList.length, (index) => index);
    final int baseColorIndex = 85;

    if (puzzleType != PuzzleType.personal) {
      indexes.shuffle();
    }

    int getTargetIndex(int i) {
      if (puzzleType == PuzzleType.personal) {
        return puzzleData[i]['puzzle_index'] ?? -1;
      }
      return puzzleData[i]['color'] == 'Base'
          ? baseColorIndex
          : (i < indexes.length ? indexes[i] : -1);
    }

    bool isExisted = false;

    for (int i = 0; i < puzzleData.length; i++) {
      final targetIndex = getTargetIndex(i);
      final updatedItem = updatedPuzzleList[targetIndex];

      updatedPuzzleList[targetIndex] = {
        ...updatedItem,
        'id': puzzleData[i]['id'],
        'title': puzzleData[i]['title'],
        'content': puzzleData[i]['content'],
        'color': ColorUtils.colorMatch(stringColor: puzzleData[i]['color']),
        'author_id': puzzleData[i]['author_id'],
        'receiver_id': puzzleData[i]['receiver_id'],
        'sender_id': puzzleData[i]['sender_id'],
        'created_at': puzzleData[i]['created_at'],
        'parent_post_type': puzzleData[i]['parent_post_type'],
        'parent_post_color': puzzleData[i]['parent_post_color'],
        'read': puzzleData[i]['read'],
      };
      if (puzzleType == PuzzleType.subject) {
        if (!isExisted && puzzleData[i]['author_id'] == userId) {
          isExisted = true;
        }
      }
    }

    _puzzleList = updatedPuzzleList;
    notifyListeners();
    if (puzzleType == PuzzleType.subject) {
      final shouldSave = isExisted ? _hasSubject != 'Y' : _hasSubject != '';
      if (shouldSave) {
        _saveHasSubject(isExisted);
      }
    }
  }

  void updateShuffle(bool value) {
    if (_isShuffle != value) {
      _isShuffle = value;
      notifyListeners();
    }
  }

  void _updateLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  void _saveHasSubject(bool isExist) {
    _hasSubject = isExist ? 'Y' : '';
    SharedPreferencesUtils.save('hasSubject', _hasSubject);
    notifyListeners();
  }
}
