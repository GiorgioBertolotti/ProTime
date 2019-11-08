import 'package:flutter/material.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/get_it_setup.dart';
import 'package:pro_time/pages/home/widgets/color_picker.dart';
import 'package:pro_time/services/projects/projects_service.dart';
import 'package:pro_time/utils/random_colors.dart';

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
          _colorButton(
            context,
            () => _setMainColor(context),
            "Pick main color",
            _selectedMainColor
          ),
          SizedBox(height: 10.0),
          _colorButton(
            context,
            () => _setTextColor(context),
            "Pick text color",
            _selectedTextColor
          ),
        ],
      ),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          textColor: Colors.lightBlue,
          child: Text(_editMode ? "Update" : "Add"),
          onPressed: !_nameValid
              ? null
              : () {
                  Project proj;
                  if (_editMode) {
                    proj = widget.projectToEdit.copyWith(
                        name: _nameController.text,
                        mainColor: _selectedMainColor,
                        textColor: _selectedTextColor);
                  } else {
                    proj = Project(
                      name: _nameController.text,
                      mainColor: _selectedMainColor,
                      textColor: _selectedTextColor,
                      created: DateTime.now(),
                    );
                  }
                  widget.projectsService.addProject(proj);
                  Navigator.of(context).pop();
                },
        ),
      ],
    );
  }

  Container _colorButton(BuildContext context, Function onTap, String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.withAlpha(100)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(title),
        trailing: Container(
          width: 35.0,
          height: 35.0,
          child: CircleAvatar(
            backgroundColor: color,
            radius: 35.0,
          ),
        ),
      ),
    );
  }

  Future _setMainColor(BuildContext context) async {
    final color = await openColoPickerDialog(
      context,
      "Main color picker",
    );
    if (color != null) {
      setState(() {
        _selectedMainColor = color;
      });
    }
  }

  Future _setTextColor(BuildContext context) async {
    final color = await openColoPickerDialog(
      context,
      "Text color picker",
    );

    if (color != null) {
      setState(() {
        _selectedTextColor = color;
      });
    }
  }
}
