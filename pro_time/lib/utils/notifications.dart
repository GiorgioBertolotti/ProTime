import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/main.dart';

Future<void> showNotification(Project project) async {
  if (!(project.notificationEnabled ?? true)) return;
  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'protime',
    'ProTime',
    'This channel is used by ProTime to send timer reminders.',
    importance: Importance.Max,
    priority: Priority.High,
    ongoing: true,
    autoCancel: false,
    ticker: 'ticker',
    enableLights: true,
    color: project.mainColor,
    ledColor: project.mainColor,
    ledOnMs: 1000,
    ledOffMs: 500,
  );
  final iOSPlatformChannelSpecifics = IOSNotificationDetails();
  final platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'Tracking active',
    'The tracking of ' + project.name + " is running!",
    platformChannelSpecifics,
    payload: project.id.toString(),
  );
}

Future<void> cancelNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}
