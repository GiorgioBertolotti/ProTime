

import 'package:pro_time/database/db.dart';
import 'package:pro_time/model/project_with_activities.dart';

abstract class ProjectsRepo {
  Stream<List<Project>> projects$;
  Stream<Project> getProject(int projectId);
  Stream<ProjectWithActivities> watchProjectWithActivities(int projectId);
  Future<void> replaceProject(Project project);
  Future<void> insertProject(Project project);
  Future<void> deleteProject(int projectId);

}