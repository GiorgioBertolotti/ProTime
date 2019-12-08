import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/subjects.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.lightBlue[800],
  accentColor: Colors.cyan[600],
  disabledColor: Color(0xFFcccccc)
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.lightBlue[800],
  accentColor: Colors.cyan[600],
  disabledColor: Color(0xFF6f6f6f)
);


class ThemeService {
  BehaviorSubject<ThemeData> themeSubject =
      BehaviorSubject<ThemeData>.seeded(lightTheme);
  Stream<ThemeData> get theme$ => themeSubject.stream;
  final Box storage;
  String activeTheme = "light";

  ThemeService(this.storage) {
    final String theme = this.storage.get("theme", defaultValue: "light");
    if(activeTheme != theme) {
      setTheme(theme);
    }
  }

  void setTheme(String theme) {
    activeTheme = theme;
    if(activeTheme == "light") {
      themeSubject.add(lightTheme);
    } else {
      themeSubject.add(darkTheme);
    }

    storage.put("theme", activeTheme);
  }

}
