import 'dart:async';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:pro_time/model/project.dart';
import 'package:pro_time/resources/controls.dart';

class ProjectPage extends StatefulWidget {
  ProjectPage(this.project);

  final Project project;

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with TickerProviderStateMixin {
  Timer _timer;
  Timer _blinkTimer;
  DateTime _started;
  int _secondsCounter = 0;
  Duration _oneSec = const Duration(seconds: 1);
  Duration _halfSec = const Duration(milliseconds: 500);
  bool _timerVisibility = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    if (_blinkTimer != null) _blinkTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.project.name,
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildTotTime(),
                    _buildAvgTime(),
                  ],
                ),
                SizedBox(height: 80.0),
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
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20.0,
              left: 0.0,
              right: 0.0,
              child: Column(
                children: <Widget>[
                  Text(
                    "Details",
                    style: TextStyle(color: Colors.white, fontSize: 30.0),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () {
                      // TODO: Open project details page
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _startTimer() {
    if (_secondsCounter == 0) _started = DateTime.now();
    _timer = Timer.periodic(
      _oneSec,
      (Timer timer) => setState(() {
        _secondsCounter++;
      }),
    );
    _startBlink();
  }

  _pauseTimer() {
    _timer.cancel();
    _stopBlink();
  }

  _stopTimer() {
    _timer.cancel();
    Activity activity = Activity(
      dateTimeStart: _started,
      activityDuration: Duration(seconds: _secondsCounter),
    );
    widget.project.activities.add(activity);
    Hive.box('projects').put(widget.project.id, widget.project);
    setState(() {
      _secondsCounter = 0;
    });
    _stopBlink();
  }

  _startBlink() {
    _blinkTimer = Timer.periodic(
      _halfSec,
      (Timer timer) => setState(() {
        _timerVisibility = !_timerVisibility;
      }),
    );
  }

  _stopBlink() {
    _blinkTimer.cancel();
    setState(() {
      _timerVisibility = true;
    });
  }

  Widget _buildTimer() {
    if (_secondsCounter == null) return Container();
    int hours = _secondsCounter ~/ 60 ~/ 60;
    int minutes = (_secondsCounter ~/ 60 % 60).toInt();
    int seconds = (_secondsCounter % 60 % 60);
    double hoursSize = (hours != 0) ? 40.0 : 0.0;
    double minutesSize = (hours != 0) ? 20.0 : 40.0;
    double secondsSize = 20.0;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(color: Colors.white),
        children: [
          hours != 0
              ? TextSpan(
                  text: hours.toString() + "H\n",
                  style: TextStyle(
                    fontSize: hoursSize,
                    height: 0.9,
                  ),
                )
              : TextSpan(),
          TextSpan(
            text: minutes.toString() + "m" + (hours != 0 ? "" : "\n"),
            style: TextStyle(
              fontSize: minutesSize,
              height: 0.9,
            ),
          ),
          hours == 0
              ? TextSpan(
                  text: (seconds < 10
                          ? ("0" + seconds.toString())
                          : seconds.toString()) +
                      "s",
                  style: TextStyle(
                    fontSize: secondsSize,
                    height: 0.9,
                  ),
                )
              : TextSpan(),
        ],
      ),
    );
  }

  Widget _buildTotTime() {
    Duration totalTime = widget.project.getTotalTime();
    String hrs = totalTime.inHours.toString() + "H\n";
    String mins = (totalTime.inMinutes % 60).toString() + "m\n";
    String secs = (totalTime.inSeconds % 60).toString() + "s";
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(color: Colors.white),
        children: [
          TextSpan(
            text: "TOT\n",
            style: TextStyle(
              fontSize: 26.0,
              height: 0.9,
              fontWeight: FontWeight.w900,
            ),
          ),
          TextSpan(
            text: hrs,
            style: TextStyle(
              fontSize: 40.0,
              height: 1.2,
            ),
          ),
          TextSpan(
            text: mins,
            style: TextStyle(
              fontSize: 20.0,
              height: 0.9,
            ),
          ),
          TextSpan(
            text: secs,
            style: TextStyle(
              fontSize: 16.0,
              height: 0.9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvgTime() {
    Duration totalTime = widget.project.getAverageTime();
    String hrs = totalTime.inHours.toString() + "H\n";
    String mins = (totalTime.inMinutes % 60).toString() + "m\n";
    String secs = (totalTime.inSeconds % 60).toString() + "s";
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(color: Colors.white),
        children: [
          TextSpan(
            text: "AVG\n",
            style: TextStyle(
              fontSize: 26.0,
              height: 0.9,
              fontWeight: FontWeight.w900,
            ),
          ),
          TextSpan(
            text: hrs,
            style: TextStyle(
              fontSize: 40.0,
              height: 1.2,
            ),
          ),
          TextSpan(
            text: mins,
            style: TextStyle(
              fontSize: 20.0,
              height: 0.9,
            ),
          ),
          TextSpan(
            text: secs,
            style: TextStyle(
              fontSize: 16.0,
              height: 0.9,
            ),
          ),
        ],
      ),
    );
  }
}
