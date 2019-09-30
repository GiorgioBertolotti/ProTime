import 'package:hive/hive.dart';
import 'package:pro_time/model/project.dart';

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  Activity read(BinaryReader reader) {
    var obj = Activity();
    var numOfFields = reader.readByte();
    for (var i = 0; i < numOfFields; i++) {
      switch (reader.readByte()) {
        case 0:
          obj.dateTimeStart = reader.read() as DateTime;
          break;
        case 1:
          obj.activityDuration = Duration(seconds: reader.read() as int);
          break;
      }
    }
    return obj;
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer.writeByte(2);
    writer.writeByte(0);
    writer.write(obj.dateTimeStart);
    writer.writeByte(1);
    writer.write(obj.activityDuration.inSeconds);
  }
}
