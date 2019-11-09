

import 'package:get_it/get_it.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/repository/activities/activities_db.dart';
import 'package:pro_time/repository/activities/activities_repo.dart';
import 'package:pro_time/repository/projects/projects_db.dart';
import 'package:pro_time/repository/projects/projects_repo.dart';
import 'package:pro_time/services/activities/activities_service.dart';
import 'package:pro_time/services/projects/projects_service.dart';
import 'package:pro_time/services/timer/timer_service.dart';

GetIt getIt = GetIt.instance;

void setupGetIt() {
  ProtimeDb protimeDb = ProtimeDb();
  ProjectsRepo projectsRepo = ProjectsDb(protimeDb);
  ActivitiesRepo activitiesRepo = ActivitiesDb(protimeDb);
  getIt.registerLazySingleton(() => ProjectsService(projectsRepo));
  getIt.registerLazySingleton(() => TimerService());
  getIt.registerLazySingleton(() => ActivitiesService(activitiesRepo));
}