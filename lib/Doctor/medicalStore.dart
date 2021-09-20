import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class MedicalStore extends StatelessWidget {
  const MedicalStore({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.grey[100],
          title: Text("Medical Store", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Colors.red[300],
          ),),
        ),
        body: Container(
          color: Colors.grey[100],
          height: MediaQuery.of(context).size.height,
          width:  MediaQuery.of(context).size.width,
          child: Center(
            child: Text("Medical Store"),
          ),
        ),
      ),
    );
  }
}
