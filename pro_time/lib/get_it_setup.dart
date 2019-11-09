import 'package:get_it/get_it.dart';
import 'package:pro_time/resources/theme_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => ThemeService(prefs));
}
