import 'package:hive/hive.dart';
import 'package:pro_time/model/deprecated/projects.dart';

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  Activity read(BinaryReader reader) {
    var obj = Activity();
    var numOfFields = reader.readByte();
    for (var i = 0; i < numOfFields; i++) {
      switch (reader.readByte()) {
        case 0:
          List<dynamic> tmpList = reader.read() as List;
          if (tmpList == null || tmpList.isEmpty)
            obj.subActivities = List<SubActivity>();
          else {
            List<SubActivity> activities = tmpList.cast<SubActivity>().toList();
            if (activities == null)
              obj.subActivities = List<SubActivity>();
            else
              obj.subActivities = activities;
          }
          break;
      }
    }
    return obj;
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer.writeByte(1);
    writer.writeByte(0);
    writer.write(obj.subActivities);
  }
}