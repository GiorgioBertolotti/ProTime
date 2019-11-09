import 'package:flutter/material.dart';

class TimerText extends StatelessWidget {
  const TimerText({
    Key key,
    @required this.hours,
    @required this.hoursSize,
    @required this.minutes,
    @required this.minutesSize,
    @required this.seconds,
    @required this.secondsSize,
  }) : super(key: key);

  final int hours;
  final double hoursSize;
  final int minutes;
  final double minutesSize;
  final int seconds;
  final double secondsSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(color: Theme.of(context).textTheme.headline.color),
        children: [
          hours != 0
              ? TextSpan(
                  text: hours.toString() + "H\n",
                  style: TextStyle(
                    fontSize: hoursSize,
                    height: 0.9,
                  ),
                )
              : TextSpan(),
          TextSpan(
            text: minutes.toString() + "m" + (hours != 0 ? "" : "\n"),
            style: TextStyle(
              fontSize: minutesSize,
              height: 0.9,
            ),
          ),
          hours == 0
              ? TextSpan(
                  text: (seconds < 10
                          ? ("0" + seconds.toString())
                          : seconds.toString()) +
                      "s",
                  style: TextStyle(
                    fontSize: secondsSize,
                    height: 0.9,
                  ),
                )
              : TextSpan(),
        ],
      ),
    );
  }
}
