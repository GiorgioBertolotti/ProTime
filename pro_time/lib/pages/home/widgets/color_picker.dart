import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Future openColoPickerDialog(
  BuildContext context, String title) {
  var newColor;
  return showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: Colors.white,
            onColorChanged: (color) {
              newColor = color;
            },
            enableLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          FlatButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            textColor: Colors.lightBlue,
            child: Text("Select"),
            onPressed: () => Navigator.of(context).pop(newColor)
          ),
        ],
      );
    },
  );
}
