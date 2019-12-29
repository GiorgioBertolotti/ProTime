import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pro_time/database/db.dart';

class ActivityTile extends StatelessWidget {
  ActivityTile(this.activity, this.onEdit, this.onDelete);

  final Activity activity;
  final Function onEdit;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        height: 75,
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          boxShadow: [
            Theme.of(context).brightness == Brightness.dark
                ? BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2.0,
                    offset: Offset(0.0, 4.0),
                  )
                : BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    offset: Offset(0.0, 4.0),
                  ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: DateFormat('yyyy-MM-dd')
                                .format(activity.startDateTime) +
                            "\n",
                        style: TextStyle(fontSize: 16.0, height: 0.9),
                      ),
                      TextSpan(
                        text:
                            DateFormat('HH:mm').format(activity.startDateTime),
                        style: TextStyle(fontSize: 28.0, height: 0.9),
                      ),
                    ],
                  ),
                ),
              ),
              _buildActivityDurationText(activity),
            ],
          ),
        ),
      ),
      actions: _buildActivityActions(context),
      secondaryActions: _buildActivityActions(context, secondary: true),
    );
  }

  Widget _buildActivityDurationText(Activity activity) {
    Duration totalTime = activity.duration;
    int secondsCounter = totalTime.inSeconds;
    int hours = secondsCounter ~/ 60 ~/ 60;
    int minutes = (secondsCounter ~/ 60 % 60).toInt();
    int seconds = (secondsCounter % 60 % 60);
    double hoursSize = (hours != 0) ? 30.0 : 0.0;
    double minutesSize = (hours != 0) ? 16.0 : 30.0;
    double secondsSize = 16.0;
    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(color: Colors.black),
        children: [
          hours != 0
              ? TextSpan(
                  text: hours.toString() + "H\n",
                  style: TextStyle(
                    fontSize: hoursSize,
                    height: 0.9,
                  ),
                )
              : TextSpan(),
          TextSpan(
            text: minutes.toString() + "m" + (hours != 0 ? "" : "\n"),
            style: TextStyle(
              fontSize: minutesSize,
              height: 0.9,
            ),
          ),
          hours == 0
              ? TextSpan(
                  text: (seconds < 10
                          ? ("0" + seconds.toString())
                          : seconds.toString()) +
                      "s",
                  style: TextStyle(
                    fontSize: secondsSize,
                    height: 0.9,
                  ),
                )
              : TextSpan(),
        ],
      ),
    );
  }

  List<Widget> _buildActivityActions(BuildContext context,
      {bool secondary = false}) {
    final List<Widget> toReturn = [
      IconSlideAction(
        caption: 'Edit',
        color: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.blue,
        icon: Icons.edit,
        onTap: onEdit,
      ),
      IconSlideAction(
        caption: 'Delete',
        color: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.red,
        icon: Icons.delete,
        onTap: onDelete,
      ),
    ];
    if (secondary)
      return toReturn.reversed.toList();
    else
      return toReturn;
  }
}
