import 'package:flutter/material.dart';
import 'package:pro_time/ui/project.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Dialog add project
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
            ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                _buildProjectTile("PWSWatcher",
                    backgroundColor: Colors.redAccent, textColor: Colors.black),
                _buildProjectTile("PWSWatcher",
                    backgroundColor: Colors.lightBlue, textColor: Colors.black),
                _buildProjectTile("PWSWatcher",
                    backgroundColor: Colors.lightGreen,
                    textColor: Colors.black),
                _buildProjectTile("PWSWatcher",
                    backgroundColor: Colors.blue, textColor: Colors.white),
                _buildProjectTile("PWSWatcher",
                    backgroundColor: Colors.yellow, textColor: Colors.black),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectTile(String projectName,
      {Color backgroundColor = Colors.white, Color textColor = Colors.black}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: backgroundColor,
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
                builder: (context) => ProjectPage(projectName),
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
                  projectName,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: textColor),
                    children: [
                      TextSpan(
                          text: "3H\n",
                          style: TextStyle(fontSize: 30.0, height: 0.9)),
                      TextSpan(
                          text: "21m",
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
