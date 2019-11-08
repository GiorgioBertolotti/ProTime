import 'package:flutter/material.dart';
import 'package:pro_time/database/db.dart';

class ProjectWithActivities {
  final Project project;
  List<Activity> activities = [];

  ProjectWithActivities(this.project, this.activities);

  String get name => project.name;

  Duration get totalHours => activities.fold<Duration>(
      Duration(), (Duration prev, Activity current) => prev + current.duration);
  Color get mainColor => project.mainColor;
  Color get textColor => project.textColor;

}
