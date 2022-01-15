import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:portfolio_app/Utilities/utils.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
/*
* Created by Mujuzi Moses
*/

class ActivityLogsScreen extends StatelessWidget {
  final Stream activityStream;
  final bool isDoctor;
  const ActivityLogsScreen({Key key, this.activityStream, this.isDoctor}) : super(key: key);

  Widget activityList() {
    return StreamBuilder(
      stream: activityStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? GroupedListView(
          elements: snapshot.data.docs,
          groupBy: (element) {
            Timestamp timeStr = element["created_at"];
            DateTime time = timeStr.toDate();
            //return Utils.formatDate(time);
            if (Utils.formatDate(time) == Utils.formatDate(DateTime.now())) {
              return "Today";
            } else if (Utils.formatDate(time) == Utils.formatDate(DateTime.now().subtract(Duration(days: 1)))) {
              return "Yesterday";
            } else {
              return Utils.formatDate(time);
            }
          },
          groupComparator: (val1, val2) => val2.compareTo(val1),
          itemComparator: (item1, item2) =>
          item1["created_at"].compareTo(item2["created_at"]),
          useStickyGroupSeparators: true,
          stickyHeaderBackgroundColor: Colors.transparent,
          sort: false,
          groupSeparatorBuilder: (val) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 39 * SizeConfig.widthMultiplier),
            child: Container(
              height: 3 * SizeConfig.heightMultiplier,
              decoration: BoxDecoration(
                color: Color(0xFFa81845).withOpacity(0.6),
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
              child: Center(
                child: Text(val, maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "Brand-Regular",
                    fontSize: 1.6 * SizeConfig.textMultiplier,
                    color: Colors.white,
                ),),
              ),
            ),
          ),
          itemBuilder: (context, element) {
            String type = element["type"];
            Timestamp timeStr = element["created_at"];
            DateTime time = timeStr.toDate();
            if (type == "post") {
              String postType = element["post_type"];
              String postHeading = element["post_heading"];
              return postTile(
                postType: postType,
                postHeading: postHeading,
                time: time,
              );
            } else if (type == "edit") {
              String editType = element["edit_type"];
              return editTile(
                editType: editType,
                time: time,
              );
            } else if (type == "buy") {
              String buyType = element["buy_type"];
              String drugName = element["name"];
              List drugNames = element["names"];
              return buyTile(
                buyType: buyType,
                drugName: drugName,
                drugNames: drugNames,
                time: time,
              );
            } else if (type == "call") {
              String callType = element["call_type"];
              String receiver = element["receiver"];
              return callTile(
                time: time,
                callType: callType,
                receiver: receiver,
              );
            } else if (type == "request") {
              String toHospital = element["to_hospital"];
              String from = element["from_location"];
              return requestTile(
                time: time,
                from: from,
                toHospital: toHospital,
              );
            } else if (type == "message") {
              String messageType = element["message_type"];
              String receiver = element["receiver"];
              return messageTile(
                time: time,
                messageType: messageType,
                receiver: receiver,
              );
            } else if (type == "reminder") {
              String reminderType = element["reminder_type"];
              if (reminderType == "appointment") {
                String user = element["user"];
                Timestamp timeStr2 = element["app_time"];
                DateTime appTime = timeStr2.toDate();
                return appointmentTile(
                  time: time,
                  user: user,
                  appTime: appTime,
                );
              } else if (reminderType == "event") {
                String eventTitle = element["event_title"];
                Timestamp timeStr2 = element["event_date"];
                DateTime eventDate = timeStr2.toDate();
                return eventTile(
                  time: time,
                  eventTitle: eventTitle,
                  eventDate: eventDate,
                );
              } else if (reminderType == "medicine") {
                String drugName = element["name"];
                String cycle = element["cycle"];
                String howLong = element["how_long"];
                return medicineTile(
                  time: time,
                  drugName: drugName,
                  cycle: cycle,
                  howLong: howLong,
                );
              } else return Container();
            } else if (type == "saved") {
              String savedType = element["saved_type"];
              String patientName = element["patient_name"];
              return savedTile(
                time: time,
                savedType: savedType,
                patientName: patientName,
              );
            } else return Container();
          },
        ) : Container(
          child: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Column(
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFa81845)),),
                ),
              ],
            ),
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
          title: Text("Activity Logs", style: TextStyle(fontFamily: "Brand Bold", color: Color(0xFFa81845)),),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[100],
          child: activityList(),
        ),
      ),
    );
  }

  Widget medicineTile({DateTime time, drugName, cycle, howLong}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0.5 * SizeConfig.heightMultiplier,
        horizontal: 3 * SizeConfig.widthMultiplier,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 5 * SizeConfig.heightMultiplier,
            width: 10 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Color(0xFFa81845), width: 1.5),
            ),
            child: Center(
              child: Stack(
                children: <Widget>[
                  Icon(CupertinoIcons.alarm_fill, color: Color(0xFFa81845),),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.grey[100]),
                      child: Padding(
                        padding: EdgeInsets.only(left: 2),
                        child: Icon(
                          FontAwesomeIcons.pills,
                          color: Color(0xFFa81845),
                          size: 2.5 * SizeConfig.imageSizeMultiplier,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 1 * SizeConfig.widthMultiplier,),
          Container(
            height: 11.5 * SizeConfig.heightMultiplier,
            width: 80 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 75 * SizeConfig.widthMultiplier,
                    child: Text("REMINDER",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Brand-Regular",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Text("Created medicine reminder; $drugName, $cycle a day for $howLong",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Container(
                          child: Text("${Utils.formatDate(time)}, ${Utils.formatTime(time)}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Brand-Regular",
                              fontSize: 1.8 * SizeConfig.textMultiplier,
                            ),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget eventTile({DateTime time, DateTime eventDate, eventTitle}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0.5 * SizeConfig.heightMultiplier,
        horizontal: 3 * SizeConfig.widthMultiplier,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 5 * SizeConfig.heightMultiplier,
            width: 10 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Color(0xFFa81845), width: 1.5),
            ),
            child: Center(
              child: Stack(
                children: <Widget>[
                  Icon(CupertinoIcons.alarm_fill, color: Color(0xFFa81845),),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.grey[100]),
                      child: Padding(
                        padding: EdgeInsets.only(left: 2),
                        child: Icon(
                          CupertinoIcons.calendar_badge_plus,
                          color: Color(0xFFa81845),
                          size: 2.5 * SizeConfig.imageSizeMultiplier,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 1 * SizeConfig.widthMultiplier,),
          Container(
            height: 11.5 * SizeConfig.heightMultiplier,
            width: 80 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 75 * SizeConfig.widthMultiplier,
                    child: Text("REMINDER",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Brand-Regular",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Text("Created event reminder, Title: $eventTitle, "
                        "happening on ${Utils.formatDate(eventDate)} at ${Utils.formatTime(eventDate)}", maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Container(
                          child: Text("${Utils.formatDate(time)}, ${Utils.formatTime(time)}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Brand-Regular",
                              fontSize: 1.8 * SizeConfig.textMultiplier,
                            ),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget appointmentTile({DateTime time, user, DateTime appTime}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0.5 * SizeConfig.heightMultiplier,
        horizontal: 3 * SizeConfig.widthMultiplier,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 5 * SizeConfig.heightMultiplier,
            width: 10 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Color(0xFFa81845), width: 1.5),
            ),
            child: Center(
              child: Stack(
                children: <Widget>[
                  Icon(CupertinoIcons.alarm_fill, color: Color(0xFFa81845),),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.grey[100]),
                      child: Padding(
                        padding: EdgeInsets.only(left: 2),
                        child: Icon(
                          FontAwesomeIcons.calendarAlt,
                          color: Color(0xFFa81845),
                          size: 2.5 * SizeConfig.imageSizeMultiplier,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 1 * SizeConfig.widthMultiplier,),
          Container(
            height: 11.5 * SizeConfig.heightMultiplier,
            width: 80 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 75 * SizeConfig.widthMultiplier,
                    child: Text("REMINDER",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Brand-Regular",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: 70 * SizeConfig.widthMultiplier,
                          child: Text("Created appointment reminder "
                              "with ${isDoctor == true ? user : "Dr. $user"}, "
                              "on ${Utils.formatDate(appTime)} at ${Utils.formatTime(appTime)}", maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "Brand Bold",
                              fontSize: 2 * SizeConfig.textMultiplier,
                            ),),
                        ),
                        Container(
                          width: 70 * SizeConfig.widthMultiplier,
                          child: Row(
                            children: <Widget>[
                              Spacer(),
                              Container(
                                child: Text("${Utils.formatDate(time)}, ${Utils.formatTime(time)}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Brand-Regular",
                                    fontSize: 1.8 * SizeConfig.textMultiplier,
                                  ),),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget requestTile({DateTime time, from, toHospital}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0.5 * SizeConfig.heightMultiplier,
        horizontal: 3 * SizeConfig.widthMultiplier,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 5 * SizeConfig.heightMultiplier,
            width: 10 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Color(0xFFa81845), width: 1.5),
            ),
            child: Center(
              child: Icon(
                FontAwesomeIcons.ambulance,
                size: 4.5 * SizeConfig.imageSizeMultiplier,
                color: Color(0xFFa81845),
              ),
            ),
          ),
          SizedBox(width: 1 * SizeConfig.widthMultiplier,),
          Container(
            height: 11.5 * SizeConfig.heightMultiplier,
            width: 80 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 75 * SizeConfig.widthMultiplier,
                    child: Text("REQUEST",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Brand-Regular",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Text("You requested an ambulance from $from to $toHospital", maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Container(
                          child: Text("${Utils.formatDate(time)}, ${Utils.formatTime(time)}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Brand-Regular",
                              fontSize: 1.8 * SizeConfig.textMultiplier,
                            ),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget messageTile({DateTime time, messageType, receiver}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0.5 * SizeConfig.heightMultiplier,
        horizontal: 3 * SizeConfig.widthMultiplier,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 5 * SizeConfig.heightMultiplier,
            width: 10 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Color(0xFFa81845), width: 1.5),
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.ellipses_bubble_fill,
                color: Color(0xFFa81845),
              ),
            ),
          ),
          SizedBox(width: 1 * SizeConfig.widthMultiplier,),
          Container(
            height: 11.5 * SizeConfig.heightMultiplier,
            width: 80 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 75 * SizeConfig.widthMultiplier,
                    child: Text("MESSAGE",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Brand-Regular",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Text("Sent $messageType message to ${isDoctor == true ? receiver : "Dr. $receiver"}", maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Container(
                          child: Text("${Utils.formatDate(time)}, ${Utils.formatTime(time)}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Brand-Regular",
                              fontSize: 1.8 * SizeConfig.textMultiplier,
                            ),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget callTile({DateTime time, callType, receiver}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0.5 * SizeConfig.heightMultiplier,
        horizontal: 3 * SizeConfig.widthMultiplier,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 5 * SizeConfig.heightMultiplier,
            width: 10 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Color(0xFFa81845), width: 1.5),
            ),
            child: Center(
              child: Icon(
                Icons.phone_rounded,
                color: Color(0xFFa81845),
              ),
            ),
          ),
          SizedBox(width: 1 * SizeConfig.widthMultiplier,),
          Container(
            height: 11.5 * SizeConfig.heightMultiplier,
            width: 80 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 75 * SizeConfig.widthMultiplier,
                    child: Text("CALL",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Brand-Regular",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Text("${callType.toString().toUpperCase()} called ${isDoctor == true ? receiver : "Dr. $receiver"}", maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Container(
                          child: Text("${Utils.formatDate(time)}, ${Utils.formatTime(time)}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Brand-Regular",
                              fontSize: 1.8 * SizeConfig.textMultiplier,
                            ),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget savedTile({DateTime time, savedType, patientName}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0.5 * SizeConfig.heightMultiplier,
        horizontal: 3 * SizeConfig.widthMultiplier,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 5 * SizeConfig.heightMultiplier,
            width: 10 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Color(0xFFa81845), width: 1.5),
            ),
            child: Center(
              child: Icon(
                FontAwesomeIcons.userPlus,
                size: 4.5 * SizeConfig.imageSizeMultiplier,
                color: Color(0xFFa81845),
              ),
            ),
          ),
          SizedBox(width: 1 * SizeConfig.widthMultiplier,),
          Container(
            height: 11.5 * SizeConfig.heightMultiplier,
            width: 80 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 75 * SizeConfig.widthMultiplier,
                    child: Text("SAVED",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Brand-Regular",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Text("You saved $patientName as one of your $savedType(s)", maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Container(
                          child: Text("${Utils.formatDate(time)}, ${Utils.formatTime(time)}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Brand-Regular",
                              fontSize: 1.8 * SizeConfig.textMultiplier,
                            ),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buyTile({buyType, drugName, List drugNames, DateTime time}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0.5 * SizeConfig.heightMultiplier,
        horizontal: 3 * SizeConfig.widthMultiplier,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 5 * SizeConfig.heightMultiplier,
            width: 10 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Color(0xFFa81845), width: 1.5),
            ),
            child: Center(
              child: Icon(
                FontAwesomeIcons.cartPlus,
                size: 4.5 * SizeConfig.imageSizeMultiplier,
                color: Color(0xFFa81845),
              ),
            ),
          ),
          SizedBox(width: 1 * SizeConfig.widthMultiplier,),
          Container(
            height: 11.5 * SizeConfig.heightMultiplier,
            width: 80 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 75 * SizeConfig.widthMultiplier,
                    child: Text("PURCHASE",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Brand-Regular",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Text("You bought $buyType ${drugName != null ? "name : $drugName" : "names:"
                        " ${drugNames.first},...${drugNames.last}"}", maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Container(
                          child: Text("${Utils.formatDate(time)}, ${Utils.formatTime(time)}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Brand-Regular",
                              fontSize: 1.8 * SizeConfig.textMultiplier,
                            ),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget editTile({DateTime time, editType}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0.5 * SizeConfig.heightMultiplier,
        horizontal: 3 * SizeConfig.widthMultiplier,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 5 * SizeConfig.heightMultiplier,
            width: 10 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Color(0xFFa81845), width: 1.5),
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.pencil,
                color: Color(0xFFa81845),
              ),
            ),
          ),
          SizedBox(width: 1 * SizeConfig.widthMultiplier,),
          Container(
            height: 11.5 * SizeConfig.heightMultiplier,
            width: 80 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 75 * SizeConfig.widthMultiplier,
                    child: Text("EDITED",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Brand-Regular",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Text("You changed your $editType", maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Container(
                          child: Text("${Utils.formatDate(time)}, ${Utils.formatTime(time)}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Brand-Regular",
                              fontSize: 1.8 * SizeConfig.textMultiplier,
                            ),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget postTile({postType, postHeading, DateTime time}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0.5 * SizeConfig.heightMultiplier,
        horizontal: 3 * SizeConfig.widthMultiplier,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 5 * SizeConfig.heightMultiplier,
            width: 10 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Color(0xFFa81845), width: 1.5),
            ),
            child: Center(
              child: Icon(
                FontAwesomeIcons.newspaper,
                size: 4.5 * SizeConfig.imageSizeMultiplier,
                color: Color(0xFFa81845),
              ),
            ),
          ),
          SizedBox(width: 1 * SizeConfig.widthMultiplier,),
          Container(
            height: 11.5 * SizeConfig.heightMultiplier,
            width: 80 * SizeConfig.widthMultiplier,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 75 * SizeConfig.widthMultiplier,
                    child: Text("POST",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Brand-Regular",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Text("Made $postType post, with heading: $postHeading", maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                  ),
                  Container(
                    width: 70 * SizeConfig.widthMultiplier,
                    child: Row(
                      children: <Widget>[
                        Spacer(),
                        Container(
                          child: Text("${Utils.formatDate(time)}, ${Utils.formatTime(time)}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Brand-Regular",
                              fontSize: 1.8 * SizeConfig.textMultiplier,
                            ),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
