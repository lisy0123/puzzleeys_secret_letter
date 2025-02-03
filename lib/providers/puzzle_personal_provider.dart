import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';

class PuzzlePersonalProvider with ChangeNotifier {
  Set<String> _readPuzzleIds = {};

  Set<String> get readPuzzleIds => _readPuzzleIds;

  Future<void> initialize(List<Map<String, dynamic>> puzzleList) async {
    final String? savedIds = await SharedPreferencesUtils.get('readPuzzleIds');
    if (savedIds != null) {
      _setIds(savedIds, puzzleList);
    } else {
      _readPuzzleIds = {};
    }
    notifyListeners();
  }

  void _setIds(String savedIds, List<Map<String, dynamic>> puzzleList) async {
    _readPuzzleIds = savedIds.split(',').toSet();

    final int beforeCount = _readPuzzleIds.length;
    final Set<String> validIds = puzzleList
        .map((p) => p['id']?.toString())
        .where((id) => id != null && id.isNotEmpty)
        .cast<String>()
        .toSet();

    _readPuzzleIds.removeWhere((id) => !validIds.contains(id));

    if (_readPuzzleIds.length != beforeCount) {
      await SharedPreferencesUtils.save(
        'readPuzzleIds',
        _readPuzzleIds.join(','),
      );
    }
  }

  Future<void> markAsRead(String puzzleId) async {
    if (_readPuzzleIds.add(puzzleId.toString())) {
      await SharedPreferencesUtils.save(
        'readPuzzleIds',
        _readPuzzleIds.join(','),
      );
      notifyListeners();
    }
  }

  bool isPuzzleRead(String puzzleId) => _readPuzzleIds.contains(puzzleId);
}
