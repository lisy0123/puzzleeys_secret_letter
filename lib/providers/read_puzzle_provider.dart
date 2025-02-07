import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';

class ReadPuzzleProvider with ChangeNotifier {
  Set<String> _readIds = {};
  Set<String> get readIds => _readIds;

  Future<void> initialize(List<Map<String, dynamic>> puzzleList) async {
    final Set<String> validIds = puzzleList
        .where((p) => p['read'] == true)
        .map((p) => p['id'] as String)
        .toSet();

    final String? savedIds = await SharedPreferencesUtils.get('readIds');
    _readIds = savedIds != null ? savedIds.split(',').toSet() : {};
    notifyListeners();

    final bool hasChanges = !_readIds.containsAll(validIds) ||
        _readIds.any((id) => !validIds.contains(id));

    if (hasChanges) {
      _readIds = validIds;
      notifyListeners();

      await SharedPreferencesUtils.save('readIds', _readIds.join(','));
    }
  }

  Future<void> markAsRead(String puzzleId) async {
    if (_readIds.add(puzzleId)) {
      notifyListeners();
      await SharedPreferencesUtils.save('readIds', _readIds.join(','));
      await apiRequest('/api/post/personal_read/$puzzleId', ApiType.post);
    }
  }

  bool isPuzzleRead(String puzzleId) => _readIds.contains(puzzleId);
}
