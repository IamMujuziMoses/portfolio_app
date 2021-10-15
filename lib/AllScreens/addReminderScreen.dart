import 'dart:math';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/bookAppointmentScreen.dart';
import 'package:creativedata_app/Models/notification.dart';
import 'package:creativedata_app/Models/reminder.dart';
import 'package:creativedata_app/Utilities/utils.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/main.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
/*
* Created by Mujuzi Moses
*/

class AddReminderScreen extends StatefulWidget {
  AddReminderScreen({Key key}) : super(key: key);

  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

List<String> timeList = ["6:00am", "6:30am", "7:00am", "7:30am", "8:00am", "8:30am", "9:00am", "9:30am",
  "10:00am", "10:30am", "11:00am", "11:30am", "12:00pm", "12:30pm", "1:00pm", "1:30pm", "2:00pm",
  "2:30pm", "3:00pm", "3:30pm", "4:00pm", "4:30pm", "5:00pm", "5:30pm", "6:00pm", "6:30pm",
  "7:00pm", "7:30pm", "8:00pm", "8:30pm", "9:00pm", "9:30pm", "10:00pm", "10:30pm", "11:00pm"];

class _AddReminderScreenState extends State<AddReminderScreen> {
  TextEditingController titleTEC = TextEditingController();
  TextEditingController dosageTEC = TextEditingController();
  TextEditingController tabletsTEC = TextEditingController();
  TextEditingController timeTEC = TextEditingController();
  TextEditingController alarmTimeTEC = TextEditingController();

  List<String> timesToTake = [];
  List<String> alarmTimesToTake = [];

  int selectedIndex = 0;
  double timeHeight = 0;
  String timeSelectedValue = "";
  String periodSelectedValue = "";
  String howLongSelectedValue = "";

