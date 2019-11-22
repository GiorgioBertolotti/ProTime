import 'package:flutter/material.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/get_it_setup.dart';
import 'package:pro_time/services/projects/projects_service.dart';
import 'package:pro_time/utils/random_colors.dart';
import 'package:pro_time/widgets/color_button.dart';

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
      List randomColors = pickRandomColors();
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
          textColor: Theme.of(context).textTheme.button.color,
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          textColor: Colors.lightBlue,
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
        name: _nameController.text,
        mainColor: _selectedMainColor,
        textColor: _selectedTextColor,
        created: DateTime.now(),
      );
      widget.projectsService.addProject(proj);
    }
    Navigator.of(context).pop();
  }
}
