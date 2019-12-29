import 'package:pro_time/database/db.dart';
import 'package:pro_time/model/project_with_activities.dart';
import 'package:pro_time/repository/projects/projects_repo.dart';

class ProjectsDb extends ProjectsRepo {
  final ProtimeDb protimeDb;

  ProjectsDb(this.protimeDb);

  @override
  Stream<List<Project>> get projects$ => protimeDb.projectDao.watchProjects;

  @override
  Stream<Project> getProject(int projectId) =>
      protimeDb.projectDao.watchProject(projectId);

  // Returns auto generated id
  @override
  Future<int> insertProject(Project project) => protimeDb.projectDao.insertProject(project);

  @override
  Future<void> replaceProject(Project project) =>
      protimeDb.projectDao.replaceProject(project);

  @override
  Future<void> deleteProject(int projectId) =>
      protimeDb.projectDao.deleteProject(projectId);

  @override
  Stream<ProjectWithActivities> watchProjectWithActivities(int projectId) => protimeDb.projectDao.watchProjectWithActivities(projectId);

}
