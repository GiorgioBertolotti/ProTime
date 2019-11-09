import 'package:flutter/material.dart';

class TimeStatsText extends StatelessWidget {
  const TimeStatsText({
    Key key,
    @required this.title,
    @required this.hrs,
    @required this.mins,
    @required this.secs,
  }) : super(key: key);

  final String hrs;
  final String mins;
  final String secs;
  final String title;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(color: Theme.of(context).textTheme.headline.color),
        children: [
          TextSpan(
            text: "$title\n",
            style: TextStyle(
              fontSize: 26.0,
              height: 0.9,
              fontWeight: FontWeight.w900,
            ),
          ),
          TextSpan(
            text: hrs,
            style: TextStyle(
              fontSize: 40.0,
              height: 1.1,
            ),
          ),
          TextSpan(
            text: mins,
            style: TextStyle(
              fontSize: 24.0,
              height: 0.7,
            ),
          ),
          TextSpan(
            text: secs,
            style: TextStyle(
              fontSize: 13.0,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
