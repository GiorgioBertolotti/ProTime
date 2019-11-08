import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/get_it_setup.dart';
import 'package:pro_time/main.dart';
import 'package:pro_time/model/time.dart';
import 'package:pro_time/services/timer/timer_service.dart';

class BottomActivityController extends StatelessWidget {
  final _timerService = getIt<TimerService>();
  @override
  Widget build(BuildContext context) {
    Project project; // @TODO set to active project
    return Container(
      height: 40.0,
      width: double.infinity,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.red, // @TODO: use current project color
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
          onTap: () => Navigator.pushNamed(context, "home",
              arguments: project.id),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 5.0),
                  child: AutoSizeText(
                    project.name,
                    style: TextStyle(
                      color: project.textColor,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 16.0,
                    maxFontSize: 24.0,
                  ),
                ),
              ),
              Row(
                children: [
                  (_timerService.timerState == TimerState.STARTED)
                      ? GestureDetector(
                          child: Container(
                            color: Colors.transparent,
                            width: 40.0,
                            height: 40.0,
                            child: Center(
                              child: Image.asset(
                                "assets/images/pause.png",
                                color: project.textColor,
                                width: 16.0,
                                height: 16.0,
                              ),
                            ),
                          ),
                          onTap: () {
                            //  @TODO: set state
                            _timerService.pauseTimer();
                            _cancelNotifications();
                          })
                      : GestureDetector(
                          child: Container(
                            color: Colors.transparent,
                            width: 40.0,
                            height: 40.0,
                            child: Center(
                              child: Image.asset(
                                "assets/images/play.png",
                                color: project.textColor,
                                width: 16.0,
                                height: 16.0,
                              ),
                            ),
                          ),
                          onTap: () {
                            _timerService.startTimer(project.id);
                            _showNotification(project);
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
                          color: project.textColor,
                          width: 16.0,
                          height: 16.0,
                        ),
                      ),
                    ),
                    onTap: () {
                      // @TODO: set state
                      _timerService.stopTimer();
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
