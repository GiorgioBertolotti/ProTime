

import 'package:pro_time/database/db.dart';
import 'package:pro_time/repository/activities/activities_repo.dart';

class ActivitiesDb extends ActivitiesRepo {
  ProtimeDb protimeDb;

  ActivitiesDb(this.protimeDb);
  
  @override
  Future<List<Activity>> getActivitesAtDate(DateTime date) => protimeDb.activityDao.getActivitiesAtDate(date);

  @override
  Future<List<Activity>> getActivitesBetweenDates(DateTime date1, DateTime date2) => protimeDb.activityDao.getActivitesBetweenDates(date1, date2);

  @override
  Future<List<Activity>> getAllActivitesInProject(int projectId) => protimeDb.activityDao.getAllActivitesInProject(projectId);

  @override
  Future<void> deleteActivity(int activityId) => protimeDb.activityDao.deleteActivity(activityId);

  @override
  Future<Activity> getActivity(int activityId) => protimeDb.activityDao.getActivity(activityId);

  @override
  Future<void> replaceActivity(Activity activity) => protimeDb.activityDao.replaceActivity(activity);

  @override
  Future<void> addActivity(Activity activity) => protimeDb.activityDao.insertActivity(activity);

}