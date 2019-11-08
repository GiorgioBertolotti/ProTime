import 'package:pro_time/database/db.dart';
import 'package:pro_time/repository/activities/activities_repo.dart';
import "package:collection/collection.dart";

class ActivitiesService {
  ActivitiesRepo activitiesRepo;

  ActivitiesService(this.activitiesRepo);

  deleteActivity(int activityId) => activitiesRepo.deleteActivity(activityId);

  replaceActivity(Activity activity) =>
      activitiesRepo.replaceActivity(activity);

  Future<Activity> getActivity(int activityId) =>
      activitiesRepo.getActivity(activityId);

  getActivitiesInProject(int projectId) =>
      activitiesRepo.getAllActivitesInProject(projectId);

  Future<Duration> getDurationForDay(DateTime day) async {
    final activites = await activitiesRepo.getActivitesAtDate(day);
    print(activites.length);
    return activites.fold<Duration>(Duration(),
        (Duration prev, Activity current) => prev + current.duration);
  }

  Future<int> getTotalHoursInProject(int projectId) async {
    final activites = await activitiesRepo.getAllActivitesInProject(projectId);
    return activites.fold<int>(
        0, (int prev, Activity current) => prev + current.duration.inHours);
  }

  Future<Duration> getDurationInProject(int projectId) async {
    final activites = await activitiesRepo.getAllActivitesInProject(projectId);
    return activites.fold<Duration>(Duration(),
        (Duration prev, Activity current) => prev + current.duration);
  }

  addActivity(Activity activity) => activitiesRepo.addActivity(activity);

  Future<List<List<Activity>>> getActivitiesBetweenDatesGroupedByDay(
      int projectId, DateTime date1, DateTime date2) async {
    final activities =
        await activitiesRepo.getActivitesBetweenDates(date1, date2);
    final activitesMap = groupBy(
        activities,
        (Activity activity) =>
            "${activity.startDateTime.year}-${activity.startDateTime.month}-${activity.startDateTime.day}");
    final List<List<Activity>> groupedActivities = [];
    activitesMap.forEach((key, value) {
      groupedActivities.add(value);
    });

    return groupedActivities;
  }
}