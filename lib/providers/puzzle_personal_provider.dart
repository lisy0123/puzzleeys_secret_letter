import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';

class PuzzlePersonalProvider with ChangeNotifier {
  Set<String> _readPuzzleIds = {};

  Set<String> get readPuzzleIds => _readPuzzleIds;

  Future<void> initialize() async {
    final savedPuzzleIds = await SharedPreferencesUtils.get('readPuzzleIds');
    if (savedPuzzleIds != null) {
      _readPuzzleIds = savedPuzzleIds.split(',').toSet();
    } else {
      _readPuzzleIds = {};
    }
    notifyListeners();
  }

  Future<void> markAsRead(String puzzleId) async {
    if (_readPuzzleIds.add(puzzleId)) {
      await SharedPreferencesUtils.save(
          'readPuzzleIds', _readPuzzleIds.join(','));
      notifyListeners();
    }
  }

  bool isPuzzleRead(String puzzleId) => _readPuzzleIds.contains(puzzleId);

  Future<void> cleanUp(List<Map<String, dynamic>> puzzles) async {
    final puzzleIds = puzzles
        .where((puzzle) => puzzle['id'] != null)
        .map((puzzle) => puzzle['id'] as String)
        .toSet();

    _readPuzzleIds.removeWhere((id) => !puzzleIds.contains(id));

    if (_readPuzzleIds.isNotEmpty) {
      await SharedPreferencesUtils.save(
        'readPuzzleIds',
        _readPuzzleIds.join(','),
      );
    } else {
      await SharedPreferencesUtils.save('readPuzzleIds', '');
    }
    notifyListeners();
  }
}
