import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart';

class ColorConverter extends TypeConverter<Color, int> {
  const ColorConverter();
  @override
  Color mapToDart(int fromDb) {
    if (fromDb == null) {
      return null;
    }
    return Color(fromDb);
  }

  @override
  int mapToSql(Color color) {
    if (color == null) {
      return null;
    }

    return color.value;
  }
}
