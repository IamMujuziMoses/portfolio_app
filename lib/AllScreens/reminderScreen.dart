import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/addReminderScreen.dart';
import 'package:creativedata_app/AllScreens/bookAppointmentScreen.dart';
import 'package:creativedata_app/Utilities/utils.dart';
import 'package:creativedata_app/main.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  DateTime dateTime;

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

  DateTime getDateTime(int index) {
    if (index == DateTime.now().weekday) {
      setState(() {
        dateTime = DateTime.now();
      });
    } else {
      if (index != 7) {
        if (index > DateTime.now().weekday) {
          int days = index - DateTime.now().weekday;
          setState(() {
            dateTime = DateTime.now().add(Duration(days: days));
          });
        } else if (index < DateTime.now().weekday) {
          int days = DateTime.now().weekday - index;
          setState(() {
            dateTime = DateTime.now().subtract(Duration(days: days));
          });
        }
      } else {
        setState(() {
          dateTime = DateTime.now().subtract(Duration(days: DateTime.now().weekday));
        });
      }
    }
    return dateTime;
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

  Widget weekReminderList({@required Stream reminderStream, int index}) {
    DateTime dateTime = getDateTime(index);
    return StreamBuilder(
      stream: reminderStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Container(
                height: 75 * SizeConfig.heightMultiplier,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  separatorBuilder: (context, index) => SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    String type = snapshot.data.docs[index].get("type");
                    if (type == "medicine") {
                      bool isOnce = snapshot.data.docs[index].get("isOnce");
                      String medicineName = snapshot.data.docs[index].get("name");
                      Timestamp date = snapshot.data.docs[index].get("date");
                      DateTime remDateTime = date.toDate();
                      String dateStr = Utils.formatDate(remDateTime);
                      String dosage = snapshot.data.docs[index].get("dosage");
                      String status = snapshot.data.docs[index].get("status");
                      String cycle = snapshot.data.docs[index].get("cycle");
                      String tablets = snapshot.data.docs[index].get("tablets");
                      String howLong = snapshot.data.docs[index].get("how_long");
                      if (howLong == "1 day") {
                        if (Utils.formatDate(dateTime) == dateStr) {
                          if (isOnce == true) {
                            return medReminder(
                              cycle: cycle,
                              isOnce: isOnce,
                              howLong: howLong,
                              id: snapshot.data.docs[index].get("id"),
                              medicine: medicineName,
                              dosage: dosage,
                              status: status,
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
                              status: status,
                              howLong: howLong,
                              idList: snapshot.data.docs[index].get("id_list"),
                              times: snapshot.data.docs[index].get("time"),
                            );
                          } else return Container();
                          } else return Container();
                      } else if (howLong == "2-3 days") {
                        for (int i = 1; i <= 2; i++) {
                          if (Utils.formatDate(dateTime) == Utils.formatDate(remDateTime) ||
                              Utils.formatDate(dateTime) == Utils.formatDate(remDateTime.subtract(Duration(days: i)))) {
                            if (isOnce == true) {
                              return medReminder(
                                cycle: cycle,
                                isOnce: isOnce,
                                howLong: howLong,
                                medicine: medicineName,
                                dosage: dosage,
                                status: status,
                                id: snapshot.data.docs[index].get("id"),
                                tablets: tablets,
                                period: snapshot.data.docs[index].get("period"),
                                time: snapshot.data.docs[index].get("once_time"),
                              );
                            } else if (isOnce == false) {
                              return medReminder(
                                medicine: medicineName,
                                dosage: dosage,
                                status: status,
                                tablets: tablets,
                                cycle: cycle,
                                isOnce: isOnce,
                                howLong: howLong,
                                idList: snapshot.data.docs[index].get("id_list"),
                                times: snapshot.data.docs[index].get("time"),
                              );
                            }
                          }
                        }
                        return Container();
                      } else if (howLong == "1 week") {
                        for (int i = 1; i <= 6; i++) {
                          if (Utils.formatDate(dateTime) == Utils.formatDate(remDateTime) ||
                              Utils.formatDate(dateTime) == Utils.formatDate(remDateTime.subtract(Duration(days: i)))) {
                            if (isOnce == true) {
                              return medReminder(
                                cycle: cycle,
                                isOnce: isOnce,
                                howLong: howLong,
                                medicine: medicineName,
                                dosage: dosage,
                                tablets: tablets,
                                status: status,
                                id: snapshot.data.docs[index].get("id"),
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
                                status: status,
                                howLong: howLong,
                                idList: snapshot.data.docs[index].get("id_list"),
                                times: snapshot.data.docs[index].get("time"),
                              );
                            }
                          }
                        }
                        return Container();
                      } else if (howLong == "2-3 weeks") {
                        for (int i = 1; i <= 20; i++) {
                          if (Utils.formatDate(dateTime) == Utils.formatDate(remDateTime) ||
                              Utils.formatDate(dateTime) == Utils.formatDate(remDateTime.subtract(Duration(days: i)))) {
                            if (isOnce == true) {
                              return medReminder(
                                cycle: cycle,
                                isOnce: isOnce,
                                howLong: howLong,
                                medicine: medicineName,
                                dosage: dosage,
                                status: status,
                                tablets: tablets,
                                id: snapshot.data.docs[index].get("id"),
                                period: snapshot.data.docs[index].get("period"),
                                time: snapshot.data.docs[index].get("once_time"),
                              );
                            } else if (isOnce == false) {
                              return medReminder(
                                medicine: medicineName,
                                dosage: dosage,
                                tablets: tablets,
                                cycle: cycle,
                                status: status,
                                isOnce: isOnce,
                                howLong: howLong,
                                idList: snapshot.data.docs[index].get("id_list"),
                                times: snapshot.data.docs[index].get("time"),
                              );
                            }
                          }
                        }
                        return Container();
                      } else if (howLong == "1 month") {
                        for (int i = 1; i <= 29; i++) {
                          if (Utils.formatDate(dateTime) == Utils.formatDate(remDateTime) ||
                              Utils.formatDate(dateTime) == Utils.formatDate(remDateTime.subtract(Duration(days: i)))) {
                            if (isOnce == true) {
                              return medReminder(
                                cycle: cycle,
                                isOnce: isOnce,
                                howLong: howLong,
                                medicine: medicineName,
                                dosage: dosage,
                                status: status,
                                tablets: tablets,
                                id: snapshot.data.docs[index].get("id"),
                                period: snapshot.data.docs[index].get("period"),
                                time: snapshot.data.docs[index].get("once_time"),
                              );
                            } else if (isOnce == false) {
                              return medReminder(
                                medicine: medicineName,
                                dosage: dosage,
                                tablets: tablets,
                                cycle: cycle,
                                status: status,
                                isOnce: isOnce,
                                howLong: howLong,
                                idList: snapshot.data.docs[index].get("id_list"),
                                times: snapshot.data.docs[index].get("time"),
                              );
                            }
                          }
                        }
                        return Container();
                      } else return Container();
                    } else if (type == "appointment") {
                      String speciality = snapshot.data.docs[index].get("speciality");
                      Timestamp timeStr = snapshot.data.docs[index].get("time");
                      DateTime remDateTime = timeStr.toDate();
                      int id = snapshot.data.docs[index].get("id");
                      String status = snapshot.data.docs[index].get("status");
                      String doctorName = snapshot.data.docs[index].get("name");
                      String hospital = snapshot.data.docs[index].get("hospital");
                      String dateStr = Utils.formatDate(remDateTime);
                      if (Utils.formatDate(dateTime) == dateStr) {
                        return appointmentReminder(
                          speciality: speciality,
                          time: remDateTime,
                          id: id,
                          status: status,
                          doctor: doctorName,
                          hospital: hospital,
                        );
                      } else return Container();
                    } else return Container();
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
                      String status = snapshot.data.docs[index].get("status");
                      String cycle = snapshot.data.docs[index].get("cycle");
                      String tablets = snapshot.data.docs[index].get("tablets");
                      String howLong = snapshot.data.docs[index].get("how_long");
                      String finalTime = Utils.formatDate(finalDate);
                      if (finalDate.isAfter(DateTime.now())
                          || finalTime == Utils.formatDate(DateTime.now())) {
                        if (isOnce == true) {
                          return medReminder(
                            cycle: cycle,
                            isOnce: isOnce,
                            howLong: howLong,
                            medicine: medicineName,
                            dosage: dosage,
                            status: status,
                            tablets: tablets,
                            id: snapshot.data.docs[index].get("id"),
                            period: snapshot.data.docs[index].get("period"),
                            time: snapshot.data.docs[index].get("once_time"),
                          );
                        } else if (isOnce == false) {
                          return medReminder(
                            medicine: medicineName,
                            dosage: dosage,
                            tablets: tablets,
                            cycle: cycle,
                            status: status,
                            isOnce: isOnce,
                            howLong: howLong,
                            idList: snapshot.data.docs[index].get("id_list"),
                            times: snapshot.data.docs[index].get("time"),
                          );
                        } else return Container();
                      } else return Container();
                    } else if (type == "appointment") {
                      String speciality = snapshot.data.docs[index].get("speciality");
                      String docName = snapshot.data.docs[index].get("name");
                      String hospital = snapshot.data.docs[index].get("hospital");
                      int id = snapshot.data.docs[index].get("id");
                      String status = snapshot.data.docs[index].get("status");
                      Timestamp timeStr = snapshot.data.docs[index].get("time");
                      DateTime time = timeStr.toDate();
                      String nowTime = Utils.formatDate(time);
                      if (nowTime == Utils.formatDate(DateTime.now())) {
                        return appointmentReminder(
                          speciality: speciality,
                          time: time,
                          id: id,
                          status: status,
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
                      Timestamp date = snapshot.data.docs[index].get("date");
                      DateTime finalDate = date.toDate();
                      String dosage = snapshot.data.docs[index].get("dosage");
                      String status = snapshot.data.docs[index].get("status");
                      String cycle = snapshot.data.docs[index].get("cycle");
                      String tablets = snapshot.data.docs[index].get("tablets");
                      String howLong = snapshot.data.docs[index].get("how_long");
                      String finalTime = Utils.formatDate(finalDate);
                      if (finalDate.isAfter(DateTime.now().add(Duration(days: 1)))
                          || finalTime == Utils.formatDate(DateTime.now().add(Duration(days: 1)))) {
                        if (isOnce == true) {
                          return medReminder(
                            cycle: cycle,
                            isOnce: isOnce,
                            howLong: howLong,
                            status: status,
                            medicine: medicineName,
                            dosage: dosage,
                            tablets: tablets,
                            id: snapshot.data.docs[index].get("id"),
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
                            status: status,
                            howLong: howLong,
                            idList: snapshot.data.docs[index].get("id_list"),
                            times: snapshot.data.docs[index].get("time"),
                          );
                        } else return Container();
                      } else return Container();
                    } else if (type == "appointment") {
                      String speciality = snapshot.data.docs[index].get("speciality");
                      String docName = snapshot.data.docs[index].get("name");
                      String hospital = snapshot.data.docs[index].get("hospital");
                      int id = snapshot.data.docs[index].get("id");
                      String status = snapshot.data.docs[index].get("status");
                      Timestamp timeStr = snapshot.data.docs[index].get("time");
                      DateTime time = timeStr.toDate();
                      String nowTime = Utils.formatDate(time);
                      if (nowTime == Utils.formatDate(DateTime.now().add(Duration(days: 1)))) {
                        return appointmentReminder(
                          speciality: speciality,
                          time: time,
                          id: id,
                          status: status,
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
                                  dateTime: getDateTime(7),
                                ),
                                dayButtons(
                                  title: "Mon",
                                  index: 1,
                                  dateTime: getDateTime(1),
                                ),
                                dayButtons(
                                  title: "Tue",
                                  index: 2,
                                  dateTime: getDateTime(2),
                                ),
                                dayButtons(
                                  title: "Wed",
                                  index: 3,
                                  dateTime: getDateTime(3),
                                ),
                                dayButtons(
                                  title: "Thur",
                                  index: 4,
                                  dateTime: getDateTime(4),
                                ),
                                dayButtons(
                                  title: "Fri",
                                  index: 5,
                                  dateTime: getDateTime(5),
                                ),
                                dayButtons(
                                  title: "Sat",
                                  index: 6,
                                  dateTime: getDateTime(6),
                                ),
                              ],
                            ),
                          ),
                          weekReminderList(reminderStream: remindersStream, index: selectedDayIndex),
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

  Widget dayButtons({String title, int index, DateTime dateTime}) {
    return Column(
      children: <Widget>[
        Container(
          width: 10 * SizeConfig.widthMultiplier,
          height: 5 * SizeConfig.heightMultiplier,
          child: RaisedButton(
            onPressed: () {
              changeDayIndex(index);
            },
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
        ),
        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
        Visibility(
          visible: selectedDayIndex == index ? true : false,
          child: Container(
            child: Text("${Utils.formatDate(dateTime)}", textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                color: Colors.grey,
                fontFamily: "Brand Bold",
                fontSize: 1.8 * SizeConfig.textMultiplier,
            ),),
          ),
        ),
      ],
    );
  }

  Widget appointmentReminder({String speciality, DateTime time, String doctor, String hospital,
    int id, String status,}) {
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
                    color: status == "waiting" ? Colors.red[100] : Colors.grey[400],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Icon(FontAwesomeIcons.calendarAlt,
                      color: status == "waiting" ? Colors.red[300] : Colors.black,
                    ),
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
                  onPressed: status == "waiting" ? () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text("Cancel appointment reminder?"),
                        content: Text("$speciality with Dr. $doctor", style: TextStyle(
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
                              cancelAlarm(name: doctor, id: id);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  } : () => displaySnackBar(message: "Reminder already ended and cancelled", context: context, label: ""),
                  color: status == "waiting" ? Colors.white : Colors.grey[400],
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text("Delete appointment reminder?"),
                        content: Text("$speciality with Dr. $doctor", style: TextStyle(
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
                              deleteAlarm(doctor);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  color: status == "waiting" ? Colors.white : Colors.grey[400],
                  splashColor: Colors.red[300],
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

  Widget medReminder({String medicine, String tablets, String cycle, String howLong, String dosage,
    String period, String time, int id, List idList, String status, bool isOnce, List times}) {
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
                    color: status == "waiting" ? Colors.red[100] : Colors.grey[400],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Icon(FontAwesomeIcons.pills,
                      color: status == "waiting" ? Colors.red[300] : Colors.black,
                    ),
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
                  onPressed: status == "waiting" ? () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text("Cancel medicine reminder?"),
                        content: Text(medicine, style: TextStyle(
                          fontFamily: "Brand-Regular",
                        ),),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("No"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: () async {
                              if (isOnce == false) {
                                for (int i = 0; i <= idList.length - 2; i++) {
                                  await notificationsPlugin.cancel(idList[i]);
                                }
                                cancelAlarm(name: medicine, id: idList[idList.length - 1]);
                              } else {
                                cancelAlarm(name: medicine, id: id);
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                    // assetsAudioPlayer.open(Audio("sounds/alert.mp3"));
                    // assetsAudioPlayer.play();
                  } : () => displaySnackBar(message: "Reminder already ended and cancelled", context: context, label: ""),
                  // onPressed: () async => await databaseMethods.deleteReminder(medicine, firebaseAuth.currentUser.uid),
                  color: status == "waiting" ? Colors.white : Colors.grey[400],
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text("Delete medicine reminder?"),
                        content: Text(medicine, style: TextStyle(
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
                              deleteAlarm(medicine);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                    // assetsAudioPlayer.stop();
                    // assetsAudioPlayer = new AssetsAudioPlayer();
                  },
                  color: status == "waiting" ? Colors.white : Colors.grey[400],
                  splashColor: Colors.red[300],
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