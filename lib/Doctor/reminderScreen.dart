import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/main.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class ReminderScreen extends StatelessWidget {
  final Stream reminderStream;
  ReminderScreen({Key key, this.reminderStream}) : super(key: key);

  Widget reminderList() {
    return StreamBuilder(
      stream: reminderStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Container(
                height: double.infinity,
                child: ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    separatorBuilder: (context, index) => SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      String type = snapshot.data.docs[index].get("type");
                      if (type == "appointment") {
                        String speciality = snapshot.data.docs[index].get("speciality");
                        String time = snapshot.data.docs[index].get("time");
                        String patientName = snapshot.data.docs[index].get("name");
                        String hospital = snapshot.data.docs[index].get("hospital");
                        return appointmentReminder(
                          speciality: speciality,
                          time: time,
                          name: patientName,
                          hospital: hospital,
                        );
                      } else {
                        return Container();
                      }
                    }),
              )
            : Container(
                child: Center(
                  child: Text("You have no reminders"),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.grey[100],
          title: Text("Reminders", style: TextStyle(fontFamily: "Brand Bold", color: Colors.red[300]),),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            color: Colors.grey[100],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: reminderList(),
          ),
        ),
      ),
    );
  }

  Widget appointmentReminder({String speciality, String time, String name, String hospital}) {
    return Container(
      width: 95 * SizeConfig.widthMultiplier,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: Offset(2, 3),
            spreadRadius: 0.5,
            blurRadius: 2,
            color: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 8 * SizeConfig.heightMultiplier,
                  width: 16 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Icon(FontAwesomeIcons.calendarAlt, color: Colors.red[300],),
                  ),
                ),
                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 70 * SizeConfig.widthMultiplier,
                      child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 3 * SizeConfig.textMultiplier,
                        ),),
                    ),
                    Text(time, style: TextStyle(
                      fontFamily: "Brand-Regular",
                      fontSize: 2 * SizeConfig.textMultiplier,
                      color: Colors.black54,
                    ),),
                    SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                    Container(
                      width: 70 * SizeConfig.widthMultiplier,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 68 * SizeConfig.widthMultiplier,
                            child: Text("$speciality Appointment", maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: "Brand Bold",
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                color: Colors.grey,
                              ),),
                          ),
                          SizedBox(width: 0.8 * SizeConfig.widthMultiplier,),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: Colors.grey, thickness: 2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {},
                  // onPressed: () async => await databaseMethods.deleteDoctorReminder(name, currentUser.uid),
                  color: Colors.white,
                  splashColor: Colors.red[300],
                  highlightColor: Colors.grey.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Icon(CupertinoIcons.clear),
                        Text("Cancel", style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),),
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () {},
                  color: Colors.white,
                  splashColor: Colors.red[300],
                  highlightColor: Colors.grey.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Icon(CupertinoIcons.checkmark_alt),
                        Text("Done", style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2 * SizeConfig.textMultiplier,
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
