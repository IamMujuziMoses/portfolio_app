import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:portfolio_app/AllScreens/addReminderScreen.dart';
import 'package:portfolio_app/AllScreens/bookAppointmentScreen.dart';
import 'package:portfolio_app/AllScreens/loginScreen.dart';
import 'package:portfolio_app/Models/activity.dart';
import 'package:portfolio_app/Models/reminder.dart';
import 'package:portfolio_app/Utilities/utils.dart';
import 'package:portfolio_app/main.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class AppointmentsScreen extends StatelessWidget {
  final Stream appointmentStream;
  const AppointmentsScreen({Key key, this.appointmentStream}) : super(key: key);

  Widget appointmentList() {
    return StreamBuilder(
      stream: appointmentStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  Timestamp dateStr = snapshot.data.docs[index].get("start_time");
                  String patientName = snapshot.data.docs[index].get("name");
                  String speciality = snapshot.data.docs[index].get("type");
                  String hospital = snapshot.data.docs[index].get("hospital");
                  return AppointmentTile(
                    dateTime: dateStr.toDate(),
                    patientName: patientName,
                    speciality: speciality,
                    hospital: hospital,
                  );
                },
              )
            : Container(
                child: Center(
                  child: Text("You have no appointments"),
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
          title: Text("Appointments", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Color(0xFFa81845),
          ),),
        ),
        body: Container(
          color: Colors.grey[100],
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.only(
              left: 4, right: 4,
            ),
            child: appointmentList(),
          ),
        ),
      ),
    );
  }
}

class AppointmentTile extends StatefulWidget {
  final String patientName;
  final DateTime dateTime;
  final String hospital;
  final String speciality;
  const AppointmentTile({Key key, this.patientName, this.hospital, this.speciality, this.dateTime,}) : super(key: key);

  @override
  _AppointmentTileState createState() => _AppointmentTileState();
}

