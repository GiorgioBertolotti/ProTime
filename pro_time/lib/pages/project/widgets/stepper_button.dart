import 'package:flutter/material.dart';

class StepperButton extends StatelessWidget {
  final Function onLeftTap;
  final Function onRightTap;

  const StepperButton({Key key, this.onLeftTap, this.onRightTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: IconButton(
            icon: Icon(
              Icons.chevron_left,
            ),
            onPressed: onLeftTap,
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        IconButton(
          icon: Icon(
            Icons.chevron_right,
          ),
          onPressed: onRightTap,
        ),
      ],
    );
  }
}
