import 'package:pro_time/database/db.dart';
import 'package:pro_time/model/time.dart';

class TimerService {
  TimerState timerState = TimerState.STOPPED;
  int activeProjectId;

  Stopwatch stopWatch = Stopwatch();

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
}
