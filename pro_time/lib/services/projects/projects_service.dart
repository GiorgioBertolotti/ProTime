


import 'package:pro_time/database/db.dart';
import 'package:pro_time/model/project_with_activities.dart';
import 'package:pro_time/repository/projects/projects_repo.dart';

class ProjectsService {
  Stream<List<Project>> get projects$ => projectsRepo.projects$;
  ProjectsRepo projectsRepo;
  ProjectsService(this.projectsRepo);

  addProject(Project project) => projectsRepo.insertProject(project);
  replaceProject(Project project) => projectsRepo.replaceProject(project);
  deleteProject(int projectId) {
  }

  Stream<Project> getProject(int projectId) => projectsRepo.getProject(projectId);

  Stream<ProjectWithActivities> watchProjectWithActivites(int projectId) => projectsRepo.watchProjectWithActivities(projectId);
}