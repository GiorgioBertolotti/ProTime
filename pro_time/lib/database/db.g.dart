// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Project extends DataClass implements Insertable<Project> {
  final int id;
  final String name;
  final dynamic textColor;
  final dynamic mainColor;
  final DateTime created;
  final bool notificationEnabled;
  Project(
      {@required this.id,
      @required this.name,
      @required this.textColor,
      @required this.mainColor,
      @required this.created,
      @required this.notificationEnabled});
  factory Project.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Project(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      textColor: $ProjectsTable.$converter0.mapToDart(intType
          .mapFromDatabaseResponse(data['${effectivePrefix}text_color'])),
      mainColor: $ProjectsTable.$converter1.mapToDart(intType
          .mapFromDatabaseResponse(data['${effectivePrefix}main_color'])),
      created: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created']),
      notificationEnabled: boolType.mapFromDatabaseResponse(
          data['${effectivePrefix}notification_enabled']),
    );
  }
  factory Project.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Project(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      textColor: serializer.fromJson<dynamic>(json['textColor']),
      mainColor: serializer.fromJson<dynamic>(json['mainColor']),
      created: serializer.fromJson<DateTime>(json['created']),
      notificationEnabled:
          serializer.fromJson<bool>(json['notificationEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'textColor': serializer.toJson<dynamic>(textColor),
      'mainColor': serializer.toJson<dynamic>(mainColor),
      'created': serializer.toJson<DateTime>(created),
      'notificationEnabled': serializer.toJson<bool>(notificationEnabled),
    };
  }

  @override
  ProjectsCompanion createCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      textColor: textColor == null && nullToAbsent
          ? const Value.absent()
          : Value(textColor),
      mainColor: mainColor == null && nullToAbsent
          ? const Value.absent()
          : Value(mainColor),
      created: created == null && nullToAbsent
          ? const Value.absent()
          : Value(created),
      notificationEnabled: notificationEnabled == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationEnabled),
    );
  }

  Project copyWith(
          {int id,
          String name,
          dynamic textColor,
          dynamic mainColor,
          DateTime created,
          bool notificationEnabled}) =>
      Project(
        id: id ?? this.id,
        name: name ?? this.name,
        textColor: textColor ?? this.textColor,
        mainColor: mainColor ?? this.mainColor,
        created: created ?? this.created,
        notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      );
  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('textColor: $textColor, ')
          ..write('mainColor: $mainColor, ')
          ..write('created: $created, ')
          ..write('notificationEnabled: $notificationEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              textColor.hashCode,
              $mrjc(mainColor.hashCode,
                  $mrjc(created.hashCode, notificationEnabled.hashCode))))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.textColor == this.textColor &&
          other.mainColor == this.mainColor &&
          other.created == this.created &&
          other.notificationEnabled == this.notificationEnabled);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<int> id;
  final Value<String> name;
  final Value<dynamic> textColor;
  final Value<dynamic> mainColor;
  final Value<DateTime> created;
  final Value<bool> notificationEnabled;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.textColor = const Value.absent(),
    this.mainColor = const Value.absent(),
    this.created = const Value.absent(),
    this.notificationEnabled = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required dynamic textColor,
    @required dynamic mainColor,
    @required DateTime created,
    this.notificationEnabled = const Value.absent(),
  })  : name = Value(name),
        textColor = Value(textColor),
        mainColor = Value(mainColor),
        created = Value(created);
  ProjectsCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<dynamic> textColor,
      Value<dynamic> mainColor,
      Value<DateTime> created,
      Value<bool> notificationEnabled}) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      textColor: textColor ?? this.textColor,
      mainColor: mainColor ?? this.mainColor,
      created: created ?? this.created,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
    );
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  final GeneratedDatabase _db;
  final String _alias;
  $ProjectsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _textColorMeta = const VerificationMeta('textColor');
  GeneratedIntColumn _textColor;
  @override
  GeneratedIntColumn get textColor => _textColor ??= _constructTextColor();
  GeneratedIntColumn _constructTextColor() {
    return GeneratedIntColumn(
      'text_color',
      $tableName,
      false,
    );
  }

  final VerificationMeta _mainColorMeta = const VerificationMeta('mainColor');
  GeneratedIntColumn _mainColor;
  @override
  GeneratedIntColumn get mainColor => _mainColor ??= _constructMainColor();
  GeneratedIntColumn _constructMainColor() {
    return GeneratedIntColumn(
      'main_color',
      $tableName,
      false,
    );
  }

  final VerificationMeta _createdMeta = const VerificationMeta('created');
  GeneratedDateTimeColumn _created;
  @override
  GeneratedDateTimeColumn get created => _created ??= _constructCreated();
  GeneratedDateTimeColumn _constructCreated() {
    return GeneratedDateTimeColumn(
      'created',
      $tableName,
      false,
    );
  }

  final VerificationMeta _notificationEnabledMeta =
      const VerificationMeta('notificationEnabled');
  GeneratedBoolColumn _notificationEnabled;
  @override
  GeneratedBoolColumn get notificationEnabled =>
      _notificationEnabled ??= _constructNotificationEnabled();
  GeneratedBoolColumn _constructNotificationEnabled() {
    return GeneratedBoolColumn('notification_enabled', $tableName, false,
        defaultValue: const Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, name, textColor, mainColor, created, notificationEnabled];
  @override
  $ProjectsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'projects';
  @override
  final String actualTableName = 'projects';
  @override
  VerificationContext validateIntegrity(ProjectsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_textColorMeta, const VerificationResult.success());
    context.handle(_mainColorMeta, const VerificationResult.success());
    if (d.created.present) {
      context.handle(_createdMeta,
          created.isAcceptableValue(d.created.value, _createdMeta));
    } else if (created.isRequired && isInserting) {
      context.missing(_createdMeta);
    }
    if (d.notificationEnabled.present) {
      context.handle(
          _notificationEnabledMeta,
          notificationEnabled.isAcceptableValue(
              d.notificationEnabled.value, _notificationEnabledMeta));
    } else if (notificationEnabled.isRequired && isInserting) {
      context.missing(_notificationEnabledMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Project.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ProjectsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.textColor.present) {
      final converter = $ProjectsTable.$converter0;
      map['text_color'] =
          Variable<int, IntType>(converter.mapToSql(d.textColor.value));
    }
    if (d.mainColor.present) {
      final converter = $ProjectsTable.$converter1;
      map['main_color'] =
          Variable<int, IntType>(converter.mapToSql(d.mainColor.value));
    }
    if (d.created.present) {
      map['created'] = Variable<DateTime, DateTimeType>(d.created.value);
    }
    if (d.notificationEnabled.present) {
      map['notification_enabled'] =
          Variable<bool, BoolType>(d.notificationEnabled.value);
    }
    return map;
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(_db, alias);
  }

  static ColorConverter $converter0 = const ColorConverter();
  static ColorConverter $converter1 = const ColorConverter();
}

