import 'dart:async' show Timer;

class TaskScheduler {
  final int hour;
  final int minute;
  final Function executeTask;
  Timer? _timer;
  bool _isScheduled = false;

  TaskScheduler({
    required this.hour,
    required this.minute,
    required this.executeTask,
  });

  void scheduleDailyTask() {
    if (_isScheduled || (_timer?.isActive ?? false)) return;

    _isScheduled = true;
    final now = DateTime.now();
    final nextExecutionTime = _getNextExecutionTime(now);
    final delay = nextExecutionTime.difference(now);

    _timer = Timer(delay, () {
      executeTask();
      _timer = Timer.periodic(const Duration(days: 1), (_) => executeTask());
    });
  }

  DateTime _getNextExecutionTime(DateTime now) {
    final targetTime = DateTime(now.year, now.month, now.day, hour, minute);
    return targetTime.isBefore(now)
        ? targetTime.add(const Duration(days: 1))
        : targetTime;
  }

  void cancelTask() {
    _timer?.cancel();
    _timer = null;
    _isScheduled = false;
  }
}
