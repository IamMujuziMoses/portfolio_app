import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/Chat/chatScreen.dart';
import 'package:creativedata_app/AllScreens/Chat/conversationScreen.dart';
import 'package:creativedata_app/AllScreens/bookAppointmentScreen.dart';
import 'package:creativedata_app/AllScreens/reminderScreen.dart';
import 'package:creativedata_app/AllScreens/specialityScreen.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/Covid-19/covid19Center.dart';
import 'package:creativedata_app/AllScreens/doctorProfileScreen.dart';
import 'package:creativedata_app/AllScreens/findADoctorScreen.dart';
import 'package:creativedata_app/AllScreens/loginScreen.dart';
import 'package:creativedata_app/AllScreens/mainScreen.dart';
import 'package:creativedata_app/AllScreens/nearestHospitalsScreen.dart';
import 'package:creativedata_app/AllScreens/newsFeedScreen.dart';
import 'package:creativedata_app/Covid-19/preventiveMeasures.dart';
import 'package:creativedata_app/Doctor/alertsScreen.dart';
import 'package:creativedata_app/Doctor/doctorAccount.dart';
import 'package:creativedata_app/Doctor/doctorRegistration.dart';
import 'package:creativedata_app/Doctor/eventsScreen.dart';
import 'package:creativedata_app/Doctor/medicalStore.dart';
import 'package:creativedata_app/Models/venue.dart';
import 'package:creativedata_app/Provider/placesProvider.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/User/aboutScreen.dart';
import 'package:creativedata_app/User/helpScreen.dart';
import 'package:creativedata_app/User/personalDetails.dart';
import 'package:creativedata_app/Utilities/permissions.dart';
import 'package:creativedata_app/Widgets/divider.dart';
import 'package:creativedata_app/Widgets/onlineIndicator.dart';
import 'package:creativedata_app/Widgets/photoViewPage.dart';
import 'package:creativedata_app/AllScreens/notificationsScreen.dart';
import 'package:creativedata_app/Widgets/progressDialog.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../sizeConfig.dart';
/*
* Created by Mujuzi Moses
*/

class UserProfileScreen extends StatefulWidget {
  static const String screenId = "userProfileScreen";
  final String name;
  final String userPic;
  final String email;
  final String phone;
  final QuerySnapshot generalSnap;
  final QuerySnapshot dentistSnap;
  final QuerySnapshot cardiologySnap;
  const UserProfileScreen({Key key, this.name, this.userPic, this.email, this.phone, this.generalSnap,
    this.dentistSnap, this.cardiologySnap,
  }) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  QuerySnapshot adSnap;
  QuerySnapshot hospitalSnap;
  Venue venue;
  Position position;
  Stream topDocStream;
  Stream hospitalStream;
  List<QuerySnapshot> hospQueryList = [];
  List hospitalList = [];
  @override
  void initState() {
    getInfo();
    super.initState();
  }