class Activity extends DataClass implements Insertable<Activity> {
  final int id;
  final int projectId;
  final DateTime startDateTime;
  final Duration duration;
  Activity(
      {@required this.id,
      @required this.projectId,
      @required this.startDateTime,
      @required this.duration});
  factory Activity.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Activity(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      projectId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}project_id']),
      startDateTime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}start_date_time']),
      duration: $ActivitiesTable.$converter0.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}duration'])),
    );
  }
  factory Activity.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Activity(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      startDateTime: serializer.fromJson<DateTime>(json['startDateTime']),
      duration: serializer.fromJson<Duration>(json['duration']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'startDateTime': serializer.toJson<DateTime>(startDateTime),
      'duration': serializer.toJson<Duration>(duration),
    };
  }

  @override
  ActivitiesCompanion createCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      startDateTime: startDateTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startDateTime),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
    );
  }

  Activity copyWith(
          {int id, int projectId, DateTime startDateTime, Duration duration}) =>
      Activity(
        id: id ?? this.id,
        projectId: projectId ?? this.projectId,
        startDateTime: startDateTime ?? this.startDateTime,
        duration: duration ?? this.duration,
      );
  @override
  String toString() {
    return (StringBuffer('Activity(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('startDateTime: $startDateTime, ')
          ..write('duration: $duration')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(projectId.hashCode,
          $mrjc(startDateTime.hashCode, duration.hashCode))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Activity &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.startDateTime == this.startDateTime &&
          other.duration == this.duration);
}

class ActivitiesCompanion extends UpdateCompanion<Activity> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<DateTime> startDateTime;
  final Value<Duration> duration;
  const ActivitiesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.startDateTime = const Value.absent(),
    this.duration = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    this.id = const Value.absent(),
    @required int projectId,
    @required DateTime startDateTime,
    @required Duration duration,
  })  : projectId = Value(projectId),
        startDateTime = Value(startDateTime),
        duration = Value(duration);
  ActivitiesCompanion copyWith(
      {Value<int> id,
      Value<int> projectId,
      Value<DateTime> startDateTime,
      Value<Duration> duration}) {
    return ActivitiesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      startDateTime: startDateTime ?? this.startDateTime,
      duration: duration ?? this.duration,
    );
  }
}

