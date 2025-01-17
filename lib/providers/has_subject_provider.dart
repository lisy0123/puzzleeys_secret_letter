import 'dart:async';
import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';

class HasSubjectProvider extends ChangeNotifier {
  String _hasSubject = '';
  Timer? _resetTimer;

  String get hasSubject => _hasSubject;

  HasSubjectProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _hasSubject = await SharedPreferencesUtils.get('hasSubject') ?? '';
    notifyListeners();
    _scheduleReset();
  }

  void save() {
    _hasSubject = 'Y';
    SharedPreferencesUtils.save('hasSubject', 'Y');
    notifyListeners();
    _scheduleReset();
  }

  // TODO: need to check
  void _scheduleReset() {
    _resetTimer?.cancel();

    final now = DateTime.now().toUtc().add(Duration(hours: 9));
    final targetTime = DateTime(now.year, now.month, now.day, 18, 0);

    final durationUntilTarget = targetTime.isBefore(now)
        ? targetTime.add(Duration(days: 1)).difference(now)
        : targetTime.difference(now);

    _resetTimer = Timer(durationUntilTarget, () {
      _resetSubject();
      _scheduleReset();
    });
  }

  void _resetSubject() {
    if (_hasSubject != '') {
      _hasSubject = '';
      SharedPreferencesUtils.save('hasSubject', '');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }
}
