import 'package:hive/hive.dart';
import 'package:pro_time/model/deprecated/projects.dart';

class SubActivityAdapter extends TypeAdapter<SubActivity> {
  @override
  SubActivity read(BinaryReader reader) {
    var obj = SubActivity();
    var numOfFields = reader.readByte();
    for (var i = 0; i < numOfFields; i++) {
      switch (reader.readByte()) {
        case 0:
          obj.dateTimeStart = reader.read() as DateTime;
          break;
        case 1:
          if (reader.availableBytes != 0) {
            var val = reader.read();
            if (val != null &&
                (val.runtimeType == int || int.tryParse(val) != null))
              obj.activityDuration = Duration(seconds: val as int);
            else
              obj.activityDuration = null;
          } else
            obj.activityDuration = null;
          break;
      }
    }
    return obj;
  }

  @override
  void write(BinaryWriter writer, SubActivity obj) {
    writer.writeByte(2);
    writer.writeByte(0);
    writer.write(obj.dateTimeStart);
    writer.writeByte(1);
    writer.write(
        obj.activityDuration != null ? obj.activityDuration.inSeconds : null);
  }
}