import 'package:portfolio_app/AllScreens/Chat/chatScreen.dart';
import 'package:portfolio_app/AllScreens/specialityScreen.dart';
import 'package:portfolio_app/AllScreens/bookAppointmentScreen.dart';
import 'package:portfolio_app/AllScreens/doctorProfileScreen.dart';
import 'package:portfolio_app/AllScreens/findADoctorScreen.dart';
import 'package:portfolio_app/AllScreens/loginScreen.dart';
import 'package:portfolio_app/AllScreens/mainScreen.dart';
import 'package:portfolio_app/AllScreens/registerScreen.dart';
import 'package:portfolio_app/AllScreens/reviewsScreen.dart';
import 'package:portfolio_app/AllScreens/userAccount.dart';
import 'package:portfolio_app/AllScreens/userProfileScreen.dart';
import 'package:portfolio_app/Doctor/doctorAccount.dart';
import 'package:portfolio_app/Doctor/doctorProfile.dart';
import 'package:portfolio_app/Doctor/doctorRegistration.dart';
import 'package:portfolio_app/Widgets/customBottomNavBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
/*
* Created by Mujuzi Moses
*/

final Map<String, WidgetBuilder> routes = {
  RegisterScreen.screenId: (context) => RegisterScreen(),
  UserAccount.screenId: (context) => UserAccount(),
  CustomBottomNavBar.screenId: (context) => CustomBottomNavBar(),
  MainScreen.screenId: (context) => MainScreen(),
  LoginScreen.screenId: (context) => LoginScreen(),
  UserProfileScreen.screenId: (context) => UserProfileScreen(),
  DoctorProfileScreen.screenId : (context) => DoctorProfileScreen(),
  DoctorProfile.screenId : (context) => DoctorProfile(),
  DoctorAccount.screenId : (context) => DoctorAccount(),
  DoctorRegistration.screenId : (context) => DoctorRegistration(),
  FindADoctorScreen.screenId: (context) => FindADoctorScreen(),
  SpecialityScreen.screenId: (context) => SpecialityScreen(),
  BookAppointmentScreen.screenId: (context) => BookAppointmentScreen(),
  ChatScreen.screenId: (context) => ChatScreen(),
  ReviewsScreen.screenId: (context) => ReviewsScreen(),
};