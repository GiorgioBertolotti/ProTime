import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pro_time/main.dart';
import 'package:pro_time/model/project.dart';
import 'package:pro_time/pages/home/widgets/delete_project_dialog.dart';
import 'package:pro_time/pages/home/widgets/project_dialog.dart';

class ProjectTile extends StatelessWidget {
  ProjectTile(this.project, this.onDelete);

  final Project project;
  final Function onDelete;
  final Color backgroundColor = Colors.grey[900];

  @override
  Widget build(BuildContext context) {
    Duration totalTime = project.getTotalTime();
    String hrs = totalTime.inHours.toString() + "H\n";
    String mins = (totalTime.inMinutes % 60).toString() + "m";
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: project.mainColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2.0,
              offset: Offset(0.0, 4.0),
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              ProTime.navigatorKey.currentState
                  .pushNamed("/projects/" + project.id, arguments: project.id);
            },
            borderRadius: BorderRadius.circular(30.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: AutoSizeText(
                      project.name,
                      style: TextStyle(
                        color: project.textColor,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 20.0,
                      maxFontSize: 34.0,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(color: project.textColor),
                        children: [
                          TextSpan(
                            text: hrs,
                            style: TextStyle(fontSize: 30.0, height: 0.9),
                          ),
                          TextSpan(
                            text: mins,
                            style: TextStyle(fontSize: 16.0, height: 0.9),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: backgroundColor,
          foregroundColor: Colors.blue,
          icon: Icons.edit,
          onTap: () => _editProject(context, project),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: backgroundColor,
          foregroundColor: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteProject(context, project),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: backgroundColor,
          foregroundColor: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteProject(context, project),
        ),
        IconSlideAction(
          caption: 'Edit',
          color: backgroundColor,
          foregroundColor: Colors.blue,
          icon: Icons.edit,
          onTap: () => _editProject(context, project),
        ),
      ],
    );
  }

  _deleteProject(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (ctx) {
        return DeleteProjectDialog(project, onDelete);
      },
    );
  }

  _editProject(BuildContext context, Project project) async {
    await showDialog(
      context: context,
      builder: (ctx) => ProjectDialog(projectToEdit: project),
    );
  }
}