class _AppointmentTileState extends State<AppointmentTile> {
  String phone = "";
  String pic = "";
  String action = "Loading...";

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  getInfo() async {
    QuerySnapshot snap;
    await databaseMethods.getUserByUsername(widget.patientName).then((val) {
      snap = val;
      phone = snap.docs[0].get("phone");
      pic = snap.docs[0].get("profile_photo");
    });
    QuerySnapshot name = await databaseMethods.getSavedPatient(widget.patientName, firebaseAuth.currentUser.uid);
    if (name.docs.isEmpty) {
      setState(() {
        action = "Add to Patients";
      });
    }
    if (name.docs.isNotEmpty){
      setState(() {
        action = "Added";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 1 * SizeConfig.heightMultiplier,
        bottom: 1 * SizeConfig.heightMultiplier,
        left: 3 * SizeConfig.widthMultiplier,
        right: 3 * SizeConfig.widthMultiplier,
      ),
      child: Container(
        height: 20 * SizeConfig.heightMultiplier,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: Offset(1, 3),
              spreadRadius: 0.5,
              blurRadius: 2,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1 * SizeConfig.heightMultiplier,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 8 * SizeConfig.heightMultiplier,
                    width: 30 * SizeConfig.widthMultiplier,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Patient's Name", style: TextStyle(
                            fontFamily: "Brand-Regular",
                            fontWeight: FontWeight.w400,
                            fontSize: 1.8 * SizeConfig.textMultiplier,
                          ),),
                          Container(
                            child: Text(widget.patientName, style: TextStyle(
                              fontFamily: "Brand Bold",
                              fontSize: 2.1 * SizeConfig.textMultiplier,
                            ), overflow: TextOverflow.ellipsis,),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 8 * SizeConfig.heightMultiplier,
                    width: 30 * SizeConfig.widthMultiplier,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Date", style: TextStyle(
                            fontFamily: "Brand-Regular",
                            fontWeight: FontWeight.w400,
                            fontSize: 1.8 * SizeConfig.textMultiplier,
                          ),),
                          Container(
                            child: Text("${Utils.formatDate(widget.dateTime)}", style: TextStyle(
                              fontFamily: "Brand Bold",
                              fontSize: 2.1 * SizeConfig.textMultiplier,
                            ), overflow: TextOverflow.ellipsis,),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 8 * SizeConfig.heightMultiplier,
                    width: 30 * SizeConfig.widthMultiplier,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Time", style: TextStyle(
                            fontFamily: "Brand-Regular",
                            fontWeight: FontWeight.w400,
                            fontSize: 1.8 * SizeConfig.textMultiplier,
                          ),),
                          Container(
                            child: Text("${Utils.formatTime(widget.dateTime)}", style: TextStyle(
                              fontFamily: "Brand Bold",
                              fontSize: 2.1 * SizeConfig.textMultiplier,
                            ), overflow: TextOverflow.ellipsis,),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(thickness: 2,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 6 * SizeConfig.heightMultiplier,
                      child: RaisedButton(
                        onPressed: () => displaySnackBar(message: "Can't cancel appointment", context: context),
                        color: Color(0xFFa81845),
                        splashColor: Colors.white,
                        highlightColor: Colors.red.withOpacity(0.1),
                        child: Center(
                          child: Text("Cancel", style: TextStyle(
                            fontFamily: "Brand Bold",
                            color: Colors.white,
                            fontSize: 2 * SizeConfig.textMultiplier,
                          ),),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                    Container(
                      height: 6 * SizeConfig.heightMultiplier,
                      child: RaisedButton(
                        onPressed: () async {
                          if (action == "Add to Patients") {
                            List medicine = [];
                            Map<String, dynamic> patientMap = {
                              "name": widget.patientName,
                              "phone": phone,
                              "pic": pic,
                              "medicine": medicine,
                              "time": FieldValue.serverTimestamp(),
                              "private": true,
                            };

                            Activity activity = Activity.saveActivity(
                              type: "saved",
                              createdAt: FieldValue.serverTimestamp(),
                              savedType: "patient",
                              patientName: widget.patientName,
                            );

                            Activity reminderAct = Activity.appReminderActivity(
                              appTime: Timestamp.fromDate(widget.dateTime),
                              createdAt: FieldValue.serverTimestamp(),
                              reminderType: "appointment",
                              type: "reminder",
                              user: widget.patientName,
                            );

                            Duration duration = widget.dateTime.add(Duration(hours: 1)).difference(DateTime.now());

                            int id = Random().nextInt(100);
                            Reminder reminder = Reminder.appointReminder(
                              speciality: widget.speciality,
                              createdAt: FieldValue.serverTimestamp(),
                              apTime: Timestamp.fromDate(widget.dateTime),
                              name: widget.patientName,
                              id: id,
                              status: "waiting",
                              hospital: widget.hospital,
                              type: "appointment",
                            );

                            int exId = Random().nextInt(50);
                            int exId1 = Random().nextInt(50);
                            int exId2 = Random().nextInt(50);

                            Duration exDuration = widget.dateTime.difference(DateTime.now());
                            Duration exDuration1 = widget.dateTime.subtract(Duration(minutes: 10)).difference(DateTime.now());
                            Duration exDuration2 = widget.dateTime.subtract(Duration(hours: 1)).difference(DateTime.now());

                            scheduleAlarm(dateTimeNow: widget.dateTime.subtract(Duration(minutes: 10)), dateTime: widget.dateTime,
                              id: exId, docName: widget.patientName, speciality: widget.speciality, isDoc: true, duration: "10 min");
                            Timer(exDuration, () async {await notificationsPlugin.cancel(exId);});

                            scheduleAlarm(dateTimeNow: widget.dateTime.subtract(Duration(hours: 1)), dateTime: widget.dateTime,
                              id: exId1, docName: widget.patientName, speciality: widget.speciality, isDoc: true, duration: "1 hour");
                            Timer(exDuration1, () async {await notificationsPlugin.cancel(exId1);});

                            scheduleAlarm(dateTimeNow: widget.dateTime.subtract(Duration(hours: 6)), dateTime: widget.dateTime,
                              id: exId2, docName: widget.patientName, speciality: widget.speciality, isDoc: true, duration: "6 hours");
                            Timer(exDuration2, () async {await notificationsPlugin.cancel(exId2);});

                            scheduleAlarm(dateTime: widget.dateTime, id: id, docName: widget.patientName, speciality: widget.speciality, isDoc: true,);
                            Timer(duration, () {cancelDocAlarm(name: widget.patientName.trim(), id: id);});

                            var activityMap = activity.toSaveActivity(activity);
                            var appActivityMap = reminderAct.toAppReminderActivity(reminderAct);
                            Map<String, dynamic> reminderMap = reminder.toAppointMap(reminder);
                            databaseMethods.createDoctorReminder(reminderMap, currentUser.uid);

                            await databaseMethods.savePatient(patientMap, currentUser.uid);
                            await databaseMethods.createDoctorActivity(activityMap, currentUser.uid);
                            await databaseMethods.createDoctorActivity(appActivityMap, currentUser.uid);
                            setState(() {
                              action = "Added";
                            });
                            displayToastMessage("Added to your patients, and automatically created a reminder", context);
                          }
                          if (action == "Added") {
                            displaySnackBar(message: "Already added to Patients", context: context, label: "OK");
                          }
                        },
                        color: Colors.white,
                        splashColor: Color(0xFFa81845),
                        highlightColor: Colors.grey.withOpacity(0.1),
                        child: Center(
                          child: Text(action, style: TextStyle(
                            fontFamily: "Brand Bold",
                            color: Color(0xFFa81845),
                            fontSize: 2 * SizeConfig.textMultiplier,
                          ),),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

