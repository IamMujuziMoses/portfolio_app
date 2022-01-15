import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:portfolio_app/AllScreens/addReminderScreen.dart';
import 'package:portfolio_app/AllScreens/drugDetails.dart';
import 'package:portfolio_app/AllScreens/loginScreen.dart';
import 'package:portfolio_app/Doctor/doctorAccount.dart';
import 'package:portfolio_app/Models/activity.dart';
import 'package:portfolio_app/Models/reminder.dart';
import 'package:portfolio_app/Utilities/utils.dart';
import 'package:portfolio_app/Widgets/progressDialog.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';
/*
* Created by Mujuzi Moses
*/

class EventDetails extends StatelessWidget {
  final String imageUrl;
  final String eventTitle;
  final String eventDesc;
  final String eventDate;
  final DateTime eventDateTime;
  final String status;
  final bool isDoctor;
  const EventDetails({Key key, this.imageUrl, this.eventTitle, this.eventDesc, this.status, this.eventDate,
    this.eventDateTime, this.isDoctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        body: customMed(
          body: _eventDetailsBody(context),
          imageUrl: imageUrl,
          drugName: eventTitle,
        ),
      ),
    );
  }

  Widget _eventDetailsBody(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 10 * SizeConfig.heightMultiplier,
      color: Colors.grey[100],
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 4 * SizeConfig.widthMultiplier,
            vertical: 2 * SizeConfig.heightMultiplier,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Status: $status", style: TextStyle(
                fontFamily: "Brand-Regular",
                color: Colors.grey,
                fontSize: 2 * SizeConfig.textMultiplier,
              ),),
              Text("Date: $eventDate", style: TextStyle(
                fontFamily: "Brand Bold",
                fontSize: 3 * SizeConfig.textMultiplier,
              ),),
              SizedBox(height: 2 * SizeConfig.heightMultiplier,),
              Text("Description", style: TextStyle(
                fontFamily: "Brand Bold",
                color: Colors.grey,
                fontSize: 3 * SizeConfig.textMultiplier,
              ),),
              SizedBox(height: 1 * SizeConfig.heightMultiplier,),
              getAbout(eventDesc),
              SizedBox(height: 5 * SizeConfig.heightMultiplier,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10 * SizeConfig.widthMultiplier),
                child: RaisedButton(
                  splashColor: Colors.white,
                  highlightColor: Colors.grey.withOpacity(0.1),
                  color: Color(0xFFa81845),
                  textColor: Colors.white,
                  child: Container(
                    width: 60 * SizeConfig.widthMultiplier,
                    child: Center(
                      child: Text("Add Reminder", style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "Brand Bold",
                      ),),
                    ),
                  ),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  onPressed: () async {
                   if (eventDateTime.isBefore(DateTime.now())) {
                     displayToastMessage("Event already ended, can't add reminder", context);
                   } else {
                     showDialog(
                       context: context,
                       builder: (context) => ProgressDialog(message: "Please wait...",),
                     );
                     Activity activity = Activity.evtReminderActivity(
                       type: "reminder",
                       createdAt: FieldValue.serverTimestamp(),
                       eventDate: Timestamp.fromDate(eventDateTime),
                       eventTitle: eventTitle,
                       reminderType: "event",
                     );
                     var activityMap = activity.toEvtReminderActivity(activity);
                     Duration duration = eventDateTime.add(Duration(minutes: 30)).difference(DateTime.now());
                     int id = Random().nextInt(500);
                     Reminder reminder = Reminder.eventReminder(
                       type: "event",
                       createdAt: FieldValue.serverTimestamp(),
                       name: eventTitle,
                       date: Timestamp.fromDate(eventDateTime),
                       id: id,
                       status: "waiting",
                       description: eventDesc,
                     );
                     Map<String, dynamic> reminderMap = reminder.toEventReminder(reminder);

                     int exId = Random().nextInt(50);
                     int exId1 = Random().nextInt(50);
                     int exId2 = Random().nextInt(50);

                     Duration exDuration = eventDateTime.difference(DateTime.now());
                     Duration exDuration1 = eventDateTime.subtract(Duration(minutes: 10)).difference(DateTime.now());
                     Duration exDuration2 = eventDateTime.subtract(Duration(hours: 1)).difference(DateTime.now());

                     scheduleEvent(dateTimeNow: eventDateTime.subtract(Duration(minutes: 10)), dateTime: eventDateTime, duration: "10 min",
                         id: exId, eventName: eventTitle);
                     Timer(exDuration, () async {await notificationsPlugin.cancel(exId);});

                     scheduleEvent(dateTimeNow: eventDateTime.subtract(Duration(hours: 1)), dateTime: eventDateTime, duration: "1 hour",
                         id: exId1, eventName: eventTitle);
                     Timer(exDuration1, () async {await notificationsPlugin.cancel(exId1);});

                     scheduleEvent(dateTimeNow: eventDateTime.subtract(Duration(hours: 6)), dateTime: eventDateTime, duration: "6 hours",
                         id: exId2, eventName: eventTitle);
                     Timer(exDuration2, () async {await notificationsPlugin.cancel(exId2);});

                     scheduleEvent(dateTime: eventDateTime, id: id, eventName: eventTitle,);
                     Timer(duration, () {
                       if (isDoctor == true) {
                         cancelDocAlarm(name: eventTitle, id: id);
                       } else {
                         cancelAlarm(name: eventTitle, id: id);
                       }
                     });
                     if (isDoctor == true) {
                       databaseMethods.createDoctorReminder(reminderMap, currentUser.uid);
                       databaseMethods.createDoctorActivity(activityMap, currentUser.uid);
                       displayToastMessage("Operation Successful! Created Reminder", context);
                     } else {
                       databaseMethods.createUserReminder(reminderMap, currentUser.uid);
                       databaseMethods.createUserActivity(activityMap, currentUser.uid);
                       displayToastMessage("Operation Successful! Created Reminder", context);
                     }
                     Navigator.pop(context);
                   }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

scheduleEvent({DateTime dateTimeNow, DateTime dateTime, int id, String eventName,String duration}) async {
  var androidPlatformChannelSpecs = AndroidNotificationDetails(
    "Siro", "Siro", "Channel for Alarm notification",
    icon: "launch_image",
    priority: Priority.High,
    importance: Importance.Max,
    sound: RawResourceAndroidNotificationSound("alert"),
    largeIcon: DrawableResourceAndroidBitmap("launch_image"),
  );

  var iosPlatformChannelSpecs = IOSNotificationDetails(
    sound: "alert.mp3",
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  var platformChannelSpecs = NotificationDetails(
    androidPlatformChannelSpecs, iosPlatformChannelSpecs,
  );
  await notificationsPlugin.schedule(
    id, "Event Reminder",
    "Event: $eventName ${dateTimeNow != null ? "at ${Utils.formatTime(dateTime)}($duration)" : "happening now"}",
    dateTimeNow != null ? dateTimeNow : dateTime,
    platformChannelSpecs,
  );
}