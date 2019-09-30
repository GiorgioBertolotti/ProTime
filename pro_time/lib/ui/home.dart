import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pro_time/model/project.dart';
import 'package:pro_time/resources/new_project_dialog.dart';
import 'package:pro_time/ui/project_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        floatingActionButton: FloatingActionButton(
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
        body: Column(
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
                          var projects = box.values.toList().cast<Project>();
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
      ),
    );
  }

  Widget _buildProjectTile(Project project) {
    Duration totalTime = project.getTotalTime();
    String hrs = totalTime.inHours.toString() + "H\n";
    String mins = totalTime.inMinutes.toString() + "m";
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
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProjectPage(project),
              ),
            );
          },
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  project.name,
                  style: TextStyle(
                    color: project.textColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
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
