import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/get_it_setup.dart';
import 'package:pro_time/main.dart';
import 'package:pro_time/model/project_with_activities.dart';
import 'package:pro_time/model/time.dart';
import 'package:pro_time/pages/project/widgets/activity_tile.dart';
import 'package:pro_time/pages/project/widgets/hour_bar_chart.dart';
import 'package:pro_time/pages/project/widgets/notification_toggle.dart';
import 'package:pro_time/pages/project/widgets/project_timer.dart';
import 'package:pro_time/pages/project/widgets/time_stats_text.dart';
import 'package:pro_time/pages/project/widgets/timer_controls.dart';
import 'package:pro_time/pages/project/widgets/timer_text.dart';
import 'package:pro_time/services/activities/activities_service.dart';
import 'package:pro_time/services/projects/projects_service.dart';
import 'package:pro_time/services/timer/timer_service.dart';
import 'package:pro_time/utils/notifications.dart';

class ProjectPage extends StatefulWidget {
  static const routeName = "project_page";
  final Color backgroundColor = Colors.grey[900];
  final timerService = getIt<TimerService>();
  final activitiesService = getIt<ActivitiesService>();
  final projectsService = getIt<ProjectsService>();

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with TickerProviderStateMixin {
  int projectId;
  Project _project;
  bool _first = true;
  ScrollController _controller = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  ProjectWithActivities _projectWithActivities;

  @override
  Widget build(BuildContext context) {
    projectId = ModalRoute.of(context).settings.arguments;

    if (_first) {
      _first = false;
    }

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: widget.backgroundColor,
        body: StreamBuilder(
            stream: widget.projectsService.watchProjectWithActivites(projectId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError || !snapshot.hasData) {
                return CircularProgressIndicator();
              }
              _projectWithActivities = snapshot.data;
              _project = _projectWithActivities.project;
              print(_project);
              final activities = _projectWithActivities.activities;
              return ListView(
                controller: _controller,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 20.0),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
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
                                      ProTime.navigatorKey.currentState.pop();
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
                              children: [
                                _buildTotTime(),
                                _buildAvgTime(),
                              ],
                            ),
                            SizedBox(height: 80.0),
                            ProjectTimer(
                              scaffoldKey: _scaffoldKey,
                              project: _project,
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 80.0,
                          left: 30.0,
                          child: NotificationToggle(
                            notificationEnabled: _project.notificationEnabled,
                            backgroundColor: widget.backgroundColor,
                            onTap: (bool value) {
                              widget.projectsService.replaceProject(_project
                                  .copyWith(notificationEnabled: !value));
                              if (!value) {
                                cancelNotifications();
                              } else if (widget.timerService.timerState ==
                                  TimerState.STARTED) {
                                showNotification(_project);
                              }
                            },
                          ),
                        ),
                        (activities.length > 0)
                            ? Positioned(
                                bottom: 20.0,
                                left: 0.0,
                                right: 0.0,
                                child: Column(
                                  children: [
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
                                        double chartHeight =
                                            (activities.length > 0)
                                                ? 230.0
                                                : 0.0;
                                        if ((MediaQuery.of(context)
                                                    .padding
                                                    .top +
                                                chartHeight +
                                                (activities.length * 100)) >
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                MediaQuery.of(context)
                                                    .padding
                                                    .top)) {
                                          scrollTo = (MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              MediaQuery.of(context)
                                                  .padding
                                                  .top);
                                        } else {
                                          scrollTo = MediaQuery.of(context)
                                                  .padding
                                                  .top +
                                              chartHeight +
                                              (activities.length * 100);
                                        }
                                        _controller.animateTo(scrollTo,
                                            duration: const Duration(
                                                milliseconds: 500),
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
                  (activities.length > 0) ? _buildDaysChart() : Container(),
                  (activities.length > 0)
                      ? Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            "swipe for actions",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xFF6D6D6D), height: 0.9),
                          ),
                        )
                      : Container(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: activities.length,
                    itemBuilder: (bctx, index) {
                      Activity activity = activities.reversed.toList()[index];
                      return ActivityTile(activity, widget.backgroundColor);
                    },
                  ),
                ],
              );
            }),
      ),
    );
  }



  Widget _buildDaysChart() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      margin: EdgeInsets.only(bottom: 30.0),
      height: 220.0,
      child: HourBarChart(
        _projectWithActivities,
        widget.backgroundColor,
      ),
    );
  }


  Widget _buildTotTime() {
    final totalTime = _projectWithActivities.totalHours;
    String hrs = totalTime.inHours.toString() + "H\n";
    String mins = (totalTime.inMinutes % 60).toString() + "m\n";
    String secs = (totalTime.inSeconds % 60).toString() + "s";
    return TimeStatsText(title: "TOT", hrs: hrs, mins: mins, secs: secs);
  }

  Widget _buildAvgTime() {
    final totalTime = _projectWithActivities.totalHours;
    final hrs = totalTime.inHours.toString() + "H\n";
    final mins = (totalTime.inMinutes % 60).toString() + "m\n";
    final secs = (totalTime.inSeconds % 60).toString() + "s";
    return TimeStatsText(title: "AVG", hrs: hrs, mins: mins, secs: secs);
  }
}
