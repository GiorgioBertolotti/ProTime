import 'package:flutter/material.dart';

class StepperButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          onPressed: () async {
            print("im here");
          },
        ),
        IconButton(
          icon: Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
          onPressed: () async {
            print("im here");
          },
        ),
      ],
    );
  }
}
