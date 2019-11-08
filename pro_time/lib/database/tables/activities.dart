
import 'package:moor_flutter/moor_flutter.dart';
import 'package:pro_time/database/converters/duration_converter.dart';

@DataClassName("Activity")
class Activities extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer()();
  DateTimeColumn get startDateTime => dateTime()();
  IntColumn get duration => integer().map(const DurationConverter())();
}
