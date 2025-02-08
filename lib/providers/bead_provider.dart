import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/utils/color_utils.dart';
import 'package:puzzleeys_secret_letter/utils/get_puzzle_type.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/request/user_request.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';

class BeadProvider with ChangeNotifier {
  Set<String> _beadIds = {};
  Set<String> get beadIds => _beadIds;

  Future<void> initialize() async {
    final String? savedIds = await SharedPreferencesUtils.get('beadIds');
    _beadIds = savedIds != null ? savedIds.split(',').toSet() : {};
    notifyListeners();

    final responseData = await apiRequest('/api/bead/user', ApiType.get);
    final Set<String> validIds = (responseData['result'] as List<dynamic>)
        .map((p) => (p as Map<String, dynamic>)['id'] as String)
        .toSet();

    final bool hasChanges =
        !(_beadIds.containsAll(validIds) && validIds.containsAll(_beadIds));

    if (hasChanges) {
      _beadIds = validIds;
      notifyListeners();

      await SharedPreferencesUtils.save('beadIds', _beadIds.join(','));
    }
  }

  Future<void> putIntoBead(
    Map<String, dynamic> puzzleData,
    PuzzleType puzzleType,
  ) async {
    final String puzzleId = puzzleData['id'];

    if (_beadIds.add(puzzleId)) {
      notifyListeners();
      await SharedPreferencesUtils.save('beadIds', _beadIds.join(','));

      final String userId = await UserRequest.getUserId();
      final Map<String, String> bodies = {
        'id': puzzleId,
        'user_id': userId,
        'title': puzzleData['title'],
        'color': ColorUtils.colorToString(puzzleData['color']),
        'author_id': puzzleType == PuzzleType.personal
            ? puzzleData['sender_id']
            : puzzleData['author_id'],
        'post_type': GetPuzzleType.typeToString(puzzleType),
      };
      final Map<String, String> headers = {'Content-Type': 'application/json'};

      await apiRequest(
        '/api/bead/user',
        ApiType.post,
        headers: headers,
        bodies: bodies,
      );
    }
  }

  bool isExist(String puzzleId) => _beadIds.contains(puzzleId);
}
