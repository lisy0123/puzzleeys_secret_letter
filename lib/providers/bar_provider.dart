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
  int _diaNums = 0;
  DateTime? _lastCheckedDate;

  int get puzzleNums => _puzzleNums;
  int get diaNums => _diaNums;

  BarProvider() {
    _loadStoredData();
  }

  void _loadStoredData() async {
    _puzzleNums = await SharedPreferencesUtils.getInt('puzzleNums');
    _diaNums = await SharedPreferencesUtils.getInt('diaNums');

    final String? savedDate =
        await SharedPreferencesUtils.get('attendance_date');
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
          final int diaNum = data['dia'];
          final DateTime? lastCheckedDate =
              data['date'].isNotEmpty ? DateTime.tryParse(data['date']) : null;

          await _updateIfChanged(puzzleNum, diaNum, lastCheckedDate);
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
    int diaNum,
    DateTime? lastCheckedDate,
  ) async {
    if (puzzleNum != _puzzleNums) {
      _puzzleNums = puzzleNum;
      notifyListeners();
      await SharedPreferencesUtils.saveInt('puzzleNums', _puzzleNums);
    }

    if (diaNum != _diaNums) {
      _diaNums = diaNum;
      notifyListeners();
      await SharedPreferencesUtils.saveInt('diaNums', _diaNums);
    }

    if (lastCheckedDate != _lastCheckedDate) {
      _lastCheckedDate = lastCheckedDate;
      notifyListeners();

      final String dateString = _lastCheckedDate != null
          ? Utils.formatDateToString(_lastCheckedDate!)
          : '';
      await SharedPreferencesUtils.save('attendance_date', dateString);
    }
  }

  Future<void> _checkIn(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime nowOnlyDate = DateTime(now.year, now.month, now.day);

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

      final String dateString = Utils.formatDateToString(_lastCheckedDate!);
      await SharedPreferencesUtils.save('attendance_date', dateString);
      _request({'date': dateString});
    }
  }

  void adPuzzleNum() async {
    _puzzleNums++;
    notifyListeners();
    await SharedPreferencesUtils.saveInt('puzzleNums', _puzzleNums);
  }

  void updatePuzzleNum(int num) async {
    _puzzleNums += num;
    notifyListeners();
    await SharedPreferencesUtils.saveInt('puzzleNums', _puzzleNums);
    _request({'puzzle': '$_puzzleNums'});
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
