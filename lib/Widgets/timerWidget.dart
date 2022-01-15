import 'dart:async';

import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class TimerController extends ValueNotifier<bool>{
TimerController({bool isPlaying = false}) : super(isPlaying);

void startTimer() => value = true;

void stopTimer() => value = false;
}

class TimerWidget extends StatefulWidget {
  final TimerController controller;
  final double height;
  final Color color;
  TimerWidget({Key key, @required this.controller, this.height, this.color}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration duration = Duration();
  Timer timer;

  @override
  void initState() {
    if (widget.controller.value) {
      startTimer();
    }
    widget.controller.addListener(() {
      if (widget.controller.value) {
        startTimer();
      } else {
        stopTimer();
      }
    });
    super.initState();
  }

  void reset() => setState(() => duration = Duration(hours: 0, minutes: 0, seconds: 0));

  void addTime() {
    final addSeconds = 1;

    setState(() {
      int seconds = duration.inSeconds + addSeconds;

      if (seconds < 0) {
        timer.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer({bool resets = true}) {
    if (!mounted) return;
    if (resets) {
      reset();
    }

    setState(() {
      timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
    });
  }

  void stopTimer({bool resets = true}) {
    if (!mounted) return;
    if (resets) {
      reset();
    }
    setState(() => timer.cancel());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: 15 * SizeConfig.widthMultiplier,
        height: widget.height != null ? widget.height : 4 * SizeConfig.heightMultiplier,
        decoration: BoxDecoration(
          gradient: widget.color != null ? null : kPrimaryGradientColor,
          color: widget.color != null ? widget.color : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: buildTime(),
        ),
      ),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    return Text(
      '$minutes:$seconds',
      style: TextStyle(
        fontFamily: "Brand Bold",
        color: Colors.white,
        fontSize: 2 * SizeConfig.textMultiplier,
      ),
    );
  }
}
