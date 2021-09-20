import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class Reminder{
  String name;
  String speciality;
  Timestamp apTime;
  String hospital;
  String dosage;
  String tablets;
  String type;
  Timestamp date;
  String cycle;
  String howLong;
  String period;
  String onceTime;
  int id;
  List<int> idList;
  List<String> time;
  bool isOnce;
  FieldValue createdAt;

  Reminder({this.name, this.dosage, this.cycle, this.howLong, this.tablets, this.type,
    this.time, this.isOnce, this.createdAt, this.idList, this.date,
  });
  Reminder.onceReminder({this.name, this.dosage, this.cycle, this.howLong, this.tablets, this.type,
    this.period, this.onceTime, this.isOnce, this.createdAt, this.id, this.date,
  });
  Reminder.appointReminder({this.speciality, this.createdAt, this.apTime, this.name, this.hospital,
    this.type, this.howLong, this.id,
  });

  Map toAppointMap(Reminder reminder) {
    Map<String, dynamic> reminderMap = Map();
    reminderMap["speciality"] = reminder.speciality;
    reminderMap["created_at"] = reminder.createdAt;
    reminderMap["time"] = reminder.apTime;
    reminderMap["name"] = reminder.name;
    reminderMap["hospital"] = reminder.hospital;
    reminderMap["id"] = reminder.id;
    reminderMap["type"] = reminder.type;
    reminderMap["how_long"] = reminder.howLong;

    return reminderMap;
  }

  Map toMap(Reminder reminder) {
    Map<String, dynamic> reminderMap = Map();
    reminderMap["name"] = reminder.name;
    reminderMap["dosage"] = reminder.dosage;
    reminderMap["tablets"] = reminder.tablets;
    reminderMap["cycle"] = reminder.cycle;
    reminderMap["how_long"] = reminder.howLong;
    reminderMap["id_list"] = reminder.idList;
    reminderMap["date"] = reminder.date;
    reminderMap["time"] = reminder.time;
    reminderMap["isOnce"] = reminder.isOnce;
    reminderMap["created_at"] = reminder.createdAt;
    reminderMap["type"] = reminder.type;

    return reminderMap;
  }

  Map toOnceMap(Reminder reminder) {
    Map<String, dynamic> reminderMap = Map();
    reminderMap["name"] = reminder.name;
    reminderMap["dosage"] = reminder.dosage;
    reminderMap["tablets"] = reminder.tablets;
    reminderMap["cycle"] = reminder.cycle;
    reminderMap["how_long"] = reminder.howLong;
    reminderMap["type"] = reminder.type;
    reminderMap["period"] = reminder.period;
    reminderMap["id"] = reminder.id;
    reminderMap["date"] = reminder.date;
    reminderMap["once_time"] = reminder.onceTime;
    reminderMap["isOnce"] = reminder.isOnce;
    reminderMap["created_at"] = reminder.createdAt;

    return reminderMap;
  }
}