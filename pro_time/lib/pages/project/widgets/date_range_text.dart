
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeText extends StatelessWidget {
  const DateRangeText({
    Key key,
    @required this.startDate,
    @required this.endDate,
  }) : super(key: key);

  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat('d.MMM').format(startDate),
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(
          width: 2.0,
        ),
        Text(
          " - ",
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(
          width: 2.0,
        ),
        Text(
          DateFormat('d.MMM').format(endDate),
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
}
