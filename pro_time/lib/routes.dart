import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro_time/pages/home/home_page.dart';
import 'package:pro_time/pages/project/project_page.dart';
import 'package:pro_time/pages/settings/settings_page.dart';

PageRoute onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case HomePage.routeName:
      return CupertinoPageRoute(builder: (_) => HomePage(), settings: settings);
    case ProjectPage.routeName:
      return CupertinoPageRoute(
          builder: (_) => ProjectPage(), settings: settings);
    case SettingsPage.routeName:
      return CupertinoPageRoute(
          builder: (_) => SettingsPage(), settings: settings);
    default:
      return CupertinoPageRoute(builder: (_) => HomePage(), settings: settings);
  }
}
