import 'dart:async';

import 'package:pro_time/database/db.dart';
import 'package:pro_time/model/time.dart';
import 'package:rxdart/rxdart.dart';

class TimerService {
  TimerState timerState = TimerState.STOPPED;
  int activeProjectId;

  Stopwatch stopWatch = Stopwatch();
  BehaviorSubject<Duration> _timerSubj = BehaviorSubject<Duration>.seeded(
    Duration(seconds: 0),
  );
  BehaviorSubject<TimerState> _timerStateSubj =
      BehaviorSubject<TimerState>.seeded(TimerState.STOPPED);

  TimerService() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (stopWatch != null && _timerSubj.value.inSeconds != stopWatch.elapsed.inSeconds) {
        _timerSubj.add(stopWatch?.elapsed);
      }
    });
  }

  DateTime startTime;
  startTimer(int projectId) {
    stopWatch.start();
    startTime = DateTime.now();
    activeProjectId = projectId;
    timerState = TimerState.STARTED;
    _timerStateSubj.add(timerState);
  }

  Activity stopTimer() {
    final duration = stopWatch.elapsed;

    final activity = Activity(
      projectId: activeProjectId,
      duration: duration,
      startDateTime: startTime,
    );
    activeProjectId = null;
    timerState = TimerState.STOPPED;
    stopWatch.stop();
    stopWatch.reset();
    _timerStateSubj.add(timerState);
    return activity;
  }

  pauseTimer() {
    stopWatch.stop();
    timerState = TimerState.PAUSED;
    _timerStateSubj.add(timerState);
    return stopWatch.elapsed;
  }

  Duration getActiveDuration() => stopWatch?.elapsed;

  Stream<Duration> getActiveDurationStream() {
    return _timerSubj.stream;
  }

  Stream<TimerState> getTimerStateStream() {
    return _timerStateSubj.stream;
  }
}
