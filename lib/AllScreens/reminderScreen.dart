import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/addReminderScreen.dart';
import 'package:creativedata_app/Utilities/utils.dart';
import 'package:creativedata_app/main.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class ReminderScreen extends StatefulWidget {
  ReminderScreen({Key key}) : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {

  Stream remindersStream;
  bool todayVisible = true;
  bool tomorrowVisible = false;
  bool weekVisible = false;
  int selectedIndex = 0;
  int alarmId = 1;
  int selectedDayIndex = DateTime.now().weekday;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    await databaseMethods.getUsersReminders(currentUser.uid).then((val) {
      setState(() {
        remindersStream = val;
      });
    });
  }

  changeIndex(int index) async {
    setState(() {
      selectedIndex = index;
      selectedDayIndex = DateTime.now().weekday;
    });
    if (index == 0) {
      setState(() {
        todayVisible = true;
        tomorrowVisible = false;
        weekVisible = false;
      });
    } else if (index == 1) {
      setState(() {
        todayVisible = false;
        tomorrowVisible = true;
        weekVisible = false;
      });
    } else if (index == 2) {
      setState(() {
        todayVisible = false;
        tomorrowVisible = false;
        weekVisible = true;
      });
    }
    await databaseMethods.getUsersReminders(currentUser.uid).then((val) {
      setState(() {
        remindersStream = val;
      });
    });
  }

  changeDayIndex(index) {
    setState(() {
      selectedDayIndex = index;
    });
  }

  Widget weekReminderList({@required Stream reminderStream}) {
    return StreamBuilder(
      stream: reminderStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Container(
                height: 76.9 * SizeConfig.heightMultiplier,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  separatorBuilder: (context, index) => SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    String type = snapshot.data.docs[index].get("type");
                    //int id = snapshot.data.docs[index].get("id");
                    if (type == "medicine") {
                      bool isOnce = snapshot.data.docs[index].get("isOnce");
                      String medicineName = snapshot.data.docs[index].get("name");
                      String dosage = snapshot.data.docs[index].get("dosage");
                      String cycle = snapshot.data.docs[index].get("cycle");
                      String tablets = snapshot.data.docs[index].get("tablets");
                      String howLong = snapshot.data.docs[index].get("how_long");
                      if (isOnce == true) {
                        return medReminder(
                          cycle: cycle,
                          isOnce: isOnce,
                          howLong: howLong,
                          medicine: medicineName,
                          dosage: dosage,
                          tablets: tablets,
                          period: snapshot.data.docs[index].get("period"),
                          time: snapshot.data.docs[index].get("once_time"),
                        );
                      } else if (isOnce == false) {
                        return medReminder(
                          medicine: medicineName,
                          dosage: dosage,
                          tablets: tablets,
                          cycle: cycle,
                          isOnce: isOnce,
                          howLong: howLong,
                          times: snapshot.data.docs[index].get("time"),
                        );
                      } else
                        return Container();
                    } else if (type == "appointment") {
                      String speciality = snapshot.data.docs[index].get("speciality");
                      Timestamp timeStr = snapshot.data.docs[index].get("time");
                      DateTime time = timeStr.toDate();
                      int id = snapshot.data.docs[index].get("id");
                      String doctorName = snapshot.data.docs[index].get("name");
                      String hospital = snapshot.data.docs[index].get("hospital");
                      return appointmentReminder(
                        speciality: speciality,
                        time: time,
                        id: id,
                        doctor: doctorName,
                        hospital: hospital,
                      );
                    } else
                      return Container();
                  },
                ),
              )
            : Container(
                child: Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red[300]),),
                ),
              );
      },
    );
  }

  Widget todayReminderList({@required Stream reminderStream}) {
    return StreamBuilder(
      stream: reminderStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Container(
                height: 83.5 * SizeConfig.heightMultiplier,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  separatorBuilder: (context, index) => SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    String type = snapshot.data.docs[index].get("type");
                    if (type == "medicine") {
                      bool isOnce = snapshot.data.docs[index].get("isOnce");
                      String medicineName = snapshot.data.docs[index].get("name");
                      Timestamp date = snapshot.data.docs[index].get("date");
                      DateTime finalDate = date.toDate();
                      String dosage = snapshot.data.docs[index].get("dosage");
                      String cycle = snapshot.data.docs[index].get("cycle");
                      String tablets = snapshot.data.docs[index].get("tablets");
                      String howLong = snapshot.data.docs[index].get("how_long");
                      if (finalDate.isAfter(DateTime.now()) || finalDate.isAtSameMomentAs(DateTime.now())) {
                        if (isOnce == true) {
                          return medReminder(
                            cycle: cycle,
                            isOnce: isOnce,
                            howLong: howLong,
                            medicine: medicineName,
                            dosage: dosage,
                            tablets: tablets,
                            period: snapshot.data.docs[index].get("period"),
                            time: snapshot.data.docs[index].get("once_time"),
                          );
                        } else if (isOnce == false) {
                          return medReminder(
                            medicine: medicineName,
                            dosage: dosage,
                            tablets: tablets,
                            cycle: cycle,
                            isOnce: isOnce,
                            howLong: howLong,
                            times: snapshot.data.docs[index].get("time"),
                          );
                        } else return Container();
                      } else return Container();
                    } else if (type == "appointment") {
                      String speciality = snapshot.data.docs[index].get("speciality");
                      String docName = snapshot.data.docs[index].get("name");
                      String hospital = snapshot.data.docs[index].get("hospital");
                      int id = snapshot.data.docs[index].get("id");
                      Timestamp timeStr = snapshot.data.docs[index].get("time");
                      DateTime time = timeStr.toDate();
                      if (time.isAtSameMomentAs(DateTime.now())) {
                        return appointmentReminder(
                          speciality: speciality,
                          time: time,
                          id: id,
                          doctor: docName,
                          hospital: hospital,
                        );
                      } else return Container();
                    }
                    else return Container();
                  },
                ),
              )
            : Container(
                child: Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red[300]),),
                ),
              );
      },
    );
  }

  Widget tomorrowReminderList({@required Stream reminderStream}) {
    return StreamBuilder(
      stream: reminderStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Container(
                height: 83.5 * SizeConfig.heightMultiplier,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  separatorBuilder: (context, index) => SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    String type = snapshot.data.docs[index].get("type");
                    if (type == "medicine") {
                      bool isOnce = snapshot.data.docs[index].get("isOnce");
                      String medicineName = snapshot.data.docs[index].get("name");
                      String dosage = snapshot.data.docs[index].get("dosage");
                      String cycle = snapshot.data.docs[index].get("cycle");
                      String tablets = snapshot.data.docs[index].get("tablets");
                      String howLong = snapshot.data.docs[index].get("how_long");
                      if (howLong != "1 day") {
                        if (isOnce == true) {
                          return medReminder(
                            cycle: cycle,
                            isOnce: isOnce,
                            howLong: howLong,
                            medicine: medicineName,
                            dosage: dosage,
                            tablets: tablets,
                            period: snapshot.data.docs[index].get("period"),
                            time: snapshot.data.docs[index].get("once_time"),
                          );
                        } else if (isOnce == false) {
                          return medReminder(
                            medicine: medicineName,
                            dosage: dosage,
                            tablets: tablets,
                            cycle: cycle,
                            isOnce: isOnce,
                            howLong: howLong,
                            times: snapshot.data.docs[index].get("time"),
                          );
                        } else
                          return Container();
                      } else
                        return Container();
                    } else
                      return Container();
                  },
                ),
              )
            : Container(
                child: Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red[300]),),
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red[300],
          child: Icon(CupertinoIcons.plus, color: Colors.white,),
          onPressed: () => Navigator.push(
            context, MaterialPageRoute(
            builder: (context) => AddReminderScreen(),
          ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            color: Colors.grey[100],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      actionButtons(
                        title: "Today",
                        index: 0,
                      ),
                      actionButtons(
                        title: "Tomorrow",
                        index: 1,
                      ),
                      actionButtons(
                        title: "This week",
                        index: 2,
                      ),
                    ],
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Visibility(
                      visible: todayVisible,
                      child: todayReminderList(reminderStream: remindersStream),
                    ),
                    Visibility(
                      visible: tomorrowVisible,
                      child: tomorrowReminderList(reminderStream: remindersStream),
                    ),
                    Visibility(
                      visible: weekVisible,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                dayButtons(
                                  title: "Sun",
                                  index: 7,
                                ),
                                dayButtons(
                                  title: "Mon",
                                  index: 1,
                                ),
                                dayButtons(
                                  title: "Tue",
                                  index: 2,
                                ),
                                dayButtons(
                                  title: "Wed",
                                  index: 3,
                                ),
                                dayButtons(
                                  title: "Thur",
                                  index: 4,
                                ),
                                dayButtons(
                                  title: "Fri",
                                  index: 5,
                                ),
                                dayButtons(
                                  title: "Sat",
                                  index: 6,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                          weekReminderList(reminderStream: remindersStream),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget actionButtons({String title, int index}) {
    return Container(
      child: RaisedButton(
        onPressed: () => changeIndex(index),
        padding: EdgeInsets.all(0),
        color: selectedIndex == index ? Colors.red[300] : Colors.white,
        splashColor: selectedIndex == index ? Colors.white : Colors.red[200],
        highlightColor: Colors.grey.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
        child: Center(
          child: Text(title, overflow: TextOverflow.ellipsis, maxLines: 1,
            style: TextStyle(
              fontFamily: "Brand Bold",
              color: selectedIndex == index ? Colors.white : Colors.red[300],
              fontSize: 1.8 * SizeConfig.textMultiplier,
            ),),
        ),
      ),
    );
  }
  Widget dayButtons({String title, int index}) {
    return Container(
      width: 10 * SizeConfig.widthMultiplier,
      height: 5 * SizeConfig.heightMultiplier,
      child: RaisedButton(
        onPressed: () => changeDayIndex(index),
        padding: EdgeInsets.all(0),
        color: selectedDayIndex == index ? Colors.red[300] : Colors.red[100],
        splashColor: selectedDayIndex == index ? Colors.white : Colors.red[200],
        highlightColor: Colors.grey.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
        child: Center(
          child: Text(title, overflow: TextOverflow.ellipsis, maxLines: 1,
            style: TextStyle(
              fontFamily: "Brand Bold",
              color: selectedDayIndex == index ? Colors.white : Colors.red[300],
              fontSize: 1.8 * SizeConfig.textMultiplier,
            ),),
        ),
      ),
    );
  }

  Widget appointmentReminder({String speciality, DateTime time, String doctor, String hospital, int id}) {
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
                      child: Text(speciality, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 3 * SizeConfig.textMultiplier,
                        ),),
                    ),
                    Text("${Utils.formatDate(time)}, ${Utils.formatTime(time)}", style: TextStyle(
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
                            //width: 35 * SizeConfig.widthMultiplier,
                            child: Text("Dr. $doctor", maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: "Brand Bold",
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                color: Colors.grey,
                              ),),
                          ),
                          SizedBox(width: 0.8 * SizeConfig.widthMultiplier,),
                          Container(
                            //width: 30 * SizeConfig.widthMultiplier,
                            child: Text("($hospital)", maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: "Brand-Regular",
                                fontSize: 2 * SizeConfig.textMultiplier,
                                color: Colors.grey,
                              ),),
                          ),
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

  Widget medReminder({String medicine, String tablets, String cycle, String howLong, String dosage,
    String period, String time, bool isOnce, List times}) {
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
                    child: Icon(FontAwesomeIcons.pills, color: Colors.red[300],),
                  ),
                ),
                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 70 * SizeConfig.widthMultiplier,
                      child: Text(medicine, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 3 * SizeConfig.textMultiplier,
                        ),),
                    ),
                    Container(
                      width: 72 * SizeConfig.widthMultiplier,
                      child: Text("$dosage, $tablets tablet(s), $cycle a day for $howLong", style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2 * SizeConfig.textMultiplier,
                          color: Colors.black54,
                        ),),
                    ),
                    SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          //width: 30 * SizeConfig.widthMultiplier,
                          child: isOnce == true ? Text(period, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "Brand Bold",
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                              color: Colors.grey,
                            ),) : Container(
                            //width: 35 * SizeConfig.widthMultiplier,
                            height: 2.5 * SizeConfig.heightMultiplier,
                            child: ListView.separated(
                              padding: EdgeInsets.all(0),
                              itemCount: times.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              separatorBuilder: (context, index) => Text(", ", style: TextStyle(
                                fontFamily: "Brand Bold",
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                color: Colors.grey,
                              ),),
                              itemBuilder: (context, index) => Text(times[index], maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: "Brand Bold",
                                  fontSize: 2.5 * SizeConfig.textMultiplier,
                                  color: Colors.grey,
                                ),),
                            ),
                          ),
                        ),
                        SizedBox(width: 0.8 * SizeConfig.widthMultiplier,),
                        isOnce == true ? Container(
                          //width: 30 * SizeConfig.widthMultiplier,
                          child: Text("(${time.toUpperCase()})", maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "Brand-Regular",
                              fontSize: 2 * SizeConfig.textMultiplier,
                              color: Colors.grey,
                            ),),
                        ) : Container(),
                      ],
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
                  onPressed: () {
                    // assetsAudioPlayer.open(Audio("sounds/alert.mp3"));
                    // assetsAudioPlayer.play();
                  },
                  // onPressed: () async => await databaseMethods.deleteReminder(medicine, firebaseAuth.currentUser.uid),
                  color: Colors.white,
                  splashColor: Colors.red[300],
                  highlightColor: Colors.grey.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Icon(CupertinoIcons.clear),
                        Text("Skip", style: TextStyle(
                            fontFamily: "Brand-Regular",
                            fontSize: 2 * SizeConfig.textMultiplier,
                          ),),
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    // assetsAudioPlayer.stop();
                    // assetsAudioPlayer = new AssetsAudioPlayer();
                  },
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