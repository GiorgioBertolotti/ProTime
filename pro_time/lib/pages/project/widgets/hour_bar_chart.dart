import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pro_time/get_it_setup.dart';
import 'package:pro_time/model/project_with_activities.dart';
import 'package:pro_time/pages/project/widgets/stepper_button.dart';
import 'package:pro_time/services/activities/activities_service.dart';

class HourBarChart extends StatefulWidget {
  final ProjectWithActivities projectWithActivities;
  final Color backgroundColor;
  final ActivitiesService activitiesService = getIt<ActivitiesService>();

  HourBarChart(this.projectWithActivities, this.backgroundColor);

  @override
  _HourBarChartState createState() => _HourBarChartState();
}

class _HourBarChartState extends State<HourBarChart> {
  int touchedIndex;
  final barTouchedResultStreamController = StreamController<BarTouchResponse>();
  StreamController<List<Duration>> streamController = StreamController();
  List<DateTime> dates;
  @override
  void initState() {
    getActivitiesForWeek();

    barTouchedResultStreamController.stream
        .distinct()
        .listen((BarTouchResponse response) {
      if (response == null) {
        return;
      }
      if (response.spot == null) {
        setState(() {
          touchedIndex = -1;
        });
        return;
      }
      setState(() {
        if (response.touchInput is FlLongPressEnd) {
          touchedIndex = -1;
        } else {
          touchedIndex = response.spot.touchedBarGroupIndex;
        }
      });
    });
    super.initState();
  }

  getActivitiesForWeek() async {
    DateTime date1 = DateTime.now();
    final List<Future<Duration>> weekHoursFutures = [];
    for (var i = 6; i >= 0; i--) {
      final date = date1.subtract(Duration(days: i));
      print(date.toLocal());
      weekHoursFutures.add(widget.activitiesService.getDurationForDay(date));
    }
    final hours = await Future.wait(weekHoursFutures);
    streamController.add(hours);
  }

  @override
  dispose() {
    streamController?.close();
    barTouchedResultStreamController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StepperButton(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "nov. 1",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "nov. 7",
                  style: TextStyle(color: Colors.white),
                )
              ],
            )
          ],
        ),
        StreamBuilder(
          stream: streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final barChartData = getBarChartData(snapshot.data);
            return Expanded(
              child: BarChart(
                mainBarData(barChartData),
              ),
            );
          },
        ),
      ],
    );
  }

  BarChartData mainBarData(List<BarChartGroupData> barChartData) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: widget.projectWithActivities.mainColor,
          getTooltipItem: (BarChartGroupData groupData, int groupIndex,
              BarChartRodData rodData, int rodIndex) {
            List days = [
              'Monday',
              'Tuesday',
              'Wednesday',
              'Thursday',
              'Friday',
              'Saturday',
              'Sunday'
            ];

            return BarTooltipItem(
              days[days[groupIndex]],
              TextStyle(
                color: widget.projectWithActivities.textColor,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
            showTitles: true,
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            margin: 16,
            getTitles: (double value) {
              switch (value.toInt()) {
                case 0:
                  return 'M';
                case 1:
                  return 'T';
                case 2:
                  return 'W';
                case 3:
                  return 'T';
                case 4:
                  return 'F';
                case 5:
                  return 'S';
                case 6:
                  return 'S';
                default:
                  return '';
              }
            }),
        leftTitles: const SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: barChartData,
    );
  }

  List<BarChartGroupData> getBarChartData(List<Duration> hours) {
    return List.generate(7, (i) {
      return makeGroupData(i, roundDecimal(hours[i].inSeconds / 60, 1),
          isTouched: i == 0);
    });
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
  }) {
    // @TODO: calculate max value
    final maxVal = 10.0;
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        y: y,
        color: isTouched ? widget.projectWithActivities.mainColor : barColor,
        width: width,
        isRound: true,
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          y: maxVal,
          color: widget.backgroundColor,
        ),
      ),
    ]);
  }

  double roundDecimal(double number, int decimals) {
    return double.parse(number.toStringAsFixed(decimals));
  }
}
