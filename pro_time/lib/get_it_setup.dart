import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:pro_time/database/db.dart';
import 'package:path_provider/path_provider.dart';
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
}