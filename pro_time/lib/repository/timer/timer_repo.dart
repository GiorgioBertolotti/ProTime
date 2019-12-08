
import 'package:pro_time/model/time.dart';

abstract class TimerRepo {
  TimerInfo getTimer();
  // Stops the timer and returns a TimerInfo containg the final total duration 
  TimerInfo stopTimer();
  // Pauses the timer and returns a TimerInfo containg the new total duration 
  TimerInfo pauseTimer();
  TimerInfo startTimer(int projectId);
  TimerInfo resumeTimer();
}