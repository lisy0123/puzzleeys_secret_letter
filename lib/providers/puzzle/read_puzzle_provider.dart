import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:hive/hive.dart';

class ReadPuzzleProvider with ChangeNotifier {
  Set<String> _readIds = {};
  Set<String> get readIds => _readIds;

  late Box<bool> _box;

  void initialize(List<Map<String, dynamic>> puzzleList) async {
    _box = await Hive.openBox<bool>('readPuzzleBox');
    _readIds = _box.keys.cast<String>().toSet();
    notifyListeners();

    final Set<String> validIds = puzzleList
        .where((p) => p['read'] == true)
        .map((p) => p['id'] as String)
        .toSet();

    final bool hasChanges = !_readIds.containsAll(validIds) ||
        _readIds.any((id) => !validIds.contains(id));

    if (hasChanges) {
      _readIds = validIds;
      notifyListeners();

      if (_readIds.isNotEmpty) {
        await _box.clear();
        await _box.putAll({for (var id in _readIds) id: true});
      }
    }
  }

  void markAsRead(String puzzleId) async {
    if (_readIds.add(puzzleId)) {
      notifyListeners();
      await Future.wait([
        _box.put(puzzleId, true),
        apiRequest('/api/post/personal_read/$puzzleId', ApiType.post),
      ]);
    }
  }

  bool isExist(String puzzleId) => _readIds.contains(puzzleId);
}
