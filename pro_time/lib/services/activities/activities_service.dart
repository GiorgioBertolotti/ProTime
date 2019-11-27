import 'package:pro_time/database/db.dart';
import 'package:pro_time/repository/activities/activities_repo.dart';

class ActivitiesService {
  ActivitiesRepo activitiesRepo;
  ActivitiesService(this.activitiesRepo);

  Future<void> addActivity(Activity activity) => activitiesRepo.addActivity(activity);

  Future<void> deleteActivity(int activityId) => activitiesRepo.deleteActivity(activityId);

  Future<void> replaceActivity(Activity activity) => activitiesRepo.replaceActivity(activity);

  Future<Activity> getActivity(int activityId) => activitiesRepo.getActivity(activityId);

  Future<List<Activity>> getActivitiesInProject(int projectId) => activitiesRepo.getAllActivitesInProject(projectId);

  Future<Duration> getDurationForDay(DateTime day) async {
    final activites = await activitiesRepo.getActivitesAtDate(day);
    return activites.fold<Duration>(Duration(), (Duration prev, Activity current) => prev + current.duration);
  }

  Future<Duration> getDurationForDayInProject(
      int projectId, DateTime day) async {
    final activites = await activitiesRepo.getActivitiesForDateInProject(projectId, day);
    return activites.fold<Duration>(Duration(), (Duration prev, Activity current) => prev + current.duration);
  }

  Future<int> getTotalHoursInProject(int projectId) async {
    final activites = await activitiesRepo.getAllActivitesInProject(projectId);
    return activites.fold<int>(0, (int prev, Activity current) => prev + current.duration.inHours);
  }

  Future<Duration> getDurationInProject(int projectId) async {
    final activites = await activitiesRepo.getAllActivitesInProject(projectId);
    return activites.fold<Duration>(Duration(), (Duration prev, Activity current) => prev + current.duration);
  }

  Stream<Duration> getDurationInProjectStream(int projectId) {
    final activitesStream = activitiesRepo.getAllActivitesInProjectStream(projectId);
    final durationStream = activitesStream.map<Duration>((List<Activity> activites) => activites.fold<Duration>(Duration(), (Duration prev, Activity current) => prev + current.duration));
    return durationStream;
  }
}
