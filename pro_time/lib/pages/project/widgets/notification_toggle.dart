import 'package:flutter/material.dart';

class NotificationToggle extends StatelessWidget {
  final Color backgroundColor;
  final Function(bool) onTap;
  final notificationEnabled;

  NotificationToggle(
      {Key key,
      @required this.notificationEnabled,
      @required this.backgroundColor,
      @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Toggle notifications",
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: notificationEnabled
              ? Colors.white
              : Theme.of(context).disabledColor,
          boxShadow: [
            Theme.of(context).brightness == Brightness.dark
                ? BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(0.0, 4.0),
                  )
                : BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(0.0, 2.0),
                  )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(100.0),
            onTap: () => onTap(!notificationEnabled),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: notificationEnabled
                    ? Icon(
                        Icons.notifications,
                        size: 30.0,
                        color: backgroundColor,
                      )
                    : Icon(
                        Icons.notifications_off,
                        size: 30.0,
                        color: backgroundColor,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
