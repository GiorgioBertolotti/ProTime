import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/get_it_setup.dart';
import 'package:pro_time/model/project_with_activities.dart';
import 'package:pro_time/model/time.dart';
import 'package:pro_time/pages/project/widgets/activity_tile.dart';
import 'package:pro_time/pages/project/widgets/edit_dialog.dart';
import 'package:pro_time/pages/project/widgets/hour_bar_chart.dart';
import 'package:pro_time/pages/project/widgets/notification_toggle.dart';
import 'package:pro_time/pages/project/widgets/project_timer.dart';
import 'package:pro_time/pages/project/widgets/time_stats_text.dart';
import 'package:pro_time/services/activities/activities_service.dart';
import 'package:pro_time/services/projects/projects_service.dart';
import 'package:pro_time/services/timer/timer_service.dart';
import 'package:pro_time/utils/notifications.dart';

class ProjectPage extends StatefulWidget {
  static const routeName = "project_page";
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
  ScrollController _controller = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  ProjectWithActivities _projectWithActivities;

  @override
  Widget build(BuildContext context) {
    projectId = ModalRoute.of(context).settings.arguments;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: StreamBuilder(
            stream: widget.projectsService.watchProjectWithActivites(projectId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError || !snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              _projectWithActivities = snapshot.data;
              _project = _projectWithActivities.project;
              final activities = _projectWithActivities.activities;
              return ListView(
                controller: _controller,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        20,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 20.0),
                            buildHeader(context),
                            SizedBox(height: 30.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildTotTime(),
                                _buildAvgTime(),
                              ],
                            ),
                            SizedBox(height: 50.0),
                            ProjectTimer(
                              scaffoldKey: _scaffoldKey,
                              project: _project,
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 90.0,
                          left: 30.0,
                          child: NotificationToggle(
                            backgroundColor: _project.mainColor,
                            notificationEnabled: _project.notificationEnabled,
                            onTap: (bool newValue) {
                              _project = _project.copyWith(
                                  notificationEnabled: newValue);
                              widget.projectsService.replaceProject(
                                _project,
                              );
                              if (!newValue) {
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
                                bottom: 60.0,
                                left: 0.0,
                                right: 0.0,
                                child: Column(
                                  children: [
                                    Text(
                                      "Details",
                                      style: TextStyle(
                                        fontSize: 30.0,
                                      ),
                                    ),
                                    Tooltip(
                                      message: "Show details",
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 30.0,
                                        ),
                                        onPressed: () =>
                                            _scrollDown(activities),
                                      ),
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
                              color: Color(0xFF6D6D6D),
                              height: 0.9,
                            ),
                          ),
                        )
                      : Container(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: activities.length,
                    itemBuilder: (BuildContext context, int index) {
                      Activity activity = activities.reversed.toList()[index];
                      return ActivityTile(
                        activity,
                        () => _editActivity(activity),
                        () => widget.activitiesService
                            .deleteActivity(activity.id),
                      );
                    },
                  ),
                ],
              );
            }),
      ),
    );
  }

  void _editActivity(Activity toEdit) async {
    Activity edited = await showDialog(
        context: context, builder: (ctx) => EditActivityDialog(toEdit));
    if (edited != null) {
      widget.activitiesService.replaceActivity(edited);
    }
  }

  Container buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              size: 30.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysChart() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      margin: EdgeInsets.only(bottom: 30.0),
      height: 220.0,
      child: HourBarChart(_projectWithActivities),
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
    final numActivties = _projectWithActivities.activities.length;
    final avgTimeInSeconds = numActivties > 0
        ? (totalTime.inSeconds ~/ _projectWithActivities.activities.length)
        : 0;
    final avgTime = Duration(seconds: avgTimeInSeconds);
    final hrs = avgTime.inHours.toString() + "H\n";
    final mins = (avgTime.inMinutes % 60).toString() + "m\n";
    final secs = (avgTime.inSeconds % 60).toString() + "s";
    return TimeStatsText(title: "AVG", hrs: hrs, mins: mins, secs: secs);
  }

  void _scrollDown(List<Activity> activities) {
    double scrollTo;
    double chartHeight =
        (activities != null && activities.length > 0) ? 240.0 : 0.0;

    final pageHeight = MediaQuery.of(context).padding.top +
        chartHeight +
        (activities.length * 100);

    final windowSizeMinusPaddingTop =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    if (pageHeight > windowSizeMinusPaddingTop) {
      scrollTo = windowSizeMinusPaddingTop;
    } else {
      scrollTo = pageHeight;
    }
    _controller.animateTo(scrollTo,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  }
}
