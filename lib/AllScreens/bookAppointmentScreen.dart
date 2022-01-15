import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/Chat/chatSearch.dart';
import 'package:portfolio_app/AllScreens/addReminderScreen.dart';
import 'package:portfolio_app/AllScreens/specialityScreen.dart';
import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:portfolio_app/AllScreens/loginScreen.dart';
import 'package:portfolio_app/Models/activity.dart';
import 'package:portfolio_app/Models/event.dart';
import 'package:portfolio_app/Models/notification.dart';
import 'package:portfolio_app/Models/reminder.dart';
import 'package:portfolio_app/Provider/eventProvider.dart';
import 'package:portfolio_app/Utilities/utils.dart';
import 'package:portfolio_app/constants.dart';
import 'package:portfolio_app/main.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
/*
* Created by Mujuzi Moses
*/

class BookAppointmentScreen extends StatefulWidget {
  static const String screenId = "bookAppointmentScreen";

  final String time;
  final String doctorsName;
  final String hospital;
  final String type;
  final List days;
  const BookAppointmentScreen({Key key, this.time, this.doctorsName, this.hospital, this.type, this.days}) : super(key: key);

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {

  int selectedIndex = 0;
  DateTime startTime;
  int reminderHours;
  int reminderMinutes;

  @override
  void initState() {
    reminderHours = widget.time == "Morning:" ? 08 : 15;
    reminderMinutes = 00;
    startTime = DateTime.now();
    super.initState();
  }

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final events = Provider.of<EventProvider>(context).events;
    return PickUpLayout(
        scaffold: Scaffold(
          body: SpecCustom(
            body: bookAppointmentBody(context, events),
            speciality: "Book an Appointment",
            appointment: true,
          ),
        ),
      );
  }

