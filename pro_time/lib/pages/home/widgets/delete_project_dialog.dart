import 'package:flutter/material.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/get_it_setup.dart';
import 'package:pro_time/services/projects/projects_service.dart';

class DeleteProjectDialog extends StatelessWidget {
  final Project project;
  final _projectsService = getIt<ProjectsService>();

  DeleteProjectDialog(this.project, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete " + project.name + "?"),
      actions: [
        FlatButton(
          textColor: Theme.of(context).textTheme.button.color,
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          textColor: Colors.deepOrange,
          child: Text("Confirm"),
          onPressed: () {
            _projectsService.deleteProject(project.id);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
