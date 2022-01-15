import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFa81845), Color(0xFF851699),],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
const kAnimationDuration = Duration(milliseconds: 200);

const UNKNOWN_ERROR = 'Unknown error occurred';

const NO_INTERNET_CONNECTION = 'No internet connection';

const CAN_NOT_REACH_SERVER = 'Failed to reach server';

class Constants{
  static String myName = "";
  static String profilePhoto = "";

  static String myEmail = "";
}