import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:pro_time/main.dart';
import 'package:pro_time/model/project.dart';
import 'package:pro_time/pages/project/widgets/activity_tile.dart';
import 'package:pro_time/pages/project/widgets/hour_bar_chart.dart';
import 'package:pro_time/pages/project/widgets/project_timer.dart';
import 'package:pro_time/pages/project/widgets/time_stats_text.dart';
import 'package:pro_time/resources/application_state.dart';
import 'package:provider/provider.dart';

class ProjectPage extends StatefulWidget {
  static const routeName = "project_page";

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  String _projectId;
  Project _project;
  ScrollController _controller = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool first = true;

  _updateProject() {
    _project = Hive.box("projects").get(_projectId);
  }

  @override
  Widget build(BuildContext context) {
    if (first) {
      _projectId = ModalRoute.of(context).settings.arguments;
      first = false;
      _updateProject();
    }
    ApplicationState appState = Provider.of<ApplicationState>(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
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
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 24.0,
                                maxFontSize: 44.0,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ProTime.navigatorKey.currentState.pop();
                              },
                              icon: Icon(
                                Icons.close,
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
                      SizedBox(height: 50.0),
                      ProjectTimer(
                        _project,
                        _scaffoldKey,
                        startCallback: () => setState(() {}),
                        pauseCallback: () => setState(() {}),
                        stopCallback: () => setState(() {}),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 60.0,
                    left: 30.0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _project.notificationEnabled
                            ? Colors.white
                            : Colors.grey[700],
                        boxShadow: [
                          Theme.of(context).brightness == Brightness.dark
                              ? BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 2.0,
                                  offset: Offset(0.0, 4.0),
                                )
                              : BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 2.0,
                                  offset: Offset(0.0, 4.0),
                                ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100.0),
                          onTap: () async {
                            bool value = !_project.notificationEnabled;
                            _project.notificationEnabled = value;
                            await Hive.box("projects")
                                .put(_project.id, _project);
                            if (!value) {
                              _cancelNotifications();
                            } else {
                              if (appState.timerState == TimerState.STARTED) {
                                _showNotification(_project);
                              }
                            }
                            setState(() {});
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: _project.notificationEnabled
                                  ? Icon(
                                      Icons.notifications,
                                      size: 30.0,
                                      color: Colors.black,
                                    )
                                  : Icon(
                                      Icons.notifications_off,
                                      size: 30.0,
                                      color: Colors.black,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  (_project.activities != null &&
                          _project.activities.length > 0)
                      ? Positioned(
                          bottom: 30.0,
                          left: 0.0,
                          right: 0.0,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Details",
                                style: TextStyle(fontSize: 30.0),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 30.0,
                                ),
                                onPressed: () =>
                                    _scrollDown(_project.activities),
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
                Activity activity =
                    _project.activities.reversed.toList()[index];
                return ActivityTile(
                  activity,
                  _project,
                  editCallback: () {
                    _updateProject();
                    setState(() {});
                  },
                  deleteCallback: () {
                    _updateProject();
                    setState(() {});
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
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

  double roundDecimal(double dec, int decimals) {
    dec = (dec * 10).round() / 10;
    return dec;
  }

  Widget _buildDaysChart() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      margin: EdgeInsets.only(bottom: 30.0),
      height: 220.0,
      child: HourBarChart(_project),
    );
  }

  _scrollDown(List<Activity> activities) {
    double scrollTo;
    double chartHeight =
        (activities != null && activities.length > 0 && _isThereAnyHour())
            ? 230.0
            : 0.0;

    final double pageHeight = MediaQuery.of(context).padding.top +
        chartHeight +
        (_project.activities.length * 100);

    final double windowSizeMinusPaddingTop =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    if (pageHeight > windowSizeMinusPaddingTop) {
      scrollTo = windowSizeMinusPaddingTop;
    } else {
      scrollTo = pageHeight;
    }
    _controller.animateTo(scrollTo,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  }

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

  Widget _buildTotTime() {
    Duration totalTime = _project.getTotalTime();
    String hrs = totalTime.inHours.toString() + "H\n";
    String mins = (totalTime.inMinutes % 60).toString() + "m\n";
    String secs = (totalTime.inSeconds % 60).toString() + "s";
    return TimeStatsText(title: "TOT", hrs: hrs, mins: mins, secs: secs);
  }

  Widget _buildAvgTime() {
    Duration totalTime = _project.getTotalTime();
    final numActivties = _project.activities.length;
    final avgTimeInSeconds = numActivties > 0
        ? (totalTime.inSeconds ~/ _project.activities.length)
        : 0;
    final avgTime = Duration(seconds: avgTimeInSeconds);
    final hrs = avgTime.inHours.toString() + "H\n";
    final mins = (avgTime.inMinutes % 60).toString() + "m\n";
    final secs = (avgTime.inSeconds % 60).toString() + "s";
    return TimeStatsText(title: "AVG", hrs: hrs, mins: mins, secs: secs);
  }
}
