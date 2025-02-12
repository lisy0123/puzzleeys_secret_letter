import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CountPuzzleProvider with ChangeNotifier {
  int _puzzleNums = 0;
  int get puzzleNums => _puzzleNums;

  void initialize() async {
    final savedNums = await SharedPreferencesUtils.get('puzzleNums');
    _puzzleNums = int.tryParse(savedNums ?? '') ?? 0;
    notifyListeners();

    while (true) {
      final currentSession = Supabase.instance.client.auth.currentSession;
      if (currentSession == null) await Utils.waitForSession();
      try {
        final responseData = await apiRequest('/api/bar/puzzle', ApiType.get);
        if (responseData['code'] == 200) {
          final data = responseData['result'] as Map<String, dynamic>;
          final int puzzleNum = data['puzzle'];

          if (puzzleNum != _puzzleNums) {
            _puzzleNums = puzzleNum;
            notifyListeners();

            await SharedPreferencesUtils.save(
              'puzzleNums',
              _puzzleNums.toString(),
            );
          }
        }
        break;
      } catch (error) {
        if (error.toString().contains('Invalid or expired JWT')) {
          await Utils.waitForSession();
        } else {
          throw Exception('Error initializing puzzleNums: $error');
        }
      }
    }
  }

  void updatePuzzleNum(int num) async {
    _puzzleNums += num;
    notifyListeners();

    await SharedPreferencesUtils.save('puzzleNums', _puzzleNums.toString());

    final Map<String, String> bodies = {'puzzle': _puzzleNums.toString()};
    final Map<String, String> headers = {'Content-Type': 'application/json'};

    await apiRequest(
      '/api/bar/puzzle',
      ApiType.post,
      headers: headers,
      bodies: bodies,
    );
  }
}
