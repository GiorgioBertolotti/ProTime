import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pro_time/main.dart';
import 'package:pro_time/model/project.dart';
import 'package:pro_time/resources/application_state.dart';
import 'package:pro_time/resources/new_project_dialog.dart';
import 'package:pro_time/ui/project_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future _openBoxes() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    return Future.wait([
      Hive.openBox('projects'),
    ]);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ApplicationState appState = Provider.of<ApplicationState>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
              bottom: (appState.timerState != TimerState.STOPPED) ? 50.0 : 0),
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return NewProjectDialog();
                },
              );
            },
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              size: 38.0,
              color: Colors.black,
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "ProTime",
                        style: TextStyle(
                          fontSize: 60.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                FutureBuilder(
                  future: _openBoxes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.error != null) {
                        return Container();
                      } else {
                        return Expanded(
                          child: WatchBoxBuilder(
                            box: Hive.box('projects'),
                            builder: (ctx, box) {
                              var projects =
                                  box.values.toList().cast<Project>();
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
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 30.0),
                                    ),
                                  ),
                                );
                              else
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: box.length,
                                  itemBuilder: (bctx, index) {
                                    Project project = projects[index];
                                    return _buildProjectTile(project);
                                  },
                                );
                            },
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: (appState.timerState != TimerState.STOPPED)
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProjectPage(
                              appState.getCurrentProject(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        color: appState.getCurrentProject().mainColor,
                        height: 50.0,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              appState.getCurrentProject().name,
                              style: TextStyle(
                                color: appState.getCurrentProject().textColor,
                                fontSize: 22.0,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                (appState.timerState == TimerState.STARTED)
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.pause,
                                          color: appState
                                              .getCurrentProject()
                                              .textColor,
                                          size: 20.0,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            appState.pauseTimer();
                                          });
                                        },
                                      )
                                    : IconButton(
                                        icon: Icon(
                                          Icons.play_arrow,
                                          color: appState
                                              .getCurrentProject()
                                              .textColor,
                                          size: 20.0,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            appState.startTimer();
                                          });
                                        },
                                      ),
                                IconButton(
                                  icon: Icon(
                                    Icons.stop,
                                    color:
                                        appState.getCurrentProject().textColor,
                                    size: 20.0,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      appState.stopTimer();
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                        //child: ,
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  var _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  Widget _buildProjectTile(Project project) {
    Duration totalTime = project.getTotalTime();
    String hrs = totalTime.inHours.toString() + "H\n";
    String mins = (totalTime.inMinutes % 60).toString() + "m";
    return Container(
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
          onTapDown: _storePosition,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProjectPage(project),
              ),
            );
          },
          onLongPress: () async {
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject();
            var coiche = await showMenu(
              position: RelativeRect.fromRect(
                  _tapPosition & Size(40, 40), // smaller rect, the touch area
                  Offset.zero & overlay.size // Bigger rect, the entire screen
                  ),
              items: <PopupMenuEntry>[
                PopupMenuItem(
                  value: "delete",
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.delete,
                        color: Colors.deepOrange,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        "Delete",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                )
              ],
              context: context,
            );
            if (coiche == "delete") {
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
                          Navigator.of(ctx).pop();
                        },
                      ),
                      FlatButton(
                        textColor: Colors.deepOrange,
                        child: Text("Confirm"),
                        onPressed: () {
                          setState(() {
                            Hive.box('projects').delete(project.id);
                          });
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    project.name,
                    style: TextStyle(
                      color: project.textColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: project.textColor),
                    children: [
                      TextSpan(
                          text: hrs,
                          style: TextStyle(fontSize: 30.0, height: 0.9)),
                      TextSpan(
                          text: mins,
                          style: TextStyle(fontSize: 16.0, height: 0.9)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
