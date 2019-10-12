import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pro_time/model/project.dart';
import 'package:hive/hive.dart';

class NewProjectDialog extends StatefulWidget {
  NewProjectDialog({this.projectToEdit});

  final Project projectToEdit;

  @override
  _NewProjectDialogState createState() => _NewProjectDialogState();
}

class _NewProjectDialogState extends State<NewProjectDialog> {
  TextEditingController _nameController = TextEditingController();
  Color _selectedMainColor;
  Color _selectedTextColor;
  Color _tmpMainColor;
  Color _tmpTextColor;
  bool _editMode;

  @override
  void initState() {
    if (widget.projectToEdit == null) {
      _editMode = false;
      List randomColors = _pickRandomColors();
      _selectedMainColor = randomColors[0];
      _selectedTextColor = randomColors[1];
    } else {
      _editMode = true;
      _nameController.text = widget.projectToEdit.name;
      _selectedMainColor = widget.projectToEdit.mainColor;
      _selectedTextColor = widget.projectToEdit.textColor;
      _tmpMainColor = widget.projectToEdit.mainColor;
      _tmpTextColor = widget.projectToEdit.textColor;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_editMode ? "Edit project" : "Create new project"),
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
              InkWell(
                onTap: () {
                  _openMainColorPicker();
                },
                child: Container(
                  width: 35.0,
                  height: 35.0,
                  child: CircleAvatar(
                    backgroundColor: _selectedMainColor,
                    radius: 35.0,
                  ),
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
              InkWell(
                onTap: () {
                  _openTextColorPicker();
                },
                child: Container(
                  width: 35.0,
                  height: 35.0,
                  child: CircleAvatar(
                    backgroundColor: _selectedTextColor,
                    radius: 35.0,
                  ),
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
          child: Text(_editMode ? "Update" : "Add"),
          onPressed: () {
            Project proj;
            if (_editMode) {
              proj = widget.projectToEdit;
              proj.name = _nameController.text;
              proj.mainColor = _selectedMainColor;
              proj.textColor = _selectedTextColor;
            } else {
              proj = Project(
                name: _nameController.text,
                mainColor: _selectedMainColor,
                textColor: _selectedTextColor,
                created: DateTime.now(),
                activities: List<Activity>(),
              );
            }
            Hive.box("projects").put(proj.id, proj);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  _openMainColorPicker() {
    _openDialog(
      "Main color picker",
      SingleChildScrollView(
        child: ColorPicker(
          pickerColor: _selectedMainColor ?? Colors.white,
          onColorChanged: (color) {
            setState(() {
              _tmpMainColor = color;
            });
          },
          enableLabel: true,
          pickerAreaHeightPercent: 0.8,
        ),
      ),
    );
  }

  _openTextColorPicker() {
    _openDialog(
      "Text color picker",
      SingleChildScrollView(
        child: ColorPicker(
          pickerColor: _selectedTextColor ?? Colors.white,
          onColorChanged: (color) {
            setState(() {
              _tmpTextColor = color;
            });
          },
          enableLabel: true,
          pickerAreaHeightPercent: 0.8,
        ),
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

  List<Color> _pickRandomColors() {
    List<Color> colors = List(2);
    Random random = Random();
    int posBright = random.nextInt(2);
    print(posBright);
    if (posBright == 1) {
      colors[0] = _pickDarkColor();
      colors[1] = _pickBrightColor();
    } else {
      colors[0] = _pickBrightColor();
      colors[1] = _pickDarkColor();
    }
    return colors;
  }

  Color _pickDarkColor() {
    Random random = Random();
    int red = random.nextInt(128);
    int green = random.nextInt(128);
    int blue = random.nextInt(128);
    return Color.fromRGBO(red, green, blue, 1.0);
  }

  Color _pickBrightColor() {
    Random random = Random();
    int red = 128 + random.nextInt(128);
    int green = 128 + random.nextInt(128);
    int blue = 128 + random.nextInt(128);
    return Color.fromRGBO(red, green, blue, 1.0);
  }
}
