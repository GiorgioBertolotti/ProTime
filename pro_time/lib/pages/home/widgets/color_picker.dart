import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pro_time/main.dart';

class ColorDialog extends StatefulWidget {
  ColorDialog({this.initialColor = Colors.white});

  final Color initialColor;

  @override
  _ColorDialogState createState() => _ColorDialogState();
}

class _ColorDialogState extends State<ColorDialog> {
  Color _selectedColor;
  Color _customColor;
  List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.pink,
    Colors.yellow,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.white,
    Colors.black,
  ];

  @override
  void initState() {
    if (_colors.contains(widget.initialColor))
      _selectedColor = widget.initialColor;
    else {
      _customColor = widget.initialColor;
      _selectedColor = _customColor;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Pick a color"),
      content: Container(
        width: MediaQuery.of(context).size.width * .7,
        padding: EdgeInsets.only(top: 10.0),
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 5,
          children: List.generate(10, (index) {
            if (index == 0) {
              List<double> invertMatr = [
                -1, 0, 0, 0, 255, //
                0, -1, 0, 0, 255, //
                0, 0, -1, 0, 255, //
                0, 0, 0, 1, 0, //
              ];
              return GestureDetector(
                onTap: () async {
                  var color = await openColorPickerDialog(
                      context, "Advanced picker", _selectedColor);
                  if (color != null)
                    setState(() {
                      _customColor = color;
                      _selectedColor = _customColor;
                    });
                },
                child: Container(
                  margin: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      color: _customColor == _selectedColor
                          ? Theme.of(context).textTheme.button.color
                          : Colors.grey.withAlpha(100),
                      shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                      backgroundColor: _customColor ?? Colors.white,
                      radius: 100.0,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.matrix(invertMatr),
                        child: Icon(
                          Icons.colorize,
                          color: _customColor ?? Colors.white,
                          size: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              Color color = _colors[index - 1];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      color: (color == _selectedColor && _customColor != color)
                          ? Theme.of(context).textTheme.button.color
                          : Colors.grey.withAlpha(100),
                      shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                      backgroundColor: color,
                      radius: 100.0,
                    ),
                  ),
                ),
              );
            }
          }),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          textColor: Colors.deepOrange,
          child: Text("Cancel"),
          onPressed: () {
            ProTime.navigatorKey.currentState.pop();
          },
        ),
        FlatButton(
          textColor: Theme.of(context).textTheme.button.color,
          child: Text("Confirm"),
          onPressed: () {
            ProTime.navigatorKey.currentState.pop(_selectedColor);
          },
        ),
      ],
    );
  }

  Future openColorPickerDialog(
      BuildContext context, String title, Color startColor) {
    var newColor;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: startColor,
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
                textColor: Theme.of(context).textTheme.button.color,
                child: Text("Select"),
                onPressed: () => Navigator.of(context).pop(newColor)),
          ],
        );
      },
    );
  }
}