  Widget bookAppointmentBody(BuildContext context, List<Event> events) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 10 * SizeConfig.heightMultiplier,
      color: Colors.grey[200],
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: 2 * SizeConfig.heightMultiplier,
                  left: 5 * SizeConfig.widthMultiplier,
                  right: 5 * SizeConfig.widthMultiplier),
              child: StatefulBuilder(
                builder: (context, setState) => SfCalendar(
                  dataSource: EventDataSource(events),
                  backgroundColor: Colors.white,
                  view: CalendarView.month,
                  initialSelectedDate: DateTime.now(),
                  firstDayOfWeek: 7,
                  showDatePickerButton: true,
                  onLongPress: (val) {
                    final provider = Provider.of<EventProvider>(context, listen: false);
                    provider.setDate(val.date);

                    showModalBottomSheet(
                        context: context,
                        builder: (context) => TaskWidget()
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 3 * SizeConfig.heightMultiplier,),
            Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                top: 1 * SizeConfig.heightMultiplier,
                right: 10,
              ),
              child: Row(
                children: <Widget>[
                  Text("Date", style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Brand Bold",
                      fontWeight: FontWeight.bold,
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                    ),),
                  SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                  Container(
                    height: 4 * SizeConfig.heightMultiplier,
                    width: (widget.days.length * 15) * SizeConfig.widthMultiplier,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Center(
                        child: Text(", ", style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 1.8 * SizeConfig.textMultiplier,
                        ),),
                      ),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.days.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Center(
                            child: Text(widget.days[index], style: TextStyle(
                              fontFamily: "Brand-Regular",
                              fontSize: 1.8 * SizeConfig.textMultiplier,
                            ),),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
            Container(
              width: 94 * SizeConfig.widthMultiplier,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    spreadRadius: 0.5,
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: buildDropdownFiled(
                        text: Utils.toDate(startTime),
                        onClicked: () {
                          pickFromDate(pickDate: true);
                        },
                      ),
                    ),
                  ],
                ),
            ),
            Visibility(
              visible: widget.time == "Morning:" ? true : false,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10.0,
                        top: 1 * SizeConfig.heightMultiplier,
                        right: 10.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Morning",
                            style: TextStyle(
                              fontFamily: "Brand Bold",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                            ),
                          ),
                          SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                          Text(
                            "08:00 - 11:30 am",
                            style: TextStyle(
                              fontFamily: "Brand-Regular",
                              color: Colors.black26,
                              fontSize: 2.2 * SizeConfig.textMultiplier,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              _button(
                                onTap: () {},
                                time: "8:00",
                                amPm: "am",
                                index: 0,
                              ),
                              SizedBox(width: 0.5 * SizeConfig.widthMultiplier,),
                              _button(
                                onTap: () {},
                                time: "8:30",
                                amPm: "am",
                                index: 1,
                              ),
                              SizedBox(width: 0.5 * SizeConfig.widthMultiplier,),
                              _button(
                                onTap: () {},
                                time: "9:00",
                                amPm: "am",
                                index: 2,
                              ),
                              SizedBox(width: 0.5 * SizeConfig.widthMultiplier,),
                              _button(
                                onTap: () {},
                                time: "9:30",
                                amPm: "am",
                                index: 3,
                              ),
                            ],
                          ),
                          SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                          Row(
                            children: <Widget>[
                              _button(
                                onTap: () {},
                                time: "10:00",
                                amPm: "am",
                                index: 4,
                              ),
                              SizedBox(width: 0.5 * SizeConfig.widthMultiplier,),
                              _button(
                                onTap: () {},
                                time: "10:30",
                                amPm: "am",
                                index: 5,
                              ),
                              SizedBox(width: 0.5 * SizeConfig.widthMultiplier,),
                              _button(
                                onTap: () {},
                                time: "11:00",
                                amPm: "am",
                                index: 6,
                              ),
                              SizedBox(width: 0.5 * SizeConfig.widthMultiplier,),
                              _button(
                                onTap: () {},
                                time: "11:30",
                                amPm: "am",
                                index: 7,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2 * SizeConfig.heightMultiplier,),
            Visibility(
              visible: widget.time == "Afternoon:" ? true : false,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10.0,
                        right: 30.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Afternoon",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                            ),
                          ),
                          SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                          Text(
                            "03:00 - 04:30 pm",
                            style: TextStyle(
                              color: Colors.black26,
                              fontSize: 2.2 * SizeConfig.textMultiplier,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          _button(
                            time: "3:00",
                            amPm: "pm",
                            index: 0,
                            onTap: () {},
                          ),
                          SizedBox(width: 0.5 * SizeConfig.widthMultiplier,),
                          _button(
                            time: "3:30",
                            amPm: "pm",
                            index: 1,
                            onTap: () {},
                          ),
                          SizedBox(width: 0.5 * SizeConfig.widthMultiplier,),
                          _button(
                              time: "4:00",
                              amPm: "pm",
                              index: 2,
                              onTap: () {}
                          ),
                          SizedBox(width: 0.5 * SizeConfig.widthMultiplier,),
                          _button(
                            time: "4:30",
                            amPm: "pm",
                            index: 3,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2 * SizeConfig.heightMultiplier,),
            Container(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: RaisedButton(
                    clipBehavior: Clip.hardEdge,
                    textColor: Colors.white,
                    padding: EdgeInsets.zero,
                    child: Container(
                      width: 80 * SizeConfig.widthMultiplier,
                      height: 5 * SizeConfig.heightMultiplier,
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradientColor,
                      ),
                      child: Center(
                        child: Text("Book Appointment", style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Brand Bold",
                          ),),
                      ),
                    ),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                      String time1 = Utils.toDate(startTime);
                      String time2 = Utils.toTime(startTime);
                      createEvent(context, time1, time2);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  createEvent(BuildContext context, String time1, String time2) async {
    String chatRoomId = getChatRoomId(myName: Constants.myName, username: widget.doctorsName);
    int t = startTime.day;
    int m = startTime.month;
    int h = startTime.hour;
    int min = startTime.minute;
    String time = "$t, $m $h:$min";
    final event = Event(
      title: "Doctor's Appointment (${widget.type}) at $time2",
      doctorsName: widget.doctorsName,
      name: Constants.myName,
      hospital: widget.hospital,
      type: widget.type,
      startTime: startTime,
      time: time,
      status: "waiting",
      isAllDay: false,
      users: [Constants.myName, widget.doctorsName],
      chatRoomId: chatRoomId,
    );

    CustomNotification notification = CustomNotification.newAppointment(
      createdAt: FieldValue.serverTimestamp(),
      type: "appointment reminder",
      counter: "1",
      appType: widget.type,
      docName: widget.doctorsName,
      name: Constants.myName,
      startTime: Timestamp.fromDate(startTime),
      hospital: widget.hospital,
      postHeading: null,
      heading: null,
      eventTitle: null,
      drugName: null,
    );
    var notificationMap = notification.toAppReminderNotification(notification);

    Duration duration = startTime.add(Duration(minutes: 30)).difference(DateTime.now());

    int id = Random().nextInt(100);
    Reminder reminder = Reminder.appointReminder(
      speciality: widget.type,
      createdAt: FieldValue.serverTimestamp(),
      apTime: Timestamp.fromDate(startTime),
      name: widget.doctorsName,
      id: id,
      status: "waiting",
      hospital: widget.hospital,
      type: "appointment",
      howLong: null,
    );

    Activity activity = Activity.appReminderActivity(
      appTime: Timestamp.fromDate(startTime),
      createdAt: FieldValue.serverTimestamp(),
      reminderType: "appointment",
      type: "reminder",
      user: widget.doctorsName,
    );

    var activityMap = activity.toAppReminderActivity(activity);
    var reminderMap = reminder.toAppointMap(reminder);

    // Duration exDuration = DateTime.parse("20210917T171200").difference(DateTime.now());
    // scheduleAlarm(dateTimeNow: DateTime.parse("20210917T171200").subtract(Duration(minutes: 2)), dateTime: startTime, duration: "2 min",
    //   id: 363, docName: widget.doctorsName, speciality: widget.type, isDoc: false,);
    // Timer(exDuration, () async {await notificationsPlugin.cancel(363);});
    // scheduleAlarm(dateTime: DateTime.parse("20210917T171200"), id: id, docName: widget.doctorsName, speciality: widget.type, isDoc: false);
    // Timer(Duration(minutes: 7), () {cancelAlarm(name: widget.doctorsName.trim(), id: id);});
    // await databaseMethods.createUserReminder(reminderMap, firebaseAuth.currentUser.uid);
    // Navigator.pop(context);
    // displaySnackBar(message: "Created Reminder", context: context, label: "OK");


    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text("Book Appointment with Dr. ${widget.doctorsName} on $time1 at $time2",
            style: TextStyle(fontFamily: "Brand Bold"),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Cancel", style: TextStyle(fontFamily: "Brand-Regular"),),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text("Confirm", style: TextStyle(fontFamily: "Brand-Regular"),),
            onPressed: () async {

              int exId = Random().nextInt(50);
              int exId1 = Random().nextInt(50);
              int exId2 = Random().nextInt(50);

              Duration exDuration = startTime.difference(DateTime.now());
              Duration exDuration1 = startTime.subtract(Duration(minutes: 10)).difference(DateTime.now());
              Duration exDuration2 = startTime.subtract(Duration(hours: 1)).difference(DateTime.now());

              scheduleAlarm(dateTimeNow: startTime.subtract(Duration(minutes: 10)), dateTime: startTime, duration: "10 min",
                id: exId, docName: widget.doctorsName, speciality: widget.type, isDoc: false,);
              Timer(exDuration, () async {await notificationsPlugin.cancel(exId);});

              scheduleAlarm(dateTimeNow: startTime.subtract(Duration(hours: 1)), dateTime: startTime, duration: "1 hour",
                id: exId1, docName: widget.doctorsName, speciality: widget.type, isDoc: false,);
              Timer(exDuration1, () async {await notificationsPlugin.cancel(exId1);});

              scheduleAlarm(dateTimeNow: startTime.subtract(Duration(hours: 6)), dateTime: startTime, duration: "6 hours",
                id: exId2, docName: widget.doctorsName, speciality: widget.type, isDoc: false,);
              Timer(exDuration2, () async {await notificationsPlugin.cancel(exId2);});

              scheduleAlarm(dateTime: startTime, id: id, docName: widget.doctorsName, speciality: widget.type, isDoc: false);
              Timer(duration, () {cancelAlarm(name: widget.doctorsName.trim(), id: id);});

              ///TODO
              // bool slotBooked =  snap.docs[0].get("time") == time ? true : false;
              Map<String, dynamic> eventMap = event.toMap(event);
              final provider = Provider.of<EventProvider>(context, listen: false);
              provider.addEvent(event);
              databaseMethods.createUserReminder(reminderMap, currentUser.uid);
              databaseMethods.createAppointment(chatRoomId, eventMap);
              databaseMethods.createNotification(notificationMap);
              databaseMethods.createUserActivity(activityMap, currentUser.uid);
              Navigator.of(context).pop();
              displayToastMessage("Operation Successful! Created Appointment Reminder too", context);
            },
          ),
        ],
      ),
    );
  }

  Widget _button({String time, int index, Function onTap, String amPm}) {
    int idx = time.indexOf(":");
    String hour = time.substring(0, idx).trim();
    String min = time.substring(idx+1).trim();
    int hourInt;
    int minInt = int.parse(min);
    if (amPm == "pm") {
      hourInt = 12 + int.parse(hour);
    } else {
      hourInt = int.parse(hour);
    }
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
        color: selectedIndex == index ? Color(0xFFa81845) : Colors.white,
        child: InkWell(
          splashColor: Color(0xFFa81845).withOpacity(0.6),
          highlightColor: Colors.grey.withOpacity(0.1),
          radius: 800,
          borderRadius: BorderRadius.circular(8),
          onTap: (){
            changeIndex(index);
            setState(() {
              reminderHours = hourInt;
              reminderMinutes = minInt;
            });
            pickFromDate(pickDate: false);
          },
          child: Container(
            height: 5 * SizeConfig.heightMultiplier,
            width: 23 * SizeConfig.widthMultiplier,
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

  Widget buildDropdownFiled({@required String text, @required Function() onClicked}) {
    return ListTile(
      title: Text(text, style: TextStyle(fontFamily: "Brand-Regular"),),
      trailing: Icon(Icons.arrow_drop_down, color: Color(0xFFa81845),),
      onTap: onClicked,
    );
  }

  Future pickFromDate({@required bool pickDate}) async {
    final date = await pickDateTime(startTime, pickDate: pickDate, firstDate: DateTime.now());
    if (date == null) return;

    setState(() {
      startTime = date;
    });
  }

  Future<DateTime> pickDateTime(DateTime initialDate, {
    DateTime firstDate, @required bool pickDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: DateTime(2089),
      );

      if (date == null) return null;

      final time = Duration(hours: reminderHours, minutes: reminderMinutes);

      return date.add(time);
    } else {

      final date = DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: reminderHours, minutes: reminderMinutes);

      return date.add(time);
    }
  }
}

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key key}) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventsOfSelectedDate;

    if (selectedEvents.isEmpty) {
      return Center(
        child: Text("No Events Found!", style:  TextStyle(
          color: Colors.red[300],
          fontSize: 24,
        ),),
      );
    } else {
      return SfCalendarTheme(
        data: SfCalendarThemeData(),
        child: SfCalendar(
          view: CalendarView.timelineDay,
          dataSource: EventDataSource(provider.events),
          initialSelectedDate: provider.selectedDate,
          appointmentBuilder: appointmentBuilder,
        ),
      );
    }
  }

  Widget appointmentBuilder(
      BuildContext context,
      CalendarAppointmentDetails details) {

    final event = details.appointments.first;
  }
}


