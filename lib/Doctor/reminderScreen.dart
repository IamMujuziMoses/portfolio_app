import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:portfolio_app/AllScreens/addReminderScreen.dart';
import 'package:portfolio_app/AllScreens/bookAppointmentScreen.dart';
import 'package:portfolio_app/Utilities/utils.dart';
import 'package:portfolio_app/constants.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class ReminderScreen extends StatelessWidget {
  final Stream reminderStream;
  const ReminderScreen({Key key, this.reminderStream}) : super(key: key);

  Widget reminderList() {
    return StreamBuilder(
      stream: reminderStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Container(
                height: double.infinity,
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      String type = snapshot.data.docs[index].get("type");
                      if (type == "appointment") {
                        String speciality = snapshot.data.docs[index].get("speciality");
                        Timestamp timeStr = snapshot.data.docs[index].get("time");
                        DateTime time = timeStr.toDate();
                        String status = snapshot.data.docs[index].get("status");
                        int id = snapshot.data.docs[index].get("id");
                        String patientName = snapshot.data.docs[index].get("name");
                        String hospital = snapshot.data.docs[index].get("hospital");
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: appointmentReminder(
                            context: context,
                            speciality: speciality,
                            time: time,
                            id: id,
                            status: status,
                            name: patientName,
                            hospital: hospital,
                          ),
                        );
                      } else if (type == "event") {
                        Timestamp timeStr = snapshot.data.docs[index].get("date");
                        DateTime date = timeStr.toDate();
                        String status = snapshot.data.docs[index].get("status");
                        int id = snapshot.data.docs[index].get("id");
                        String description = snapshot.data.docs[index].get("description");
                        String eventName = snapshot.data.docs[index].get("name");
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: eventReminder(
                            context: context,
                            description: description,
                            status: status,
                            id: id,
                            date: date,
                            eventName: eventName,
                          ),
                        );
                      } else return Container();
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
          title: Text("Reminders", style: TextStyle(fontFamily: "Brand Bold", color: Color(0xFFa81845)),),
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

  Widget eventReminder({BuildContext context, DateTime date, description, eventName, status, int id}) {
    return Container(
      width: 95 * SizeConfig.widthMultiplier,
      decoration: BoxDecoration(
        color: status == "waiting" ? Colors.white : Colors.white38,
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
                    gradient: status == "waiting" ? kPrimaryGradientColor : null,
                    color: status == "waiting" ? null : Colors.grey[400],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Icon(CupertinoIcons.calendar_badge_plus,
                      color: status == "waiting" ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 70 * SizeConfig.widthMultiplier,
                      child: Text(eventName, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 3 * SizeConfig.textMultiplier,
                        ),),
                    ),
                    Text("${Utils.formatDate(date)}", style: TextStyle(
                      fontFamily: "Brand-Regular",
                      fontSize: 2 * SizeConfig.textMultiplier,
                      color: Colors.black54,
                    ),),
                    SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                    Container(
                      width: 70 * SizeConfig.widthMultiplier,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 68 * SizeConfig.widthMultiplier,
                            child: Text("$description", maxLines: 2, overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: "Brand Bold",
                                fontSize: 2 * SizeConfig.textMultiplier,
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
                  onPressed: status == "waiting" ? () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text("Cancel event reminder?"),
                        content: Text("$eventName on ${Utils.formatDate(date)}", style: TextStyle(
                          fontFamily: "Brand-Regular",
                        ),),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("No"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: () {
                              cancelDocAlarm(name: eventName, id: id);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  } : () => displaySnackBar(message: "Reminder already ended and cancelled", context: context, label: ""),
                  color: status == "waiting" ? Colors.white : Colors.grey[400],
                  splashColor: Color(0xFFa81845).withOpacity(0.6),
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text("Delete event reminder?"),
                        content: Text("$eventName on ${Utils.formatDate(date)}", style: TextStyle(
                          fontFamily: "Brand-Regular",
                        ),),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("No"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: () {
                              deleteDocAlarm(eventName);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  color: status == "waiting" ? Colors.white : Colors.grey[400],
                  splashColor: Color(0xFFa81845).withOpacity(0.6),
                  highlightColor: Colors.grey.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Icon(CupertinoIcons.checkmark_alt),
                        Text("Delete", style: TextStyle(
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

  Widget appointmentReminder({String speciality, DateTime time, String name, String hospital,
    int id, String status, BuildContext context}) {
    return Container(
      width: 95 * SizeConfig.widthMultiplier,
      decoration: BoxDecoration(
        color: status == "waiting" ? Colors.white : Colors.white38,
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
                    gradient: status == "waiting" ? kPrimaryGradientColor : null,
                    color: status == "waiting" ? null : Colors.grey[400],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Icon(FontAwesomeIcons.calendarAlt,
                      color: status == "waiting" ? Colors.white : Colors.black,
                    ),
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
                    Text("${Utils.formatDate(time)}", style: TextStyle(
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
                  onPressed: status == "waiting" ? () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text("Cancel appointment reminder?"),
                        content: Text("$speciality with $name", style: TextStyle(
                          fontFamily: "Brand-Regular",
                        ),),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("No"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: () {
                              cancelDocAlarm(name: name, id: id);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  } : () => displaySnackBar(message: "Reminder already ended and cancelled", context: context, label: ""),
                  color: status == "waiting" ? Colors.white : Colors.grey[400],
                  splashColor: Color(0xFFa81845).withOpacity(0.6),
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text("Delete appointment reminder?"),
                        content: Text("$speciality with $name", style: TextStyle(
                          fontFamily: "Brand-Regular",
                        ),),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("No"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: () {
                              deleteDocAlarm(name);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  color: status == "waiting" ? Colors.white : Colors.grey[400],
                  splashColor: Color(0xFFa81845).withOpacity(0.6),
                  highlightColor: Colors.grey.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Icon(CupertinoIcons.checkmark_alt),
                        Text("Delete", style: TextStyle(
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
