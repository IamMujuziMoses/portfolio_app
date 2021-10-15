import 'dart:math';

import 'package:creativedata_app/AllScreens/Chat/voiceCallScreen.dart';
import 'package:creativedata_app/AllScreens/VideoChat/callScreen.dart';
import 'package:creativedata_app/Models/call.dart';
import 'package:creativedata_app/Models/doctor.dart';
import 'package:creativedata_app/Models/user.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class CallUtils{

  static final DatabaseMethods databaseMethods = new DatabaseMethods();

  static videoDialUser(User from, Doctor to, context) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      isVoiceCall: false,
      // TODO Create a more robust randomly generated alpha-numeric String
      channelId: Random().nextInt(1000).toString(),
    );

   bool callMade = await databaseMethods.makeCall(call: call);
    call.hasDialled = true;

    Navigator.pop(context);
    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(call: call, isDoctor: false,),
        ),
      );
    }
  }

  static voiceDialUser(User from, Doctor to, context) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      isVoiceCall: true,
      // TODO Create a more robust randomly generated alpha-numeric String
      channelId: Random().nextInt(1000).toString(),
    );

   bool callMade = await databaseMethods.makeCall(call: call);
    call.hasDialled = true;

    Navigator.pop(context);
    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VoiceCallScreen(call: call, isDoctor: false,),
        ),
      );
    }
  }

  static videoDialDoctor(Doctor from, User to, context) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      isVoiceCall: false,
      // TODO Create a more robust randomly generated alpha-numeric String
      channelId: Random().nextInt(1000).toString(),
    );

   bool callMade = await databaseMethods.makeCall(call: call);
    call.hasDialled = true;

    Navigator.pop(context);
    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(call: call, isDoctor: true,),
        ),
      );
    }
  }

  static voiceDialDoctor(Doctor from, User to, context) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      isVoiceCall: true,
      // TODO Create a more robust randomly generated alpha-numeric String
      channelId: Random().nextInt(1000).toString(),
    );

   bool callMade = await databaseMethods.makeCall(call: call);
    call.hasDialled = true;

    Navigator.pop(context);
    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VoiceCallScreen(call: call, isDoctor: true,),
        ),
      );
    }
  }
}