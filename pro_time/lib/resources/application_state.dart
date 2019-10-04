import 'package:hive/hive.dart';
import 'package:pro_time/main.dart';
import 'package:pro_time/model/project.dart';

class ApplicationState {
  TimerState timerState = TimerState.STOPPED;
  Project _currentProject;
  Activity _currentActivity;
  DateTime _dateTimeStart;

  Project getCurrentProject() => _currentProject;

  int getSecondsCounter() {
    if (_dateTimeStart == null && _currentActivity == null) return null;
    if (_dateTimeStart == null)
      return _currentActivity.getDuration().inSeconds;
    else
      return _currentActivity.getDuration().inSeconds +
          DateTime.now().difference(_dateTimeStart).inSeconds;
  }

  startTimer({Project project}) {
    switch (timerState) {
      case TimerState.STOPPED:
        if (this._currentProject == null && project == null) return;
        this._currentProject = project;
        this._currentActivity = Activity();
        this._currentProject.activities.add(this._currentActivity);
        break;
      case TimerState.PAUSED:
        if (this._currentProject == null) {
          if (project == null) return;
          this._currentProject = project;
        }
        if (this._currentActivity == null) {
          this._currentActivity = Activity();
          this._currentProject.activities.add(this._currentActivity);
        }
        break;
      case TimerState.STARTED:
        break;
    }
    _dateTimeStart = DateTime.now();
    timerState = TimerState.STARTED;
  }

  pauseTimer() {
    Duration activityDuration = DateTime.now().difference(_dateTimeStart);
    SubActivity subActivity = SubActivity(
        dateTimeStart: _dateTimeStart, activityDuration: activityDuration);
    this._currentActivity.subActivities.add(subActivity);
    _saveProject(_currentProject);
    _dateTimeStart = null;
    timerState = TimerState.PAUSED;
  }

  stopTimer() {
    if (timerState == TimerState.STARTED) {
      Duration activityDuration = DateTime.now().difference(_dateTimeStart);
      SubActivity subActivity = SubActivity(
          dateTimeStart: _dateTimeStart, activityDuration: activityDuration);
      this._currentActivity.subActivities.add(subActivity);
    }
    _saveProject(_currentProject);
    this._currentProject = null;
    this._currentActivity = null;
    this._dateTimeStart = null;
    timerState = TimerState.STOPPED;
  }

  _saveProject(Project project) {
    Hive.box('projects').put(project.id, project);
  }
}
