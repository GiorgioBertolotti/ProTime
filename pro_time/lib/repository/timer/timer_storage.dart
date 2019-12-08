import 'dart:io';

import 'package:hive/hive.dart';
import 'package:pro_time/model/time.dart';
import 'package:pro_time/repository/timer/timer_repo.dart';

class TimerPersist extends TimerRepo {
  Box storage;

  TimerPersist(this.storage);

  @override
  TimerInfo stopTimer() {
    final timer = getTimer();
    timer.state = TimerState.STOPPED;
    storage.delete("timerDuration");
    storage.delete("timerStartDate");
    storage.delete("timerResumeDate");
    storage.delete("timerProjectId");
    storage.put("timerState", "STOPPED");
    return timer;
  }

  @override
  TimerInfo getTimer() {
    final String stringState = storage.get("timerState", defaultValue: "STOPPED");
    final state = timerStateFromString(stringState);
    if (state == TimerState.STOPPED) {
      return TimerInfo(state: state);
    }

    final int duration = storage.get("timerDuration");
    final DateTime startDate = storage.get("timerStartDate");
    final DateTime resumeDate = storage.get("timerResumeDate");
    final int projectId = storage.get("timerProjectId");

    stderr.writeln("im in get timer");
    if (resumeDate != null) {
      final durationSinceResumed = DateTime.now().difference(resumeDate);
      final newTotalDuration = durationSinceResumed + Duration(seconds: duration);
      return TimerInfo(
        startDate: startDate,
        totalDuration: newTotalDuration,
        projectId: projectId,
        resumeDate: resumeDate,
        state: state,
      );
    }

    final newTotalDuration = DateTime.now().difference(startDate);
    return TimerInfo(
      startDate: startDate,
      totalDuration: Duration(seconds: newTotalDuration.inSeconds),
      projectId: projectId,
      resumeDate: null,
      state: state,
    );
  }

  @override
  TimerInfo pauseTimer() {
    storage.put("timerState", "PAUSED");
    final int duration = storage.get("timerDuration");
    final DateTime startDate = storage.get("timerStartDate");
    final DateTime resumeDate = storage.get("timerResumeDate");
    final int projectId = storage.get("timerProjectId");
    if (resumeDate != null) {
      final durationSinceResumed = DateTime.now().difference(resumeDate);
      final newTotalDuration = durationSinceResumed + Duration(seconds: duration);
      storage.put("timerDuration", newTotalDuration.inSeconds);
      return TimerInfo(
        startDate: startDate,
        totalDuration: newTotalDuration,
        projectId: projectId,
        resumeDate: resumeDate,
        state: TimerState.PAUSED,
      );
    }

    final newTotalDuration = DateTime.now().difference(startDate);
    storage.put("timerDuration", newTotalDuration.inSeconds);
    return TimerInfo(
      startDate: startDate,
      totalDuration: newTotalDuration,
      projectId: projectId,
      resumeDate: null,
      state: TimerState.PAUSED,
    );
  }

  @override
  TimerInfo resumeTimer() {
    storage.put("timerState", "STARTED");
    final resumeDate = DateTime.now();
    storage.put("timerResumeDate", resumeDate);

    final int duration = storage.get("timerDuration");
    final DateTime startDate = storage.get("timerStartDate");
    final int projectId = storage.get("timerProjectId");

    return TimerInfo(
      startDate: startDate,
      totalDuration: Duration(seconds: duration),
      projectId: projectId,
      resumeDate: resumeDate,
      state: TimerState.STARTED,
    );
  }

  @override
  TimerInfo startTimer(int projectId) {
    final startDate = DateTime.now();
    storage.put("timerProjectId", projectId);
    storage.put("timerStartDate", startDate);
    storage.put("timerState", "STARTED");

    return TimerInfo(
      startDate: startDate,
      totalDuration: Duration(seconds: 0),
      projectId: projectId,
      resumeDate: null,
      state: TimerState.STARTED,
    );
  }
}
