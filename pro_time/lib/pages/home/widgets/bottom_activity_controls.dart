import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pro_time/main.dart';
import 'package:pro_time/pages/project/project_page.dart';
import 'package:pro_time/resources/application_state.dart';
import 'package:provider/provider.dart';

class BottomActivityControls extends StatelessWidget {
  BottomActivityControls(
      this.startCallback, this.pauseCallback, this.stopCallback);

  final Function startCallback;
  final Function pauseCallback;
  final Function stopCallback;

  @override
  Widget build(BuildContext context) {
    ApplicationState appState = Provider.of<ApplicationState>(context);
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
            ProTime.navigatorKey.currentState.pushNamed(ProjectPage.routeName,
                arguments: appState.getCurrentProject().id);
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
                          onTap: pauseCallback,
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
                          onTap: startCallback,
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
                    onTap: stopCallback,
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
}
