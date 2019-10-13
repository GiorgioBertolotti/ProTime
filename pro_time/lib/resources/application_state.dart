import 'package:hive/hive.dart';
import 'package:pro_time/main.dart';
import 'package:pro_time/model/project.dart';

class ApplicationState {
  TimerState timerState = TimerState.STOPPED;
  Project _currentProject;
  Activity _currentActivity;

  Project getCurrentProject() => _currentProject;

  int getSecondsCounter() {
    if (this._currentProject == null) return null;
    if (this._currentActivity == null) {
      this._currentActivity = this._currentProject.getIncompleteActivity();
      if (this._currentActivity == null) return null;
    }
    SubActivity incomplete = this._currentActivity.getIncompleteSubActivity();
    if (incomplete == null)
      return this._currentActivity.getDuration().inSeconds;
    else
      return this._currentActivity.getDuration().inSeconds +
          DateTime.now().difference(incomplete.dateTimeStart).inSeconds;
  }

  setCurrentProject(Project project) {
    this._currentProject = project;
    if (this._currentProject.hasIncompleteActivities()) {
      this.timerState = TimerState.STARTED;
      this._currentActivity = this._currentProject.getIncompleteActivity();
    }
  }

  startTimer() {
    if (this._currentProject == null) return;
    DateTime dateTimeStart = DateTime.now();
    switch (timerState) {
      case TimerState.STOPPED:
        this._currentActivity = Activity();
        SubActivity subActivity = SubActivity(dateTimeStart: dateTimeStart);
        this._currentActivity.subActivities.add(subActivity);
        this._currentProject.activities.add(this._currentActivity);
        break;
      case TimerState.PAUSED:
        if (this._currentActivity == null) {
          this._currentActivity = Activity();
          this._currentProject.activities.add(this._currentActivity);
        }
        SubActivity subActivity = SubActivity(dateTimeStart: dateTimeStart);
        this._currentActivity.subActivities.add(subActivity);
        break;
      case TimerState.STARTED:
        break;
    }
    _saveProject(_currentProject);
    timerState = TimerState.STARTED;
  }

  pauseTimer() {
    SubActivity incomplete = this._currentActivity.getIncompleteSubActivity();
    if (incomplete != null) {
      Duration activityDuration =
          DateTime.now().difference(incomplete.dateTimeStart);
      incomplete.activityDuration = activityDuration;
    }
    _saveProject(_currentProject);
    timerState = TimerState.PAUSED;
  }

  stopTimer() {
    if (timerState == TimerState.STARTED) {
      SubActivity incomplete = this._currentActivity.getIncompleteSubActivity();
      if (incomplete != null) {
        Duration activityDuration =
            DateTime.now().difference(incomplete.dateTimeStart);
        incomplete.activityDuration = activityDuration;
      }
    }
    _saveProject(_currentProject);
    this._currentProject = null;
    this._currentActivity = null;
    timerState = TimerState.STOPPED;
  }

  _saveProject(Project project) {
    Hive.box('projects').put(project.id, project);
  }
}
