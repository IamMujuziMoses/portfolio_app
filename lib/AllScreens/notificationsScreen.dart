import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/chatSearch.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/newsFeedScreen.dart';
import 'package:creativedata_app/AllScreens/reminderScreen.dart';
import 'package:creativedata_app/Doctor/alertsScreen.dart';
import 'package:creativedata_app/Doctor/appointmentsScreen.dart';
import 'package:creativedata_app/Doctor/eventDetails.dart';
import 'package:creativedata_app/Utilities/utils.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/main.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class NotificationsScreen extends StatefulWidget {
  final Stream notificationsStream;
  final String name;
  final String userPic;
  final bool isDoctor;
  const NotificationsScreen({Key key, this.notificationsStream, this.name, this.userPic, this.isDoctor}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Widget notificationList() {
    return StreamBuilder(
      stream: widget.notificationsStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            String type = snapshot.data.docs[index].get("type");
            Timestamp createdTStamp = snapshot.data.docs[index].get("created_at");
            DateTime createdAt = createdTStamp.toDate();
            if (type == "medicine reminder") {
              String userName = snapshot.data.docs[index].get("user_name");
              String drugName = snapshot.data.docs[index].get("drug_name");
              String cycle = snapshot.data.docs[index].get("cycle");
              String dosage = snapshot.data.docs[index].get("dosage");
              String howLong = snapshot.data.docs[index].get("how_long");
              if (userName == widget.name) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: medicineReminderTile(
                    createdAt: createdAt,
                    context: context,
                    dosage: dosage,
                    drugName: drugName,
                    cycle: cycle,
                    howLong: howLong,
                  ),
                );
              } else return Container();
            } else if (type == "post") {
              String from = snapshot.data.docs[index].get("from");
              String postText = snapshot.data.docs[index].get("post_text");
              String postHeading = snapshot.data.docs[index].get("post_heading");
              if (from == widget.name) {
                return Container();
              } else return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: postTile(
                  createdAt: createdAt,
                  context: context,
                  from: from,
                  postText: postText,
                  postHeading: postHeading,
                ),
              );
            } else if (type == "appointment reminder") {
              String patientName = snapshot.data.docs[index].get("name");
              String docName = snapshot.data.docs[index].get("doctors_name");
              String appType = snapshot.data.docs[index].get("app_type");
              String hospital = snapshot.data.docs[index].get("hospital");
              Timestamp startTStamp = snapshot.data.docs[index].get("start_time");
              DateTime startTime = startTStamp.toDate();
              if (docName == widget.name) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: appointmentReminderTile(
                    context: context,
                    docName: docName,
                    patientName: patientName,
                    appType: appType,
                    hospital: hospital,
                    createdAt: createdAt,
                    startTime: startTime,
                  ),
                );
              } else if (patientName == widget.name) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: appointmentReminderTile(
                    context: context,
                    docName: docName,
                    patientName: patientName,
                    appType: appType,
                    hospital: hospital,
                    createdAt: createdAt,
                    startTime: startTime,
                  ),
                );
              } else return Container();
            } else if (type == "event") {
              Timestamp eventTStamp = snapshot.data.docs[index].get("event_date");
              DateTime eventDate = eventTStamp.toDate();
              String eventDesc = snapshot.data.docs[index].get("event_desc");
              String status = snapshot.data.docs[index].get("status");
              String imageUrl = snapshot.data.docs[index].get("image_url");
              String eventTitle = snapshot.data.docs[index].get("event_title");
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: eventTile(
                    context: context,
                    eventDate: eventDate,
                    eventDesc: eventDesc,
                    eventTitle: eventTitle,
                    createdAt: createdAt,
                    imageUrl: imageUrl,
                    status: status
                ),
              );
            } else if (type == "alert") {
              String heading = snapshot.data.docs[index].get("heading");
              String issuedBy = snapshot.data.docs[index].get("issued_by");
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: healthAlertTile(
                  context: context,
                  heading: heading,
                  issuedBy: issuedBy,
                  createdAt: createdAt,
                ),
              );
            } else if (type == "message") {
              String senderName = snapshot.data.docs[index].get("sender_name");
              String senderPhoto = snapshot.data.docs[index].get("sender_photo");
              String senderUid = snapshot.data.docs[index].get("sender_uid");
              String receiverName = snapshot.data.docs[index].get("receiver_name");
              String receiverPhoto = snapshot.data.docs[index].get("receiver_photo");
              String receiverUid = snapshot.data.docs[index].get("receiver_uid");
              String messageType = snapshot.data.docs[index].get("message_type");
              if (receiverName == widget.name) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: messageTile(
                    context: context,
                    createdAt: createdAt,
                    senderName: senderName,
                    senderPhoto: senderPhoto,
                    senderUid: senderUid,
                    receiverName: receiverName,
                    receiverPhoto: receiverPhoto,
                    receiverUid: receiverUid,
                    messageType: messageType,
                  ),
                );
              } else return Container();
            } else return Container();
          },
        ) : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey[100],
          titleSpacing: 0,
          title: Text("Notifications", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Color(0xFFa81845),
          ),),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[100],
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: notificationList(),
          ),
        ),
      ),
    );
  }

  Widget postTile({BuildContext context, from, postText, postHeading, DateTime createdAt}) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context, MaterialPageRoute(
        builder: (context) => NewsFeedScreen(
          userPic: widget.userPic,
          userName: widget.name,
          isDoctor: widget.isDoctor,
        ),
      ),
      ),
      child: Container(
        //height: 11 * SizeConfig.heightMultiplier,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 8 * SizeConfig.heightMultiplier,
                width: 16 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                  gradient: kPrimaryGradientColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Icon(FontAwesomeIcons.newspaper, color: Colors.white,),
                ),
              ),
              SizedBox(width: 1 * SizeConfig.widthMultiplier,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("New post from Dr. $from", style: TextStyle(
                      fontFamily: "Brand Bold",
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                    ),),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Text("Heading: $postHeading", maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand-Regular",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Text(postText, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand-Regular",
                        fontSize: 2 * SizeConfig.textMultiplier,
                        color: Colors.black54,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Text("${Utils.formatDate(createdAt)}, ${Utils.formatTime(createdAt)}", style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 1.8 * SizeConfig.textMultiplier,
                        ),),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.hardEdge,
                    height: 4 * SizeConfig.heightMultiplier,
                    width: 6 * SizeConfig.widthMultiplier,
                    child: IconButton(
                      splashColor: Color(0xFFa81845),
                      highlightColor: Colors.grey.withOpacity(0.1),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            title: Text("Remove this notification?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("No"),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              FlatButton(
                                child: Text("Yes"),
                                onPressed: () async {
                                  await databaseMethods.deleteNotification("post", postHeading);
                                  Navigator.of(context).pop();
                                }
                              ),
                            ],
                          ),
                        );
                      },
                      padding: EdgeInsets.all(0),
                      icon: Icon(CupertinoIcons.clear, size: 3 * SizeConfig.imageSizeMultiplier,),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget medicineReminderTile({BuildContext context, DateTime createdAt, dosage, drugName, cycle, howLong,}) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context, MaterialPageRoute(
        builder: (context) => ReminderScreen(),
      ),
      ),
      child: Container(
        //height: 11 * SizeConfig.heightMultiplier,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 8 * SizeConfig.heightMultiplier,
                width: 16 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                  gradient: kPrimaryGradientColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Container(
                    width: 6.4 * SizeConfig.widthMultiplier,
                    child: Stack(
                      children: <Widget>[
                        Icon(CupertinoIcons.alarm_fill, color: Colors.white,),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration:
                                BoxDecoration(borderRadius: BorderRadius.circular(50), color: Color(0xFFa81845),),
                            child: Padding(
                              padding: EdgeInsets.only(left: 2),
                              child: Icon(FontAwesomeIcons.pills,
                                color: Colors.white,
                                size: 3 * SizeConfig.imageSizeMultiplier,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 1 * SizeConfig.widthMultiplier,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("New medicine reminder", style: TextStyle(
                      fontFamily: "Brand Bold",
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                    ),),
                  Text("Medicine: $drugName.", maxLines: 1,
                    style: TextStyle(
                      fontFamily: "Brand-Regular",
                      fontSize: 2 * SizeConfig.textMultiplier,
                    ),),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Text("$dosage, $cycle a day for $howLong.", maxLines: 3, overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand-Regular",
                        fontSize: 2 * SizeConfig.textMultiplier,
                        color: Colors.black54,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Text("${Utils.formatDate(createdAt)}, ${Utils.formatTime(createdAt)}", style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 1.8 * SizeConfig.textMultiplier,
                        ),),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.hardEdge,
                    height: 4 * SizeConfig.heightMultiplier,
                    width: 6 * SizeConfig.widthMultiplier,
                    child: IconButton(
                      splashColor: Color(0xFFa81845),
                      highlightColor: Colors.grey.withOpacity(0.1),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            title: Text("Remove this notification?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("No"),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              FlatButton(
                                child: Text("Yes"),
                                onPressed: () async {
                                  await databaseMethods.deleteNotification("medicine reminder", drugName);
                                  Navigator.of(context).pop();
                                }
                              ),
                            ],
                          ),
                        );
                      },
                      padding: EdgeInsets.all(0),
                      icon: Icon(CupertinoIcons.clear, size: 3 * SizeConfig.imageSizeMultiplier,),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget messageTile({BuildContext context, DateTime createdAt, senderName, senderPhoto, senderUid,
    receiverName, receiverPhoto, receiverUid, messageType,}) {
    return GestureDetector(
      onTap: () async {
        goToChat(senderName, senderPhoto, widget.isDoctor, senderUid, receiverPhoto, context,);
        await databaseMethods.deleteMessageNotification(senderName, receiverName);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 8 * SizeConfig.heightMultiplier,
                width: 16 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                  gradient: kPrimaryGradientColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Icon(FontAwesomeIcons.solidEnvelope, color: Colors.white,),
                ),
              ),
              SizedBox(width: 1 * SizeConfig.widthMultiplier,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("New message", style: TextStyle(
                    fontFamily: "Brand Bold",
                    fontSize: 2.5 * SizeConfig.textMultiplier,
                  ),),
                  Text("From: ${widget.isDoctor == true ? senderName : "Dr. $senderName"}", maxLines: 1,
                    style: TextStyle(
                      fontFamily: "Brand-Regular",
                      fontSize: 2 * SizeConfig.textMultiplier,
                    ),),
                  Text("Message type: $messageType", maxLines: 1,
                    style: TextStyle(
                      fontFamily: "Brand-Regular",
                      fontSize: 2 * SizeConfig.textMultiplier,
                      color: Colors.black54,
                    ),),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Text("${Utils.formatDate(createdAt)}, ${Utils.formatTime(createdAt)}", style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 1.8 * SizeConfig.textMultiplier,
                        ),),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.hardEdge,
                    height: 4 * SizeConfig.heightMultiplier,
                    width: 6 * SizeConfig.widthMultiplier,
                    child: IconButton(splashColor: Color(0xFFa81845),
                      highlightColor: Colors.grey.withOpacity(0.1),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            title: Text("Remove this notification?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("No"),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              FlatButton(
                                  child: Text("Yes"),
                                  onPressed: () async {
                                    await databaseMethods.deleteMessageNotification(senderName, receiverName);
                                    Navigator.of(context).pop();
                                  }
                              ),
                            ],
                          ),
                        );
                      },
                      padding: EdgeInsets.all(0),
                      icon: Icon(CupertinoIcons.clear, size: 3 * SizeConfig.imageSizeMultiplier,),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget healthAlertTile({BuildContext context, DateTime createdAt, issuedBy, heading}) {
    return GestureDetector(
      onTap: () async {
        Stream alertStream;
        await databaseMethods.getAlerts().then((val) {
          setState(() {
            alertStream = val;
          });
        });
        Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => AlertsScreen(
            alertStream: alertStream,
          ),
        ),
        );
      },
      child: Container(
        //height: 11 * SizeConfig.heightMultiplier,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 8 * SizeConfig.heightMultiplier,
                width: 16 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                  gradient: kPrimaryGradientColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Icon(FontAwesomeIcons.exclamationTriangle, color: Colors.white,),
                ),
              ),
              SizedBox(width: 1 * SizeConfig.widthMultiplier,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("New health alert", style: TextStyle(
                      fontFamily: "Brand Bold",
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                    ),),
                  Text("Issued By: $issuedBy", maxLines: 1,
                    style: TextStyle(
                      fontFamily: "Brand-Regular",
                      fontSize: 2 * SizeConfig.textMultiplier,
                    ),),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Text("Alert: $heading", maxLines: 3, overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand-Regular",
                        fontSize: 2 * SizeConfig.textMultiplier,
                        color: Colors.black54,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Text("${Utils.formatDate(createdAt)}, ${Utils.formatTime(createdAt)}", style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 1.8 * SizeConfig.textMultiplier,
                        ),),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.hardEdge,
                    height: 4 * SizeConfig.heightMultiplier,
                    width: 6 * SizeConfig.widthMultiplier,
                    child: IconButton(splashColor: Color(0xFFa81845),
                      highlightColor: Colors.grey.withOpacity(0.1),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            title: Text("Remove this notification?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("No"),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              FlatButton(
                                child: Text("Yes"),
                                onPressed: () async {
                                  await databaseMethods.deleteNotification("alert", heading);
                                  Navigator.of(context).pop();
                                }
                              ),
                            ],
                          ),
                        );
                      },
                      padding: EdgeInsets.all(0),
                      icon: Icon(CupertinoIcons.clear, size: 3 * SizeConfig.imageSizeMultiplier,),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appointmentReminderTile({BuildContext context, DateTime startTime, DateTime createdAt, docName,
    patientName, appType, hospital,
  }) {
    return GestureDetector(
      onTap: () async {
        if (widget.isDoctor == true) {
          Stream appointmentStream;
          await databaseMethods.getAppointments(widget.name).then((val) {
            setState(() {
              appointmentStream = val;
            });
          });
          Navigator.push(
            context, MaterialPageRoute(
            builder: (context) => AppointmentsScreen(
              appointmentStream: appointmentStream,
            ),
          ),
          );
        } else {
          Navigator.push(
            context, MaterialPageRoute(
            builder: (context) => ReminderScreen(),
          ),
          );
        }
      },
      child: Container(
        // height: 11 * SizeConfig.heightMultiplier,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 8 * SizeConfig.heightMultiplier,
                width: 16 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                  gradient: kPrimaryGradientColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Container(
                    width: 6.4 * SizeConfig.widthMultiplier,
                    child: Stack(
                      children: <Widget>[
                        Icon(CupertinoIcons.alarm_fill, color: Colors.white,),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration:
                                BoxDecoration(borderRadius: BorderRadius.circular(50), color: Color(0xFFa81845)),
                            child: Padding(
                              padding: EdgeInsets.only(left: 2),
                              child: Icon(
                                FontAwesomeIcons.calendarAlt,
                                color: Colors.white,
                                size: 3 * SizeConfig.imageSizeMultiplier,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 1 * SizeConfig.widthMultiplier,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("New appointment reminder", style: TextStyle(
                      fontFamily: "Brand Bold",
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                    ),),
                  Container(
                    width: 68 * SizeConfig.widthMultiplier,
                    child: Text(widget.isDoctor == true
                        ? "New $appType appointment with $patientName, going to take place at $hospital (hospital) on "
                        "${Utils.formatDate(startTime)} at ${Utils.formatTime(startTime)}."
                        : "New $appType appointment with Dr. $docName, going to take place at $hospital on "
                        "${Utils.formatDate(startTime)} at ${Utils.formatTime(startTime)}.",
                      maxLines: 3, overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand-Regular",
                        fontSize: 2 * SizeConfig.textMultiplier,
                        color: Colors.black54,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Text("${Utils.formatDate(createdAt)}, ${Utils.formatTime(createdAt)}", style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 1.8 * SizeConfig.textMultiplier,
                        ),),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.hardEdge,
                    height: 4 * SizeConfig.heightMultiplier,
                    width: 6 * SizeConfig.widthMultiplier,
                    child: IconButton(
                      splashColor: Color(0xFFa81845).withOpacity(0.1),
                      highlightColor: Colors.grey.withOpacity(0.1),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            title: Text("Remove this notification?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("No"),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              FlatButton(
                                child: Text("Yes"),
                                onPressed: () async {
                                  await databaseMethods.deleteNotification("appointment reminder", appType);
                                  Navigator.of(context).pop();
                                }
                              ),
                            ],
                          ),
                        );
                      },
                      padding: EdgeInsets.all(0),
                      icon: Icon(CupertinoIcons.clear, size: 3 * SizeConfig.imageSizeMultiplier,),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget eventTile({BuildContext context, DateTime eventDate, DateTime createdAt, eventDesc, eventTitle,
    status, imageUrl,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => EventDetails(
            isDoctor: widget.isDoctor,
            eventDateTime: eventDate,
            imageUrl: imageUrl,
            eventTitle: eventTitle,
            eventDate: Utils.formatDate(eventDate),
            eventDesc: eventDesc,
            status: status,
          ),
        ),
        ),
      child: Container(
        //height: 11 * SizeConfig.heightMultiplier,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 8 * SizeConfig.heightMultiplier,
                width: 16 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                  gradient: kPrimaryGradientColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Icon(
                    CupertinoIcons.calendar_badge_plus,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 1 * SizeConfig.widthMultiplier,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Text("New event [$eventTitle]", maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Text("Date: ${Utils.formatDate(eventDate)} starting ${Utils.formatTime(eventDate)}", maxLines: 1,
                    style: TextStyle(
                      fontFamily: "Brand-Regular",
                      fontSize: 2 * SizeConfig.textMultiplier,
                    ),),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Text(eventDesc, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand-Regular",
                        fontSize: 2 * SizeConfig.textMultiplier,
                        color: Colors.black54,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Text("${Utils.formatDate(createdAt)}, ${Utils.formatTime(createdAt)}", style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 1.8 * SizeConfig.textMultiplier,
                        ),),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.hardEdge,
                    height: 4 * SizeConfig.heightMultiplier,
                    width: 6 * SizeConfig.widthMultiplier,
                    child: IconButton(
                      splashColor: Color(0xFFa81845).withOpacity(0.1),
                      highlightColor: Colors.grey.withOpacity(0.1),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            title: Text("Remove this notification?"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("No"),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              FlatButton(
                                child: Text("Yes"),
                                onPressed: () async {
                                  await databaseMethods.deleteNotification("event", eventTitle);
                                  Navigator.of(context).pop();
                                }
                              ),
                            ],
                          ),
                        );
                      },
                      padding: EdgeInsets.all(0),
                      icon: Icon(CupertinoIcons.clear, size: 3 * SizeConfig.imageSizeMultiplier,),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
