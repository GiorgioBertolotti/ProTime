import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:pro_time/database/db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_time/model/deprecated/activity_adapter.dart';
import 'package:pro_time/model/deprecated/projects_adapter.dart';
import 'package:pro_time/model/deprecated/subactivity_adapter.dart';
import 'package:pro_time/model/deprecated/projects.dart' as DeprecatedProject;
import 'package:pro_time/repository/activities/activities_db.dart';
import 'package:pro_time/repository/activities/activities_repo.dart';
import 'package:pro_time/repository/projects/projects_db.dart';
import 'package:pro_time/repository/projects/projects_repo.dart';
import 'package:pro_time/repository/timer/timer_repo.dart';
import 'package:pro_time/repository/timer/timer_storage.dart';
import 'package:pro_time/services/activities/activities_service.dart';
import 'package:pro_time/services/projects/projects_service.dart';
import 'package:pro_time/services/theme/theme_service.dart';
import 'package:pro_time/services/timer/timer_service.dart';

GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  final timerBox = await Hive.openBox('timerBox');
  final themeBox = await Hive.openBox('themeBox');
  ProtimeDb protimeDb = ProtimeDb();
  ProjectsRepo projectsRepo = ProjectsDb(protimeDb);
  ActivitiesRepo activitiesRepo = ActivitiesDb(protimeDb);
  TimerRepo timerRepo = TimerPersist(timerBox);

  getIt.registerLazySingleton(() => ProjectsService(projectsRepo));
  getIt.registerLazySingleton(() => TimerService(timerRepo));
  getIt.registerLazySingleton(() => ActivitiesService(activitiesRepo));
  getIt.registerLazySingleton(() => ThemeService(themeBox));

  await _migrateHiveToSqlite();
}

Future<void> _migrateHiveToSqlite() async {
  Hive.registerAdapter(ProjectsAdapter(), 35);
  Hive.registerAdapter(ActivityAdapter(), 36);
  Hive.registerAdapter(SubActivityAdapter(), 37);
  final projectsBox = await Hive.openBox('projects');
  List<DeprecatedProject.Project> projects =
      projectsBox.values.toList().cast<DeprecatedProject.Project>();
  if (projects.length != 0) {
    for (var legacyProject in projects) {
      final project = Project(
          id: null,
          created: legacyProject.created,
          mainColor: legacyProject.mainColor,
          name: legacyProject.name,
          notificationEnabled: legacyProject.notificationEnabled,
          textColor: legacyProject.textColor);

      final projectId = await getIt<ProjectsService>().addProject(project);

      final activities = legacyProject.activities;
      for (var legacyActivity in activities) {
        print("im here activity: ");
        final activity = Activity(
          duration: legacyActivity.getDuration(),
          projectId: projectId,
          startDateTime: legacyActivity.getFirstStarted(),
          id: null,
        );

        print(activity); 
  
        await getIt<ActivitiesService>().addActivity(activity);
      }

      await Hive.box('projects').delete(legacyProject.id);
    }
  }
}
