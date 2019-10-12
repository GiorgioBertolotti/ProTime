import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:pro_time/main.dart';
import 'package:pro_time/model/project.dart';
import 'package:pro_time/resources/application_state.dart';
import 'package:pro_time/resources/controls.dart';
import 'package:provider/provider.dart';

class ProjectPage extends StatefulWidget {
  ProjectPage(this.project);

  final Project project;
  final Color backgroundColor = Colors.grey[900];

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with TickerProviderStateMixin {
  Timer _blinkTimer;
  Duration _halfSec = const Duration(milliseconds: 0500);
  bool _timerVisibility = true;
  bool _first = true;
  ScrollController _controller = new ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_blinkTimer != null) _blinkTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ApplicationState appState = Provider.of<ApplicationState>(context);
    if (_first) {
      _first = false;
      if ((appState.getCurrentProject() == null ||
              appState.getCurrentProject().id == widget.project.id) &&
          appState.timerState == TimerState.STARTED) _startBlink();
    }
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: widget.backgroundColor,
        body: ListView(
          controller: _controller,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: AutoSizeText(
                                widget.project.name,
                                style: TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 24.0,
                                maxFontSize: 44.0,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _buildTotTime(),
                          _buildAvgTime(),
                        ],
                      ),
                      SizedBox(height: 80.0),
                      Center(
                        child: Opacity(
                          opacity: _timerVisibility ? 1 : 0,
                          child: _buildTimer(),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Center(
                        child: TimerControls(
                          startCallback: _startTimer,
                          pauseCallback: _pauseTimer,
                          stopCallback: _stopTimer,
                          initialState: appState.timerState,
                          enabled: appState.getCurrentProject() == null ||
                              appState.getCurrentProject().id ==
                                  widget.project.id,
                          scaffoldKey: _scaffoldKey,
                        ),
                      ),
                    ],
                  ),
                  (widget.project.activities != null &&
                          widget.project.activities.length > 0)
                      ? Positioned(
                          bottom: 20.0,
                          left: 0.0,
                          right: 0.0,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Details",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30.0),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  double scrollTo;
                                  if ((MediaQuery.of(context).padding.top +
                                          (widget.project.activities.length *
                                              100)) >
                                      (MediaQuery.of(context).size.height -
                                          MediaQuery.of(context).padding.top)) {
                                    scrollTo =
                                        (MediaQuery.of(context).size.height -
                                            MediaQuery.of(context).padding.top);
                                  } else {
                                    scrollTo =
                                        MediaQuery.of(context).padding.top +
                                            (widget.project.activities.length *
                                                100);
                                  }
                                  _controller.animateTo(scrollTo,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeOut);
                                },
                              )
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Text(
              "swipe for actions",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF6D6D6D), height: 0.9),
            ),
            SizedBox(height: 5.0),
            ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: widget.project.activities.length,
              itemBuilder: (bctx, index) {
                Activity activity = widget.project.activities[index];
                return _buildActivityTile(activity);
              },
            ),
          ],
        ),
      ),
    );
  }

  _startTimer() {
    ApplicationState appState = Provider.of<ApplicationState>(context);
    appState.startTimer(project: widget.project);
    _startBlink();
  }

  _pauseTimer() {
    ApplicationState appState = Provider.of<ApplicationState>(context);
    appState.pauseTimer();
    _stopBlink();
  }

  _stopTimer() {
    ApplicationState appState = Provider.of<ApplicationState>(context);
    setState(() {
      appState.stopTimer();
      _stopBlink();
    });
  }

  _startBlink() {
    _blinkTimer = Timer.periodic(
      _halfSec,
      (Timer timer) => setState(() {
        _timerVisibility = !_timerVisibility;
      }),
    );
  }

  _stopBlink() {
    if (_blinkTimer != null && _blinkTimer.isActive) _blinkTimer.cancel();
    setState(() {
      _timerVisibility = true;
    });
  }

  _editActivity(Activity toEdit) {
    Picker picker = Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(
          initValue: toEdit.getDuration().inHours,
          begin: 0,
          end: 999,
          suffix: Text(
            "h",
            style: TextStyle(color: Colors.blue, fontSize: 22.0),
          ),
        ),
        NumberPickerColumn(
          initValue: toEdit.getDuration().inMinutes % 60,
          begin: 0,
          end: 60,
          suffix: Text(
            "m",
            style: TextStyle(color: Colors.blue, fontSize: 22.0),
          ),
        ),
        NumberPickerColumn(
          initValue: toEdit.getDuration().inSeconds % 60,
          begin: 0,
          end: 60,
          suffix: Text(
            "s",
            style: TextStyle(color: Colors.blue, fontSize: 22.0),
          ),
        ),
      ]),
      title: Text("Duration"),
      textAlign: TextAlign.left,
      textStyle: const TextStyle(color: Colors.blue, fontSize: 22.0),
      selectedTextStyle: const TextStyle(color: Colors.blue, fontSize: 22.0),
      columnPadding: const EdgeInsets.all(8.0),
      onConfirm: (Picker picker, List value) {
        print(value);
        setState(() {
          toEdit.setDuration(
              Duration(hours: value[0], minutes: value[1], seconds: value[2]));
          Hive.box("projects").put(widget.project.id, widget.project);
        });
      },
    );
    picker.showModal(context);
  }

  _deleteActivity(Activity toDelete) {
    setState(() {
      widget.project.activities.remove(toDelete);
      Hive.box("projects").put(widget.project.id, widget.project);
    });
  }

  Widget _buildActivityTile(Activity activity) {
    Duration totalTime = activity.getDuration();
    int secondsCounter = totalTime.inSeconds;
    int hours = secondsCounter ~/ 60 ~/ 60;
    int minutes = (secondsCounter ~/ 60 % 60).toInt();
    int seconds = (secondsCounter % 60 % 60);
    double hoursSize = (hours != 0) ? 30.0 : 0.0;
    double minutesSize = (hours != 0) ? 16.0 : 30.0;
    double secondsSize = 16.0;
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2.0,
              offset: Offset(0.0, 4.0),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: DateFormat('yyyy-MM-dd')
                                .format(activity.getFirstStarted()) +
                            "\n",
                        style: TextStyle(fontSize: 16.0, height: 0.9),
                      ),
                      TextSpan(
                        text: DateFormat('HH:mm')
                            .format(activity.getFirstStarted()),
                        style: TextStyle(fontSize: 28.0, height: 0.9),
                      ),
                    ],
                  ),
                ),
              ),
              RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    hours != 0
                        ? TextSpan(
                            text: hours.toString() + "H\n",
                            style: TextStyle(
                              fontSize: hoursSize,
                              height: 0.9,
                            ),
                          )
                        : TextSpan(),
                    TextSpan(
                      text: minutes.toString() + "m" + (hours != 0 ? "" : "\n"),
                      style: TextStyle(
                        fontSize: minutesSize,
                        height: 0.9,
                      ),
                    ),
                    hours == 0
                        ? TextSpan(
                            text: (seconds < 10
                                    ? ("0" + seconds.toString())
                                    : seconds.toString()) +
                                "s",
                            style: TextStyle(
                              fontSize: secondsSize,
                              height: 0.9,
                            ),
                          )
                        : TextSpan(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: widget.backgroundColor,
          foregroundColor: Colors.blue,
          icon: Icons.edit,
          onTap: () => _editActivity(activity),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: widget.backgroundColor,
          foregroundColor: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteActivity(activity),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: widget.backgroundColor,
          foregroundColor: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteActivity(activity),
        ),
        IconSlideAction(
          caption: 'Edit',
          color: widget.backgroundColor,
          foregroundColor: Colors.blue,
          icon: Icons.edit,
          onTap: () => _editActivity(activity),
        ),
      ],
    );
  }

  Widget _buildTimer() {
    ApplicationState appState = Provider.of<ApplicationState>(context);
    int secondsCounter;
    if (appState.getCurrentProject() == null ||
        appState.getCurrentProject().id == widget.project.id)
      secondsCounter = appState.getSecondsCounter() ?? 0;
    else
      secondsCounter = 0;
    if (secondsCounter == null) return Container();
    int hours = secondsCounter ~/ 60 ~/ 60;
    int minutes = (secondsCounter ~/ 60 % 60).toInt();
    int seconds = (secondsCounter % 60 % 60);
    double hoursSize = (hours != 0) ? 40.0 : 0.0;
    double minutesSize = (hours != 0) ? 20.0 : 40.0;
    double secondsSize = 20.0;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(color: Colors.white),
        children: [
          hours != 0
              ? TextSpan(
                  text: hours.toString() + "H\n",
                  style: TextStyle(
                    fontSize: hoursSize,
                    height: 0.9,
                  ),
                )
              : TextSpan(),
          TextSpan(
            text: minutes.toString() + "m" + (hours != 0 ? "" : "\n"),
            style: TextStyle(
              fontSize: minutesSize,
              height: 0.9,
            ),
          ),
          hours == 0
              ? TextSpan(
                  text: (seconds < 10
                          ? ("0" + seconds.toString())
                          : seconds.toString()) +
                      "s",
                  style: TextStyle(
                    fontSize: secondsSize,
                    height: 0.9,
                  ),
                )
              : TextSpan(),
        ],
      ),
    );
  }

  Widget _buildTotTime() {
    Duration totalTime = widget.project.getTotalTime();
    String hrs = totalTime.inHours.toString() + "H\n";
    String mins = (totalTime.inMinutes % 60).toString() + "m\n";
    String secs = (totalTime.inSeconds % 60).toString() + "s";
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(color: Colors.white),
        children: [
          TextSpan(
            text: "TOT\n",
            style: TextStyle(
              fontSize: 26.0,
              height: 0.9,
              fontWeight: FontWeight.w900,
            ),
          ),
          TextSpan(
            text: hrs,
            style: TextStyle(
              fontSize: 40.0,
              height: 1.2,
            ),
          ),
          TextSpan(
            text: mins,
            style: TextStyle(
              fontSize: 20.0,
              height: 0.9,
            ),
          ),
          TextSpan(
            text: secs,
            style: TextStyle(
              fontSize: 16.0,
              height: 0.9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvgTime() {
    Duration totalTime = widget.project.getAverageTime();
    String hrs = totalTime.inHours.toString() + "H\n";
    String mins = (totalTime.inMinutes % 60).toString() + "m\n";
    String secs = (totalTime.inSeconds % 60).toString() + "s";
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(color: Colors.white),
        children: [
          TextSpan(
            text: "AVG\n",
            style: TextStyle(
              fontSize: 26.0,
              height: 0.9,
              fontWeight: FontWeight.w900,
            ),
          ),
          TextSpan(
            text: hrs,
            style: TextStyle(
              fontSize: 40.0,
              height: 1.2,
            ),
          ),
          TextSpan(
            text: mins,
            style: TextStyle(
              fontSize: 20.0,
              height: 0.9,
            ),
          ),
          TextSpan(
            text: secs,
            style: TextStyle(
              fontSize: 16.0,
              height: 0.9,
            ),
          ),
        ],
      ),
    );
  }
}
