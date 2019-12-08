
import 'package:moor_flutter/moor_flutter.dart';

class DurationConverter extends TypeConverter<Duration, int> {
  const DurationConverter();
  @override
  Duration mapToDart(int seconds) {
    if (seconds == null) {
      return null;
    }
    return Duration(seconds: seconds);
  }

  @override
  int mapToSql(Duration duration) {
    if (duration == null) {
      return null;
    }

    return duration.inSeconds;
  }
}
