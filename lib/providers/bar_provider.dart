import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/utils/request/api_request.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_overlay.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BarProvider with ChangeNotifier {
  int _puzzleNums = 0;
  DateTime? _lastCheckedDate;

  int get puzzleNums => _puzzleNums;

  BarProvider() {
    _loadStoredData();
  }

  void _loadStoredData() async {
    final savedNums = await SharedPreferencesUtils.get('puzzleNums');
    final savedDate = await SharedPreferencesUtils.get('attendance_date');

    _puzzleNums = int.tryParse(savedNums ?? '') ?? 0;
    _lastCheckedDate = savedDate != null ? DateTime.tryParse(savedDate) : null;
    notifyListeners();
  }

  Future<void> initialize(BuildContext context) async {
    while (true) {
      final currentSession = Supabase.instance.client.auth.currentSession;
      if (currentSession == null) await Utils.waitForSession();
      try {
        final responseData = await apiRequest('/api/bar/user', ApiType.get);
        if (responseData['code'] == 200) {
          final data = responseData['result'] as Map<String, dynamic>;
          final int puzzleNum = data['puzzle'];
          final DateTime? lastCheckedDate =
              data['date'].isNotEmpty ? DateTime.tryParse(data['date']) : null;

          await _updateIfChanged(puzzleNum, lastCheckedDate);
          if (context.mounted) await _checkIn(context);
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

  Future<void> _updateIfChanged(
    int puzzleNum,
    DateTime? lastCheckedDate,
  ) async {
    if (puzzleNum != _puzzleNums) {
      _puzzleNums = puzzleNum;
      notifyListeners();

      await SharedPreferencesUtils.save(
        'puzzleNums',
        _puzzleNums.toString(),
      );
    }
    if (lastCheckedDate != _lastCheckedDate) {
      _lastCheckedDate = lastCheckedDate;
      notifyListeners();

      final String dateString = _lastCheckedDate?.toIso8601String() ?? '';
      await SharedPreferencesUtils.save('attendance_date', dateString);
    }
  }

  Future<void> _checkIn(BuildContext context) async {
    final now = DateTime.now();
    final nowOnlyDate = DateTime(now.year, now.month, now.day);

    if (_lastCheckedDate == null ||
        _lastCheckedDate!.compareTo(nowOnlyDate) != 0) {
      _lastCheckedDate = nowOnlyDate;
      notifyListeners();

      if (context.mounted) {
        CustomOverlay.show(
          text: MessageStrings.overlayMessages[OverlayType.attendance]![1],
          puzzleVis: true,
          puzzleNum: MessageStrings.overlayMessages[OverlayType.attendance]![0],
          context: context,
        );
      }

      final String dateString = _lastCheckedDate!.toIso8601String();

      await SharedPreferencesUtils.save('attendance_date', dateString);
      _request({'date': dateString});
    }
  }

  void updatePuzzleNum(int num) async {
    _puzzleNums += num;
    notifyListeners();

    final String numString = _puzzleNums.toString();

    await SharedPreferencesUtils.save('puzzleNums', numString);
    _request({'puzzle': numString});
  }

  void _request(Map<String, String> bodies) async {
    final Map<String, String> headers = {'Content-Type': 'application/json'};

    await apiRequest(
      '/api/bar/user',
      ApiType.post,
      headers: headers,
      bodies: bodies,
    );
  }

  Future<void> resetAttendance() async {
    await SharedPreferencesUtils.delete('attendance_date');
    _lastCheckedDate = null;

    notifyListeners();
  }
}
