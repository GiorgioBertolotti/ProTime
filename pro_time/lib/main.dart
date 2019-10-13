import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pro_time/resources/activity_adapter.dart';
import 'package:pro_time/resources/application_state.dart';
import 'package:pro_time/resources/projects_adapter.dart';
import 'package:pro_time/resources/subactivity_adapter.dart';
import 'package:pro_time/ui/home.dart';
import 'package:provider/provider.dart';

void main() {
  Hive.registerAdapter(ProjectsAdapter(), 35);
  Hive.registerAdapter(ActivityAdapter(), 36);
  Hive.registerAdapter(SubActivityAdapter(), 37);
  runApp(MyApp());
}

enum TimerState { STOPPED, STARTED, PAUSED }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProTime',
      home: Provider<ApplicationState>.value(
        value: ApplicationState(),
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: 'Cereal',
            primarySwatch: Colors.grey,
          ),
          home: HomePage(),
        ),
      ),
    );
  }
}
