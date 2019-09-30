import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pro_time/resources/activity_adapter.dart';
import 'package:pro_time/resources/projects_adapter.dart';
import 'package:pro_time/ui/home.dart';

void main() {
  Hive.registerAdapter(ProjectsAdapter(), 35);
  Hive.registerAdapter(ActivityAdapter(), 36);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProTime',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: HomePage(),
    );
  }
}
