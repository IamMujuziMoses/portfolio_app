import 'dart:io';

import 'package:portfolio_app/AllScreens/Chat/chatSearch.dart';
import 'package:portfolio_app/constants.dart';
import 'package:portfolio_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
/*
* Created by Mujuzi Moses
*/

class PushNotificationServices{
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  showNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecs = AndroidNotificationDetails(
      "Siro", "Siro", "Channel for new message notification",
      icon: "launch_image",
      priority: Priority.High,
      importance: Importance.Max,
      largeIcon: DrawableResourceAndroidBitmap("launch_image"),
    );

    var iosPlatformChannelSpecs = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platformChannelSpecs = NotificationDetails(
      androidPlatformChannelSpecs, iosPlatformChannelSpecs,
    );
    String fromUserName = "";
    String sendToDocStr;
    bool sendToDoc;
    if (Platform.isAndroid) {
      sendToDocStr = message['data']['send_to_doctor'];
      if (sendToDocStr == "true") {
        sendToDoc = true;
      } else {
        sendToDoc = false;
      }
      fromUserName = message['data']['sender_name'];
    } else {
      sendToDoc = message['send_to_doctor'];
      fromUserName = message['sender_name'];
    }
    await notificationsPlugin.show(
      0, "Siro Message", "You have a new message from ${sendToDoc == true ? fromUserName : "Dr. $fromUserName"}",
      platformChannelSpecs,
    );
  }

  Future initialize(BuildContext context) async {

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        showNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
      },
    );
  }

  Future<String> getToken(bool isDoctor) async {
    String token = await firebaseMessaging.getToken();
    if (isDoctor == true) {
      await databaseMethods.updateDoctorDocField({"token": token}, currentUser.uid);
      firebaseMessaging.subscribeToTopic("allDoctors");
    } else {
      await databaseMethods.updateUserDocField({"token": token}, currentUser.uid);
      firebaseMessaging.subscribeToTopic("allUsers");
    }
  }

}