import 'dart:async';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:pro_time/main.dart';
import 'package:pro_time/model/project.dart';
import 'package:pro_time/resources/application_state.dart';
import 'package:pro_time/resources/controls.dart';
import 'package:provider/provider.dart';

class ProjectPage extends StatefulWidget {
  ProjectPage(this.projectId);

  final String projectId;
  final Color backgroundColor = Colors.grey[900];

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with TickerProviderStateMixin {
  Project _project;
  Timer _blinkTimer;
  Duration _halfSec = const Duration(milliseconds: 0500);
  bool _timerVisibility = true;
  bool _first = true;
  ScrollController _controller = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  StreamController<BarTouchResponse> barTouchedResultStreamController;
  int touchedIndex;

  @override
  void initState() {
    _updateProject();
    barTouchedResultStreamController = StreamController();
    barTouchedResultStreamController.stream
        .distinct()
        .listen((BarTouchResponse response) {
      if (response == null) {
        return;
      }
      if (response.spot == null) {
        setState(() {
          touchedIndex = -1;
        });
        return;
      }
      setState(() {
        if (response.touchInput is FlLongPressEnd) {
          touchedIndex = -1;
        } else {
          touchedIndex = response.spot.touchedBarGroupPosition;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_blinkTimer != null) _blinkTimer.cancel();
    barTouchedResultStreamController.close();
    super.dispose();
  }

  _updateProject() {
    _project = Hive.box("projects").get(widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    ApplicationState appState = Provider.of<ApplicationState>(context);
    if (_first) {
      _first = false;
      if ((appState.getCurrentProject() == null ||
              appState.getCurrentProject().id == _project.id) &&
          appState.timerState == TimerState.STARTED) _startBlink();
    }
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: widget.backgroundColor,
        body: ListView(
          controller: _controller,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              child: Stack(
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
                            Expanded(
                              child: AutoSizeText(
                                _project.name,
                                style: TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 24.0,
                                maxFontSize: 44.0,
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
                          initialState: appState.timerState,
                          enabled: appState.getCurrentProject() == null ||
                              appState.getCurrentProject().id == _project.id,
                          scaffoldKey: _scaffoldKey,
                        ),
                      ),
                    ],
                  ),
                  (_project.activities != null &&
                          _project.activities.length > 0)
                      ? Positioned(
                          bottom: 20.0,
                          left: 0.0,
                          right: 0.0,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Details",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30.0),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  double scrollTo;
                                  if ((MediaQuery.of(context).padding.top +
                                          230.0 +
                                          (_project.activities.length * 100)) >
                                      (MediaQuery.of(context).size.height -
                                          MediaQuery.of(context).padding.top)) {
                                    scrollTo =
                                        (MediaQuery.of(context).size.height -
                                            MediaQuery.of(context).padding.top);
                                  } else {
                                    scrollTo =
                                        MediaQuery.of(context).padding.top +
                                            230.0 +
                                            (_project.activities.length * 100);
                                  }
                                  _controller.animateTo(scrollTo,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeOut);
                                },
                              )
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            (_project.activities != null &&
                    _project.activities.length > 0 &&
                    _isThereAnyHour())
                ? _buildDaysChart()
                : Container(),
            (_project.activities != null && _project.activities.length > 0)
                ? Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      "swipe for actions",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF6D6D6D), height: 0.9),
                    ),
                  )
                : Container(),
            ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: _project.activities.length,
              itemBuilder: (bctx, index) {
                Activity activity = _project.activities[index];
                return _buildActivityTile(activity);
              },
            ),
          ],
        ),
      ),
    );
  }

  _showNotification(Project project) async {
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
    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Tracking active',
      'The tracking of ' + project.name + " is running!",
      DateTime.now().add(Duration(seconds: 5)),
      platformChannelSpecifics,
      payload: project.id,
    );
  }

  _cancelNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  _startTimer() {
    ApplicationState appState = Provider.of<ApplicationState>(context);
    setState(() {
      if (appState.getCurrentProject() == null ||
          appState.getCurrentProject() != _project)
        appState.setCurrentProject(_project);
      appState.startTimer();
      _startBlink();
      _updateProject();
    });
    _showNotification(_project);
  }

  _pauseTimer() {
    ApplicationState appState = Provider.of<ApplicationState>(context);
    setState(() {
      appState.pauseTimer();
      _stopBlink();
      _updateProject();
    });
  }

  _stopTimer() {
    ApplicationState appState = Provider.of<ApplicationState>(context);
    setState(() {
      appState.stopTimer();
      _stopBlink();
      _updateProject();
    });
    _cancelNotifications();
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
    if (_blinkTimer != null && _blinkTimer.isActive) _blinkTimer.cancel();
    setState(() {
      _timerVisibility = true;
    });
  }

  _editActivity(Activity toEdit) {
    Picker picker = Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(
          initValue: toEdit.getDuration().inHours,
          begin: 0,
          end: 999,
          suffix: Text(
            "h",
            style: TextStyle(color: Colors.blue, fontSize: 22.0),
          ),
        ),
        NumberPickerColumn(
          initValue: toEdit.getDuration().inMinutes % 60,
          begin: 0,
          end: 60,
          suffix: Text(
            "m",
            style: TextStyle(color: Colors.blue, fontSize: 22.0),
          ),
        ),
        NumberPickerColumn(
          initValue: toEdit.getDuration().inSeconds % 60,
          begin: 0,
          end: 60,
          suffix: Text(
            "s",
            style: TextStyle(color: Colors.blue, fontSize: 22.0),
          ),
        ),
      ]),
      title: Text("Duration"),
      textAlign: TextAlign.left,
      textStyle: const TextStyle(color: Colors.blue, fontSize: 22.0),
      selectedTextStyle: const TextStyle(color: Colors.blue, fontSize: 22.0),
      columnPadding: const EdgeInsets.all(8.0),
      onConfirm: (Picker picker, List value) {
        print(value);
        setState(() {
          toEdit.setDuration(
              Duration(hours: value[0], minutes: value[1], seconds: value[2]));
          Hive.box("projects").put(_project.id, _project);
        });
      },
    );
    picker.showModal(context);
  }

  _deleteActivity(Activity toDelete) {
    setState(() {
      _project.activities.remove(toDelete);
      Hive.box("projects").put(_project.id, _project);
    });
  }

  double roundDecimal(double dec, int decimals) {
    dec = (dec * 10).round() / 10;
    return dec;
  }

  Widget _buildDaysChart() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      margin: EdgeInsets.only(bottom: 30.0),
      height: 200.0,
      child: FlChart(
        chart: BarChart(
          mainBarData(),
        ),
      ),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: TouchTooltipData(
            tooltipBgColor: _project.mainColor,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                String weekDay;
                switch (touchedSpot.spot.x.toInt()) {
                  case 0:
                    weekDay = 'Monday';
                    break;
                  case 1:
                    weekDay = 'Tuesday';
                    break;
                  case 2:
                    weekDay = 'Wednesday';
                    break;
                  case 3:
                    weekDay = 'Thursday';
                    break;
                  case 4:
                    weekDay = 'Friday';
                    break;
                  case 5:
                    weekDay = 'Saturday';
                    break;
                  case 6:
                    weekDay = 'Sunday';
                    break;
                }
                return TooltipItem(
                  weekDay +
                      '\n' +
                      roundDecimal(touchedSpot.spot.y - 1, 1).toString() +
                      "H",
                  TextStyle(color: _project.textColor),
                );
              }).toList();
            }),
        touchResponseSink: barTouchedResultStreamController.sink,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
            showTitles: true,
            textStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            margin: 16,
            getTitles: (double value) {
              switch (value.toInt()) {
                case 0:
                  return 'M';
                case 1:
                  return 'T';
                case 2:
                  return 'W';
                case 3:
                  return 'T';
                case 4:
                  return 'F';
                case 5:
                  return 'S';
                case 6:
                  return 'S';
                default:
                  return '';
              }
            }),
        leftTitles: const SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        var value = _getHoursForDay(i);
        switch (i) {
          case 0:
            return makeGroupData(0, value, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, value, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, value, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, value, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, value, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, value, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, value, isTouched: i == touchedIndex);
          default:
            return null;
        }
      });

  bool _isThereAnyHour() {
    return List.generate(7, (i) {
          return _getHoursForDay(i);
        }).reduce(max) !=
        0.0;
  }

  double _getHoursForDay(int dayIndex) {
    int toReturn = 0;
    for (Activity activity in _project.activities) {
      if (activity.getFirstStarted().weekday - 1 == dayIndex) {
        toReturn += activity.getDuration().inMinutes;
      }
    }
    return roundDecimal(toReturn / 60, 1);
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
  }) {
    var maxVal = List.generate(7, (i) {
      return _getHoursForDay(i);
    }).reduce(max);
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        y: isTouched ? y + 1 : y,
        color: isTouched ? _project.mainColor : barColor,
        width: width,
        isRound: true,
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          y: maxVal,
          color: widget.backgroundColor,
        ),
      ),
    ]);
  }

  Widget _buildActivityTile(Activity activity) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2.0,
              offset: Offset(0.0, 4.0),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: DateFormat('yyyy-MM-dd')
                                .format(activity.getFirstStarted()) +
                            "\n",
                        style: TextStyle(fontSize: 16.0, height: 0.9),
                      ),
                      TextSpan(
                        text: DateFormat('HH:mm')
                            .format(activity.getFirstStarted()),
                        style: TextStyle(fontSize: 28.0, height: 0.9),
                      ),
                    ],
                  ),
                ),
              ),
              _buildActivityDurationText(activity),
            ],
          ),
        ),
      ),
      actions: _buildActivityActions(activity),
      secondaryActions: _buildActivityActions(activity, secondary: true),
    );
  }

  Widget _buildActivityDurationText(Activity activity) {
    if (activity.getIncompleteSubActivity() != null) {
      return Text(
        "running\nnow",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[600]),
      );
    }
    Duration totalTime = activity.getDuration();
    int secondsCounter = totalTime.inSeconds;
    int hours = secondsCounter ~/ 60 ~/ 60;
    int minutes = (secondsCounter ~/ 60 % 60).toInt();
    int seconds = (secondsCounter % 60 % 60);
    double hoursSize = (hours != 0) ? 30.0 : 0.0;
    double minutesSize = (hours != 0) ? 16.0 : 30.0;
    double secondsSize = 16.0;
    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(color: Colors.black),
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

  List<Widget> _buildActivityActions(Activity activity,
      {bool secondary = false}) {
    List<Widget> toReturn;
    if (activity.getIncompleteSubActivity() != null) {
      toReturn = <Widget>[];
    } else {
      toReturn = <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: widget.backgroundColor,
          foregroundColor: Colors.blue,
          icon: Icons.edit,
          onTap: () => _editActivity(activity),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: widget.backgroundColor,
          foregroundColor: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteActivity(activity),
        ),
      ];
    }
    if (secondary)
      return toReturn.reversed.toList();
    else
      return toReturn;
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
    Duration totalTime = _project.getTotalTime();
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
    Duration totalTime = _project.getAverageTime();
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