  bool periodVisible = false;
  bool morningVisible = false;
  bool breakfastVisible = false;
  bool midMorningVisible = false;
  bool lunchVisible = false;
  bool eveningVisible = false;
  bool nightVisible = false;
  bool startTimeVisible = false;

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
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
          title: Text("Add Reminder", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Colors.red[300],
          ),),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            color: Colors.grey[100],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text("Please fill in all fields correctly.", style: TextStyle(
                      fontFamily: "Brand Bold",
                      color: Colors.black54,
                      fontSize: 2 * SizeConfig.textMultiplier,
                    ),),
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Text("Name of medicine", style: TextStyle(
                    fontFamily: "Brand Bold",
                    fontSize: 3 * SizeConfig.textMultiplier,
                  ),),
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  Container(
                    width: 95 * SizeConfig.widthMultiplier,
                    child: TextField(
                      controller: titleTEC,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "e.g Paracetamol 100mg",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                        fontFamily: "Brand-Regular",
                      ),
                    ),
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Text("Dosage", style: TextStyle(
                    fontFamily: "Brand Bold",
                    fontSize: 3 * SizeConfig.textMultiplier,
                  ),),
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  Container(
                    width: 95 * SizeConfig.widthMultiplier,
                    child: TextField(
                      controller: dosageTEC,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "e.g 100mg",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                        fontFamily: "Brand-Regular",
                      ),
                    ),
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Text("Tablets to take", style: TextStyle(
                    fontFamily: "Brand Bold",
                    fontSize: 3 * SizeConfig.textMultiplier,
                  ),),
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  Container(
                    width: 95 * SizeConfig.widthMultiplier,
                    child: TextField(
                      controller: tabletsTEC,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "tablets to take each time (e.g 2)",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                        fontFamily: "Brand-Regular",
                      ),
                    ),
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Text("Times a day", style: TextStyle(
                    fontFamily: "Brand Bold",
                    fontSize: 3 * SizeConfig.textMultiplier,
                  ),),
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  _dropDownList(
                    listItems: ["Once", "2 times", "3 times", "4 times",],
                    placeholder: "Times a day",
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Text("How long", style: TextStyle(
                    fontFamily: "Brand Bold",
                    fontSize: 3 * SizeConfig.textMultiplier,
                  ),),
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  _dropDownList(
                    listItems: ["1 day", "2-3 days", "1 week", "2-3 weeks", "1 month"],
                    placeholder: "How long",
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Visibility(
                    visible: periodVisible,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Periods", style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 3 * SizeConfig.textMultiplier,
                        ),),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        _dropDownList(
                          listItems: ["Morning", "After Breakfast", "Mid Morning", "After Lunch", "Evening", "Night"],
                          placeholder: "Period",
                        ),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        Visibility(
                          visible: morningVisible,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text("Morning", style: TextStyle(
                                      fontFamily: "Brand Bold",
                                      color: Colors.black54,
                                      fontSize: 3 * SizeConfig.textMultiplier,
                                    ),),
                                    Text("(06:00 am - 09:30 am)", style: TextStyle(
                                      fontFamily: "Brand-Regular",
                                      color: Colors.black54,
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                    ),),
                                  ],
                                ),
                                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    button(time: "6:00", amPm: "am", index: 0,),
                                    button(time: "6:30", amPm: "am", index: 1,),
                                    button(time: "7:00", amPm: "am", index: 2,),
                                    button(time: "7:30", amPm: "am", index: 3,),
                                  ],
                                ),
                                SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    button(time: "8:00", amPm: "am", index: 4,),
                                    button(time: "8:30", amPm: "am", index: 5,),
                                    button(time: "9:00", amPm: "am", index: 6,),
                                    button(time: "9:30", amPm: "am", index: 7,),
                                  ],
                                ),
                                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: breakfastVisible,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text("After Breakfast", style: TextStyle(
                                      fontFamily: "Brand Bold",
                                      color: Colors.black54,
                                      fontSize: 3 * SizeConfig.textMultiplier,
                                    ),),
                                    Text("(08:30 am - 11:00 am)", style: TextStyle(
                                      fontFamily: "Brand-Regular",
                                      color: Colors.black54,
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                    ),),
                                  ],
                                ),
                                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    button(time: "8:30", amPm: "am", index: 0,),
                                    button(time: "9:00", amPm: "am", index: 1,),
                                    button(time: "9:30", amPm: "am", index: 2,),
                                  ],
                                ),
                                SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    button(time: "10:00", amPm: "am", index: 3,),
                                    button(time: "10:30", amPm: "am", index: 4,),
                                    button(time: "11:00", amPm: "am", index: 5,),
                                  ],
                                ),
                                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: midMorningVisible,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text("Mid Morning", style: TextStyle(
                                      fontFamily: "Brand Bold",
                                      color: Colors.black54,
                                      fontSize: 3 * SizeConfig.textMultiplier,
                                    ),),
                                    Text("(10:00 am - 1:30 pm)", style: TextStyle(
                                      fontFamily: "Brand-Regular",
                                      color: Colors.black54,
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                    ),),
                                  ],
                                ),
                                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    button(time: "10:00", amPm: "am", index: 0,),
                                    button(time: "10:30", amPm: "am", index: 1,),
                                    button(time: "11:00", amPm: "am", index: 2,),
                                    button(time: "11:30", amPm: "am", index: 3,),
                                  ],
                                ),
                                SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    button(time: "12:00", amPm: "pm", index: 4,),
                                    button(time: "12:30", amPm: "pm", index: 5,),
                                    button(time: "1:00", amPm: "pm", index: 6,),
                                    button(time: "1:30", amPm: "pm", index: 7,),
                                  ],
                                ),
                                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: lunchVisible,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text("After Lunch", style: TextStyle(
                                      fontFamily: "Brand Bold",
                                      color: Colors.black54,
                                      fontSize: 3 * SizeConfig.textMultiplier,
                                    ),),
                                    Text("(12:30 pm - 3:00 pm)", style: TextStyle(
                                      fontFamily: "Brand-Regular",
                                      color: Colors.black54,
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                    ),),
                                  ],
                                ),
                                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    button(time: "12:30", amPm: "pm", index: 0,),
                                    button(time: "1:00", amPm: "pm", index: 1,),
                                    button(time: "1:30", amPm: "pm", index: 2,),
                                  ],
                                ),
                                SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    button(time: "2:00", amPm: "pm", index: 3,),
                                    button(time: "2:30", amPm: "pm", index: 4,),
                                    button(time: "3:00", amPm: "pm", index: 5,),
                                  ],
                                ),
                                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: eveningVisible,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text("Evening", style: TextStyle(
                                      fontFamily: "Brand Bold",
                                      color: Colors.black54,
                                      fontSize: 3 * SizeConfig.textMultiplier,
                                    ),),
                                    Text("(3:30 pm - 7:00 pm)", style: TextStyle(
                                      fontFamily: "Brand-Regular",
                                      color: Colors.black54,
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                    ),),
                                  ],
                                ),
                                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    button(time: "3:30", amPm: "pm", index: 0,),
                                    button(time: "4:00", amPm: "pm", index: 1,),
                                    button(time: "4:30", amPm: "pm", index: 2,),
                                    button(time: "5:00", amPm: "pm", index: 3,),
                                  ],
                                ),
                                SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    button(time: "5:30", amPm: "pm", index: 4,),
                                    button(time: "6:00", amPm: "pm", index: 5,),
                                    button(time: "6:30", amPm: "pm", index: 6,),
                                    button(time: "7:00", amPm: "pm", index: 7,),
                                  ],
                                ),
                                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: nightVisible,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text("Night", style: TextStyle(
                                      fontFamily: "Brand Bold",
                                      color: Colors.black54,
                                      fontSize: 3 * SizeConfig.textMultiplier,
                                    ),),
                                    Text("(7:30 pm - 11:00 pm)", style: TextStyle(
                                      fontFamily: "Brand-Regular",
                                      color: Colors.black54,
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                    ),),
                                  ],
                                ),
                                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    button(time: "7:30", amPm: "pm", index: 0,),
                                    button(time: "8:00", amPm: "pm", index: 1,),
                                    button(time: "8:30", amPm: "pm", index: 2,),
                                    button(time: "9:00", amPm: "pm", index: 3,),
                                  ],
                                ),
                                SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    button(time: "9:30", amPm: "pm", index: 4,),
                                    button(time: "10:00", amPm: "pm", index: 5,),
                                    button(time: "10:30", amPm: "pm", index: 6,),
                                    button(time: "11:00", amPm: "am", index: 7,),
                                  ],
                                ),
                                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: startTimeVisible,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Start time", style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 3 * SizeConfig.textMultiplier,
                        ),),
                        SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                        Container(
                          width: 30 * SizeConfig.widthMultiplier,
                            height: timeHeight,
                            child: ListView.builder(
                              itemCount: timesToTake.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: ClampingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    child: Text("${index + 1}: ${timesToTake[index]}", style: TextStyle(
                                      fontFamily: "Brand-Regular",
                                      color: Colors.grey,
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                    ),),
                                  ),
                                );
                              },
                            ),
                        ),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Container(
                          width: 95 * SizeConfig.widthMultiplier,
                          height: 7 * SizeConfig.heightMultiplier,
                          child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5
                            ),
                            itemCount: timeList.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              String timeStr = timeList[index];
                              int idx = timeStr.indexOf(":");
                              int idx2 = timeStr.indexOf(":") + 3;
                              String hour = timeStr.substring(0, idx2);
                              String amPm = timeStr.substring(idx+3).trim();
                              return button(time: hour, amPm: amPm, index: index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Center(
                    child: Container(
                      width: 50 * SizeConfig.widthMultiplier,
                      child: RaisedButton(
                        onPressed: () => createReminder(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: Colors.red[300],
                        splashColor: Colors.white,
                        highlightColor: Colors.grey.withOpacity(0.1),
                        padding: EdgeInsets.all(0),
                        child: Text("Create Reminder", style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          color: Colors.white,
                        ),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget button({String time, int index, String amPm}) {
    int idx = time.indexOf(":");
    String hour = time.substring(0, idx);
    String min = time.substring(idx+1);
    int hourInt = int.parse(hour);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            spreadRadius: 1,
            blurRadius: 5,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: selectedIndex == index ? Colors.red[300] : Colors.white,
        child: InkWell(
          splashColor: Colors.red[200],
          highlightColor: Colors.grey.withOpacity(0.1),
          radius: 800,
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            changeIndex(index);
            setState(() {
              timeTEC.text = "$time $amPm";
              alarmTimeTEC.text = "${amPm == "am" ? "${hourInt > 9 ? "$hour" : "0$hour"}" : hour != "12" ? "${hourInt + 12}" : "12"}, $min";
            });
            if (startTimeVisible == true) {
              if (timeSelectedValue == "2 times") {
                setState(() {
                  timesToTake = ["$time $amPm", "$time ${amPm == "am" ? "pm" : "am"}"];
                  alarmTimesToTake = [
                    "${amPm == "am" ? "${hourInt > 9 ? "$hour" : "0$hour"}" : hour != "12" ? "${hourInt + 12}" : "12"}, $min",
                    "${amPm == "am" ? "${hourInt + 12}" : hour != "12" ? "${hourInt > 9 ? "$hour" : "0$hour"}" : "00"}, $min",
                  ];
                });
              }
              if (timeSelectedValue == "3 times") {
                int hourInt = int.parse(hour);
                String amPMin = "";
                String pmAMin = "";

                if (hourInt + 16 < 24) {
                  if (amPm == "am") {
                    pmAMin = "pm";
                  }
                } else if (hourInt + 16 > 24) {
                  if (amPm == "am") {
                    pmAMin = "am";
                  }
                }
                if (hourInt + 16 == 24) {
                  if (amPm == "am") {
                    pmAMin = "am";
                  } else if (amPm == "pm") {
                    pmAMin = "pm";
                  }
                }
                if (hourInt + 16 < 24) {
                  if (amPm == "pm") {
                    pmAMin = "am";
                  }
                } else if (hourInt + 16 > 24) {
                  if (amPm == "pm") {
                    pmAMin = "pm";
                  }
                }
                if (hourInt + 4 == 12) {
                  if (amPm == "pm") {
                    pmAMin = "pm";
                  } else if (amPm == "am") {
                    pmAMin = "am";
                  }
                }
                if (hourInt == 12) {
                  if (amPm == "pm") {
                    pmAMin = "am";
                  } else if (amPm == "am") {
                    pmAMin = "pm";
                  }
                }
                if (hourInt + 8 < 12) {
                  if (amPm == "am") {
                    amPMin = "am";
                  }
                } else if (hourInt + 8 > 12) {
                  if (amPm == "am") {
                    amPMin = "pm";
                  }
                }
                if (hourInt + 8 == 12) {
                  if (amPm == "am") {
                    amPMin = "pm";
                  } else if (amPm == "pm") {
                    amPMin = "am";
                  }
                }
                if (hourInt + 8 < 12) {
                  if (amPm == "pm") {
                    amPMin = "pm";
                  }
                } else if (hourInt + 8 > 12) {
                  if (amPm == "pm") {
                    amPMin = "am";
                  }
                }
                if (hourInt == 12) {
                  if (amPm == "pm"){
                    amPMin = "pm";
                  } else if (amPm == "am") {
                    amPMin = "am";
                  }
                }
                setState(() {
                  timesToTake = ["$time $amPm",
                    "${hourInt + 8 > 12 ? (hourInt + 8) - 12 : hourInt + 8}:$min $amPMin",
                    "${hourInt + 16 > 24 ? (hourInt + 16) - 24 : (hourInt + 16) - 12}:$min $pmAMin"
                  ];
                  alarmTimesToTake = [
                    "${amPm == "am" ? "${hourInt > 9 ? "$hour" : "0$hour"}" : hour != "12" ? "${hourInt + 12}" : "12"}, $min",
                    "${amPm == "am" ? "${hourInt + 8}" : "${hour != "12" ? "${hourInt + 12 + 8 >= 24 ? "${hourInt + 12 + 8 == 24 ? "00" : "0${hourInt + 12 + 8 - 24}"}" : "${hourInt + 12 + 8}"}" : "${hourInt + 8}"}"}, $min",
                    "${amPm == "am" ? "${hourInt + 16 >= 24 ? "${hourInt + 16 == 24 ? "00" : "0${hourInt + 16 - 24}"}" : "${hourInt + 16}"}" : "${hour != "12" ? "${hourInt + 16 >= 24 ? "${hourInt + 16 == 24 ? "12" : "${hourInt + 16 - 12}"}" : "0${hourInt + 16 - 12}"}" : "0${hourInt + 16 - 24}"}"}, $min",
                  ];
                });
              }
              if (timeSelectedValue == "4 times") {
                int hourInt = int.parse(hour);
                String amPMin = "";
                String pmAMin = "";
                if (hourInt < 6 || hourInt == 12) {
                  if (amPm == "am") {
                    amPMin = "am";
                  } else if (amPm == "pm") {
                    amPMin = "pm";
                  }
                } else if (hourInt >= 6) {
                  if (amPm == "am") {
                    amPMin = "pm";
                  } else if (amPm == "pm") {
                    amPMin = "am";
                  }
                }

                if (hourInt < 6 || hourInt == 12) {
                  if (amPm == "am") {
                    pmAMin = "pm";
                  } else if (amPm == "pm") {
                    pmAMin = "am";
                  }
                } else if (hourInt >= 6) {
                  if (amPm == "am") {
                    pmAMin = "am";
                  } else if (amPm == "pm") {
                    pmAMin = "pm";
                  }
                }
                setState(() {
                  timesToTake = ["$time $amPm",
                    "${hourInt + 6 > 12 ? (hourInt + 6) - 12 : hourInt + 6}:$min $amPMin",
                    "$time ${amPm == "am" ? "pm" : "am"}",
                    "${hourInt + 6 > 12 ? (hourInt + 6) - 12 : hourInt + 6}:$min $pmAMin",
                  ];
                  alarmTimesToTake = [
                    "${amPm == "am" ? "${hourInt > 9 ? "$hour" : "0$hour"}" : hour != "12" ? "${hourInt + 12}" : "12"}, $min",
                    "${amPm == "am" ? "${hourInt + 6}" : "${hour == "12" ? "${hourInt + 6}" : "${hourInt + 6 >= 12 ? "${hourInt + 6 == 12 ? "00" : "0${hourInt + 6 - 12}"}" : "${hourInt + 12 + 6}"}"}"}, $min",
                    "${amPm == "am" ? "${hourInt + 12}" : "${hour != "12" ? "${hourInt > 9 ? "$hour" : "0$hour"}" : "00"}"}, $min",
                    "${amPm == "am" ? "${hourInt + 18 == 24 ? "00" : "0${hourInt + 18 - 24}"}"
                        : "${hour != "12" ? "${hourInt + 18  >= 24 ? "${hourInt + 18 == 24 ? "12" : "${hourInt + 18 - 12}"}" : "${hourInt + 18 - 12 >= 10 ? "${hourInt + 18 - 12}" : "0${hourInt + 18 - 12}"}"}" : "0${hourInt + 18 - 24}"}"}, $min",
                  ];
                });
              }
            }
            },
          child: Container(
            height: 5 * SizeConfig.heightMultiplier,
            width: 22 * SizeConfig.widthMultiplier,
            child: Padding(
              padding: EdgeInsets.only(),
              child: Center(
                child: Text("$time $amPm", style: TextStyle(
                  color: selectedIndex == index ? Colors.white : Colors.black45,
                  fontFamily: "Brand-Regular",
                  fontSize: 2.2 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.bold,
                ),),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dropDownList({String placeholder, List listItems}) {
    String valueChoose;
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField(
              decoration: InputDecoration.collapsed(hintText: ""),
              hint: Text(placeholder, style: TextStyle(
                  fontFamily: "brand-Regular",
                  fontSize: 2.5 * SizeConfig.textMultiplier,
                  color: Colors.grey,
                ),),
              dropdownColor: Colors.white,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.red[300],
                size: 5 * SizeConfig.imageSizeMultiplier,
              ),
              iconSize: 8 * SizeConfig.imageSizeMultiplier,
              isExpanded: true,
              value: valueChoose,
              onChanged: (newValue) {
                setState(() {
                  valueChoose = newValue;
                });

                if (placeholder == "Times a day") {
                  setState(() {
                    timeSelectedValue = valueChoose;
                  });
                  if (timeSelectedValue == "Once") {
                    setState(() {
                      periodVisible = true;
                      startTimeVisible = false;
                      selectedIndex = 0;
                    });
                  } else {
                    setState(() {
                      periodVisible = false;
                      startTimeVisible = true;
                      morningVisible = false;
                      breakfastVisible = false;
                      midMorningVisible = false;
                      lunchVisible = false;
                      eveningVisible = false;
                      nightVisible = false;
                    });
                  }

                  if (timeSelectedValue == "2 times") {
                    setState(() {
                      selectedIndex = 0;
                      timesToTake = ["6:00 am", "6:00 pm"];
                      alarmTimesToTake = ["06, 00", "18, 00"];
                      timeHeight = 8 * SizeConfig.heightMultiplier;
                    });
                  }
                  if (timeSelectedValue == "3 times") {
                    setState(() {
                      selectedIndex = 0;
                      timesToTake = ["6:00 am", "2:00 pm", "10:00 pm"];
                      alarmTimesToTake = ["06, 00", "14, 00", "22, 00"];
                      timeHeight = 12 * SizeConfig.heightMultiplier;
                    });
                  }
                  if (timeSelectedValue == "4 times") {
                    setState(() {
                      selectedIndex = 0;
                      timesToTake = ["6:00 am", "12:00 pm", "6:00 pm", "12:00 am"];
                      alarmTimesToTake = ["06, 00", "12, 00", "18, 000", "00, 00"];
                      timeHeight = 16 * SizeConfig.heightMultiplier;
                    });
                  }
                }
                if (placeholder  == "Period") {
                  setState(() {
                    periodSelectedValue = valueChoose;
                  });
                  switch (periodSelectedValue) {
                    case "Morning":
                      setState(() {
                        timeTEC.text = "6:00 am";
                        alarmTimeTEC.text = "06, 00";
                        selectedIndex = 0;
                        morningVisible = true;
                        breakfastVisible = false;
                        midMorningVisible = false;
                        lunchVisible = false;
                        eveningVisible = false;
                        nightVisible = false;
                      });
                      break;
                    case "After Breakfast":
                      setState(() {
                        timeTEC.text = "8:30 am";
                        alarmTimeTEC.text = "08, 00";
                        selectedIndex = 0;
                        morningVisible = false;
                        breakfastVisible = true;
                        midMorningVisible = false;
                        lunchVisible = false;
                        eveningVisible = false;
                        nightVisible = false;
                      });
                      break;
                    case "Mid Morning":
                      setState(() {
                        timeTEC.text = "10:00 am";
                        alarmTimeTEC.text = "10, 00";
                        selectedIndex = 0;
                        morningVisible = false;
                        breakfastVisible = false;
                        midMorningVisible = true;
                        lunchVisible = false;
                        eveningVisible = false;
                        nightVisible = false;
                      });
                      break;
                    case "After Lunch":
                      setState(() {
                        timeTEC.text = "12:30 pm";
                        alarmTimeTEC.text = "12, 30";
                        selectedIndex = 0;
                        morningVisible = false;
                        breakfastVisible = false;
                        midMorningVisible = false;
                        lunchVisible = true;
                        eveningVisible = false;
                        nightVisible = false;
                      });
                      break;
                    case "Evening":
                      setState(() {
                        timeTEC.text = "3:30 pm";
                        alarmTimeTEC.text = "15, 30";
                        selectedIndex = 0;
                        morningVisible = false;
                        breakfastVisible = false;
                        midMorningVisible = false;
                        lunchVisible = false;
                        eveningVisible = true;
                        nightVisible = false;
                      });
                      break;
                    case "Night":
                      setState(() {
                        timeTEC.text = "7:30 pm";
                        alarmTimeTEC.text = "19, 30";
                        selectedIndex = 0;
                        morningVisible = false;
                        breakfastVisible = false;
                        midMorningVisible = false;
                        lunchVisible = false;
                        eveningVisible = false;
                        nightVisible = true;
                      });
                      break;
                  }
                }
                if (placeholder == "How long") {
                  setState(() {
                    howLongSelectedValue = valueChoose;
                  });
                }
              },
              onSaved: (newValue) {
                setState(() {
                  valueChoose = newValue;
                });
              },
              items: listItems.map((valueItem) {
                return new DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem, style: TextStyle(
                        fontFamily: "Brand-Regular",
                        color: Colors.black,
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                  ),),
                );
              }).toList(),
            ),
          ),
        ),
      );
  }

  void scheduleAlarm({DateTime dateTime, int id, String medName}) async {
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
        id, "Medicine Reminder", "It's time to take medicine: $medName, its ${Utils.formatTime(dateTime)}",
        dateTime,
        platformChannelSpecs,
    );
  }

  void scheduleDailyAlarm({Time time, int id, String medName, DateTime dateTime}) async {
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
    await notificationsPlugin.showDailyAtTime(
        id, "Medicine Reminder", "It's time to take medicine: $medName, its ${Utils.formatTime(dateTime)}",
        time,
        platformChannelSpecs,
    );
  }

  createReminder() async {
    if (titleTEC.text.isEmpty) {
      displaySnackBar(message: "Name of medicine field is needed", context: context, label: "OK",
      );
    } else if (dosageTEC.text.isEmpty) {
      displaySnackBar(message: "Dosage field is needed", context: context, label: "OK",
      );
    } else if (tabletsTEC.text.isEmpty) {
      displaySnackBar(message: "Tablets to take field is needed", context: context, label: "OK",
      );
    } else if (timeSelectedValue.isEmpty) {
      displaySnackBar(message: "Times a day field is needed", context: context, label: "OK",
      );
    } else if (howLongSelectedValue.isEmpty) {
      displaySnackBar(message: "How long field is needed", context: context, label: "OK",
      );
    } else if (timeSelectedValue == "Once" && periodSelectedValue.isEmpty) {
      displaySnackBar(message: "Periods field is needed", context: context, label: "OK");
    } else {
      int id = Random().nextInt(100);
      List<int> idList = [];
      if (timeSelectedValue == "Once") {
        int idx = alarmTimeTEC.text.indexOf(",");
        int hour = int.parse(alarmTimeTEC.text.substring(0, idx));
        String minStr = alarmTimeTEC.text.substring(idx+1);
        int min = int.parse(minStr.trim());
        DateTime alarmDateTime = DateTime.parse("${Utils.formatForAlarm("${Utils.formatDate(DateTime.now())}, $hour, $min")}");

        CustomNotification notification = CustomNotification.newMedReminder(
          createdAt: FieldValue.serverTimestamp(),
          type: "medicine reminder",
          cycle: timeSelectedValue,
          dosage: dosageTEC.text.trim(),
          drugName: titleTEC.text.trim(),
          howLong: howLongSelectedValue,
          name: Constants.myName,
          postHeading: null,
          heading: null,
          eventTitle: null,
          appType: null,
        );
        var notificationMap = notification.toMedReminderNotification(notification);

        Reminder reminder = Reminder.onceReminder(
          name: titleTEC.text.trim(),
          dosage: dosageTEC.text.trim(),
          tablets: tabletsTEC.text.trim(),
          cycle: timeSelectedValue,
          howLong: howLongSelectedValue,
          isOnce: true,
          id: id,
          status: "waiting",
          type: "medicine",
          period: periodSelectedValue,
          onceTime: timeTEC.text.trim(),
          createdAt: FieldValue.serverTimestamp(),
        );

        if (howLongSelectedValue == "1 day") {
          if (DateTime.now().isAfter(alarmDateTime)) {
            scheduleAlarm(dateTime: alarmDateTime.add(Duration(days: 1)), id: id, medName: titleTEC.text.trim());
            reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 1)));
            Timer(Duration(days: 2), () {cancelAlarm(name: titleTEC.text.trim(), id: id);});
          } else if (DateTime.now().isBefore(alarmDateTime)) {
            scheduleAlarm(dateTime: alarmDateTime, id: id, medName: titleTEC.text.trim());
            reminder.date = Timestamp.fromDate(alarmDateTime);
            Timer(Duration(days: 1), () {cancelAlarm(name: titleTEC.text.trim(), id: id);});
          }
        } else if (howLongSelectedValue != "1 day") {
          scheduleDailyAlarm(time: Time(hour, min, 00), id: id, medName: titleTEC.text.trim(), dateTime: alarmDateTime);
          if (howLongSelectedValue == "2-3 days") {
            if (DateTime.now().isAfter(alarmDateTime)) {
              reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 3)));
            } else if (DateTime.now().isBefore(alarmDateTime)) {
              reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 2)));
            }
            Timer(Duration(days: 4), () {cancelAlarm(name: titleTEC.text.trim(), id: id);});
          } else if (howLongSelectedValue == "1 week") {
            if (DateTime.now().isAfter(alarmDateTime)) {
              reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 7)));
            } else if (DateTime.now().isBefore(alarmDateTime)) {
              reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 6)));
            }
            Timer(Duration(days: 8), () {cancelAlarm(name: titleTEC.text.trim(), id: id);});
          } else if (howLongSelectedValue == "2-3 weeks") {
            if (DateTime.now().isAfter(alarmDateTime)) {
              reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 21)));
            } else if (DateTime.now().isBefore(alarmDateTime)) {
              reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 20)));
            }
            Timer(Duration(days: 22), () {cancelAlarm(name: titleTEC.text.trim(), id: id);});
          } else if (howLongSelectedValue == "1 month") {
            if (DateTime.now().isAfter(alarmDateTime)) {
              reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 31)));
            } else if (DateTime.now().isBefore(alarmDateTime)) {
              reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 30)));
            }
            Timer(Duration(days: 32), () {cancelAlarm(name: titleTEC.text.trim(), id: id);});
          }
        }

        Map<String, dynamic> reminderMap = reminder.toOnceMap(reminder);
        await databaseMethods.createUserReminder(reminderMap, firebaseAuth.currentUser.uid);
        await databaseMethods.createNotification(notificationMap);

        Navigator.pop(context);
        displaySnackBar(message: "Created Reminder", context: context, label: "OK");

      } else if (timeSelectedValue != "Once") {
        int randomInt = Random().nextInt(100) + Random().nextInt(100);
        int randomInt2 = Random().nextInt(100) + Random().nextInt(100);
        int randomInt3 = Random().nextInt(100) + Random().nextInt(100);
        int randomInt4 = Random().nextInt(100) + Random().nextInt(100);
        if (timeSelectedValue == "2 times") {
          setState(() {
            idList = [randomInt, randomInt2];
          });
        } else if (timeSelectedValue == "3 times") {
          setState(() {
            idList = [randomInt, randomInt2, randomInt3];
          });
        } else if (timeSelectedValue == "4 times") {
          setState(() {
            idList = [randomInt, randomInt2, randomInt3, randomInt4];
          });
        }
        CustomNotification notification = CustomNotification.newMedReminder(
          createdAt: FieldValue.serverTimestamp(),
          type: "medicine reminder",
          cycle: timeSelectedValue,
          dosage: dosageTEC.text.trim(),
          drugName: titleTEC.text.trim(),
          howLong: howLongSelectedValue,
          name: Constants.myName,
          postHeading: null,
          heading: null,
          eventTitle: null,
          appType: null,
        );
        var notificationMap = notification.toMedReminderNotification(notification);

        Reminder reminder = Reminder(
          name: titleTEC.text.trim(),
          dosage: dosageTEC.text.trim(),
          tablets: tabletsTEC.text.trim(),
          cycle: timeSelectedValue,
          idList: idList,
          status: "waiting",
          howLong: howLongSelectedValue,
          isOnce: false,
          type: "medicine",
          time: timesToTake,
          createdAt: FieldValue.serverTimestamp(),
        );
        for (int i = 0; i < timesToTake.length; i++) {
          int idx = alarmTimesToTake[i].indexOf(",");
          int hour = int.parse(alarmTimesToTake[i].substring(0, idx));
          int refHour = int.parse(alarmTimesToTake[0].substring(0, idx));
          String minStr = alarmTimesToTake[i].substring(idx+1);
          String refMinStr = alarmTimesToTake[0].substring(idx+1);
          int refMin = int.parse(refMinStr.trim());
          int min = int.parse(minStr.trim());

          DateTime refDateTime = DateTime.parse("${Utils.formatForAlarm("${Utils.formatDate(DateTime.now())}, $refHour, $refMin")}");
          DateTime alarmDateTime = DateTime.parse("${Utils.formatForAlarm("${Utils.formatDate(DateTime.now())}, $hour, $min")}");

          if (howLongSelectedValue == "1 day") {
            if (DateTime.now().isAfter(refDateTime)) {
              scheduleAlarm(dateTime: alarmDateTime.add(Duration(days: 1)), id: idList[i], medName: titleTEC.text.trim());
              reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 1)));
              Timer(Duration(days: 2), () {cancelAlarm(name: titleTEC.text.trim(), id: idList[i]);});
            } else if (DateTime.now().isBefore(refDateTime)) {
              if (alarmTimesToTake[i] != alarmTimesToTake[0]) {
                if (alarmTimesToTake.length == 2) {
                  if (refHour >= 12) {
                    reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 1)));
                    scheduleAlarm(dateTime: alarmDateTime.add(Duration(days: 1)), id: idList[i], medName: titleTEC.text.trim());
                  } else {
                    reminder.date = Timestamp.fromDate(alarmDateTime);
                    scheduleAlarm(dateTime: alarmDateTime, id: idList[i], medName: titleTEC.text.trim());
                  }
                } else if (alarmTimesToTake.length == 3) {
                  if (alarmTimesToTake[i] == alarmTimesToTake[2]) {
                    if (refHour >= 8) {
                      reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 1)));
                      scheduleAlarm(dateTime: alarmDateTime.add(Duration(days: 1)), id: idList[i], medName: titleTEC.text.trim());
                    } else {
                      reminder.date = Timestamp.fromDate(alarmDateTime);
                      scheduleAlarm(dateTime: alarmDateTime, id: idList[i], medName: titleTEC.text.trim());
                    }
                  }
                  if (alarmTimesToTake[i] == alarmTimesToTake[1]) {
                    if (refHour >= 16) {
                      reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 1)));
                      scheduleAlarm(dateTime: alarmDateTime.add(Duration(days: 1)), id: idList[i], medName: titleTEC.text.trim());
                    } else {
                      reminder.date = Timestamp.fromDate(alarmDateTime);
                      scheduleAlarm(dateTime: alarmDateTime, id: idList[i], medName: titleTEC.text.trim());
                    }
                  }
                } else if (alarmTimesToTake.length == 4) {
                  if (alarmTimesToTake[i] == alarmTimesToTake[3]) {
                    reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 1)));
                    scheduleAlarm(dateTime: alarmDateTime.add(Duration(days: 1)), id: idList[i], medName: titleTEC.text.trim());
                  }
                  if (alarmTimesToTake[i] == alarmTimesToTake[2]) {
                    if (refHour >= 12) {
                      reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 1)));
                      scheduleAlarm(dateTime: alarmDateTime.add(Duration(days: 1)), id: idList[i], medName: titleTEC.text.trim());
                    } else {
                      reminder.date = Timestamp.fromDate(alarmDateTime);
                      scheduleAlarm(dateTime: alarmDateTime, id: idList[i], medName: titleTEC.text.trim());
                    }
                  }
                  if (alarmTimesToTake[i] == alarmTimesToTake[1]) {
                    if (refHour >= 18) {
                      reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 1)));
                      scheduleAlarm(dateTime: alarmDateTime.add(Duration(days: 1)), id: idList[i], medName: titleTEC.text.trim());
                    } else {
                      reminder.date = Timestamp.fromDate(alarmDateTime);
                      scheduleAlarm(dateTime: alarmDateTime, id: idList[i], medName: titleTEC.text.trim());
                    }
                  }
                }
              } else if (alarmTimesToTake[i] == alarmTimesToTake[0]) {
                reminder.date = Timestamp.fromDate(alarmDateTime);
                scheduleAlarm(dateTime: alarmDateTime, id: idList[i], medName: titleTEC.text.trim());
              }
              Timer(Duration(days: 2), () {cancelAlarm(name: titleTEC.text.trim(), id: idList[i]);});
            }
          } else if (howLongSelectedValue != "1 day") {
            scheduleDailyAlarm(time: Time(hour, min, 00), id: idList[i], medName: titleTEC.text.trim(), dateTime: alarmDateTime);
            if (howLongSelectedValue == "2-3 days") {
              if (DateTime.now().isAfter(alarmDateTime)) {
                reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 3)));
              } else if (DateTime.now().isBefore(alarmDateTime)) {
                reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 2)));
              }
              Timer(Duration(days: 4), () {cancelAlarm(name: titleTEC.text.trim(), id: idList[i]);});
            } else if (howLongSelectedValue == "1 week") {
              if (DateTime.now().isAfter(alarmDateTime)) {
                reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 7)));
              } else if (DateTime.now().isBefore(alarmDateTime)) {
                reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 6)));
              }
              Timer(Duration(days: 8), () {cancelAlarm(name: titleTEC.text.trim(), id: idList[i]);});
            } else if (howLongSelectedValue == "2-3 weeks") {
              if (DateTime.now().isAfter(alarmDateTime)) {
                reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 21)));
              } else if (DateTime.now().isBefore(alarmDateTime)) {
                reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 20)));
              }
              Timer(Duration(days: 22), () {cancelAlarm(name: titleTEC.text.trim(), id: idList[i]);});
            } else if (howLongSelectedValue == "1 month") {
              if (DateTime.now().isAfter(alarmDateTime)) {
                reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 31)));
              } else if (DateTime.now().isBefore(alarmDateTime)) {
                reminder.date = Timestamp.fromDate(alarmDateTime.add(Duration(days: 30)));
              }
              Timer(Duration(days: 32), () {cancelAlarm(name: titleTEC.text.trim(), id: idList[i]);});
            }
          }
        }

        Map<String, dynamic> reminderMap = reminder.toMap(reminder);
        await databaseMethods.createUserReminder(reminderMap, firebaseAuth.currentUser.uid);
        await databaseMethods.createNotification(notificationMap);

        Navigator.pop(context);
        displaySnackBar(message: "Created Reminder", context: context, label: "OK");
      }
    }
  }
}
cancelAlarm({String name, int id}) {
  cancel() async {
    await notificationsPlugin.cancel(id);
    await databaseMethods.updateUserReminder({"status": "complete"}, currentUser.uid, name);
  }
  cancel();
}

deleteAlarm(String name) async {
  await databaseMethods.deleteUserReminder(name, currentUser.uid);
}

cancelDocAlarm({String name, int id}) {
  cancel() async {
    await notificationsPlugin.cancel(id);
    await databaseMethods.updateDoctorReminder({"status": "complete"}, currentUser.uid, name);
  }
  cancel();
}

deleteDocAlarm(String name) async {
  await databaseMethods.deleteDoctorReminder(name, currentUser.uid);
}
