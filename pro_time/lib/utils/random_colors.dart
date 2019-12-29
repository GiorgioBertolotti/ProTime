import 'dart:math';
import 'package:flutter/material.dart';

// Returns two randon colors. One Bright and one Dark
List<Color> pickRandomColors() {
    List<Color> colors = List(2);
    Random random = Random();
    int posBright = random.nextInt(2);
    if (posBright == 1) {
      colors[0] = _pickDarkColor();
      colors[1] = _pickBrightColor();
    } else {
      colors[0] = _pickBrightColor();
      colors[1] = _pickDarkColor();
    }
    return colors;
  }

  Color _pickDarkColor() {
    Random random = Random();
    int red = random.nextInt(128);
    int green = random.nextInt(128);
    int blue = random.nextInt(128);
    return Color.fromRGBO(red, green, blue, 1.0);
  }

  Color _pickBrightColor() {
    Random random = Random();
    int red = 128 + random.nextInt(128);
    int green = 128 + random.nextInt(128);
    int blue = 128 + random.nextInt(128);
    return Color.fromRGBO(red, green, blue, 1.0);
  }