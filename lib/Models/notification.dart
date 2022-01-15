import 'package:cloud_firestore/cloud_firestore.dart';
/*
* Created by Mujuzi Moses
*/

class CustomNotification{
  FieldValue createdAt;
  String cycle;
  String eventTitle;
  String heading;
  String postText;
  String postHeading;
  String appType;
  String docName;
  String hospital;
  String name;
  String counter;
  Timestamp startTime;
  String from;
  String dosage;
  String drugName;
  String howLong;
  String type;
  String messageType;
  String senderPhoto;
  String senderName;
  String senderUid;
  String receiverPhoto;
  String receiverName;
  String receiverUid;

  CustomNotification.newPost({this.createdAt, this.type, this.postText, this.from, this.counter,
    this.postHeading, this.heading, this.eventTitle, this.drugName, this.appType,
  });

  CustomNotification.newAppointment({this.createdAt, this.type, this.appType, this.docName, this.name, this.startTime,
    this.hospital, this.postHeading, this.heading, this.eventTitle, this.drugName, this.counter,
  });

  CustomNotification.newMedReminder({this.createdAt, this.type, this.cycle, this.dosage, this.drugName, this.howLong,
    this.name, this.postHeading, this.heading, this.eventTitle, this.appType, this.counter,
  });

  CustomNotification.newMessage({this.createdAt, this.type, this.senderName, this.senderPhoto, this.senderUid,
    this.receiverName, this.receiverPhoto, this.receiverUid, this.messageType, this.counter,
  });

  Map toMessageNotification(CustomNotification notification) {
    Map<String, dynamic> notificationMap = Map();
    notificationMap["created_at"] = notification.createdAt;
    notificationMap["type"] = notification.type;
    notificationMap["sender_name"] = notification.senderName;
    notificationMap["sender_photo"] = notification.senderPhoto;
    notificationMap["sender_uid"] = notification.senderUid;
    notificationMap["counter"] = notification.counter;
    notificationMap["receiver_name"] = notification.receiverName;
    notificationMap["receiver_photo"] = notification.receiverPhoto;
    notificationMap["receiver_uid"] = notification.receiverUid;
    notificationMap["message_type"] = notification.messageType;

    return notificationMap;
  }

  Map toAppReminderNotification(CustomNotification notification) {
    Map<String, dynamic> notificationMap = Map();
    notificationMap["created_at"] = notification.createdAt;
    notificationMap["type"] = notification.type;
    notificationMap["doctors_name"] = notification.docName;
    notificationMap["post_heading"] = notification.postHeading;
    notificationMap["event_title"] = notification.eventTitle;
    notificationMap["drug_name"] = notification.drugName;
    notificationMap["heading"] = notification.heading;
    notificationMap["counter"] = notification.counter;
    notificationMap["app_type"] = notification.appType;
    notificationMap["hospital"] = notification.hospital;
    notificationMap["name"] = notification.name;
    notificationMap["start_time"] = notification.startTime;

    return notificationMap;
  }

  Map toPostNotification(CustomNotification notification) {
    Map<String, dynamic> notificationMap = Map();
    notificationMap["created_at"] = notification.createdAt;
    notificationMap["type"] = notification.type;
    notificationMap["post_text"] = notification.postText;
    notificationMap["post_heading"] = notification.postHeading;
    notificationMap["event_title"] = notification.eventTitle;
    notificationMap["drug_name"] = notification.drugName;
    notificationMap["heading"] = notification.heading;
    notificationMap["counter"] = notification.counter;
    notificationMap["app_type"] = notification.appType;
    notificationMap["from"] = notification.from;

    return notificationMap;
  }

  Map toMedReminderNotification(CustomNotification notification) {
    Map<String, dynamic> notificationMap = Map();
    notificationMap["created_at"] = notification.createdAt;
    notificationMap["type"] = notification.type;
    notificationMap["cycle"] = notification.cycle;
    notificationMap["dosage"] = notification.dosage;
    notificationMap["drug_name"] = notification.drugName;
    notificationMap["post_heading"] = notification.postHeading;
    notificationMap["event_title"] = notification.eventTitle;
    notificationMap["heading"] = notification.heading;
    notificationMap["app_type"] = notification.appType;
    notificationMap["counter"] = notification.counter;
    notificationMap["how_long"] = notification.howLong;
    notificationMap["user_name"] = notification.name;

    return notificationMap;
  }

}