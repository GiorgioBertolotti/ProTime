import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_time/get_it_setup.dart';
import 'package:pro_time/pages/home/home.dart';
import 'package:pro_time/pages/project/project_page.dart';
import 'package:pro_time/resources/activity_adapter.dart';
import 'package:pro_time/resources/application_state.dart';
import 'package:pro_time/resources/projects_adapter.dart';
import 'package:pro_time/resources/subactivity_adapter.dart';
import 'package:pro_time/resources/theme_service.dart';
import 'package:pro_time/routes.dart';
import 'package:provider/provider.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  await setupGetIt();
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
    ProTime.navigatorKey.currentState
        .pushNamed(ProjectPage.routeName, arguments: details.payload);
  }
}

Future _openBoxes() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  return Future.wait([
    Hive.openBox('projects'),
  ]);
}

Future onSelectNotification(String id) async {
  ProTime.navigatorKey.currentState
      .pushNamedAndRemoveUntil(ProjectPage.routeName, (currentRoute) {
    return currentRoute.settings.name == HomePage.routeName;
  }, arguments: id);
}

enum TimerState { STOPPED, STARTED, PAUSED, DISABLED }

class ProTime extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: getIt<ThemeService>().theme$,
      builder: (context, snapshot) {
        return Provider<ApplicationState>.value(
          value: ApplicationState(),
          child: MaterialApp(
            initialRoute: HomePage.routeName,
            onGenerateRoute: onGenerateRoutes,
            theme: snapshot.data,
            title: 'ProTime',
            navigatorKey: navigatorKey,
          ),
        );
      },
    );
  }
}
