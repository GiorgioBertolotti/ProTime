import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/get_it_setup.dart';
import 'package:pro_time/services/activities/activities_service.dart';

class ActivityTile extends StatelessWidget {
  final Activity activity;
  final _activitiesService = getIt<ActivitiesService>();
  ActivityTile(this.activity);

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
            Theme.of(context).brightness == Brightness.dark ? 
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2.0,
              offset: Offset(0.0, 4.0),
            ) : BoxShadow(
              color: Colors.black12,
              blurRadius: 2.0,
              offset: Offset(0.0, 4.0),
            ) 

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
      actions: _buildActivityActions(context, activity),
      secondaryActions:
          _buildActivityActions(context, activity, secondary: true),
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

  List<Widget> _buildActivityActions(BuildContext context, Activity activity,
      {bool secondary = false}) {
    final List<Widget> toReturn = [
      IconSlideAction(
        caption: 'Edit',
        color: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.blue,
        icon: Icons.edit,
        onTap: () => _editActivity(context, activity),
      ),
      IconSlideAction(
        caption: 'Delete',
        color: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.red,
        icon: Icons.delete,
        onTap: () => _activitiesService.deleteActivity(activity.id),
      ),
    ];
    if (secondary)
      return toReturn.reversed.toList();
    else
      return toReturn;
  }

  _editActivity(BuildContext context, Activity toEdit) {
    Picker picker = Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(
          initValue: toEdit.duration.inHours,
          begin: 0,
          end: 999,
          suffix: Text(
            "h",
            style: TextStyle(color: Colors.blue, fontSize: 22.0),
          ),
        ),
        NumberPickerColumn(
          initValue: toEdit.duration.inMinutes % 60,
          begin: 0,
          end: 60,
          suffix: Text(
            "m",
            style: TextStyle(color: Colors.blue, fontSize: 22.0),
          ),
        ),
        NumberPickerColumn(
          initValue: toEdit.duration.inSeconds % 60,
          begin: 0,
          end: 60,
          suffix: Text(
            "s",
            style: TextStyle(color: Colors.blue, fontSize: 22.0),
          ),
        ),
      ]),
      title: Text("Duration"),
      textAlign: TextAlign.left,
      textStyle: const TextStyle(color: Colors.blue, fontSize: 22.0),
      selectedTextStyle: const TextStyle(color: Colors.blue, fontSize: 22.0),
      columnPadding: const EdgeInsets.all(8.0),
      onConfirm: (Picker picker, List value) async {
        final newDuration =
            Duration(hours: value[0], minutes: value[1], seconds: value[2]);
        Duration();
        newDuration.inSeconds;
        _activitiesService
            .replaceActivity(activity.copyWith(duration: newDuration));
      },
      confirmTextStyle: const TextStyle(color: Colors.blue, fontSize: 22.0),
      cancelTextStyle: const TextStyle(color: Colors.blue, fontSize: 22.0),
    );
    picker.showModal(context);
  }
}
