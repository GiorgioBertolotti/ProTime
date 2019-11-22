

import 'package:get_it/get_it.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/repository/activities/activities_db.dart';
import 'package:pro_time/repository/activities/activities_repo.dart';
import 'package:pro_time/repository/projects/projects_db.dart';
import 'package:pro_time/repository/projects/projects_repo.dart';
import 'package:pro_time/services/activities/activities_service.dart';
import 'package:pro_time/services/projects/projects_service.dart';
import 'package:pro_time/services/theme/theme_service.dart';
import 'package:pro_time/services/timer/timer_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  ProtimeDb protimeDb = ProtimeDb();
  ProjectsRepo projectsRepo = ProjectsDb(protimeDb);
  ActivitiesRepo activitiesRepo = ActivitiesDb(protimeDb);
  SharedPreferences prefs = await SharedPreferences.getInstance();

  getIt.registerLazySingleton(() => ProjectsService(projectsRepo));
  getIt.registerLazySingleton(() => TimerService(prefs));
  getIt.registerLazySingleton(() => ActivitiesService(activitiesRepo));
  getIt.registerLazySingleton(() => ThemeService(prefs));
}