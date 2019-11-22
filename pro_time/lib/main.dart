import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pro_time/get_it_setup.dart';
import 'package:pro_time/pages/home/home_page.dart';
import 'package:pro_time/pages/project/project_page.dart';
import 'package:pro_time/routes.dart';
import 'package:pro_time/services/theme/theme_service.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  await setupGetIt();
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final initializationSettingsAndroid =
      AndroidInitializationSettings('ic_notification');
  final initializationSettingsIOS = IOSInitializationSettings();
  final initializationSettings = InitializationSettings(
    initializationSettingsAndroid,
    initializationSettingsIOS,
  );
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: onSelectNotification,
  );
  final details =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  runApp(ProTime());

  if (details.didNotificationLaunchApp) {
    ProTime.navigatorKey.currentState
        .pushNamed(ProjectPage.routeName, arguments: details.payload);
  }
}

Future onSelectNotification(String id) async {
  ProTime.navigatorKey.currentState.pushNamedAndRemoveUntil(
    ProjectPage.routeName,
    (currentRoute) => currentRoute.settings.name == "/",
    arguments: id,
  );
}

class ProTime extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: getIt<ThemeService>().theme$,
      builder: (context, snapshot) {
        return MaterialApp(
          initialRoute: HomePage.routeName,
          routes: routes,
          theme: snapshot.data,
          title: 'ProTime',
          navigatorKey: navigatorKey,
        );
      }
    );
  }
}
