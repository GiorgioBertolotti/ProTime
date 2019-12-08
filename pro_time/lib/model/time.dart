enum TimerState { STOPPED, STARTED, PAUSED, DISABLED }

TimerState timerStateFromString(String state) {
  switch (state.toUpperCase()) {
    case "STOPPED":
      return TimerState.STOPPED;
    case "STARTED":
      return TimerState.STARTED;
    case "PAUSED":
      return TimerState.PAUSED;
    default:
      return null;
  }
}

String timerStateToString(TimerState state) {
  switch (state) {
    case TimerState.STOPPED:
      return "STOPPED";
    case TimerState.STARTED:
      return "STARTED";
    case TimerState.PAUSED:
      return "PAUSED";
    default:
      return null;
  }
}

class TimerInfo {
  DateTime startDate;
  // DateTime when the user resumed the timer. This will be `null` if the
  // user has never paused -> resumed the stopwatch.
  DateTime resumeDate;
  TimerState state;
  Duration totalDuration;
  int projectId;

  TimerInfo(
      {this.startDate,
      this.resumeDate,
      this.state,
      this.totalDuration,
      this.projectId});
}

class ProTimeStopwatch {
  final Stopwatch _stopWatch = Stopwatch();
  Duration _initialOffset;

  ProTimeStopwatch({Duration initialOffset = Duration.zero})
      : _initialOffset = initialOffset;

  start() => _stopWatch.start();

  stop() => _stopWatch.stop();

  reset({Duration newInitialOffset}) {
    _stopWatch.reset();
    _initialOffset = newInitialOffset ?? _initialOffset;
  }

  Duration get elapsed => _stopWatch.elapsed + _initialOffset;
}
