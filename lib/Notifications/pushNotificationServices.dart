import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
/*
* Created by Mujuzi Moses
*/

class PushNotificationServices{
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  Future initialize(BuildContext context) async {

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {},
      onLaunch: (Map<String, dynamic> message) async {},
      onResume: (Map<String, dynamic> message) async {},
    );
  }

  Future<String> getToken() async {
    String token = await firebaseMessaging.getToken();

    print("This is Token ::: $token");
    return token;
  }

}