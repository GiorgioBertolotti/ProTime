import 'package:flutter/material.dart';

class Project {
  Project({
    this.name,
    this.mainColor,
    this.textColor,
    DateTime created,
    List<Activity> activities,
    bool notificationEnabled,
  })  : this.created = created ?? DateTime.now(),
        this.activities = activities ?? List(),
        this.notificationEnabled = notificationEnabled ?? true;

  String get id => (created.millisecondsSinceEpoch).toString();
  String name;
  Color mainColor;
  Color textColor;
  DateTime created;
  List<Activity> activities;
  bool notificationEnabled;

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

  bool hasIncompleteActivities() {
    if (activities == null || activities.length == 0) return false;
    for (Activity activity in this.activities) {
      if (activity.getIncompleteSubActivity() != null) return true;
    }
    return false;
  }

  Activity getIncompleteActivity() {
    if (activities == null || activities.length == 0) return null;
    for (Activity activity in this.activities) {
      if (activity.getIncompleteSubActivity() != null) return activity;
    }
    return null;
  }

  bool operator ==(o) => o is Project && o.id == this.id;
  int get hashCode => id.hashCode;
}

class Activity {
  List<SubActivity> subActivities = List();

  SubActivity getIncompleteSubActivity() {
    for (SubActivity subActivity in subActivities) {
      if (subActivity.activityDuration == null) {
        return subActivity;
      }
    }
    return null;
  }

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
      if (subActivity.getDuration() != null)
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

  bool operator ==(o) =>
      o is Activity && o.getFirstStarted() == this.getFirstStarted();
  int get hashCode => this.getFirstStarted().hashCode;
}

class SubActivity {
  SubActivity({this.dateTimeStart, this.activityDuration});

  DateTime dateTimeStart;
  Duration activityDuration;

  Duration getDuration() {
    return activityDuration;
  }

  bool operator ==(o) =>
      o is SubActivity && o.dateTimeStart == this.dateTimeStart;
  int get hashCode => this.dateTimeStart.hashCode;
}