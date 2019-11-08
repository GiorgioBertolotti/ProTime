import 'dart:async';

import 'package:pro_time/database/db.dart';
import 'package:pro_time/model/time.dart';
import 'package:rxdart/rxdart.dart';

class TimerService {
  TimerState timerState = TimerState.STOPPED;
  int activeProjectId;

  Stopwatch stopWatch = Stopwatch();
  BehaviorSubject<Duration> _timerSubj =
      BehaviorSubject<Duration>.seeded(Duration(seconds: 0));

  TimerService() {
    Timer.periodic(Duration(milliseconds: 500), (timer) => _timerSubj.add(stopWatch?.elapsed));
  }

  DateTime startTime;
  startTimer(int projectId) {
    stopWatch.start();
    startTime = DateTime.now();
    activeProjectId = projectId;
    timerState = TimerState.STARTED;
  }

  Activity stopTimer() {
    final duration = stopWatch.elapsed;

    final activity = Activity(
      projectId: activeProjectId,
      duration: duration,
      startDateTime: startTime,
    );
    activeProjectId = null;
    timerState = TimerState.STARTED;
    stopWatch.reset();
    return activity;
  }

  pauseTimer() {
    stopWatch.stop();
    return stopWatch.elapsed;
  }

  Duration getActiveDuration() => stopWatch?.elapsed;

  Stream<Duration> getActiveDurationObservable() {
    return _timerSubj.stream;
  }
}
