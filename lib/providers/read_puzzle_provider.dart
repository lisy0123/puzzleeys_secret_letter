import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';

class ReadPuzzleProvider with ChangeNotifier {
  Set<String> _readPuzzleIds = {};
  Set<String> get readPuzzleIds => _readPuzzleIds;

  Future<void> initialize(List<Map<String, dynamic>> puzzleList) async {
    final Set<String> validIds = puzzleList
        .where((p) => p['read'] == true)
        .map((p) => p['id'] as String)
        .toSet();

    final String? savedIds = await SharedPreferencesUtils.get('readPuzzleIds');
    _readPuzzleIds = savedIds != null ? savedIds.split(',').toSet() : {};

    final bool hasChanges = !_readPuzzleIds.containsAll(validIds) ||
        _readPuzzleIds.any((id) => !validIds.contains(id));

    if (hasChanges) {
      _readPuzzleIds = validIds;
      notifyListeners();

      await SharedPreferencesUtils.save(
        'readPuzzleIds',
        _readPuzzleIds.join(','),
      );
    }
  }

  Future<void> markAsRead(String puzzleId) async {
    final puzzleIdStr = puzzleId.toString();

    if (_readPuzzleIds.add(puzzleIdStr)) {
      notifyListeners();
      await SharedPreferencesUtils.save(
        'readPuzzleIds',
        _readPuzzleIds.join(','),
      );
      await apiRequest('/api/post/personal_read/$puzzleId', ApiType.post);
    }
  }

  bool isPuzzleRead(String puzzleId) => _readPuzzleIds.contains(puzzleId);
}
