import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pro_time/get_it_setup.dart';
import 'package:pro_time/services/theme/theme_service.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = "settings_page";
  final ThemeService _themeService = getIt<ThemeService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 20.0),
              buildHeader(context),
              SizedBox(height: 20.0),
              buildThemeSettings()
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder buildThemeSettings() {
    return StreamBuilder<ThemeData>(
        stream: _themeService.theme$,
        builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Theming",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                SwitchListTile(
                  title: Text("Dark Theme"),
                  value: _themeService.activeTheme == "dark",
                  onChanged: (bool isDark) {
                    if (isDark) {
                      _themeService.setTheme("dark");
                    } else {
                      _themeService.setTheme("light");
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Row buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: AutoSizeText(
            "Settings",
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            minFontSize: 24.0,
            maxFontSize: 44.0,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.close,
            size: 30.0,
          ),
        ),
      ],
    );
  }
}
