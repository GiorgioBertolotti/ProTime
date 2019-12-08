import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  const EditButton({
    Key key,
    @required this.onTap,
    @required this.title,
    @required this.text,
  }) : super(key: key);

  final Function onTap;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.withAlpha(100)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(title),
        trailing: Text(text),
      ),
    );
  }
}