class $ActivitiesTable extends Activities
    with TableInfo<$ActivitiesTable, Activity> {
  final GeneratedDatabase _db;
  final String _alias;
  $ActivitiesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _projectIdMeta = const VerificationMeta('projectId');
  GeneratedIntColumn _projectId;
  @override
  GeneratedIntColumn get projectId => _projectId ??= _constructProjectId();
  GeneratedIntColumn _constructProjectId() {
    return GeneratedIntColumn(
      'project_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _startDateTimeMeta =
      const VerificationMeta('startDateTime');
  GeneratedDateTimeColumn _startDateTime;
  @override
  GeneratedDateTimeColumn get startDateTime =>
      _startDateTime ??= _constructStartDateTime();
  GeneratedDateTimeColumn _constructStartDateTime() {
    return GeneratedDateTimeColumn(
      'start_date_time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _durationMeta = const VerificationMeta('duration');
  GeneratedIntColumn _duration;
  @override
  GeneratedIntColumn get duration => _duration ??= _constructDuration();
  GeneratedIntColumn _constructDuration() {
    return GeneratedIntColumn(
      'duration',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, projectId, startDateTime, duration];
  @override
  $ActivitiesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'activities';
  @override
  final String actualTableName = 'activities';
  @override
  VerificationContext validateIntegrity(ActivitiesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.projectId.present) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableValue(d.projectId.value, _projectIdMeta));
    } else if (projectId.isRequired && isInserting) {
      context.missing(_projectIdMeta);
    }
    if (d.startDateTime.present) {
      context.handle(
          _startDateTimeMeta,
          startDateTime.isAcceptableValue(
              d.startDateTime.value, _startDateTimeMeta));
    } else if (startDateTime.isRequired && isInserting) {
      context.missing(_startDateTimeMeta);
    }
    context.handle(_durationMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Activity map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Activity.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ActivitiesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.projectId.present) {
      map['project_id'] = Variable<int, IntType>(d.projectId.value);
    }
    if (d.startDateTime.present) {
      map['start_date_time'] =
          Variable<DateTime, DateTimeType>(d.startDateTime.value);
    }
    if (d.duration.present) {
      final converter = $ActivitiesTable.$converter0;
      map['duration'] =
          Variable<int, IntType>(converter.mapToSql(d.duration.value));
    }
    return map;
  }

  @override
  $ActivitiesTable createAlias(String alias) {
    return $ActivitiesTable(_db, alias);
  }

  static DurationConverter $converter0 = const DurationConverter();
}

abstract class _$ProtimeDb extends GeneratedDatabase {
  _$ProtimeDb(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $ProjectsTable _projects;
  $ProjectsTable get projects => _projects ??= $ProjectsTable(this);
  $ActivitiesTable _activities;
  $ActivitiesTable get activities => _activities ??= $ActivitiesTable(this);
  ProjectDao _projectDao;
  ProjectDao get projectDao => _projectDao ??= ProjectDao(this as ProtimeDb);
  ActivityDao _activityDao;
  ActivityDao get activityDao =>
      _activityDao ??= ActivityDao(this as ProtimeDb);
  @override
  List<TableInfo> get allTables => [projects, activities];
}
