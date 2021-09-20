import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/chatScreen.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/allCallsScreen.dart';
import 'package:creativedata_app/AllScreens/userAccount.dart';
import 'package:creativedata_app/AllScreens/userProfileScreen.dart';
import 'package:creativedata_app/Doctor/doctorAccount.dart';
import 'package:creativedata_app/Doctor/doctorProfile.dart';
import 'package:creativedata_app/Enum/userState.dart';
import 'package:creativedata_app/Provider/userProvider.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
/*
* Created by Mujuzi Moses
*/

class CustomBottomNavBar extends StatefulWidget {
  static const String screenId = "customBottomNavBar";
  final bool isDoctor;
  const CustomBottomNavBar({Key key, this.isDoctor}) : super(key: key);

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> with WidgetsBindingObserver {

  int _currentIndex = 0;
  UserProvider userProvider;
  DatabaseMethods databaseMethods = DatabaseMethods();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String regId = "";
  String name = "";
  String phone = "";
  String speciality = "";
  String userPic = "";
  String email = "";
  String about = "";
  String age = "";
  String hospital = "";
  String hours = "";
  String patients = "";
  String experience = "";
  String reviews = "100";
  Map fees = Map();
  List days = [];
  Stream callRecordsStream;
  Stream chatRoomStream;
  QuerySnapshot generalSnap;
  QuerySnapshot dentistSnap;
  QuerySnapshot cardiologySnap;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void getUserInfo() async {
    Constants.myName = await databaseMethods.getName();
    regId = await databaseMethods.getRegId();
    databaseMethods.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomStream = val;
      });
    });

    generalSnap = await databaseMethods.getAllDoctorsBySpecialitySnap("General Doctor");
    dentistSnap = await databaseMethods.getAllDoctorsBySpecialitySnap("Dentist");
    cardiologySnap = await databaseMethods.getAllDoctorsBySpecialitySnap("Cardiology");

    databaseMethods.getCallRecords(Constants.myName).then((val) {
      setState(() {
        callRecordsStream = val;
      });
    });
    databaseMethods.getPhone().then((val) {
      setState(() {
        phone = val;
      });
    });
    databaseMethods.getName().then((val) {
      setState(() {
        name = val;
      });
    });
    databaseMethods.getEmail().then((val) {
      setState(() {
        email = val;
      });
    });
    databaseMethods.getProfilePhoto().then((val) {
      setState(() {
        userPic = val;
      });
    });


    if (regId == "Doctor") {
      databaseMethods.getSpeciality().then((val) {
        setState(() {
          speciality = val;
        });
      });
      databaseMethods.getReviews().then((val) {
        setState(() {
          reviews = val;
        });
      });
      databaseMethods.getDays().then((val) {
        setState(() {
          days = val;
        });
      });
      databaseMethods.getFees().then((val) {
        setState(() {
          fees = val;
        });
      });
      databaseMethods.getAbout().then((val) {
        setState(() {
          about = val;
        });
      });
      databaseMethods.getDoctorsHospital().then((val) {
        setState(() {
          hospital = val;
        });
      });
      databaseMethods.getAge().then((val) {
        setState(() {
          age = val;
        });
      });
      databaseMethods.getPatients().then((val) {
        setState(() {
          patients = val;
        });
      });
      databaseMethods.getExperience().then((val) {
        setState(() {
          experience = val;
        });
      });
      databaseMethods.getHours().then((val) {
        setState(() {
          hours = val;
        });
      });
    }

    if (regId == "Doctor") {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.refreshDoctor();
        databaseMethods.setUserState(
          uid: firebaseAuth.currentUser.uid,
          userState: UserState.Online,
          isDoctor: true,
        );
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.refreshUser();
        databaseMethods.setUserState(
          uid: firebaseAuth.currentUser.uid,
          userState: UserState.Online,
          isDoctor: false,
        );
      });
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId = firebaseAuth.currentUser.uid;
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? databaseMethods.setUserState(
          uid: currentUserId,
          userState: UserState.Online,
          isDoctor: regId == "Doctor" ? true : false,)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? databaseMethods.setUserState(
          uid: currentUserId,
          userState: UserState.Offline,
          isDoctor: regId == "Doctor" ? true : false,)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? databaseMethods.setUserState(
            uid: currentUserId,
            userState: UserState.Waiting,
            isDoctor: regId == "Doctor" ? true : false,)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? databaseMethods.setUserState(
          uid: currentUserId,
          userState: UserState.Offline,
          isDoctor: regId == "Doctor" ? true : false,)
            : print("detached state");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> userChildren = [
      UserProfileScreen(name: name, userPic: userPic, email: email, phone : phone,
        cardiologySnap: cardiologySnap, generalSnap: generalSnap, dentistSnap: dentistSnap,),
      AllCallsScreen(isDoctor: widget.isDoctor, callRecordsStream: callRecordsStream,),
      ChatScreen(isDoctor: widget.isDoctor,),
      UserAccount(name: name, email: email, userPic: userPic, phone: phone),
    ];

    final List<Widget> doctorChildren = [
      DoctorProfile(name: name, speciality: speciality,
        userPic: userPic, email: email,),
      AllCallsScreen(isDoctor: widget.isDoctor, callRecordsStream: callRecordsStream,),
      ChatScreen(isDoctor: widget.isDoctor,),
      DoctorAccount(name: name, speciality: speciality, userPic: userPic, fees: fees,
        email: email, about: about, age: age, hospital: hospital, hours: hours, days: days,
        patients: patients, experience: experience, reviews: reviews, uid: firebaseAuth.currentUser.uid,
      ),
    ];

    SizeConfig().init(context);
    return widget.isDoctor == true
        ? bottomNavBar(child: doctorChildren, index: _currentIndex)
        : bottomNavBar(child: userChildren, index: _currentIndex);
  }

  Widget bottomNavBar({List<Widget> child, int index}) {
    return PickUpLayout(
      scaffold: Scaffold(
        body: child[index],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey[100],
          onTap: onTappedBar,
          elevation: 0,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500, fontFamily: "Brand Bold",
          ),
          selectedItemColor: Colors.red[300],
          currentIndex: index,
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house, color: Colors.red[300],),
              label: "Home",
              activeIcon: selectedIcon(CupertinoIcons.house_fill),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.call_outlined, color: Colors.red[300],),
              label: "Calls",
              activeIcon: selectedIcon(Icons.call),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined, color: Colors.red[300]),
              label: "Chat",
              activeIcon: selectedIcon(Icons.chat),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_circle, color: Colors.red[300]),
              label: "Profile",
              activeIcon: selectedIcon(CupertinoIcons.person_circle_fill),
            ),
          ],
        ),
      ),
    );
  }

  Widget selectedIcon(IconData icon) {
    return Container(
      height: 3.5 * SizeConfig.heightMultiplier,
      width: 28 * SizeConfig.widthMultiplier,
      decoration: BoxDecoration(
        color: Colors.red[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}