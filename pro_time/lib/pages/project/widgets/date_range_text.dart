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
        ),
        SizedBox(
          width: 2.0,
        ),
        Text(
          " - ",
        ),
        SizedBox(
          width: 2.0,
        ),
        Text(
          DateFormat('d.MMM').format(endDate),
        )
      ],
    );
  }
}
