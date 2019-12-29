import 'package:moor_flutter/moor_flutter.dart';
import 'package:pro_time/database/db.dart';
import 'package:pro_time/database/tables/activities.dart';

part 'activity_dao.g.dart';

@UseDao(tables: [Activities])
class ActivityDao extends DatabaseAccessor<ProtimeDb> with _$ActivityDaoMixin {
  ActivityDao(ProtimeDb db) : super(db);

  Future<List<Activity>> getActivitiesAtDate(DateTime date) =>
      (select(activities)
            ..where(
              (a) => and(
                day(a.startDateTime).equals(date.day),
                and(
                  month(a.startDateTime).equals(date.month),
                  year(a.startDateTime).equals(date.year),
                ),
              ),
            ))
          .get();

  Future<List<Activity>> getActivitiesForDateInProject(
          int projectId, DateTime date) =>
      (select(activities)
            ..where(
              (a) => and(
                and(
                  day(a.startDateTime).equals(date.day),
                  month(a.startDateTime).equals(date.month),
                ),
                and(
                  year(a.startDateTime).equals(date.year),
                  a.projectId.equals(projectId),
                ),
              ),
            ))
          .get();

  Future<List<Activity>> getActivitesBetweenDates(DateTime date1, DateTime date2) =>
      (select(activities)..where((a) => a.startDateTime.isBetweenValues(date1, date2))).get();

  Future<List<Activity>> getActivitesBetweenDatesInProject(
          int projectId, DateTime date1, DateTime date2) =>
      (select(activities)
            ..where(
              (a) => and(
                a.startDateTime.isBetweenValues(date1, date2),
                a.projectId.equals(projectId),
              ),
            ))
          .get();

  Future<List<Activity>> getAllActivitesInProject(projectId) =>
      (select(activities)..where((a) => a.projectId.equals(projectId))).get();
  
  Stream<List<Activity>> getAllActivitesInProjectStream(projectId) =>
      (select(activities)..where((a) => a.projectId.equals(projectId))).watch();

  Future<void> replaceActivity(Activity activity) =>
      update(activities).replace(activity);

  Future<Activity> getActivity(int activityId) =>
      (select(activities)..where((a) => a.id.equals(activityId))).getSingle();

  Future<void> deleteActivity(int activityId) =>
      (delete(activities)..where((a) => a.id.equals(activityId))).go();

  Future<int> insertActivity(Activity activity) =>
      into(activities).insert(activity);
}
