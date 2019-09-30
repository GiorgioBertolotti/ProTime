import 'package:flutter/material.dart';

class Project {
  Project({
    this.name,
    this.mainColor,
    this.textColor,
    this.created,
    this.activities,
  });

  String get id => (created.millisecondsSinceEpoch).toString();
  String name;
  Color mainColor;
  Color textColor;
  DateTime created = DateTime.now();
  List<Activity> activities = List();

  Duration getTotalTime() {
    if (activities == null || activities.length == 0)
      return Duration(seconds: 0);
    int seconds = 0;
    for (Activity a in activities) {
      seconds += a.activityDuration.inSeconds;
    }
    return Duration(seconds: seconds);
  }

  Duration getAverageTime() {
    if (activities == null || activities.length == 0)
      return Duration(seconds: 0);
    int seconds = 0;
    for (Activity a in activities) {
      seconds += a.activityDuration.inSeconds;
    }
    seconds = (seconds ~/ activities.length);
    return Duration(seconds: seconds);
  }
}

class Activity {
  Activity({this.dateTimeStart, this.activityDuration});

  DateTime dateTimeStart;
  Duration activityDuration;
}
