import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/pages/project/widgets/edit_button.dart';

class EditActivityDialog extends StatefulWidget {
  EditActivityDialog(this.activityToEdit);
  final Activity activityToEdit;

  @override
  EditActivityDialogState createState() => EditActivityDialogState();
}

class EditActivityDialogState extends State<EditActivityDialog> {
  Activity _edited;

  @override
  void initState() {
    _edited = widget.activityToEdit.copyWith();
    super.initState();
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
                initialDate: _edited.startDateTime,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                setState(() {
                  DateTime dateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    _edited.startDateTime.hour,
                    _edited.startDateTime.minute,
                  );
                  _edited = _edited.copyWith(startDateTime: dateTime);
                });
              }
            },
            title: "Edit date",
            text: DateFormat('yyyy-MM-dd').format(_edited.startDateTime),
          ),
          SizedBox(height: 10.0),
          EditButton(
            onTap: () async {
              TimeOfDay picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: _edited.startDateTime.hour,
                  minute: _edited.startDateTime.minute,
                ),
              );
              if (picked != null) {
                setState(() {
                  DateTime dateTime = DateTime(
                    _edited.startDateTime.year,
                    _edited.startDateTime.month,
                    _edited.startDateTime.day,
                    picked.hour,
                    picked.minute,
                  );
                  _edited = _edited.copyWith(startDateTime: dateTime);
                });
              }
            },
            title: "Edit time",
            text: DateFormat('HH:mm').format(_edited.startDateTime),
          ),
          SizedBox(height: 10.0),
          EditButton(
            onTap: () async {
              Picker picker = Picker(
                adapter: NumberPickerAdapter(data: [
                  NumberPickerColumn(
                    initValue: _edited.duration.inHours,
                    begin: 0,
                    end: 999,
                    suffix: Text(
                      "h",
                      style: TextStyle(color: Colors.blue, fontSize: 22.0),
                    ),
                  ),
                  NumberPickerColumn(
                    initValue: _edited.duration.inMinutes % 60,
                    begin: 0,
                    end: 60,
                    suffix: Text(
                      "m",
                      style: TextStyle(color: Colors.blue, fontSize: 22.0),
                    ),
                  ),
                  NumberPickerColumn(
                    initValue: _edited.duration.inSeconds % 60,
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
                  setState(() {
                    _edited = _edited.copyWith(
                      duration: Duration(
                        hours: value[0],
                        minutes: value[1],
                        seconds: value[2],
                      ),
                    );

                    print(_edited);
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
            text: _addZero(_edited.duration.inHours) +
                ":" +
                _addZero(_edited.duration.inMinutes % 60) +
                ":" +
                _addZero(_edited.duration.inSeconds % 60),
          ),
        ],
      ),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          textColor: Theme.of(context).textTheme.button.color,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Update"),
          onPressed: () => Navigator.of(context).pop(_edited),
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
