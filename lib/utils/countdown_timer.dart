import 'dart:async';
import 'package:flutter/material.dart';
import 'package:puzzleeys_secret_letter/screens/puzzle/content/puzzle_screen_handler.dart';

class CountdownTimer extends StatefulWidget {
  final String createdAt;
  final bool grayText;
  final VoidCallback? onEnd;

  const CountdownTimer({
    super.key,
    required this.createdAt,
    this.grayText = false,
    this.onEnd,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late TimerUtil timerUtil;
  StreamSubscription<String>? _timerSubscription;
  String _remainingTime = '00:00:00';

  @override
  void initState() {
    super.initState();

    timerUtil = TimerUtil(widget.createdAt, onEnd: widget.onEnd);
    _timerSubscription = timerUtil.timeStream.listen((remainingTime) {
      if (_remainingTime != remainingTime) {
        setState(() {
          _remainingTime = remainingTime;
        });
      }
    });
  }

  @override
  void dispose() {
    _timerSubscription?.cancel();
    timerUtil.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PuzzleScreenHandler().buildSideText(
      iconName: 'btn_clock',
      text: _remainingTime,
      grayText: widget.grayText,
      context: context,
    );
  }
}

class TimerUtil {
  final DateTime targetTime;
  final VoidCallback? onEnd;
  late StreamController<String> _timeStreamController;
  late Stream<String> timeStream;
  Timer? _timer;

  TimerUtil(String createdAtStr, {this.onEnd})
      : targetTime = DateTime.parse(createdAtStr).add(Duration(hours: 33)) {
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
    final now = DateTime.now().toUtc().add(Duration(hours: 9));
    Duration remainingTime = targetTime.isAfter(now)
        ? targetTime.difference(now)
        : Duration.zero;

    _timeStreamController.add(_formatTime(remainingTime));

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      final now = DateTime.now().toUtc().add(Duration(hours: 9));
      remainingTime = targetTime.isAfter(now)
          ? targetTime.difference(now)
          : Duration.zero;

      if (remainingTime.inSeconds <= 0) {
        if (!_timeStreamController.isClosed) {
          _timeStreamController.add("00:00:00");
        }
        _timer?.cancel();
        _timeStreamController.close();
        onEnd?.call();
      } else {
        if (!_timeStreamController.isClosed) {
          _timeStreamController.add(_formatTime(remainingTime));
        }
      }
    });
  }

  void dispose() {
    _timer?.cancel();
    _timeStreamController.close();
  }
}
