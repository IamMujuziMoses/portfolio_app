import 'package:cloud_firestore/cloud_firestore.dart';
/*
* Created by Mujuzi Moses
*/

class Notification{
  FieldValue createdAt;
  String cycle;
  String dosage;
  String drugName;
  String howLong;
  String onceTime;
  String period;
  String type;

  Notification.newPost({this.createdAt, this.type,
  });
  Notification.newAlert({this.createdAt, this.type,
  });
  Notification.newAppointment({this.createdAt, this.type,
  });
  Notification.newEvent({this.createdAt, this.type,
  });
  Notification.newMedReminder({this.createdAt, this.type, this.cycle, this.dosage, this.drugName, this.howLong,
    this.onceTime, this.period,
  });

  Map toMedReminder(Notification notification) {
    Map<String, dynamic> notificationMap = Map();
    notificationMap["created_at"] = notification.createdAt;
    notificationMap["type"] = notification.type;
    notificationMap["cycle"] = notification.cycle;
    notificationMap["dosage"] = notification.dosage;
    notificationMap["drug_name"] = notification.drugName;
    notificationMap["how_long"] = notification.howLong;
    notificationMap["once_time"] = notification.onceTime;
    notificationMap["period"] = notification.period;

    return notificationMap;
  }

}