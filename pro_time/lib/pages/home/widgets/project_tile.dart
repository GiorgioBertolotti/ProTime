import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/get_it_setup.dart';
import 'package:pro_time/pages/home/widgets/delete_project_dialog.dart';
import 'package:pro_time/pages/home/widgets/project_dialog.dart';
import 'package:pro_time/pages/project/project_page.dart';
import 'package:pro_time/services/activities/activities_service.dart';

class ProjectTile extends StatelessWidget {
  final Project project;
  final ActivitiesService activitiesService = getIt<ActivitiesService>();
  ProjectTile(this.project);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: project.mainColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2.0,
              offset: Offset(0.0, 4.0),
            )
          ],
        ),
        child: InkWell(
          onTap: () => Navigator.of(context)
              .pushNamed(ProjectPage.routeName, arguments: project.id),
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            height: 75.0,
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                buildHourCounter(),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconSlideAction(
          caption: 'Edit',
          color: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Colors.blue,
          icon: Icons.edit,
          onTap: () => _editProject(context, project),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteProject(context, project),
        ),
      ],
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          color: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteProject(context, project),
        ),
        IconSlideAction(
          caption: 'Edit',
          color: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Colors.blue,
          icon: Icons.edit,
          onTap: () => _editProject(context, project),
        ),
      ],
    );
  }

  Container buildHourCounter() {
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: StreamBuilder(
          stream: activitiesService.getDurationInProjectStream(project.id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return CircularProgressIndicator();
            }
            Duration totalTime = snapshot.data;
            String hrs = totalTime.inHours.toString() + "H\n";
            String mins = (totalTime.inMinutes % 60).toString() + "m";
            return RichText(
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
            );
          }),
    );
  }

  _deleteProject(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteProjectDialog(project),
    );
  }

  _editProject(BuildContext context, Project project) async {
    await showDialog(
      context: context,
      builder: (ctx) => ProjectDialog(projectToEdit: project),
    );
  }
}
