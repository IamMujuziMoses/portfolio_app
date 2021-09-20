import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/Chat/chatScreen.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/findADoctorScreen.dart';
import 'package:creativedata_app/AllScreens/loginScreen.dart';
import 'package:creativedata_app/AllScreens/newsFeedScreen.dart';
import 'package:creativedata_app/AllScreens/notificationsScreen.dart';
import 'package:creativedata_app/AllScreens/userProfileScreen.dart';
import 'package:creativedata_app/Covid-19/covid19Center.dart';
import 'package:creativedata_app/Doctor/activityLogsScreen.dart';
import 'package:creativedata_app/Doctor/alertsScreen.dart';
import 'package:creativedata_app/Doctor/appointmentsScreen.dart';
import 'package:creativedata_app/Doctor/doctorAccount.dart';
import 'package:creativedata_app/Doctor/medicalStore.dart';
import 'package:creativedata_app/Doctor/patientsScreen.dart';
import 'package:creativedata_app/Doctor/postArticleScreen.dart';
import 'package:creativedata_app/Doctor/eventsScreen.dart';
import 'package:creativedata_app/Doctor/reminderScreen.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Widgets/divider.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class DoctorProfile extends StatefulWidget {
  static const String screenId = "doctorProfile";
  final String name;
  final String speciality;
  final String userPic;
  final String email;
  final String about;
  final String age;
  final String hospital;
  final String hours;
  final String patients;
  final String experience;
  final String reviews;
  DoctorProfile({Key key,
    this.name,
    this.speciality,
    this.userPic,
    this.email,
    this.about,
    this.age,
    this.hospital,
    this.hours,
    this.patients,
    this.experience,
    this.reviews}) : super(key: key);

  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {

  DatabaseMethods databaseMethods = DatabaseMethods();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool> _onBackPressed() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit the app?"),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: PickUpLayout(
        scaffold: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Colors.grey[100],
            elevation: 0,
            centerTitle: true,
            title: Text("Siro", style: TextStyle(
              fontFamily: "Brand Bold",
              color: Colors.red[300],
            ),),
            actions: <Widget>[
              Stack(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.notifications_outlined,
                      size: 8 * SizeConfig.imageSizeMultiplier,
                      color: Colors.red[300],
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationsScreen(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Visibility(
                      visible: true,
                      child: Container(
                        height: 2 * SizeConfig.heightMultiplier,
                        width: 4 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          color: Colors.red[300],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text("2", style: TextStyle(
                              fontFamily: "Brand-Regular",
                              color: Colors.white
                          ),),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          drawer: Container(
            color: Colors.white,
            width: 65 * SizeConfig.widthMultiplier,
            child: Drawer(
              child: ListView(
                children: [
                  //drawer Header
                  Container(
                    color: Colors.white,
                    height: 25 * SizeConfig.heightMultiplier,
                    child: DrawerHeader(
                      decoration: BoxDecoration(color: Colors.red[300]),
                      child: Row(
                        children: [
                          CachedImage(
                            imageUrl: widget.userPic,
                            isRound: true,
                            radius: 70,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 2 * SizeConfig.widthMultiplier),
                          Container(
                            height: 10 * SizeConfig.heightMultiplier,
                            width: 36 * SizeConfig.widthMultiplier,
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Spacer(),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      height: 3 * SizeConfig.heightMultiplier,
                                      width: 36 * SizeConfig.widthMultiplier,
                                      child: Text("Dr. " + widget.name, style: TextStyle(
                                        fontSize: 2.5 * SizeConfig.textMultiplier,
                                        fontFamily: "Brand Bold",
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ), overflow: TextOverflow.ellipsis,),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      height: 2 * SizeConfig.heightMultiplier,
                                      width: 36 * SizeConfig.widthMultiplier,
                                      child: Text(widget.email, style: TextStyle(
                                        color: Colors.white60,
                                        fontFamily: "Brand-Regular",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 1.5 * SizeConfig.textMultiplier,
                                      ), overflow: TextOverflow.ellipsis,),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DividerWidget(),
                  SizedBox(height: 12.0,),
                  //Drawer body controller
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ChatScreen(isDoctor: true,),
                    ),),
                    child: ListTile(
                      hoverColor: Colors.red[300],
                      leading: Container(
                        height: 5 * SizeConfig.heightMultiplier,
                        width: 10 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Icon(Icons.message_outlined,
                          ),
                        ),),
                      title: Text("Chats", style: TextStyle(fontSize: 15.0, fontFamily: "Brand-Regular"),),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) => DoctorAccount(
                        name: widget.name, speciality: widget.speciality, userPic: widget.userPic, email: widget.email,
                        about: widget.about, age: widget.age, hospital: widget.hospital, hours: widget.hours,
                        patients: widget.patients, experience: widget.experience, reviews: widget.reviews,
                      ),
                    ),),
                    child: ListTile(
                      hoverColor: Colors.red[300],
                      leading: Container(
                        height: 5 * SizeConfig.heightMultiplier,
                        width: 10 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Icon(Icons.account_box_rounded,
                          ),
                        ),),
                      title: Text("Visit Profile", style: TextStyle(fontSize: 15.0, fontFamily: "Brand-Regular"),),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      hoverColor: Colors.red[300],
                      leading: Container(
                        height: 5 * SizeConfig.heightMultiplier,
                        width: 10 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Icon(Icons.info,
                          ),
                        ),),
                      title: Text("About", style: TextStyle(fontSize: 15.0, fontFamily: "Brand-Regular"),),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => LoginScreen()
                      ));
                    },
                    child: ListTile(
                      hoverColor: Colors.red[300],
                      leading: Container(
                        height: 5 * SizeConfig.heightMultiplier,
                        width: 10 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Icon(Icons.logout, color: Colors.red[300],
                          ),
                        ),),
                      title: Text("Log Out", style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: "Brand Bold",
                        color: Colors.red[300],
                      ),),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey[100],
            child: Stack(
              children: <Widget>[
                Container(
                    height: 10 * SizeConfig.heightMultiplier,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(2, 3),
                          spreadRadius: 0.5,
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20,
                          right: 10,
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => profilePicView(
                                  imageUrl: widget.userPic,
                                  context: context,
                                  isSender: true,
                                ),
                                child: CachedImage(
                                  imageUrl: widget.userPic,
                                  isRound: true,
                                  radius: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 5 * SizeConfig.widthMultiplier,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 0,
                                    child: Container(
                                      width: 60 * SizeConfig.widthMultiplier,
                                      child: Wrap(
                                        children: [Text("Dr. " + widget.name, style: TextStyle(
                                            color: Colors.red[300],
                                            fontFamily: "Brand Bold",
                                            fontSize: 3 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold,
                                          ),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                                  Row(
                                    children: <Widget>[
                                      Image.asset("images/doctor.png", color: Colors.black54,
                                        height: 2 * SizeConfig.heightMultiplier,
                                        width: 3.5 * SizeConfig.widthMultiplier,
                                      ),
                                      SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                      Text(widget.speciality, style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: "Brand Bold",
                                        fontSize: 2.3 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    ],
                                  ),
                                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                  Text(
                                    TimeOfDay.now().hour >= 12 && TimeOfDay.now().hour < 16
                                        ? "Good Afternoon!"
                                        : TimeOfDay.now().hour >= 16
                                            ? "Good Evening!"
                                            : "Good Morning!",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 2.2 * SizeConfig.textMultiplier,
                                    ),),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 11 * SizeConfig.heightMultiplier,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    child: SingleChildScrollView(

                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 2 * SizeConfig.heightMultiplier,
                          bottom: 2 * SizeConfig.heightMultiplier,
                          left: 2 * SizeConfig.widthMultiplier,
                          right: 2 * SizeConfig.widthMultiplier,
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                            Container(
                              width: 95 * SizeConfig.widthMultiplier,
                              height: 55 * SizeConfig.heightMultiplier,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(2, 3),
                                    spreadRadius: 0.5,
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.1),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Quick  Access", style: TextStyle(
                                      fontFamily: "Brand Bold",
                                      fontSize: 3 * SizeConfig.textMultiplier,
                                    ),),
                                    Container(
                                      height: 43 * SizeConfig.heightMultiplier,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              accessTile(
                                                icon: Icons.post_add,
                                                title: "Post Article",
                                                alert: "0",
                                                onTap: () => Navigator.push(
                                                  context, MaterialPageRoute(
                                                  builder: (context) => PostArticleScreen(
                                                    userName: widget.name,
                                                    userPic: widget.userPic,
                                                  ),
                                                ),
                                                ),
                                              ),
                                              ///TODO
                                              accessTile(
                                                icon: CupertinoIcons.calendar_today,
                                                title: "Appointments",
                                                alert: "5",
                                                onTap: () async {
                                                  Stream appointmentStream;
                                                  await databaseMethods.getAppointments(Constants.myName).then((val) {
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
                                                },
                                              ),
                                              accessTile(
                                                icon: CupertinoIcons.alarm,
                                                title: "Reminders",
                                                alert: "2",
                                                onTap: () async {
                                                  Stream reminderStream;
                                                  await databaseMethods.getDoctorsReminders(firebaseAuth.currentUser.uid)
                                                      .then((val) {
                                                        setState(() {
                                                          reminderStream = val;
                                                        });
                                                  });
                                                  Navigator.push(
                                                    context, MaterialPageRoute(
                                                    builder: (context) => ReminderScreen(
                                                      reminderStream: reminderStream,
                                                    ),
                                                  ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              accessTile(
                                                icon: FontAwesomeIcons.users,
                                                title: "My Patients",
                                                alert: "0",
                                                onTap: () async {
                                                  Stream patientsStream;
                                                  await databaseMethods
                                                      .getDoctorsSavedPatients(firebaseAuth.currentUser.uid)
                                                      .then((val) {
                                                    setState(() {
                                                      patientsStream = val;
                                                    });
                                                  });
                                                  Navigator.push(
                                                    context, MaterialPageRoute(
                                                    builder: (context) => PatientsScreen(
                                                      patientsStream: patientsStream,
                                                    ),
                                                  ),
                                                  );
                                                },
                                              ),
                                              accessTile(
                                                icon: FontAwesomeIcons.newspaper,
                                                title: "My Feed",
                                                alert: "0",
                                                onTap: () => Navigator.push(
                                                  context, MaterialPageRoute(
                                                  builder: (context) => NewsFeedScreen(
                                                    userName: widget.name,
                                                    userPic: widget.userPic,
                                                    isDoctor: true,
                                                  ),
                                                ),
                                                ),
                                              ),
                                              accessTile(
                                                icon: CupertinoIcons.calendar_badge_plus,
                                                title: "Events",
                                                alert: "0",
                                                onTap: () => Navigator.push(
                                                  context, MaterialPageRoute(
                                                  builder: (context) => EventsScreen(),
                                                ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              accessTile(
                                                icon: CupertinoIcons.exclamationmark_triangle,
                                                title: "Alerts",
                                                alert: "3",
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
                                              ),
                                              accessTile(
                                                icon: Icons.fact_check_outlined,
                                                title: "Activity Log",
                                                alert: "0",
                                                onTap: () => Navigator.push(
                                                  context, MaterialPageRoute(
                                                  builder: (context) => ActivityLogsScreen(),
                                                ),
                                                ),
                                              ),
                                              accessTile(
                                                icon: Icons.add_shopping_cart_rounded,
                                                title: "Medical Store",
                                                alert: "0",
                                                onTap: () => Navigator.push(
                                                  context, MaterialPageRoute(
                                                  builder: (context) => MedicalStore(),
                                                ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              accessTile(
                                                icon: FontAwesomeIcons.ban,
                                                title: "MoH",
                                                alert: "0",
                                                onTap: () {},
                                              ),
                                              accessTile(
                                                icon: FontAwesomeIcons.virus,
                                                title: "COVID-19",
                                                alert: "0",
                                                onTap: () async {
                                                  QuerySnapshot snap = await databaseMethods.getImageAd();
                                                  Navigator.push(context,
                                                    MaterialPageRoute(
                                                      builder: (context) => Covid19Center(
                                                        adSnap: snap,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              accessTile(
                                                icon: Icons.support_agent_rounded,
                                                title: "Help Centers",
                                                alert: "0",
                                                onTap: () {},
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
                            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                            Container(
                              width: 95 * SizeConfig.widthMultiplier,
                              height: 10 * SizeConfig.heightMultiplier,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: arrowBox(
                                  message: "Does your hospital have an ambulance? Register or invite your driver to register",
                                  greeting: "Help Save Lives!",
                                  image: "images/ambulance.png",
                                  onTap: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget accessTile({IconData icon, String title, Function onTap, String alert}) {
    bool alertVisible = false;
    int alertInt = int.parse(alert);
    if (alertInt > 0) {
      setState(() {
        alertVisible = true;
      });
    }
    return Container(
      height: 10 * SizeConfig.heightMultiplier,
      width: 29 * SizeConfig.widthMultiplier,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            offset: Offset(2, 3),
            spreadRadius: 0.5,
            blurRadius: 2,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Material(
        color: Colors.grey[100],
        child: InkWell(
          splashColor: Colors.red[300],
          highlightColor: Colors.grey.withOpacity(0.1),
          radius: 800,
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: Icon(icon,
                          size: 8 * SizeConfig.imageSizeMultiplier,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 65,
                      child: Visibility(
                        visible: alertVisible,
                        child: Container(
                          height: 2 * SizeConfig.heightMultiplier,
                          width: 4 * SizeConfig.widthMultiplier,
                          decoration: BoxDecoration(
                            color: Colors.red[300],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(alert, style: TextStyle(
                                fontFamily: "Brand-Regular",
                                color: Colors.white
                            ),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(title, style: TextStyle(
                  fontFamily: "Brand-Regular",
                  fontSize: 2 * SizeConfig.textMultiplier,
                ),),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
