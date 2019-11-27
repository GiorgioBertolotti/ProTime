import 'package:flutter/material.dart';
import 'package:pro_time/pages/home/widgets/color_picker.dart';

class ColorButton extends StatelessWidget {
  const ColorButton({
    Key key,
    @required this.onTap,
    @required this.title,
    @required this.color,
  }) : super(key: key);

  final Function(Color) onTap;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.withAlpha(100)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        onTap: () async {
          var newColor = await showDialog(
            context: context,
            builder: (ctx) {
              return ColorDialog(
                initialColor: color,
              );
            },
          );
          if (newColor != null) {
            onTap(newColor);
          }
        },
        title: Text(title),
        trailing: Container(
          width: 35.0,
          height: 35.0,
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: CircleAvatar(
              backgroundColor: color,
              radius: 35.0,
            ),
          ),
        ),
      ),
    );
  }
}
