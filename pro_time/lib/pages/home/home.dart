import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pro_time/main.dart';
import 'package:pro_time/model/project.dart';
import 'package:pro_time/pages/home/widgets/bottom_activity_controls.dart';
import 'package:pro_time/pages/home/widgets/project_dialog.dart';
import 'package:pro_time/pages/home/widgets/project_tile.dart';
import 'package:pro_time/resources/application_state.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final Color backgroundColor = Colors.grey[900];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _first = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ApplicationState appState = Provider.of<ApplicationState>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.backgroundColor,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
              bottom: (appState.timerState != TimerState.STOPPED) ? 50.0 : 0),
          child: FloatingActionButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (ctx) {
                  return ProjectDialog();
                },
              );
            },
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              size: 44.0,
              color: Colors.black,
            ),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    ApplicationState appState = Provider.of<ApplicationState>(context);
    List<Widget> columnChildren = [
      SizedBox(height: 20.0),
      Container(
        padding: EdgeInsets.only(left: 20.0),
        child: Row(
          children: [
            Text(
              "ProTime",
              style: TextStyle(
                fontSize: 60.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 20.0),
    ];
    columnChildren.add(Expanded(
      child: WatchBoxBuilder(
        box: Hive.box('projects'),
        builder: (ctx, box) {
          List<Project> projects = box.values.toList().cast<Project>();
          if (projects.length == 0)
            return Center(
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return ProjectDialog();
                    },
                  );
                },
                child: Text(
                  "ADD A PROJECT",
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
            );
          else {
            if (_first) {
              _first = false;
              return AutoAnimatedList(
                showItemInterval: Duration(milliseconds: 300),
                showItemDuration: Duration(milliseconds: 400),
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: box.length + 2,
                itemBuilder: (bctx, index, animation) {
                  if (index == 0) {
                    return Text(
                      "swipe for actions",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF6D6D6D), height: 0.9),
                    );
                  }
                  if (index == box.length + 1) {
                    return SizedBox(
                        height: 74.0 +
                            ((appState.timerState != TimerState.STOPPED)
                                ? 50
                                : 0));
                  }
                  Project project = projects[index - 1];
                  return FadeTransition(
                    opacity: Tween<double>(
                      begin: 0,
                      end: 1,
                    ).animate(animation),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, -0.1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: ProjectTile(
                        project,
                        () => setState(() {
                          Hive.box('projects').delete(project.id);
                        }),
                      ),
                    ),
                  );
                },
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: box.length + 2,
                itemBuilder: (bctx, index) {
                  if (index == 0) {
                    return Text(
                      "swipe for actions",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF6D6D6D), height: 0.9),
                    );
                  }
                  if (index == box.length + 1) {
                    return SizedBox(
                        height: 74.0 +
                            ((appState.timerState != TimerState.STOPPED)
                                ? 50
                                : 0));
                  }
                  Project project = projects[index - 1];
                  return ProjectTile(
                    project,
                    () => setState(() {
                      Hive.box('projects').delete(project.id);
                    }),
                  );
                },
              );
            }
          }
        },
      ),
    ));
    List<Widget> stackChildren = [
      Column(children: columnChildren),
      Align(
        alignment: Alignment.bottomCenter,
        child: (appState.timerState != TimerState.STOPPED)
            ? BottomActivityControls(
                () => setState(() {
                  appState.startTimer();
                  _showNotification(appState.getCurrentProject());
                }),
                () => setState(() {
                  appState.pauseTimer();
                  _cancelNotifications();
                }),
                () => setState(() {
                  appState.stopTimer();
                  _cancelNotifications();
                }),
              )
            : Container(),
      ),
    ];
    List<Project> projects =
        Hive.box('projects').values.toList().cast<Project>();
    for (Project project in projects)
      if (project.hasIncompleteActivities()) {
        appState.setCurrentProject(project);
        break;
      }
    return Stack(children: stackChildren);
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
