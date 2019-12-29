import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/get_it_setup.dart';
import 'package:pro_time/services/projects/projects_service.dart';
import 'package:pro_time/pages/home/widgets/color_button.dart';

class ProjectDialog extends StatefulWidget {
  final projectsService = getIt<ProjectsService>();
  ProjectDialog({this.projectToEdit});

  final Project projectToEdit;

  @override
  _ProjectDialogState createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<ProjectDialog> {
  TextEditingController _nameController = TextEditingController();
  Color _selectedMainColor;
  Color _selectedTextColor;
  bool _editMode;
  bool _nameValid = false;

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
      if (widget.projectToEdit.name != null &&
          widget.projectToEdit.name.isNotEmpty) _nameValid = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_editMode ? "Edit project" : "Create new project"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.0),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: "Enter project name",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (!_nameValid && (value != null && value.isNotEmpty)) {
                setState(() {
                  _nameValid = true;
                });
              }
              if (_nameValid && (value == null || value.isEmpty)) {
                setState(() {
                  _nameValid = false;
                });
              }
            },
          ),
          SizedBox(height: 10.0),
          ColorButton(
            onTap: (Color color) => _setMainColor(color),
            title: "Pick main color",
            color: _selectedMainColor,
          ),
          SizedBox(height: 10.0),
          ColorButton(
            onTap: (Color color) => _setTextColor(color),
            title: "Pick text color",
            color: _selectedTextColor,
          ),
        ],
      ),
      actions: [
        FlatButton(
          textColor: Colors.deepOrange,
          child: Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          textColor: Theme.of(context).textTheme.button.color,
          child: Text(_editMode ? "Update" : "Add"),
          onPressed: !_nameValid ? null : () => _saveOrCreateProject(context),
        ),
      ],
    );
  }

  Future _setMainColor(Color color) async {
    if (color != null) {
      setState(() {
        _selectedMainColor = color;
      });
    }
  }

  Future _setTextColor(Color color) async {
    if (color != null) {
      setState(() {
        _selectedTextColor = color;
      });
    }
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

  void _saveOrCreateProject(BuildContext context) {
    Project proj;
    if (_editMode) {
      proj = widget.projectToEdit.copyWith(
        name: _nameController.text,
        mainColor: _selectedMainColor,
        textColor: _selectedTextColor,
      );
      widget.projectsService.replaceProject(proj);
    } else {
      proj = Project(
        notificationEnabled: false,
        name: _nameController.text,
        mainColor: _selectedMainColor,
        textColor: _selectedTextColor,
        created: DateTime.now(), id: null,
      );
      widget.projectsService.addProject(proj);
    }
    Navigator.of(context).pop();
  }
}
