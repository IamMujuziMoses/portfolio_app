import 'package:creativedata_app/AllScreens/Chat/voiceCallScreen.dart';
import 'package:creativedata_app/AllScreens/VideoChat/callScreen.dart';
import 'package:creativedata_app/Models/call.dart';
import 'package:creativedata_app/Models/doctor.dart';
import 'package:creativedata_app/Models/user.dart';
import 'package:creativedata_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
/*
* Created by Mujuzi Moses
*/

class CallUtils{

  static videoDialUser(User from, Doctor to, context) async {
    String channelId = randomAlphaNumeric(25);
    String token = await getToken(channelId);

    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      isVoiceCall: false,
      token: token,
      channelId: channelId,
    );

   bool callMade = await databaseMethods.makeCall(call: call);
    call.hasDialled = true;

    Navigator.pop(context);
    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(isReceiving: false, call: call, isDoctor: false,),
        ),
      );
    }
  }

  static Future<String> getToken(channelName) async {
    //String baseUrl = "http://10.0.2.2:8082"; // testing emulator
    // String baseUrl = "http://192.168.43.73:8082"; // testing phone
    String baseUrl = "https://server-ksnvexj7ta-uc.a.run.app";
    int uid = 0;
    String token;
    final response = await http.post(
      Uri.parse(baseUrl + '/rtc/' + channelName + '/publisher/' + uid.toString()),
    );

    if (response.statusCode == 200) {
      token = convert.jsonDecode(response.body)['token'];
      return token;
    } else {
      print("Failed to fetch the Token ::: ${response.statusCode}");
      return null;
    }
  }

  static voiceDialUser(User from, Doctor to, context) async {
    String channelId = randomAlphaNumeric(25);
    String token = await getToken(channelId);

    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      token: token,
      isVoiceCall: true,
      channelId: channelId,
    );

   bool callMade = await databaseMethods.makeCall(call: call);
    call.hasDialled = true;

    Navigator.pop(context);
    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VoiceCallScreen(isReceiving: false, call: call, isDoctor: false,),
        ),
      );
    }
  }

  static videoDialDoctor(Doctor from, User to, context) async {
    String channelId = randomAlphaNumeric(25);
    String token = await getToken(channelId);

    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      isVoiceCall: false,
      token: token,
      channelId: channelId,
    );

   bool callMade = await databaseMethods.makeCall(call: call);
    call.hasDialled = true;

    Navigator.pop(context);
    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(isReceiving: false, call: call, isDoctor: true,),
        ),
      );
    }
  }
  
  static voiceDialDoctor(Doctor from, User to, context) async {
    String channelId = randomAlphaNumeric(25);
    String token = await getToken(channelId);

    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      isVoiceCall: true,
      token: token,
      channelId: channelId,
    );

   bool callMade = await databaseMethods.makeCall(call: call);
    call.hasDialled = true;

    Navigator.pop(context);
    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VoiceCallScreen(isReceiving: false, call: call, isDoctor: true,),
        ),
      );
    }
  }
}