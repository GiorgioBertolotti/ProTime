import 'package:moor_flutter/moor_flutter.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/database/tables/activities.dart';
import 'package:pro_time/database/tables/projects.dart';
import 'package:pro_time/model/project_with_activities.dart';

part 'project_dao.g.dart';

@UseDao(tables: [Projects, Activities])
class ProjectDao extends DatabaseAccessor<ProtimeDb> with _$ProjectDaoMixin {
  ProjectDao(ProtimeDb db) : super(db);

  Stream<List<Project>> get watchProjects => select(projects).watch();
  Stream<Project> watchProject(int projectId) => (select(projects)..where((project) => project.id.equals(projectId))).watchSingle();

  Future<int> insertProject(Project project) => into(projects).insert(project);
  Future<void> replaceProject(Project project) => update(projects).replace(project);
  Future<void> deleteProject(int projectId) => (delete(projects)..where((p) => p.id.equals(projectId))).go();

  Stream<ProjectWithActivities> watchProjectWithActivities(int projectId) =>
      (select(projects)..where((p) => p.id.equals(projectId)))
          .join([
            leftOuterJoin(
                activities, activities.projectId.equalsExp(projects.id))
          ])
          .watch()
          .map((rows) {
            final project = rows[0].readTable(projects);
            final activityArray = rows
                .map((row) => row.readTable(activities))
                .where((a) => a != null)
                .toList();
            return ProjectWithActivities(project, activityArray ?? []);
          });
}
