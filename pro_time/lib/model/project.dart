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
      seconds += a.getDuration().inSeconds;
    }
    return Duration(seconds: seconds);
  }

  Duration getAverageTime() {
    if (activities == null || activities.length == 0)
      return Duration(seconds: 0);
    int seconds = 0;
    for (Activity a in activities) {
      seconds += a.getDuration().inSeconds;
    }
    seconds = (seconds ~/ activities.length);
    return Duration(seconds: seconds);
  }
}

class Activity {
  List<SubActivity> subActivities = List();

  setDuration(Duration newDuration) {
    DateTime started = getFirstStarted();
    subActivities.clear();
    subActivities.add(
      SubActivity(dateTimeStart: started, activityDuration: newDuration),
    );
  }

  Duration getDuration() {
    if (subActivities == null || subActivities.length == 0)
      return Duration(seconds: 0);
    int seconds = 0;
    for (SubActivity subActivity in subActivities) {
      seconds += subActivity.getDuration().inSeconds;
    }
    return Duration(seconds: seconds);
  }

  DateTime getFirstStarted() {
    if (subActivities == null || subActivities.length == 0)
      return DateTime.now();
    DateTime first = subActivities[0].dateTimeStart;
    for (int i = 1; i < subActivities.length; i++) {
      if (subActivities[i].dateTimeStart.isBefore(first))
        first = subActivities[i].dateTimeStart;
    }
    return first;
  }
}

class SubActivity {
  SubActivity({this.dateTimeStart, this.activityDuration});

  DateTime dateTimeStart;
  Duration activityDuration;

  Duration getDuration() {
    return activityDuration;
  }
}
