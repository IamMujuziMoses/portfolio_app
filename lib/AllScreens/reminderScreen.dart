import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/addReminderScreen.dart';
import 'package:creativedata_app/AllScreens/bookAppointmentScreen.dart';
import 'package:creativedata_app/AllScreens/loginScreen.dart';
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
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8),
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
                    } else if (type == "event") {
                      Timestamp timeStr = snapshot.data.docs[index].get("date");
                      DateTime date = timeStr.toDate();
                      String status = snapshot.data.docs[index].get("status");
                      int id = snapshot.data.docs[index].get("id");
                      String description = snapshot.data.docs[index].get("description");
                      String eventName = snapshot.data.docs[index].get("name");
                      String dateStr = Utils.formatDate(date);
                      if (Utils.formatDate(dateTime) == dateStr) {
                        return eventReminder(
                          description: description,
                          status: status,
                          id: id,
                          date: date,
                          eventName: eventName,
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
                    } else if (type == "event") {
                      Timestamp timeStr = snapshot.data.docs[index].get("date");
                      DateTime date = timeStr.toDate();
                      String status = snapshot.data.docs[index].get("status");
                      int id = snapshot.data.docs[index].get("id");
                      String description = snapshot.data.docs[index].get("description");
                      String eventName = snapshot.data.docs[index].get("name");
                      String dateStr = Utils.formatDate(date);
                      if (dateStr == Utils.formatDate(DateTime.now())) {
                        return eventReminder(
                          description: description,
                          status: status,
                          id: id,
                          date: date,
                          eventName: eventName,
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
                    } else if (type == "event") {
                      Timestamp timeStr = snapshot.data.docs[index].get("date");
                      DateTime date = timeStr.toDate();
                      String status = snapshot.data.docs[index].get("status");
                      int id = snapshot.data.docs[index].get("id");
                      String description = snapshot.data.docs[index].get("description");
                      String eventName = snapshot.data.docs[index].get("name");
                      String dateStr = Utils.formatDate(date);
                      if (dateStr == Utils.formatDate(DateTime.now().add(Duration(days: 1)))) {
                        return eventReminder(
                          description: description,
                          status: status,
                          id: id,
                          date: date,
                          eventName: eventName,
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        resizeToAvoidBottomInset: false,
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

  Widget eventReminder({DateTime date, description, eventName, status, int id}) {
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
                    child: Icon(CupertinoIcons.calendar_badge_plus,
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
                              cancelAlarm(name: eventName, id: id);
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
                              deleteAlarm(eventName);
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

  Widget appointmentReminder({String speciality, DateTime time, String doctor, String hospital,
    int id, String status,}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Container(
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
                  Container(
                    height: 10 * SizeConfig.heightMultiplier,
                    width: 5 * SizeConfig.widthMultiplier,
                    child: Column(
                      children: <Widget>[
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 0,
                              child: Text("Edit Reminder", style: TextStyle(
                                fontFamily: "Brand-Regular",
                              ),),
                            ),
                          ],
                          onSelected: (item) => selectedItem(
                            context: context,
                            item: item,
                            type: "appointment reminder"
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
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
      ),
    );
  }

  Widget medReminder({medicine, tablets, cycle, howLong, dosage, period, time, status, id, List idList,
    bool isOnce, List times}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Container(
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
                        width: 65 * SizeConfig.widthMultiplier,
                        child: Text(medicine, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: "Brand Bold",
                            fontSize: 3 * SizeConfig.textMultiplier,
                          ),),
                      ),
                      Container(
                        width: 65 * SizeConfig.widthMultiplier,
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
                            child: isOnce == true ? Text(period, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: "Brand Bold",
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                color: Colors.grey,
                              ),) : Container(
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
                  Container(
                    height: 8 * SizeConfig.heightMultiplier,
                    width: 5 * SizeConfig.widthMultiplier,
                    child: Column(
                      children: <Widget>[
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 0,
                              child: Text("Edit Reminder", style: TextStyle(
                                fontFamily: "Brand-Regular",
                              ),),
                            ),
                          ],
                          onSelected: (item) => selectedItem(
                            context: context,
                            item: item,
                            isOnce: isOnce,
                            cycle: cycle,
                            type: "medicine reminder",
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
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
      ),
    );
  }

  selectedItem({BuildContext context, item, bool isOnce, String type, String cycle}) {
    String valueChoose;
    List listItems = ["Morning", "After Breakfast", "Mid Morning", "After Lunch", "Evening", "Night"];
    TextEditingController drugNameTEC = TextEditingController();
    TextEditingController dosageTEC = TextEditingController();
    TextEditingController tabletsTEC = TextEditingController();
    TextEditingController timeTEC = TextEditingController();
    TextEditingController alarmTimeTEC = TextEditingController();
    List<String> timesToTake = [];
    List<String> alarmTimesToTake = [];
    bool drugNameVisible = false;
    bool dosageVisible = false;
    bool tabletsVisible = false;
    bool periodsVisible = false;
    bool morningVisible = false;
    bool breakfastVisible = false;
    bool midMorningVisible = false;
    bool lunchVisible = false;
    bool eveningVisible = false;
    bool nightVisible = false;
    double timeHeight = 0;
    int buttonSelectedIndex = 0;
    String periodSelectedValue = "";
    switch (item) {
      case 0:
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            button({String time, int index, String amPm}) {
              return StatefulBuilder(
                builder: (context, setState) {
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
                      color: buttonSelectedIndex == index ? Colors.red[300] : Colors.white,
                      child: InkWell(
                        splashColor: Colors.red[200],
                        highlightColor: Colors.grey.withOpacity(0.1),
                        radius: 800,
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            buttonSelectedIndex = index;
                          });
                        },
                        child: Container(
                          height: 4 * SizeConfig.heightMultiplier,
                          width: 16 * SizeConfig.widthMultiplier,
                          child: Center(
                            child: Text("$time $amPm", style: TextStyle(
                              color: buttonSelectedIndex == index ? Colors.white : Colors.black45,
                              fontFamily: "Brand-Regular",
                              fontSize: 1.8 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return StatefulBuilder(
              builder: (context, setState) {
                if (cycle == "2 times") {
                  setState(() {
                    buttonSelectedIndex = 0;
                    timesToTake = ["6:00 am", "6:00 pm"];
                    alarmTimesToTake = ["06, 00", "18, 00"];
                    timeHeight = 8 * SizeConfig.heightMultiplier;
                  });
                }
                if (cycle == "3 times") {
                  setState(() {
                    buttonSelectedIndex = 0;
                    timesToTake = ["6:00 am", "2:00 pm", "10:00 pm"];
                    alarmTimesToTake = ["06, 00", "14, 00", "22, 00"];
                    timeHeight = 12 * SizeConfig.heightMultiplier;
                  });
                }
                if (cycle == "4 times") {
                  setState(() {
                    buttonSelectedIndex = 0;
                    timesToTake = ["6:00 am", "12:00 pm", "6:00 pm", "12:00 am"];
                    alarmTimesToTake = ["06, 00", "12, 00", "18, 000", "00, 00"];
                    timeHeight = 16 * SizeConfig.heightMultiplier;
                  });
                }
                return AlertDialog(
                  contentPadding: EdgeInsets.only(
                    top: 2 * SizeConfig.heightMultiplier,
                    left: 2 * SizeConfig.widthMultiplier,
                    right: 2 * SizeConfig.widthMultiplier,
                  ),
                  actionsPadding: EdgeInsets.zero,
                  title: Text("Edit Reminder\n(${isOnce == true ? "Once a day" : "$cycle a day"})", textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Brand Bold",
                      color: Colors.red[300],
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                    ),),
                  content: Container(
                    height: 30 * SizeConfig.heightMultiplier,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RaisedButton(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Colors.white,
                            splashColor: Colors.red[200],
                            highlightColor: Colors.grey.withOpacity(0.1),
                            onPressed: () {
                              if (drugNameVisible == false) {
                                setState(() {
                                  drugNameVisible = true;
                                });
                              } else {
                                setState(() {
                                  drugNameVisible = false;
                                });
                              }
                            },
                            child: Container(
                              width: 70 * SizeConfig.widthMultiplier,
                              height: 4 * SizeConfig.heightMultiplier,
                              child: Padding(
                                padding: EdgeInsets.only(top: 6, bottom: 6, left: 8),
                                child: Text("Drug Name", style: TextStyle(
                                    fontFamily: "Brand Bold",
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                  ),),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: drugNameVisible,
                            child: TextField(
                              controller: drugNameTEC,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "Edit drug name...",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "Brand-Regular",
                                  fontSize: 2 * SizeConfig.textMultiplier,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 2 * SizeConfig.textMultiplier,
                                fontFamily: "Brand-Regular",
                              ),
                            ),
                          ),
                          RaisedButton(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Colors.white,
                            splashColor: Colors.red[200],
                            highlightColor: Colors.grey.withOpacity(0.1),
                            onPressed: () {
                              if (dosageVisible == false) {
                                setState(() {
                                  dosageVisible = true;
                                });
                              } else {
                                setState(() {
                                  dosageVisible = false;
                                });
                              }
                            },
                            child: Container(
                              width: 70 * SizeConfig.widthMultiplier,
                              height: 4 * SizeConfig.heightMultiplier,
                              child: Padding(
                                padding: EdgeInsets.only(top: 6, bottom: 6, left: 8),
                                child: Text("Dosage", style: TextStyle(
                                    fontFamily: "Brand Bold",
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                  ),),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: dosageVisible,
                            child: TextField(
                              controller: dosageTEC,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "Edit dosage...",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "Brand-Regular",
                                  fontSize: 2 * SizeConfig.textMultiplier,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 2 * SizeConfig.textMultiplier,
                                fontFamily: "Brand-Regular",
                              ),
                            ),
                          ),
                          RaisedButton(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Colors.white,
                            splashColor: Colors.red[200],
                            highlightColor: Colors.grey.withOpacity(0.1),
                            onPressed: () {
                              if (tabletsVisible == false) {
                                setState(() {
                                  tabletsVisible = true;
                                });
                              } else {
                                setState(() {
                                  tabletsVisible = false;
                                });
                              }
                            },
                            child: Container(
                              width: 70 * SizeConfig.widthMultiplier,
                              height: 4 * SizeConfig.heightMultiplier,
                              child: Padding(
                                padding: EdgeInsets.only(top: 6, bottom: 6, left: 8),
                                child: Text("Tablets to take", style: TextStyle(
                                    fontFamily: "Brand Bold",
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                  ),),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: tabletsVisible,
                            child: TextField(
                              controller: tabletsTEC,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Edit number of tablets to take...",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "Brand-Regular",
                                  fontSize: 2 * SizeConfig.textMultiplier,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 2 * SizeConfig.textMultiplier,
                                fontFamily: "Brand-Regular",
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isOnce == true ? true : false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RaisedButton(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  color: Colors.white,
                                  splashColor: Colors.red[200],
                                  highlightColor: Colors.grey.withOpacity(0.1),
                                  onPressed: () {
                                    if (periodsVisible == false) {
                                      setState(() {
                                        periodsVisible = true;
                                      });
                                    } else {
                                      setState(() {
                                        periodsVisible = false;
                                        buttonSelectedIndex = 0;
                                        morningVisible = false;
                                        breakfastVisible = false;
                                        midMorningVisible = false;
                                        lunchVisible = false;
                                        eveningVisible = false;
                                        nightVisible = false;
                                        valueChoose = null;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 70 * SizeConfig.widthMultiplier,
                                    height: 4 * SizeConfig.heightMultiplier,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 6, bottom: 6, left: 8),
                                      child: Text("Period", style: TextStyle(
                                          fontFamily: "Brand Bold",
                                          fontSize: 2.5 * SizeConfig.textMultiplier,
                                        ),),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: periodsVisible,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.grey, width: 1),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration.collapsed(hintText: ""),
                                          hint: Text("Edit period...", style: TextStyle(
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
                                                periodSelectedValue = valueChoose;
                                              });
                                              switch (periodSelectedValue) {
                                                case "Morning":
                                                  setState(() {
                                                    //timeTEC.text = "6:00 am";
                                                    //alarmTimeTEC.text = "06, 00";
                                                    buttonSelectedIndex = 0;
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
                                                    //timeTEC.text = "8:30 am";
                                                    //alarmTimeTEC.text = "08, 00";
                                                    buttonSelectedIndex = 0;
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
                                                    //timeTEC.text = "10:00 am";
                                                    //alarmTimeTEC.text = "10, 00";
                                                    buttonSelectedIndex = 0;
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
                                                    //timeTEC.text = "12:30 pm";
                                                    //alarmTimeTEC.text = "12, 30";
                                                    buttonSelectedIndex = 0;
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
                                                    //timeTEC.text = "3:30 pm";
                                                    //alarmTimeTEC.text = "15, 30";
                                                    buttonSelectedIndex = 0;
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
                                                    //timeTEC.text = "7:30 pm";
                                                    //alarmTimeTEC.text = "19, 30";
                                                    buttonSelectedIndex = 0;
                                                    morningVisible = false;
                                                    breakfastVisible = false;
                                                    midMorningVisible = false;
                                                    lunchVisible = false;
                                                    eveningVisible = false;
                                                    nightVisible = true;
                                                  });
                                                  break;
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
                                              child: Text(
                                                valueItem,
                                                style: TextStyle(
                                                  fontFamily: "Brand-Regular",
                                                  color: Colors.black,
                                                  fontSize: 2.5 * SizeConfig.textMultiplier,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: morningVisible,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text("Morning", style: TextStyle(
                                              fontFamily: "Brand Bold",
                                              color: Colors.black54,
                                              fontSize: 2 * SizeConfig.textMultiplier,
                                            ),),
                                          Text("(06:00 am - 09:30 am)", style: TextStyle(
                                              fontFamily: "Brand-Regular",
                                              color: Colors.black54,
                                              fontSize: 1.6 * SizeConfig.textMultiplier,
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
                                      SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: breakfastVisible,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text("After Breakfast", style: TextStyle(
                                              fontFamily: "Brand Bold",
                                              color: Colors.black54,
                                              fontSize: 2 * SizeConfig.textMultiplier,
                                            ),),
                                            Text("(08:30 am - 11:00 am)", style: TextStyle(
                                              fontFamily: "Brand-Regular",
                                              color: Colors.black54,
                                              fontSize: 1.6 * SizeConfig.textMultiplier,
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
                                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                      ],
                                    ),
                                ),
                                Visibility(
                                  visible: midMorningVisible,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text("Mid Morning", style: TextStyle(
                                              fontFamily: "Brand Bold",
                                              color: Colors.black54,
                                              fontSize: 2 * SizeConfig.textMultiplier,
                                            ),),
                                            Text("(10:00 am - 1:30 pm)", style: TextStyle(
                                              fontFamily: "Brand-Regular",
                                              color: Colors.black54,
                                              fontSize: 1.6 * SizeConfig.textMultiplier,
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
                                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                      ],
                                  ),
                                ),
                                Visibility(
                                  visible: lunchVisible,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text("After Lunch", style: TextStyle(
                                              fontFamily: "Brand Bold",
                                              color: Colors.black54,
                                              fontSize: 2 * SizeConfig.textMultiplier,
                                            ),),
                                            Text("(12:30 pm - 3:00 pm)", style: TextStyle(
                                              fontFamily: "Brand-Regular",
                                              color: Colors.black54,
                                              fontSize: 1.6 * SizeConfig.textMultiplier,
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
                                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                      ],
                                  ),
                                ),
                                Visibility(
                                  visible: eveningVisible,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text("Evening", style: TextStyle(
                                              fontFamily: "Brand Bold",
                                              color: Colors.black54,
                                              fontSize: 2 * SizeConfig.textMultiplier,
                                            ),),
                                            Text("(3:30 pm - 7:00 pm)", style: TextStyle(
                                              fontFamily: "Brand-Regular",
                                              color: Colors.black54,
                                              fontSize: 1.6 * SizeConfig.textMultiplier,
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
                                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                      ],
                                  ),
                                ),
                                Visibility(
                                  visible: nightVisible,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text("Night", style: TextStyle(
                                              fontFamily: "Brand Bold",
                                              color: Colors.black54,
                                              fontSize: 2 * SizeConfig.textMultiplier,
                                            ),),
                                            Text("(7:30 pm - 11:00 pm)", style: TextStyle(
                                              fontFamily: "Brand-Regular",
                                              color: Colors.black54,
                                              fontSize: 1.6 * SizeConfig.textMultiplier,
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
                                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                      ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isOnce == false ? true : false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Start time", style: TextStyle(
                                  fontFamily: "Brand Bold",
                                  fontSize: 2 * SizeConfig.textMultiplier,
                                ),),
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
                                            fontSize: 1.6 * SizeConfig.textMultiplier,
                                          ),),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  width: 70 * SizeConfig.widthMultiplier,
                                  height: 5.5 * SizeConfig.heightMultiplier,
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
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Update", style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),),
                      onPressed: () {
                        Navigator.pop(context);
                        // showDialog(
                        //     context: context,
                        //     barrierDismissible: false,
                        //     builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
                        // );
                      },
                    ),
                    FlatButton(
                      child: Text("Cancel", style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              },
            );
          },
        );
        break;
    }
  }

}