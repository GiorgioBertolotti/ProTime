import 'package:pro_time/database/db.dart';

abstract class ActivitiesRepo {
  Future<List<Activity>> getActivitesAtDate(DateTime date);
  Future<List<Activity>> getActivitesBetweenDates(
      DateTime date1, DateTime date2);
  Future<List<Activity>> getAllActivitesInProject(int projectId);
  Future<void> deleteActivity(int activityId);
  Future<Activity> getActivity(int activityId);
  Future<void> replaceActivity(Activity activity);
  Future<void> addActivity(Activity activity);
  Future<List<Activity>> getActivitiesForDateInProject(int projectId, DateTime date);
  Future<List<Activity>> getActivitesBetweenDatesInProject(int projectId, DateTime date1, DateTime date2);
  Stream<List<Activity>> getAllActivitesInProjectStream(int activityId);
}
