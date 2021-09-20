import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.grey[100],
          title: Text("Events", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Colors.red[300],
          ),),
        ),
        body: Container(
          child: Center(
            child: Text("Events Screen"),
          ),
        ),
      ),
    );
  }
}
