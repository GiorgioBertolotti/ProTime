
import 'package:moor_flutter/moor_flutter.dart';
import 'package:pro_time/database/converters/color_converter.dart';

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get textColor => integer().map(const ColorConverter())();
  IntColumn get mainColor => integer().map(const ColorConverter())();
  DateTimeColumn get created => dateTime()();
  BoolColumn get notificationEnabled => boolean().withDefault(const Constant(false))();
}

