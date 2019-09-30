import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:pro_time/model/project.dart';
import 'package:hive/hive.dart';

class NewProjectDialog extends StatefulWidget {
  @override
  _NewProjectDialogState createState() => _NewProjectDialogState();
}

class _NewProjectDialogState extends State<NewProjectDialog> {
  TextEditingController _nameController = TextEditingController();
  Color _selectedMainColor;
  Color _selectedTextColor;
  Color _tmpMainColor;
  Color _tmpTextColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create new project"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10.0),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: "Enter project name",
              border: UnderlineInputBorder(),
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              OutlineButton(
                child: Text("Pick main color"),
                onPressed: () {
                  _openMainColorPicker();
                },
              ),
              Container(
                width: 35.0,
                height: 35.0,
                child: CircleAvatar(
                  backgroundColor: _selectedMainColor,
                  radius: 35.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              OutlineButton(
                child: Text("Pick text color"),
                onPressed: () {
                  _openTextColorPicker();
                },
              ),
              Container(
                width: 35.0,
                height: 35.0,
                child: CircleAvatar(
                  backgroundColor: _selectedTextColor,
                  radius: 35.0,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          textColor: Colors.deepOrange,
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          textColor: Colors.lightBlue,
          child: Text("Add"),
          onPressed: () {
            Project toAdd = Project(
              name: _nameController.text,
              mainColor: _selectedMainColor,
              textColor: _selectedTextColor,
              created: DateTime.now(),
              activities: List<Activity>(),
            );
            Hive.box("projects").put(toAdd.id, toAdd);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  _openMainColorPicker() {
    _openDialog(
      "Main color picker",
      MaterialColorPicker(
        allowShades: false,
        selectedColor: _selectedMainColor,
        onMainColorChange: (color) {
          setState(() {
            _tmpMainColor = color;
          });
        },
      ),
    );
  }

  _openTextColorPicker() {
    _openDialog(
      "Text color picker",
      MaterialColorPicker(
        allowShades: false,
        selectedColor: _selectedTextColor,
        onMainColorChange: (color) {
          setState(() {
            _tmpTextColor = color;
          });
        },
      ),
    );
  }

  _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: content,
          actions: <Widget>[
            FlatButton(
              textColor: Colors.deepOrange,
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              textColor: Colors.lightBlue,
              child: Text("Select"),
              onPressed: () {
                setState(() {
                  _selectedMainColor = _tmpMainColor;
                  _selectedTextColor = _tmpTextColor;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
