import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class ActivityLogsScreen extends StatelessWidget {
  const ActivityLogsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.grey[100],
        title: Text("Activity Logs", style: TextStyle(fontFamily: "Brand Bold", color: Colors.red[300]),),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Center(
          child: Text("Activity Logs Screen"),
        ),
      ),
    );
  }
}
