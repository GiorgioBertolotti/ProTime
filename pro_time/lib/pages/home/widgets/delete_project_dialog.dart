import 'package:flutter/material.dart';
import 'package:pro_time/main.dart';
import 'package:pro_time/model/project.dart';

class DeleteProjectDialog extends StatelessWidget {
  DeleteProjectDialog(
    this.project,
    this.onConfirm, {
    Key key,
  }) : super(key: key);

  final Project project;
  final Function onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete " + project.name + "?"),
      actions: <Widget>[
        FlatButton(
          textColor: Theme.of(context).textTheme.button.color,
          child: Text("Cancel"),
          onPressed: () {
            ProTime.navigatorKey.currentState.pop();
          },
        ),
        FlatButton(
          textColor: Colors.deepOrange,
          child: Text("Confirm"),
          onPressed: () {
            onConfirm();
            ProTime.navigatorKey.currentState.pop();
          },
        ),
      ],
    );
  }
}
