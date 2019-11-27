import 'package:moor_flutter/moor_flutter.dart';
import 'package:pro_time/database/converters/color_converter.dart';
import 'package:pro_time/database/dao/activity_dao.dart';
import 'package:pro_time/database/dao/project_dao.dart';
import 'package:pro_time/database/tables/activities.dart';
import 'package:pro_time/database/tables/projects.dart';
import 'converters/color_converter.dart';
import 'converters/duration_converter.dart';

part 'db.g.dart';

@UseMoor(tables: [Projects, Activities], daos: [ProjectDao, ActivityDao])
class ProtimeDb extends _$ProtimeDb {
  ProtimeDb() : super(FlutterQueryExecutor.inDatabaseFolder(path: 'protime.sqlite'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAllTables();
        },
        onUpgrade: (Migrator m, int from, int to) async {
        },
      );
}
