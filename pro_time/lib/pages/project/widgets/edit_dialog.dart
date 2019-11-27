import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';
import 'package:pro_time/main.dart';
import 'package:pro_time/model/project.dart';
import 'package:pro_time/pages/project/widgets/edit_button.dart';

class EditActivityDialog extends StatefulWidget {
  EditActivityDialog(this.activityToEdit, this.project);

  final Activity activityToEdit;
  final Project project;

  @override
  EditActivityDialogState createState() => EditActivityDialogState();
}

class EditActivityDialogState extends State<EditActivityDialog> {
  Activity _edited;

  @override
  void initState() {
    _setActivity(
      start: widget.activityToEdit.getFirstStarted(),
      duration: widget.activityToEdit.getDuration(),
    );
    super.initState();
  }

  _setActivity({DateTime start, Duration duration}) {
    if (start == null) start = _edited.getFirstStarted();
    if (duration == null) duration = _edited.getDuration();
    _edited = Activity();
    _edited.subActivities.add(
      SubActivity(
        dateTimeStart: start,
        activityDuration: duration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit activity"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10.0),
          EditButton(
            onTap: () async {
              DateTime selectedDate = await showDatePicker(
                context: context,
                initialDate: _edited.getFirstStarted(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                setState(() {
                  DateTime dateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    _edited.getFirstStarted().hour,
                    _edited.getFirstStarted().minute,
                  );
                  _setActivity(start: dateTime);
                });
              }
            },
            title: "Edit date",
            text: DateFormat('yyyy-MM-dd').format(_edited.getFirstStarted()),
          ),
          SizedBox(height: 10.0),
          EditButton(
            onTap: () async {
              TimeOfDay picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: _edited.getFirstStarted().hour,
                  minute: _edited.getFirstStarted().minute,
                ),
              );
              if (picked != null) {
                setState(() {
                  DateTime dateTime = DateTime(
                    _edited.getFirstStarted().year,
                    _edited.getFirstStarted().month,
                    _edited.getFirstStarted().day,
                    picked.hour,
                    picked.minute,
                  );
                  _setActivity(start: dateTime);
                });
              }
            },
            title: "Edit time",
            text: DateFormat('HH:mm').format(_edited.getFirstStarted()),
          ),
          SizedBox(height: 10.0),
          EditButton(
            onTap: () async {
              Picker picker = Picker(
                adapter: NumberPickerAdapter(data: [
                  NumberPickerColumn(
                    initValue: _edited.getDuration().inHours,
                    begin: 0,
                    end: 999,
                    suffix: Text(
                      "h",
                      style: TextStyle(color: Colors.blue, fontSize: 22.0),
                    ),
                  ),
                  NumberPickerColumn(
                    initValue: _edited.getDuration().inMinutes % 60,
                    begin: 0,
                    end: 60,
                    suffix: Text(
                      "m",
                      style: TextStyle(color: Colors.blue, fontSize: 22.0),
                    ),
                  ),
                  NumberPickerColumn(
                    initValue: _edited.getDuration().inSeconds % 60,
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
                selectedTextStyle:
                    const TextStyle(color: Colors.blue, fontSize: 22.0),
                columnPadding: const EdgeInsets.all(8.0),
                onConfirm: (Picker picker, List value) async {
                  //await Hive.box("projects").put(widget.project.id, widget.project);
                  setState(() {
                    _setActivity(
                      duration: Duration(
                        hours: value[0],
                        minutes: value[1],
                        seconds: value[2],
                      ),
                    );
                  });
                },
                confirmTextStyle:
                    const TextStyle(color: Colors.blue, fontSize: 22.0),
                cancelTextStyle:
                    const TextStyle(color: Colors.blue, fontSize: 22.0),
                backgroundColor: Theme.of(context).dialogBackgroundColor,
              );
              await picker.showModal(context);
            },
            title: "Edit duration",
            text: _addZero(_edited.getDuration().inHours) +
                ":" +
                _addZero(_edited.getDuration().inMinutes % 60) +
                ":" +
                _addZero(_edited.getDuration().inSeconds % 60),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          textColor: Colors.deepOrange,
          child: Text("Cancel"),
          onPressed: () {
            ProTime.navigatorKey.currentState.pop();
          },
        ),
        FlatButton(
          textColor: Theme.of(context).textTheme.button.color,
          child: Text("Update"),
          onPressed: () {
            ProTime.navigatorKey.currentState.pop(_edited);
          },
        ),
      ],
    );
  }

  String _addZero(int number) {
    if (number < 10)
      return "0" + number.toString();
    else
      return number.toString();
  }
}
