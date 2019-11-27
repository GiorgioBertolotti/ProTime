import 'dart:async';

import 'package:pro_time/database/db.dart';
import 'package:pro_time/model/time.dart';
import 'package:pro_time/repository/timer/timer_repo.dart';
import 'package:rxdart/rxdart.dart';

class TimerService {
  TimerState get timerState => timer?.state ?? TimerState.STOPPED;
  int get activeProjectId => timer?.projectId;

  ProTimeStopwatch stopWatch = ProTimeStopwatch();
  BehaviorSubject<Duration> _timerSubj = BehaviorSubject<Duration>.seeded(
    Duration(seconds: 0)
  );
  BehaviorSubject<TimerState> _timerStateSubj =
      BehaviorSubject<TimerState>.seeded(TimerState.STOPPED);

  TimerRepo storage;
  TimerInfo timer;

  TimerService(this.storage) {
    timer = storage.getTimer();
    if(timer.state == TimerState.STARTED) {
      stopWatch = ProTimeStopwatch(initialOffset: timer.totalDuration);
      stopWatch.start();
    } else if(timer.state == TimerState.PAUSED) {
      stopWatch = ProTimeStopwatch(initialOffset: timer.totalDuration);
    }
    _timerStateSubj.add(timer.state);

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (stopWatch != null && _timerSubj.value.inSeconds != stopWatch.elapsed.inSeconds) {
        _timerSubj.add(stopWatch?.elapsed);
        this.timer?.totalDuration = stopWatch?.elapsed;
      }
    });
  }

  startTimer(int projectId) {
    if(timerState == TimerState.PAUSED) {
      timer = storage.resumeTimer();
    } else {
      timer = storage.startTimer(projectId);
    }

    stopWatch.start();
    _timerStateSubj.add(timerState);
  }

  Activity stopTimer() {
    final timerResult = storage.stopTimer();
    final duration = stopWatch.elapsed;

    final activity = Activity(
      projectId: timerResult.projectId,
      duration: duration,
      startDateTime: timerResult.startDate,
      id: null,
    );

    stopWatch.stop();
    stopWatch.reset(newInitialOffset: Duration(seconds: 0));
    timer = TimerInfo(state: TimerState.STOPPED, totalDuration: Duration(seconds: 0));
    _timerStateSubj.add(timerState);
    return activity;
  }

  Duration pauseTimer() {
    timer = storage.pauseTimer();
    stopWatch.stop();
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
