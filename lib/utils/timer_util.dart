import 'dart:async';

class TimerUtil {
  final DateTime targetTime;
  late StreamController<String> _timeStreamController;
  late Stream<String> timeStream;
  Timer? _timer;

  TimerUtil(String createdAtStr)
      : targetTime =
            DateTime.parse(createdAtStr).toUtc().add(Duration(hours: 33)) {
    _timeStreamController = StreamController<String>();
    timeStream = _timeStreamController.stream;
    _startTimer();
  }

  String _formatTime(Duration duration) {
    final hours = (duration.inHours % 24).toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _startTimer() {
    final now = DateTime.now().add(Duration(hours: 9));
    Duration remainingTime =
        targetTime.isAfter(now) ? targetTime.difference(now) : Duration.zero;

    _timeStreamController.add(_formatTime(remainingTime));

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      final now = DateTime.now().add(Duration(hours: 9));
      remainingTime =
          targetTime.isAfter(now) ? targetTime.difference(now) : Duration.zero;

      if (remainingTime.inSeconds <= 0) {
        _timeStreamController.add("00:00:00");
        _timer?.cancel();
        _timeStreamController.close();
      } else {
        _timeStreamController.add(_formatTime(remainingTime));
      }
    });
  }

  void dispose() {
    _timer?.cancel();
    _timeStreamController.close();
  }
}
