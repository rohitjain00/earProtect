import 'package:clock/clock.dart';
import 'package:earprotect/file.dart';
import 'package:flutter/material.dart';

class TimeCalculate extends StatefulWidget {
  @override
  TimeCalculateState createState() => TimeCalculateState();
  final int decibal;
  const TimeCalculate({Key key, this.decibal}) : super(key: key);
}

class TimeCalculateState extends State<TimeCalculate> {
  static int startLevel;
  static int endLevel;
  static int levelWidth;
  static List<double> timeElapsed;

  void initState() {
    super.initState();
    startLevel = 0;
    endLevel = 100;
    levelWidth = 10;
    List<dynamic> tempList = File.retrieveCounter();
    if (tempList.length == 0) {
      timeElapsed = new List.filled(
        ((endLevel - startLevel) / levelWidth).round(),
        0.0,
        growable: false,
      );
    } else {
      timeElapsed = new List<double>.from(tempList);
    }
  }

  String timeFormatter(double time) {
    Duration duration = Duration(seconds: time.round());

    return [duration.inHours, duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  @override
  Widget build(BuildContext context) {
    if (timeElapsed.length == 0) {
      this.initState();
    }
    if (widget.decibal != null) {
      if (widget.decibal > startLevel && widget.decibal < endLevel) {
        int indexToUpdate = (widget.decibal / levelWidth).floor() -
            (startLevel / levelWidth).round();
        if (indexToUpdate < startLevel || indexToUpdate > endLevel) {
        } else {
          timeElapsed[indexToUpdate] += 0.5;
          print(
              '${widget.decibal} ${(widget.decibal / levelWidth).floor() - (startLevel / levelWidth).round()}');
          File.syncCounter(timeElapsed);
        }
      }
    }
    return ListView.builder(
      itemCount: timeElapsed.length,
      itemBuilder: (context, index) {
        int rangeStart = startLevel + (levelWidth * index);
        int rangeEnd = rangeStart + levelWidth;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  '$rangeStart - $rangeEnd',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Text(
                  '${timeFormatter(timeElapsed[index])}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
