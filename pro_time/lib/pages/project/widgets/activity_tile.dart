import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pro_time/model/project.dart';
import 'package:pro_time/pages/project/widgets/edit_dialog.dart';

class ActivityTile extends StatefulWidget {
  ActivityTile(this.activity, this.project,
      {this.editCallback, this.deleteCallback});

  final Activity activity;
  final Project project;
  final Function deleteCallback;
  final Function editCallback;

  @override
  _ActivityTileState createState() => _ActivityTileState();
}

class _ActivityTileState extends State<ActivityTile> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        height: 75.0,
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
            children: <Widget>[
              Expanded(
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: DateFormat('yyyy-MM-dd')
                                .format(widget.activity.getFirstStarted()) +
                            "\n",
                        style: TextStyle(fontSize: 16.0, height: 0.9),
                      ),
                      TextSpan(
                        text: DateFormat('HH:mm')
                            .format(widget.activity.getFirstStarted()),
                        style: TextStyle(fontSize: 28.0, height: 0.9),
                      ),
                    ],
                  ),
                ),
              ),
              _buildActivityDurationText(widget.activity),
            ],
          ),
        ),
      ),
      actions: _buildActivityActions(widget.activity),
      secondaryActions: _buildActivityActions(widget.activity, secondary: true),
    );
  }

  Widget _buildActivityDurationText(Activity activity) {
    if (activity.getIncompleteSubActivity() != null) {
      return Text(
        "running\nnow",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[600]),
      );
    }
    Duration totalTime = activity.getDuration();
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

  List<Widget> _buildActivityActions(Activity activity,
      {bool secondary = false}) {
    List<Widget> toReturn;
    if (activity.getIncompleteSubActivity() != null) {
      toReturn = <Widget>[];
    } else {
      toReturn = <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Colors.blue,
          icon: Icons.edit,
          onTap: () => _editActivity(activity),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteActivity(activity),
        ),
      ];
    }
    if (secondary)
      return toReturn.reversed.toList();
    else
      return toReturn;
  }

  _editActivity(Activity toEdit) async {
    var edited = await showDialog(
      context: context,
      builder: (ctx) {
        return EditActivityDialog(toEdit, widget.project);
      },
    );
    if (edited != null) {
      widget.project.activities.remove(toEdit);
      widget.project.activities.add(edited);
      await Hive.box("projects").put(widget.project.id, widget.project);
    }
    if (widget.editCallback != null) widget.editCallback();
  }

  _deleteActivity(Activity toDelete) async {
    widget.project.activities.remove(toDelete);
    await Hive.box("projects").put(widget.project.id, widget.project);
    if (widget.deleteCallback != null) widget.deleteCallback();
  }
}
