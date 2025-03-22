import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/utils/get_puzzle_type.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/color_utils.dart';
import 'package:puzzleeys_secret_letter/utils/request/user_request.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PuzzleProvider extends ChangeNotifier {
  final int _rows = 9;
  final int _cols = 18;
  late String _userId;
  final Set<int> _loadedScreens = {};

  List<Map<String, dynamic>> _puzzleList = [];
  PuzzleType? _currentPuzzleType;
  bool _isLoading = false;
  bool _isShuffle = false;
  bool _hasSubject = false;
  String _subjectTitle = '';

  List<Map<String, dynamic>> get puzzleList => _puzzleList;
  bool get isLoading => _isLoading;
  bool get isShuffle => _isShuffle;
  bool get hasSubject => _hasSubject;
  String get subjectTitle => _subjectTitle;

  PuzzleProvider() {
    _initialize();
  }

  void _initialize() async {
    _puzzleList = List<Map<String, dynamic>>.generate(
      _rows * _cols,
      (index) => _emptyPuzzle(index),
    );
    _hasSubject = await SharedPreferencesUtils.getBool('hasSubject') ?? false;
    _subjectTitle = await SharedPreferencesUtils.get('subjectTitle') ?? '';
    notifyListeners();
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
        if (puzzleType != PuzzleType.reply && puzzleType != PuzzleType.me) {
          _currentPuzzleType = puzzleType;
        }

        late List<Map<String, dynamic>> puzzleListCache = [];
        if (!_isShuffle) {
          final int screenIndex = GetPuzzleType.typeToIndex(puzzleType);
          if (!_loadedScreens.add(screenIndex)) {
            puzzleListCache = await _loadPuzzleList(_currentPuzzleType!);
          }
        }

        if (puzzleListCache.isNotEmpty) {
          _puzzleList = puzzleListCache;
          notifyListeners();

          updateShuffle(false);
          _updateLoading(false);
          break;
        } else {
          final puzzleResponse = await _fetchResponse(_currentPuzzleType!);
          if (puzzleResponse['code'] == 200) {
            final puzzleList = puzzleResponse['result'] as List<dynamic>;
            await _refreshPuzzles(puzzleList, _currentPuzzleType!);
            await _savePuzzleList(_currentPuzzleType!);
            updateShuffle(false);
          } else {
            updateShuffle(true);
          }
          _updateLoading(false);
          break;
        }
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

  Future<List<Map<String, dynamic>>> _loadPuzzleList(
      PuzzleType puzzleType) async {
    final box = await _openPuzzleBox(puzzleType);
    final storedList = box.get('puzzles', defaultValue: []);
    return List<Map<String, dynamic>>.from(storedList);
  }

  Future<Box> _openPuzzleBox(PuzzleType puzzleType) async {
    switch (puzzleType) {
      case PuzzleType.global:
        return await Hive.openBox('globalPuzzleBox');
      case PuzzleType.subject:
        return await Hive.openBox('subjectPuzzleBox');
      default:
        return await Hive.openBox('personalPuzzleBox');
    }
  }

  Future<void> _savePuzzleList(PuzzleType puzzleType) async {
    final box = await _openPuzzleBox(puzzleType);
    await box.put('puzzles', _puzzleList);
  }

  Future<Map<String, dynamic>> _fetchResponse(PuzzleType puzzleType) async {
    late String url;
    switch (puzzleType) {
      case PuzzleType.global:
        url = '/api/post/global';
        break;
      case PuzzleType.subject:
        url = '/api/post/subject';
        break;
      default:
        url = '/api/post/personal';
        break;
    }
    return await apiRequest(url, ApiType.get);
  }

  Future<void> _refreshPuzzles(
    List<dynamic> puzzleData,
    PuzzleType puzzleType,
  ) async {
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
    _userId = await UserRequest.getUserId();

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
        if (!isExisted && puzzleData[i]['author_id'] == _userId) {
          isExisted = true;
        }
      }
    }

    _puzzleList = updatedPuzzleList;
    notifyListeners();

    if (puzzleType == PuzzleType.subject) {
      _handleSubjectPuzzle(puzzleType, isExisted);
    }
  }

  void _handleSubjectPuzzle(PuzzleType puzzleType, bool isExisted) {
    if (_hasSubject != isExisted) {
      _hasSubject = isExisted;
      notifyListeners();
      SharedPreferencesUtils.saveBool('hasSubject', _hasSubject);
    }

    String matchingTitle = _puzzleList.firstWhere(
          (data) => data['color'] == Colors.white.withValues(alpha: 0.8),
          orElse: () => {},
        )['title'] ??
        '';
    if (_subjectTitle != matchingTitle) {
      _subjectTitle = matchingTitle;
      notifyListeners();
      SharedPreferencesUtils.save('subjectTitle', _subjectTitle);
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
}