class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  Event getEvent(int index) => appointments[index] as Event;

  @override
  DateTime getStartTime(int index) => getEvent(index).startTime;
  
  @override
  DateTime getEndTime(int index) => getEvent(index).startTime.add(const Duration(hours: 2));

  @override
  String getSubject(int index) => getEvent(index).title;

  @override
  bool isAllDay(int index) => getEvent(index).isAllDay;

  @override
  Color getColor(int index) {
    return Colors.red[300];
  }

}

displaySnackBar({@required String message, @required BuildContext context, Function onPressed,String label, Duration duration}) {
  SnackBar snackBar = SnackBar(
    duration: duration != null ? duration : Duration(seconds: 4),
    content: Text(message),
    action: SnackBarAction(
      label: label != null ? label : "Cancel",
      onPressed: onPressed != null ? onPressed : () {},
    ),
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

scheduleAlarm({DateTime dateTimeNow, DateTime dateTime, int id, String docName, String speciality,
  bool isDoc, String duration}) async {
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
    id, "Appointment Reminder",
    "$speciality appointment with ${isDoc == true ? docName : "Dr. $docName"} ${dateTimeNow != null ? "at ${Utils.formatTime(dateTime)}($duration)" : "happening now"}",
    dateTimeNow != null ? dateTimeNow : dateTime,
    platformChannelSpecs,
  );
}