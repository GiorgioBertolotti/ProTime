import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:pro_time/main.dart';
import 'package:pro_time/model/project.dart';
import 'package:pro_time/pages/project/widgets/timer_text.dart';
import 'package:pro_time/resources/application_state.dart';
import 'package:pro_time/resources/controls.dart';
import 'package:provider/provider.dart';

class ProjectTimer extends StatefulWidget {
  ProjectTimer(
    this.project,
    this.scaffoldKey, {
    this.startCallback,
    this.pauseCallback,
    this.stopCallback,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final Project project;
  final Function startCallback;
  final Function pauseCallback;
  final Function stopCallback;

  @override
  _ProjectTimerState createState() => _ProjectTimerState();
}

class _ProjectTimerState extends State<ProjectTimer>
    with TickerProviderStateMixin {
  bool _first = true;
  bool _timerVisibility = true;
  Timer _blinkTimer;
  Duration _halfSec = const Duration(milliseconds: 0500);
  Project _project;

  @override
  void initState() {
    _project = widget.project;
    super.initState();
  }

  @override
  void dispose() {
    if (_blinkTimer != null) _blinkTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ApplicationState appState = Provider.of<ApplicationState>(context);
    if (_first) {
      _first = false;
      if ((appState.getCurrentProject() == null ||
              appState.getCurrentProject().id == _project.id) &&
          appState.timerState == TimerState.PAUSED)
        _startBlink();
      else
        _stopBlink();
    }
    return Column(
      children: [
        Center(
          child: Opacity(
            opacity: _timerVisibility ? 1 : 0,
            child: _buildTimer(),
          ),
        ),
        SizedBox(height: 20.0),
        Center(
          child: TimerControls(
            startCallback: _startTimer,
            pauseCallback: _pauseTimer,
            stopCallback: _stopTimer,
            initialState: ((appState.getCurrentProject() != null &&
                        appState.getCurrentProject().id != _project.id) &&
                    (appState.timerState == TimerState.PAUSED ||
                        appState.timerState == TimerState.STARTED))
                ? TimerState.DISABLED
                : appState.timerState,
            enabled: appState.getCurrentProject() == null ||
                appState.getCurrentProject().id == _project.id,
            scaffoldKey: widget.scaffoldKey,
          ),
        ),
      ],
    );
  }

  Widget _buildTimer() {
    ApplicationState appState = Provider.of<ApplicationState>(context);
    int secondsCounter;
    if (appState.getCurrentProject() == null ||
        appState.getCurrentProject().id == _project.id)
      secondsCounter = appState.getSecondsCounter() ?? 0;
    else
      secondsCounter = 0;
    if (secondsCounter == null) return Container();
    int hours = secondsCounter ~/ 60 ~/ 60;
    int minutes = (secondsCounter ~/ 60 % 60).toInt();
    int seconds = (secondsCounter % 60 % 60);
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

  _updateProject() {
    _project = Hive.box("projects").get(_project.id);
  }

  _startTimer() {
    ApplicationState appState = Provider.of<ApplicationState>(context);
    setState(() {
      if (appState.getCurrentProject() == null ||
          appState.getCurrentProject() != _project)
        appState.setCurrentProject(_project);
      appState.startTimer();
      _stopBlink();
      _updateProject();
    });
    _showNotification(_project);
    if (widget.startCallback != null) widget.startCallback();
  }

  _pauseTimer() {
    ApplicationState appState = Provider.of<ApplicationState>(context);
    setState(() {
      appState.pauseTimer();
      _startBlink();
      _updateProject();
    });
    _cancelNotifications();
    if (widget.pauseCallback != null) widget.pauseCallback();
  }

  _stopTimer() {
    ApplicationState appState = Provider.of<ApplicationState>(context);
    setState(() {
      appState.stopTimer();
      _stopBlink();
      _updateProject();
    });
    _cancelNotifications();
    if (widget.stopCallback != null) widget.stopCallback();
  }

  _startBlink() {
    if (_blinkTimer != null && _blinkTimer.isActive) _blinkTimer.cancel();
    _blinkTimer = Timer.periodic(
      _halfSec,
      (Timer timer) => setState(() {
        _timerVisibility = !_timerVisibility;
      }),
    );
  }

  _stopBlink() {
    if (_blinkTimer != null && _blinkTimer.isActive) _blinkTimer.cancel();
    _blinkTimer = Timer.periodic(
      _halfSec * 2,
      (Timer timer) => setState(() {}),
    );
    setState(() {
      _timerVisibility = true;
    });
  }

  _showNotification(Project project) async {
    if (!(project.notificationEnabled ?? true)) return;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'protime',
      'ProTime',
      'This channel is used by ProTime to send timer reminders.',
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: true,
      autoCancel: false,
      ticker: 'ticker',
      enableLights: true,
      color: project.mainColor,
      ledColor: project.mainColor,
      ledOnMs: 1000,
      ledOffMs: 500,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Tracking active',
      'The tracking of ' + project.name + " is running!",
      platformChannelSpecifics,
      payload: project.id,
    );
  }

  _cancelNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
