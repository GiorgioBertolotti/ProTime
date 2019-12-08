import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:pro_time/model/deprecated/projects.dart';

class ProjectsAdapter extends TypeAdapter<Project> {
  @override
  Project read(BinaryReader reader) {
    var obj = Project();
    var numOfFields = reader.readByte();
    for (var i = 0; i < numOfFields; i++) {
      switch (reader.readByte()) {
        case 0:
          obj.name = reader.read() as String;
          break;
        case 1:
          obj.mainColor = Color(reader.read() as int);
          break;
        case 2:
          obj.textColor = Color(reader.read() as int);
          break;
        case 3:
          obj.created = reader.read() as DateTime;
          break;
        case 4:
          List<dynamic> tmpList = reader.read() as List;
          if (tmpList == null || tmpList.isEmpty)
            obj.activities = List<Activity>();
          else {
            List<Activity> activities = tmpList.cast<Activity>().toList();
            if (activities == null)
              obj.activities = List<Activity>();
            else
              obj.activities = activities;
          }
          break;
        case 5:
          obj.notificationEnabled = reader.read() as bool;
          break;
      }
    }
    return obj;
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer.writeByte(6);
    writer.writeByte(0);
    writer.write(obj.name);
    writer.writeByte(1);
    writer.write(obj.mainColor.value);
    writer.writeByte(2);
    writer.write(obj.textColor.value);
    writer.writeByte(3);
    writer.write(obj.created);
    writer.writeByte(4);
    writer.write(obj.activities);
    writer.writeByte(5);
    writer.write(obj.notificationEnabled);
  }
}