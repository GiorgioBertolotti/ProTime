import 'package:auto_animated/auto_animated.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pro_time/main.dart';
import 'package:pro_time/model/project.dart';
import 'package:pro_time/resources/application_state.dart';
import 'package:pro_time/resources/new_project_dialog.dart';
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
                  return NewProjectDialog();
                },
              );
              setState(() {});
            },
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              size: 44.0,
              color: Colors.black,
            ),
          ),
        ),
        body: _buildBody(appState),
      ),
    );
  }

  Widget _buildBody(ApplicationState appState) {
    List<Widget> stackChildren = [];
    List<Widget> columnChildren = [
      SizedBox(height: 20.0),
      Container(
        padding: EdgeInsets.only(left: 20.0),
        child: Row(
          children: <Widget>[
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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return NewProjectDialog();
                    },
                  );
                },
                child: Text(
                  "Add a project",
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
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
                      child: _buildProjectTile(project),
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
                  return _buildProjectTile(project);
                },
              );
            }
          }
        },
      ),
    ));
    stackChildren.add(Column(children: columnChildren));
    List<Project> projects =
        Hive.box('projects').values.toList().cast<Project>();
    for (Project project in projects)
      if (project.hasIncompleteActivities()) {
        appState.setCurrentProject(project);
      }
    stackChildren.add(Align(
      alignment: Alignment.bottomCenter,
      child: (appState.timerState != TimerState.STOPPED)
          ? _buildBottomControls(appState)
          : Container(),
    ));
    return Stack(children: stackChildren);
  }

  Widget _buildBottomControls(ApplicationState appState) {
    return Container(
      height: 40.0,
      width: double.infinity,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: appState.getCurrentProject().mainColor,
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
          onTap: () {
            ProTime.navigatorKey.currentState
                .pushNamed("/projects/" + appState.getCurrentProject().id);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 5.0),
                  child: AutoSizeText(
                    appState.getCurrentProject().name,
                    style: TextStyle(
                      color: appState.getCurrentProject().textColor,
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
                children: <Widget>[
                  (appState.timerState == TimerState.STARTED)
                      ? GestureDetector(
                          child: Container(
                            color: Colors.transparent,
                            width: 40.0,
                            height: 40.0,
                            child: Center(
                              child: Image.asset(
                                "assets/images/pause.png",
                                color: appState.getCurrentProject().textColor,
                                width: 16.0,
                                height: 16.0,
                              ),
                            ),
                          ),
                          onTap: () => setState(() {
                            appState.pauseTimer();
                            _cancelNotifications();
                          }),
                        )
                      : GestureDetector(
                          child: Container(
                            color: Colors.transparent,
                            width: 40.0,
                            height: 40.0,
                            child: Center(
                              child: Image.asset(
                                "assets/images/play.png",
                                color: appState.getCurrentProject().textColor,
                                width: 16.0,
                                height: 16.0,
                              ),
                            ),
                          ),
                          onTap: () => setState(() {
                            appState.startTimer();
                            _showNotification(appState.getCurrentProject());
                          }),
                        ),
                  GestureDetector(
                    child: Container(
                      color: Colors.transparent,
                      width: 40.0,
                      height: 40.0,
                      child: Center(
                        child: Image.asset(
                          "assets/images/stop.png",
                          color: appState.getCurrentProject().textColor,
                          width: 16.0,
                          height: 16.0,
                        ),
                      ),
                    ),
                    onTap: () => setState(() {
                      appState.stopTimer();
                      _cancelNotifications();
                    }),
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

  Widget _buildProjectTile(Project project) {
    Duration totalTime = project.getTotalTime();
    String hrs = totalTime.inHours.toString() + "H\n";
    String mins = (totalTime.inMinutes % 60).toString() + "m";
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: project.mainColor,
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
            onTap: () {
              ProTime.navigatorKey.currentState
                  .pushNamed("/projects/" + project.id);
            },
            borderRadius: BorderRadius.circular(30.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: AutoSizeText(
                      project.name,
                      style: TextStyle(
                        color: project.textColor,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 20.0,
                      maxFontSize: 34.0,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(color: project.textColor),
                        children: [
                          TextSpan(
                            text: hrs,
                            style: TextStyle(fontSize: 30.0, height: 0.9),
                          ),
                          TextSpan(
                            text: mins,
                            style: TextStyle(fontSize: 16.0, height: 0.9),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: widget.backgroundColor,
          foregroundColor: Colors.blue,
          icon: Icons.edit,
          onTap: () => _editProject(project),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: widget.backgroundColor,
          foregroundColor: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteProject(project),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: widget.backgroundColor,
          foregroundColor: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteProject(project),
        ),
        IconSlideAction(
          caption: 'Edit',
          color: widget.backgroundColor,
          foregroundColor: Colors.blue,
          icon: Icons.edit,
          onTap: () => _editProject(project),
        ),
      ],
    );
  }

  _deleteProject(Project project) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Delete " + project.name + "?"),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.lightBlue,
              child: Text("Cancel"),
              onPressed: () {
                ProTime.navigatorKey.currentState.pop();
              },
            ),
            FlatButton(
              textColor: Colors.deepOrange,
              child: Text("Confirm"),
              onPressed: () {
                setState(() {
                  Hive.box('projects').delete(project.id);
                });
                ProTime.navigatorKey.currentState.pop();
              },
            ),
          ],
        );
      },
    );
  }

  _editProject(Project project) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return NewProjectDialog(projectToEdit: project);
      },
    );
    setState(() {});
  }
}
