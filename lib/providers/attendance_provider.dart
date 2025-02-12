import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzleeys_secret_letter/constants/enums.dart';
import 'package:puzzleeys_secret_letter/constants/strings.dart';
import 'package:puzzleeys_secret_letter/providers/count_puzzle_provider.dart';
import 'package:puzzleeys_secret_letter/utils/storage/shared_preferences_utils.dart';
import 'package:puzzleeys_secret_letter/utils/utils.dart';
import 'package:puzzleeys_secret_letter/widgets/custom_overlay.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceProvider extends ChangeNotifier {
  DateTime? _lastCheckedDate;

  AttendanceProvider() {
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    final savedDate = await SharedPreferencesUtils.get('attendance_date');
    _lastCheckedDate = savedDate != null ? DateTime.tryParse(savedDate) : null;
    notifyListeners();
  }

  Future<void> checkIn(BuildContext context) async {
    final now = DateTime.now();

    final currentSession = Supabase.instance.client.auth.currentSession;
    if (currentSession == null) await Utils.waitForSession();

    if (_lastCheckedDate == null ||
        _lastCheckedDate!.day != now.day ||
        _lastCheckedDate!.month != now.month ||
        _lastCheckedDate!.year != now.year) {
      _lastCheckedDate = now;
      notifyListeners();
      if (context.mounted) {
        CustomOverlay.show(
          text: MessageStrings.overlayMessages[OverlayType.attendance]![1],
          puzzleVis: true,
          puzzleNum: MessageStrings.overlayMessages[OverlayType.attendance]![0],
          context: context,
        );
      }
      await SharedPreferencesUtils.save(
        'attendance_date',
        now.toIso8601String(),
      );
    }
  }

  Future<void> resetAttendance() async {
    await SharedPreferencesUtils.delete('attendance_date');
    _lastCheckedDate = null;

    notifyListeners();
  }
}
