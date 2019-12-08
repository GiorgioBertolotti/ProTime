import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/get_it_setup.dart';
import 'package:pro_time/model/time.dart';
import 'package:pro_time/pages/project/widgets/timer_controls.dart';
import 'package:pro_time/pages/project/widgets/timer_text.dart';
import 'package:pro_time/services/activities/activities_service.dart';
import 'package:pro_time/services/timer/timer_service.dart';
import 'package:pro_time/utils/notifications.dart';

class ProjectTimer extends StatefulWidget {
  final TimerService timerService = getIt<TimerService>();
  final activitiesService = getIt<ActivitiesService>();
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Project project;

  ProjectTimer({this.scaffoldKey, this.project});

  @override
  _ProjectTimerState createState() => _ProjectTimerState();
}

class _ProjectTimerState extends State<ProjectTimer> {
  int _secondsCounter = 0;
  bool _timerVisibility = true;
  StreamSubscription _timerSubscription;
  Timer _blinkTimer;

  @override
  void initState() {
    super.initState();
    if (widget.timerService.activeProjectId != null &&
        widget.timerService.activeProjectId == widget.project.id) {
      _secondsCounter = widget.timerService.getActiveDuration().inSeconds;
    }
    _timerSubscription = widget.timerService
        .getActiveDurationStream()
        .listen((Duration duration) {
      if (duration.inSeconds != _secondsCounter &&
          widget.timerService.activeProjectId == widget.project.id) {
        setState(() => _secondsCounter = duration.inSeconds);
      }
    });
  }

  @override
  void dispose() {
    if (_blinkTimer != null) _blinkTimer.cancel();
    _timerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Opacity(
          opacity: _timerVisibility ? 1 : 0,
          child: Center(
            child: _buildTimer(),
          ),
        ),
        SizedBox(height: 20.0),
        Center(
          child: TimerControls(
            startCallback: _startTimer,
            pauseCallback: _pauseTimer,
            stopCallback: _stopTimer,
            state: (widget.timerService.activeProjectId == widget.project.id || widget.timerService.timerState == TimerState.STOPPED)
                ? widget.timerService.timerState
                : TimerState.DISABLED,
            scaffoldKey: widget.scaffoldKey,
          ),
        )
      ],
    );
  }

  Widget _buildTimer() {
    int hours = _secondsCounter ~/ 60 ~/ 60;
    int minutes = (_secondsCounter ~/ 60 % 60).toInt();
    int seconds = (_secondsCounter % 60 % 60);
    double hoursSize = (hours != 0) ? 40.0 : 0.0;
    double minutesSize = (hours != 0) ? 20.0 : 40.0;
    double secondsSize = 20.0;
    return TimerText(
      hours: hours,
      hoursSize: hoursSize,
      minutes: minutes,
      minutesSize: minutesSize,
      seconds: seconds,
      secondsSize: secondsSize,
    );
  }

  _startTimer() {
    final isPaused = widget.timerService.timerState == TimerState.PAUSED &&
        widget.timerService.activeProjectId == widget.project.id;
    if (widget.timerService.timerState == TimerState.STOPPED || isPaused) {
      widget.timerService.startTimer(widget.project.id);
      _timerSubscription?.resume();
      _stopBlink();
      showNotification(widget.project);
    } else {
      widget.scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
              "You have to stop the current activity before starting another."),
        ),
      );
    }
  }

  _pauseTimer() {
    widget.timerService.pauseTimer();
    _timerSubscription?.pause();
    _startBlink();
    cancelNotifications();
  }

  _stopTimer() {
    final Activity activity = widget.timerService.stopTimer();
    widget.activitiesService.addActivity(activity);
    setState(() {
      _secondsCounter = 0;
    });
    _stopBlink();
    cancelNotifications();
  }

  _startBlink() {
    _blinkTimer = Timer.periodic(
      Duration(milliseconds: 500),
      (Timer timer) => setState(() {
        _timerVisibility = !_timerVisibility;
      }),
    );
  }

  _stopBlink() {
    if (_blinkTimer != null && _blinkTimer.isActive) _blinkTimer.cancel();
    setState(() {
      _timerVisibility = true;
    });
  }
}