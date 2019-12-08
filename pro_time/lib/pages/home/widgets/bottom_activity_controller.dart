import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/get_it_setup.dart';
import 'package:pro_time/main.dart';
import 'package:pro_time/model/time.dart';
import 'package:pro_time/pages/project/project_page.dart';
import 'package:pro_time/services/activities/activities_service.dart';
import 'package:pro_time/services/projects/projects_service.dart';
import 'package:pro_time/services/timer/timer_service.dart';

class BottomActivityController extends StatelessWidget {
  final _timerService = getIt<TimerService>();
  final _projectService = getIt<ProjectsService>();
  final _activitiesService = getIt<ActivitiesService>();
  @override
  Widget build(BuildContext context) {
    int id = _timerService.activeProjectId;
    if (id != null) {
      return StreamBuilder<Project>(
        stream: _projectService.getProject(id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          Project project = snapshot.data;
          return Container(
            height: 40.0,
            width: double.infinity,
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: project.mainColor, // @TODO: use current project color
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2.0,
                  offset: Offset(0.0, 4.0),
                )
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15.0),
                onTap: () => Navigator.pushNamed(context, ProjectPage.routeName,
                    arguments: project.id),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 5.0),
                        child: Row(
                          children: <Widget>[
                            AutoSizeText(
                              project.name,
                              style: TextStyle(
                                color: project != null
                                    ? project.textColor
                                    : Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 16.0,
                              maxFontSize: 24.0,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            StreamBuilder<Duration>(
                              stream: _timerService.getActiveDurationStream(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                return _buildTimer(
                                    snapshot.data.inSeconds, project);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        StreamBuilder<TimerState>(
                          stream: _timerService.getTimerStateStream(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            }
                            TimerState timerState = snapshot.data;
                            if (timerState == TimerState.STARTED) {
                              return GestureDetector(
                                child: Container(
                                  color: Colors.transparent,
                                  width: 40.0,
                                  height: 40.0,
                                  child: Center(
                                    child: Image.asset(
                                      "assets/images/pause.png",
                                      color: project != null
                                          ? project.textColor
                                          : Colors.white,
                                      width: 16.0,
                                      height: 16.0,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  _timerService.pauseTimer();
                                  _cancelNotifications();
                                },
                              );
                            } else {
                              return GestureDetector(
                                child: Container(
                                  color: Colors.transparent,
                                  width: 40.0,
                                  height: 40.0,
                                  child: Center(
                                    child: Image.asset(
                                      "assets/images/play.png",
                                      color: project != null
                                          ? project.textColor
                                          : Colors.white,
                                      width: 16.0,
                                      height: 16.0,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  _timerService.startTimer(project.id);
                                  _showNotification(project);
                                },
                              );
                            }
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            color: Colors.transparent,
                            width: 40.0,
                            height: 40.0,
                            child: Center(
                              child: Image.asset(
                                "assets/images/stop.png",
                                color: project != null
                                    ? project.textColor
                                    : Colors.white,
                                width: 16.0,
                                height: 16.0,
                              ),
                            ),
                          ),
                          onTap: () {
                            final activity = _timerService.stopTimer();
                            _activitiesService.addActivity(activity);
                            _cancelNotifications();
                          },
                        ),
                        SizedBox(width: 10.0),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
    return Container();
  }

  Widget _buildTimer(int secondsCounter, Project project) {
    int hours = secondsCounter ~/ 60 ~/ 60;
    int minutes = (secondsCounter ~/ 60 % 60).toInt();
    int seconds = (secondsCounter % 60 % 60);

    String hoursStr = hours.toString().length == 1
        ? '0' + hours.toString()
        : hours.toString();
    String minutesStr = minutes.toString().length == 1
        ? '0' + minutes.toString()
        : minutes.toString();
    String secondsStr = seconds.toString().length == 1
        ? '0' + seconds.toString()
        : seconds.toString();
    return Text(
      hoursStr + ':' + minutesStr + ':' + secondsStr,
      style: TextStyle(fontSize: 18.0, color: project.textColor),
    );
  }

  _showNotification(Project project) async {
    if (!(project.notificationEnabled ?? true)) return;
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
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

    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Tracking active',
      'The tracking of ' + project.name + " is running!",
      platformChannelSpecifics,
      payload: project.id.toString(),
    );
  }

  _cancelNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
