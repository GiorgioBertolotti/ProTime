import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/get_it_setup.dart';
import 'package:pro_time/model/time.dart';
import 'package:pro_time/pages/home/widgets/bottom_activity_controller.dart';
import 'package:pro_time/pages/home/widgets/project_dialog.dart';
import 'package:pro_time/pages/home/widgets/project_tile.dart';
import 'package:pro_time/services/projects/projects_service.dart';
import 'package:pro_time/services/timer/timer_service.dart';

class HomePage extends StatefulWidget {
  static const routeName = "home_page";
  final Color backgroundColor = Colors.grey[900];
  final timerService = getIt<TimerService>();

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.backgroundColor,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
              bottom: (widget.timerService.timerState != TimerState.STOPPED)
                  ? 50.0
                  : 0),
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
    columnChildren.add(
      Expanded(
        child: StreamBuilder(
          stream: getIt<ProjectsService>().projects$,
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (!snapshot.hasData || snapshot.hasError) {
              return Text("loading...");
            }
            final projects = snapshot.data;
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
                  itemCount: projects.length + 2,
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
                    if (index == projects.length + 1) {
                      return SizedBox(
                          height: 74.0 +
                              ((widget.timerService.timerState !=
                                      TimerState.STOPPED)
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
                        child: ProjectTile(widget.backgroundColor, project),
                      ),
                    );
                  },
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: projects.length + 2,
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
                    if (index == projects.length + 1) {
                      return SizedBox(
                          height: 74.0 +
                              ((widget.timerService.timerState !=
                                      TimerState.STOPPED)
                                  ? 50
                                  : 0));
                    }
                    Project project = projects[index - 1];
                    return ProjectTile(widget.backgroundColor, project);
                  },
                );
              }
            }
          },
        ),
      ),
    );
    /*    for (Project project in projects) {
      if (project.hasIncompleteActivities()) {
        appState.setCurrentProject(project);
      }
    }
 */
    List<Widget> stackChildren = [
      Column(children: columnChildren),
      Align(
        alignment: Alignment.bottomCenter,
        child: (widget.timerService.timerState != TimerState.STOPPED)
            ? BottomActivityController()
            : Container(),
      )
    ];
    return Stack(children: stackChildren);
  }
}
