import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_time/resources/activity_adapter.dart';
import 'package:pro_time/resources/application_state.dart';
import 'package:pro_time/resources/projects_adapter.dart';
import 'package:pro_time/resources/subactivity_adapter.dart';
import 'package:pro_time/ui/home.dart';
import 'package:pro_time/ui/project_page.dart';
import 'package:provider/provider.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  Hive.registerAdapter(ProjectsAdapter(), 35);
  Hive.registerAdapter(ActivityAdapter(), 36);
  Hive.registerAdapter(SubActivityAdapter(), 37);
  await _openBoxes();
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('ic_notification');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification);
  var details =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  runApp(ProTime());
  if (details.didNotificationLaunchApp) {
    ProTime.navigatorKey.currentState.pushNamed("/projects/" + details.payload);
  }
}

Future _openBoxes() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  return Future.wait([
    Hive.openBox('projects'),
  ]);
}

Future onSelectNotification(String id) async {}

enum TimerState { STOPPED, STARTED, PAUSED }

class ProTime extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  Route routes(RouteSettings settings) {
    if (settings.name == "/") {
      return MaterialPageRoute(
        builder: (_) => HomePage(),
      );
    } else if (settings.name.startsWith("/projects/")) {
      try {
        String id = settings.name.split("/")[2];
        return MaterialPageRoute(
          builder: (_) => ProjectPage(id),
        );
      } catch (e) {
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
      }
    } else {
      return MaterialPageRoute(
        builder: (_) => HomePage(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ApplicationState>.value(
      value: ApplicationState(),
      child: MaterialApp(
        initialRoute: "/",
        onGenerateRoute: routes,
        title: 'ProTime',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          fontFamily: 'Cereal',
          primarySwatch: Colors.grey,
        ),
        home: HomePage(),
      ),
    );
  }
}