  getInfo() async {
    adSnap = await databaseMethods.getVideoAd();
    await databaseMethods.getHospitals().then((val) {
      setState(() {
        hospitalStream = val;
      });
    });
    hospitalSnap = await hospitalStream.first;
    for (int i = 0; i <= hospitalSnap.size - 1; i++) {
      hospitalList.add(hospitalSnap.docs[i].get("name"));
    }
    for (int i = 0; i <= hospitalList.length - 1; i++) {
      QuerySnapshot hospSnap;
      await databaseMethods.getHospitalByName(hospitalList[i]).then((val) {
        setState(() {
          hospSnap = val;
        });
      });
      hospQueryList.add(hospSnap);
    }

    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    print("positionLat ::: ${position.latitude}");

    if (position != null) {
      await Provider.of<PlacesNotifier>(context, listen: false).getPlaces(
          position.latitude.toString(), position.longitude.toString());

      venue = Provider.of<PlacesNotifier>(context, listen: false).getVenue;
      print("Venue ::: ${venue.response.venues.length}");

      String reviews = "70";
      await databaseMethods.getTopDoctors(reviews).then((val) {
        topDocStream = val;
      });
    }
  }

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
                    onPressed: () async {
                      Stream notificationStream;
                      await databaseMethods.getNotifications().then((val) {
                        setState(() {
                          notificationStream = val;
                        });
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsScreen(
                            notificationsStream: notificationStream,
                            name: widget.name,
                            userPic: widget.userPic,
                            isDoctor: false,
                          ),
                        ),
                      );
                    },
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
                          child: Text("5", style: TextStyle(
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
                  DrawerHeader(
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
                                      child: Text(widget.name, style: TextStyle(
                                        fontSize: 2.3 * SizeConfig.textMultiplier,
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
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Brand-Regular",
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
                  DividerWidget(),
                  SizedBox(height: 12.0,),
                  //Drawer body controller
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MainScreen(
                        fromNearest: false,
                        name: widget.name,
                        phone: widget.phone,
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
                          child: Image.asset(
                            "images/ambulance.png",
                            height: 6 * SizeConfig.heightMultiplier,
                            width: 6 * SizeConfig.widthMultiplier,
                            color: Colors.red[300],
                          ),
                        ),
                      ),
                      title: Text("Emergency", style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: "Brand Bold",
                          color: Colors.red[300]
                      ),),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) => HelpScreen(),
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
                            child: Icon(CupertinoIcons.question_circle_fill,
                            ),
                          ),),
                      title: Text("Help", style: TextStyle(fontSize: 15.0, fontFamily: "Brand-Regular"),),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) => PersonalDetails(
                        name: widget.name,
                        phone: widget.phone,
                        userPic: widget.userPic,
                        email: widget.email,
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
                            child: Icon(CupertinoIcons.person_alt,
                            ),
                          ),),
                      title: Text("Profile", style: TextStyle(fontSize: 15.0, fontFamily: "Brand-Regular"),),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) => AboutScreen(
                        title: "About",
                        heading: "Know more about us",
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
                            child: Icon(Icons.logout,
                            ),
                          ),),
                      title: Text("Log Out", style: TextStyle(fontSize: 15.0, fontFamily: "Brand-Regular"),),
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
                 Padding(
                   padding: EdgeInsets.only(
                     top: 1 * SizeConfig.heightMultiplier,
                   ),
                   child: Container(
                      height: 8 * SizeConfig.heightMultiplier,
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
                                    isDoctor: false,
                                    isUser: true,
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
                                            children: [Text(widget.name, style: TextStyle(
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
                                    Text(
                                      TimeOfDay.now().hour >= 12 && TimeOfDay.now().hour < 16
                                          ? "Good Afternoon!"
                                          : TimeOfDay.now().hour >= 16
                                              ? "Good Evening!"
                                              : "Good Morning!",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 2.2 * SizeConfig.textMultiplier,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                 ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 9.4 * SizeConfig.heightMultiplier,
                  ),
                  child: Container(
                    height: 80 * SizeConfig.heightMultiplier,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("COVID-19 Prevention Tips", style: TextStyle(
                                  fontSize: 2.5 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Brand Bold"
                                ),),
                              ],
                            ),
                            Container(
                              width: 95 * SizeConfig.widthMultiplier,
                              height: 14 * SizeConfig.heightMultiplier,
                              color: Colors.grey[100],
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    _prevTips(desc: "Keep Distance \n ",
                                      icon: FontAwesomeIcons.peopleArrows,
                                    ),
                                    SizedBox(width: 4 * SizeConfig.widthMultiplier,),
                                    _prevTips(desc: "Avoid Shaking Hands",
                                      icon: FontAwesomeIcons.handshakeSlash,
                                    ),
                                    SizedBox(width: 4 * SizeConfig.widthMultiplier,),
                                    _prevTips(desc: "Keep Hands Clean",
                                      icon: FontAwesomeIcons.handsWash,
                                    ),
                                    SizedBox(width: 4 * SizeConfig.widthMultiplier,),
                                    _prevTips(desc: "Wear Mask\n ",
                                      icon: FontAwesomeIcons.headSideMask,
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () => Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) => PreventiveMeasures(),
                                        ),
                                      ),
                                      child: Container(
                                        height: 8 * SizeConfig.heightMultiplier,
                                        width: 6 * SizeConfig.widthMultiplier,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(1, 2),
                                              spreadRadius: 0.5,
                                              blurRadius: 2,
                                              color: Colors.black.withOpacity(0.1),
                                            ),
                                          ],

                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Icon(Icons.arrow_forward_ios_rounded,
                                            color: Colors.black54,
                                            size: 4 * SizeConfig.imageSizeMultiplier,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                            Row(
                              children: <Widget>[
                                Text("Find a Doctor", style: TextStyle(
                                      fontSize: 2.5 * SizeConfig.textMultiplier,
                                      fontFamily: "Brand Bold",
                                      fontWeight: FontWeight.w400,
                                    ),),
                                Spacer(),
                              ],
                            ),
                            Container(
                              height: 10 * SizeConfig.heightMultiplier,
                              width: 95 * SizeConfig.widthMultiplier,
                              color: Colors.grey[100],
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 8,
                                  bottom: 8,
                                  left: 10,
                                  right: 10,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    custTile(
                                      image: "images/tooth.png",
                                      title: "Dentist",
                                      doctors: widget.dentistSnap != null
                                          ? widget.dentistSnap.size.toString()
                                          : "0",
                                      onTap: () async {
                                        QuerySnapshot doctorSnap;
                                        await databaseMethods.getAllDoctorsBySpecialitySnap("Dentist").then((val) {
                                          setState(() {
                                            doctorSnap= val;
                                          });
                                        });
                                        List doctorsList = [];
                                        for (int i = 0; i <= doctorSnap.size - 1; i++) {
                                          doctorsList.add(doctorSnap.docs[i].get("name"));
                                        }
                                        Navigator.push(
                                          context, MaterialPageRoute(
                                          builder: (context) => SpecialityScreen(
                                            doctors: doctorsList,
                                            speciality: "Dentist",
                                          ),
                                        ),);
                                      },
                                    ),
                                    SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                    custTile(
                                      image: "images/stethoscope.png",
                                      title: "GM",
                                      doctors: widget.generalSnap != null
                                          ? widget.generalSnap.size.toString()
                                          : "0",
                                      onTap: () async {
                                        QuerySnapshot doctorSnap;
                                        await databaseMethods.getAllDoctorsBySpecialitySnap("General Doctor").then((val) {
                                          setState(() {
                                            doctorSnap= val;
                                          });
                                        });
                                        List doctorsList = [];
                                        for (int i = 0; i <= doctorSnap.size - 1; i++) {
                                          doctorsList.add(doctorSnap.docs[i].get("name"));
                                        }
                                        Navigator.push(
                                          context, MaterialPageRoute(
                                          builder: (context) => SpecialityScreen(
                                            doctors: doctorsList,
                                            speciality: "General Doctor",
                                          ),
                                        ),);
                                      },
                                    ),
                                    SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                    custTile(
                                      image: "images/heart.png",
                                      title: "Cardiology",
                                      doctors: widget.cardiologySnap != null
                                          ? widget.cardiologySnap.size.toString()
                                          : "0",
                                      onTap: () async {
                                        QuerySnapshot doctorSnap;
                                        await databaseMethods.getAllDoctorsBySpecialitySnap("Cardiology").then((val) {
                                          setState(() {
                                            doctorSnap= val;
                                          });
                                        });
                                        List doctorsList = [];
                                        for (int i = 0; i <= doctorSnap.size - 1; i++) {
                                          doctorsList.add(doctorSnap.docs[i].get("name"));
                                        }
                                        Navigator.push(
                                          context, MaterialPageRoute(
                                          builder: (context) => SpecialityScreen(
                                            doctors: doctorsList,
                                            speciality: "Cardiology",
                                          ),
                                        ),);
                                      },
                                    ),
                                    SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                    GestureDetector(
                                      onTap: () async {
                                        QuerySnapshot doctorSnap;
                                        await databaseMethods.getDoctorsSnap().then((val) {
                                          setState(() {
                                            doctorSnap= val;
                                          });
                                        });
                                        List doctorsList = [];
                                        for (int i = 0; i <= doctorSnap.size - 1; i++) {
                                          doctorsList.add(doctorSnap.docs[i].get("name"));
                                        }
                                        Navigator.push(
                                          context, MaterialPageRoute(
                                          builder: (context) => FindADoctorScreen(
                                            hospSnap: hospQueryList,
                                            doctors: doctorsList,
                                            adSnap: adSnap,
                                          ),
                                        ),);
                                      },
                                      child: Container(
                                        height: 8 * SizeConfig.heightMultiplier,
                                        width: 6 * SizeConfig.widthMultiplier,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(1, 2),
                                              spreadRadius: 0.5,
                                              blurRadius: 2,
                                              color: Colors.black.withOpacity(0.1),
                                            ),
                                          ],

                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Icon(Icons.arrow_forward_ios_rounded,
                                            color: Colors.black54,
                                            size: 4 * SizeConfig.imageSizeMultiplier,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                            Row(
                              children: <Widget>[
                                Text("Quick Access", style: TextStyle(
                                      fontSize: 2.5 * SizeConfig.textMultiplier,
                                      fontFamily: "Brand Bold",
                                      fontWeight: FontWeight.w400,
                                    ),),
                                Spacer(),
                              ],
                            ),
                            Container(
                              height: 50 * SizeConfig.heightMultiplier,
                              width: 95 * SizeConfig.widthMultiplier,
                              color: Colors.grey[100],
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: <Widget>[
                                    Positioned(
                                      child: customAccessB(
                                        color: Colors.white,
                                        icon: FontAwesomeIcons.solidHospital,
                                        title1: "Nearest",
                                        title2: "Health Center",
                                        onTap: () => Navigator.push(
                                            context, MaterialPageRoute(
                                            builder: (context) => NearestHospitalScreen(
                                              name: widget.name,
                                              phone: widget.phone,
                                              currentPosition: position,
                                              venue: venue,
                                            )
                                          ),
                                          ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 35 * SizeConfig.widthMultiplier,
                                      child: customAccessB(
                                        color: Colors.white,
                                        icon: Icons.add_shopping_cart_rounded,
                                        title1: "Medical Store",
                                        onTap: () async {
                                          Stream drugStream;
                                          await databaseMethods.getDrugs().then((val) {
                                            setState(() {
                                              drugStream = val;
                                            });
                                          });
                                          Navigator.push(
                                            context, MaterialPageRoute(
                                            builder: (context) => MedicalStore(
                                              drugStream: drugStream,
                                            ),
                                          ),
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      top: 17.5 * SizeConfig.heightMultiplier,
                                      child: customAccessB(
                                        color: Colors.white,
                                        icon: CupertinoIcons.exclamationmark_triangle_fill,
                                        title1: "Health Alerts",
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
                                    ),
                                    Positioned(
                                      top: 40 * SizeConfig.heightMultiplier,
                                      child: customAccessB(
                                        color: Colors.white,
                                        icon: CupertinoIcons.alarm_fill,
                                        title1: "Reminders",
                                        onTap: () => Navigator.push(
                                          context, MaterialPageRoute(
                                          builder: (context) => ReminderScreen(),
                                        ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 35 * SizeConfig.widthMultiplier,
                                      top: 40 * SizeConfig.heightMultiplier,
                                      child: customAccessB(
                                        color: Colors.white,
                                        icon: CupertinoIcons.calendar_badge_plus,
                                        title1: "Events",
                                        onTap: () async {
                                          Stream eventsStream;
                                          await databaseMethods.getEvents().then((val) {
                                            setState(() {
                                              eventsStream = val;
                                            });
                                          });
                                          Navigator.push(
                                            context, MaterialPageRoute(
                                            builder: (context) => EventsScreen(
                                              isDoctor: false,
                                              eventsStream: eventsStream,
                                            ),
                                          ),
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: customAccessB(
                                        color: Colors.white,
                                        icon: CupertinoIcons.news_solid,
                                        title1: "News Feed",
                                        onTap: () => Navigator.push(
                                          context, MaterialPageRoute(
                                          builder: (context) => NewsFeedScreen(
                                            userName: widget.name,
                                            userPic: widget.userPic,
                                            isDoctor: false,
                                          ),
                                        ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 17.5 * SizeConfig.heightMultiplier,
                                      right: 0,
                                      child: customAccessB(
                                        color: Colors.white,
                                        icon: FontAwesomeIcons.userMd,
                                        title1: "Find A",
                                        title2: "Doctor",
                                        onTap: () async {
                                          QuerySnapshot doctorSnap;
                                          await databaseMethods.getDoctorsSnap().then((val) {
                                            setState(() {
                                              doctorSnap= val;
                                            });
                                          });
                                          List doctorsList = [];
                                          for (int i = 0; i <= doctorSnap.size - 1; i++) {
                                            doctorsList.add(doctorSnap.docs[i].get("name"));
                                          }
                                          Navigator.push(context,
                                            MaterialPageRoute(
                                              builder: (context) => FindADoctorScreen(
                                                hospSnap: hospQueryList,
                                                doctors: doctorsList,
                                                adSnap: adSnap,
                                              ),
                                            ),);
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 40 * SizeConfig.heightMultiplier,
                                      child: customAccessB(
                                        color: Colors.white,
                                        icon: FontAwesomeIcons.virus,
                                        title1: "Covid-19",
                                        title2: "Center",
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
                                    ),
                                    Positioned(
                                      top: 16 * SizeConfig.heightMultiplier,
                                      left: 31 * SizeConfig.widthMultiplier,
                                      child: customAccessB(
                                        size: "medium",
                                        color: Colors.red[300],
                                        image: "images/ambulance.png",
                                        title1: "Emergency",
                                        onTap: () => Navigator.push(
                                          context, MaterialPageRoute(
                                            builder: (context) => MainScreen(
                                              fromNearest: false,
                                              name: widget.name,
                                              phone: widget.phone,
                                            ),
                                          ),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 2 * SizeConfig.heightMultiplier,),
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

  Widget _prevTips({String desc, Color color, IconData icon}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 8 * SizeConfig.heightMultiplier,
          width: 16 * SizeConfig.widthMultiplier,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(1, 3),
                spreadRadius: 0.5,
                blurRadius: 2,
                color: Colors.black.withOpacity(0.3),
              ),
            ],
            color: color == null ? Colors.white : color,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Icon(icon, color: Colors.black54,),
          ),
        ),
        Container(
          width: 18 * SizeConfig.widthMultiplier,
          child: Wrap(
            children: <Widget>[
              Center(
                child: Text(
                desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 1.6 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Brand-Regular"
                ),),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class InfoView extends StatefulWidget {
  final String imageUrl;
  final String doctorsName;
  final String speciality;
  final String hospital;
  final String reviews;
  final String uid;
  InfoView({Key key, this.imageUrl, this.doctorsName, this.speciality, this.hospital, this.reviews, this.uid}) : super(key: key);

  @override
  _InfoViewState createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot snap;
  String email = "";
  String about = "";
  String phone = "";
  String age = "";
  String hours = "";
  String patients = "";
  String experience = "";
  List days = [];
  Map fee = {};

  @override
  void initState() {
    super.initState();
    getDoctorInfo();
  }

  getDoctorInfo() async{
    await databaseMethods.getUserByUid(widget.uid).then((val) {
      snap = val;
      email = snap.docs[0].get("email");
      about = snap.docs[0].get("about");
      phone = snap.docs[0].get("phone");
      age = snap.docs[0].get("age");
      hours = snap.docs[0].get("hours");
      patients = snap.docs[0].get("patients");
      experience = snap.docs[0].get("years");
      days = snap.docs[0].get("days");
      fee = snap.docs[0].get("fee");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1 * SizeConfig.heightMultiplier),
      child: Container(
        height: 19 * SizeConfig.heightMultiplier,
        width: 95 * SizeConfig.widthMultiplier,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(2, 3),
              spreadRadius: 0.5,
              blurRadius: 2,
              color: Colors.black.withOpacity(0.3),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 1 * SizeConfig.heightMultiplier,
                left: 1 * SizeConfig.widthMultiplier,
              ),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => DoctorProfileScreen(
                      imageUrl: widget.imageUrl,
                      doctorsName: widget.doctorsName,
                      speciality: widget.speciality,
                      hospital: widget.hospital,
                      reviews: widget.reviews,
                      uid: widget.uid,
                      doctorsAge: age,
                      phone: phone,
                      hours: hours,
                      patients: patients,
                      experience: experience,
                      doctorsEmail: email,
                      about: about,
                      days: days,
                      fee: fee,
                    ),
                ),),
                child: Container(
                  height: 20 * SizeConfig.heightMultiplier,
                  width: 92 * SizeConfig.widthMultiplier,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 12 * SizeConfig.heightMultiplier,
                            width: 24 * SizeConfig.widthMultiplier,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                            ),
                            child: Stack(
                              children: <Widget>[
                                ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedImage(
                                  imageUrl: widget.imageUrl,
                                  isRound: true,
                                  radius: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                                Positioned(
                                  right: 0, bottom: 0,
                                  child: OnlineIndicator(
                                    uid: widget.uid,
                                    isDoctor: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                          Container(
                            height: 12 * SizeConfig.heightMultiplier,
                            width: 67 * SizeConfig.widthMultiplier,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 4 * SizeConfig.heightMultiplier,
                                      width: 57 * SizeConfig.widthMultiplier,
                                      child: Text("Dr. " + widget.doctorsName, style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Brand Bold",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 2.7 * SizeConfig.textMultiplier,
                                        decoration: TextDecoration.none,
                                      ), overflow: TextOverflow.ellipsis,),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                                Container(
                                  height: 7 * SizeConfig.heightMultiplier,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      iconLabel(
                                        icon: FontAwesomeIcons.hospital,
                                        hospital: widget.hospital,
                                      ),
                                      iconLabel(
                                        icon: FontAwesomeIcons.stethoscope,
                                        hospital: widget.speciality,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                            height: 6 * SizeConfig.heightMultiplier,
                            width: 92 * SizeConfig.widthMultiplier,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                getReviews(widget.reviews, ""),
                                Container(
                                  width: 45 * SizeConfig.widthMultiplier,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        RaisedButton(
                                          padding: EdgeInsets.all(0),
                                          color: Colors.white,
                                          elevation: 8,
                                          splashColor: Colors.red[200],
                                          highlightColor: Colors.grey.withOpacity(0.1),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
                                          onPressed: () {
                                            int idx = hours.indexOf(":");
                                            String time = hours.substring(0, idx+1).trim();
                                            Navigator.push(
                                                context, MaterialPageRoute(
                                                builder: (context) => BookAppointmentScreen(
                                                  time: time,
                                                  doctorsName: widget.doctorsName,
                                                  hospital: widget.hospital,
                                                  type: widget.speciality,
                                                )));
                                          },
                                          child: Container(
                                            height: 4 * SizeConfig.heightMultiplier,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 8,
                                              ),
                                              child: Text("Book Appointment", style: TextStyle(
                                                fontFamily: "Brand Bold",
                                                color: Colors.red[300],
                                                fontSize: 2 * SizeConfig.textMultiplier,
                                              ),)
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            showDialog(
                                              context: context,
                                              builder: (context) => ProgressDialog(message: "Please wait...",),
                                            );
                                            await Permissions.cameraAndMicrophonePermissionsGranted() ?
                                            goToVideoChat(databaseMethods, widget.doctorsName, context, false) : {};
                                          },
                                          child: Container(
                                            height: 5 * SizeConfig.heightMultiplier,
                                            width: 10 * SizeConfig.widthMultiplier,
                                            decoration: BoxDecoration(
                                                color: Colors.red[300],
                                                boxShadow: [
                                                  BoxShadow(
                                                    offset: Offset(2, 3),
                                                    spreadRadius: 0.5,
                                                    blurRadius: 2,
                                                    color: Colors.black.withOpacity(0.3),
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.circular(50)
                                            ),
                                            child: Center(
                                              child: Icon(
                                                CupertinoIcons.video_camera,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget iconLabel({String hospital, IconData icon}) {
  return Container(
    width: 22 * SizeConfig.widthMultiplier,
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: Colors.grey,
            size: 6 * SizeConfig.imageSizeMultiplier,
          ),
          Text(
            hospital,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Brand-Regular",
              fontSize: 1.5 * SizeConfig.textMultiplier,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    ),
  );
}

Future<dynamic> profilePicView({String imageUrl, BuildContext context, bool isSender, String chatRoomId, bool isUser, bool isDoctor}) {
  return showDialog(
    context: context,
    builder: (context) => Padding(
      padding: EdgeInsets.only(top: 100, left: 50, right: 50, bottom: 350),
      child: Builder(
        builder: (context) => Container(
          height: 10 * SizeConfig.heightMultiplier,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoViewPage(
                          message: imageUrl,
                          isSender: isSender,
                          chatRoomId: chatRoomId,
                        ),
                      ));
                },
                child: CachedImage(
                  height: 33 * SizeConfig.heightMultiplier,
                  width: 90 * SizeConfig.widthMultiplier,
                  imageUrl: imageUrl,
                  radius: 10,
                  fit: BoxFit.cover,
                ),
              ),
              Spacer(),
              isUser == true
                  ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4 * SizeConfig.widthMultiplier),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child:FocusedMenuHolder(
                          blurSize: 0,
                          duration: Duration(milliseconds: 500),
                          menuWidth: MediaQuery.of(context).size.width * 0.3,
                          menuItemExtent: 40,
                          onPressed: () {
                            displayToastMessage("Tap & Hold to make selection", context);
                          },
                          menuItems: <FocusedMenuItem>[
                            FocusedMenuItem(title: Text("Gallery", style: TextStyle(
                                color: Colors.red[300], fontWeight: FontWeight.w500),),
                              onPressed: () async =>
                              await Permissions.cameraAndMicrophonePermissionsGranted() ?
                              pickImage(
                                  source: ImageSource.gallery,
                                  context: context,
                                  databaseMethods: databaseMethods).then((val) async{
                                String profilePic = val;
                                  if (isDoctor == true) {
                                    if (profilePic == null || profilePic == "") {} else {
                                      await databaseMethods.updateDoctorDocField({"profile_photo": profilePic}, currentUser.uid);
                                      Navigator.pop(context);
                                      displaySnackBar(message: "Changes will be seen next time you open the app", label: "OK", context: context);
                                    }
                                  } else {
                                    if (profilePic == null || profilePic == "") {} else {
                                      await databaseMethods.updateUserDocField({"profile_photo": profilePic}, currentUser.uid);
                                      Navigator.pop(context);
                                      displaySnackBar(message: "Changes will be seen next time you open the app", label: "OK", context: context);
                                    }
                                  }
                              }) : {},
                              trailingIcon: Icon(Icons.photo_library_outlined, color: Colors.red[300],),
                            ),
                            FocusedMenuItem(title: Text("Capture", style: TextStyle(
                                color: Colors.red[300], fontWeight: FontWeight.w500),),
                              onPressed: () async =>
                              await Permissions.cameraAndMicrophonePermissionsGranted() ?
                              pickImage(
                                  source: ImageSource.camera,
                                  context: context,
                                  databaseMethods: databaseMethods).then((val) async {
                                    String profilePic = val;
                                      if (isDoctor == true) {
                                        if (profilePic == null || profilePic == "") {} else {
                                          await databaseMethods.updateDoctorDocField({"profile_photo": profilePic}, currentUser.uid);
                                          Navigator.pop(context);
                                          displaySnackBar(message: "Changes will be seen next time you open the app", label: "OK", context: context);
                                        }
                                      } else {
                                        if (profilePic == null || profilePic == "") {} else {
                                          await databaseMethods.updateUserDocField({"profile_photo": profilePic}, currentUser.uid);
                                          Navigator.pop(context);
                                          displaySnackBar(message: "Changes will be seen next time you open the app", label: "OK", context: context);
                                        }
                                      }
                              }) : {},
                              trailingIcon: Icon(Icons.camera, color: Colors.red[300],),
                            ),
                          ],
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            child: Row(
                              children: <Widget>[
                                Icon(CupertinoIcons.pencil, color: Colors.red[300],),
                                Text("Edit Profile Picture", style: TextStyle(
                                  fontFamily: "Brand Bold",
                                  color: Colors.red[300],
                                ),),
                              ],
                            ),
                          ),
                        ),
                      ),
                  Image(
                    image: AssetImage("images/logo.png"),
                    width: 12 * SizeConfig.widthMultiplier,
                    height: 5 * SizeConfig.heightMultiplier,
                  ),
                ],
              ),
                  ) :
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4 * SizeConfig.widthMultiplier),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Icon(Icons.message_rounded, color: Colors.red[300],),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ConversationScreen(
                            isDoctor: isDoctor,
                            chatRoomId: chatRoomId,
                            userName: chatRoomId.replaceAll("_", "").replaceAll(Constants.myName, ""),
                            profilePhoto: imageUrl,
                          )),
                      );
                    },
                  ),
                  GestureDetector(
                    child: Icon(Icons.call_rounded, color: Colors.red[300],),
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (context) => ProgressDialog(message: "Please wait...",),
                      );
                      await Permissions.cameraAndMicrophonePermissionsGranted() ?
                      goToVoiceCall(databaseMethods, chatRoomId.replaceAll("_", "").replaceAll(Constants.myName, ""), context, isDoctor) : {};
                    },
                  ),
                  GestureDetector(
                    child: Icon(Icons.videocam_rounded, color: Colors.red[300],),
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (context) => ProgressDialog(message: "Please wait...",),
                      );
                      await Permissions.cameraAndMicrophonePermissionsGranted() ?
                      goToVideoChat(databaseMethods, chatRoomId.replaceAll("_", "").replaceAll(Constants.myName, ""), context, isDoctor) : {};
                    },
                  ),
                  Image(
                    image: AssetImage("images/logo.png"),
                    width: 12 * SizeConfig.widthMultiplier,
                    height: 5 * SizeConfig.heightMultiplier,
                  ),
                ],
              ),
                  ),
              Spacer(),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget custTile({String image, String title, String doctors, Function onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 8 * SizeConfig.heightMultiplier,
      width: 26.5 * SizeConfig.widthMultiplier,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(1, 2),
            spreadRadius: 0.5,
            blurRadius: 2,
            color: Colors.black.withOpacity(0.1),
          ),
        ],

        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: 8 * SizeConfig.heightMultiplier,
            width: 7 * SizeConfig.widthMultiplier,
            child: Padding(
              padding: EdgeInsets.all(2),
              child: Image.asset(image,
                color: Colors.black54,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
            child: Container(
              height: 8 * SizeConfig.heightMultiplier,
              width: 17 * SizeConfig.widthMultiplier,
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 2 * SizeConfig.heightMultiplier,
                        width: 17 * SizeConfig.widthMultiplier,
                        child: Text(title, style: TextStyle(
                            fontSize: 2 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Brand Bold",
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 1 * SizeConfig.heightMultiplier,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 2 * SizeConfig.heightMultiplier,
                        width: 17 * SizeConfig.widthMultiplier,
                        child: Text(doctors + " Doctor(s)", style: TextStyle(
                            fontSize: 1.5 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Band-Regular",
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    ),
  );
}

Widget customAccessB({
  String image,
  String size,
  IconData icon,
  String title1,
  String title2,
  Function onTap,
  Color color}) {

  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: size == "medium"
          ? 22 * SizeConfig.heightMultiplier
          : 14 * SizeConfig.heightMultiplier,
      width: size == "medium"
          ? 30 * SizeConfig.widthMultiplier
          : 20 * SizeConfig.widthMultiplier,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              height: size == "medium"
                  ? 14 * SizeConfig.heightMultiplier
                  : 8 * SizeConfig.heightMultiplier,
              width: size == "medium"
                  ? 28 * SizeConfig.widthMultiplier
                  : 16 * SizeConfig.widthMultiplier,
              decoration: BoxDecoration(
                color: color,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(2, 2),
                    spreadRadius: 0.5,
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
                borderRadius: BorderRadius.circular(
                    size == "medium"
                        ? 60
                        : 45
                ),
              ),
              child: icon != null
                  ? Icon(
                      icon,
                      color: size == "medium" ? Colors.white : Colors.black54,
                      size: size == "medium"
                          ? 20 * SizeConfig.imageSizeMultiplier
                          : 10 * SizeConfig.imageSizeMultiplier,
                    )
                  : color != Colors.transparent
                      ? Padding(
                          padding: EdgeInsets.all(
                              size == "medium"
                                  ? 18
                                  : 12
                          ),
                          child: Image.asset(image,
                            color: size == "medium" ? Colors.white : Colors.red[300],
                          ),
                        )
                      : Image.asset(image),
            ),
            SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
            Text(title1, style: TextStyle(
              fontFamily: size == "medium" ? "Brand Bold" : "Brand-Regular",
                color: size == "medium" ? color : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: size == "medium"
                    ? 2.3 * SizeConfig.textMultiplier
                    : 1.5 * SizeConfig.textMultiplier,
              ),),
            title2 != null
                ? Text(title2, style: TextStyle(
              fontFamily: size == "medium" ? "Brand Bold" : "Brand-Regular",
              color: size == "medium" ? color : Colors.black,
                fontWeight: FontWeight.w500,
              fontSize: size == "medium"
                  ? 2.3 * SizeConfig.textMultiplier
                  : 1.5 * SizeConfig.textMultiplier,
              ),) : Container(),
          ],
        ),
      ),
    ),
  );
}
