import 'package:cloud_firestore/cloud_firestore.dart';
/*
* Created by Mujuzi Moses
*/

class Activity {
  String type;
  FieldValue createdAt;
  Timestamp appTime;
  Timestamp eventDate;
  String eventTitle;
  String postHeading;
  String fromLocation;
  String toHospital;
  String postType;
  String callType;
  String messageType;
  String reminderType;
  String receiver;
  String editType;
  String buyType;
  String savedType;
  String drugName;
  String patientName;
  String user;
  String cycle;
  String howLong;
  List drugNames;

  Activity.saveActivity({this.type, this.createdAt, this.savedType, this.patientName,});

  Activity.messageActivity({this.type, this.createdAt, this.messageType, this.receiver,});

  Activity.callActivity({this.type, this.createdAt, this.callType, this.receiver,});

  Activity.buyActivity({this.type, this.createdAt, this.buyType, this.drugName, this.drugNames,});

  Activity.editActivity({this.type, this.createdAt, this.editType,});

  Activity.requestActivity({this.type, this.createdAt, this.fromLocation, this.toHospital});

  Activity.postActivity({this.type, this.createdAt, this.postHeading, this.postType});

  Activity.evtReminderActivity({this.type, this.createdAt, this.reminderType, this.eventDate, this.eventTitle,});

  Activity.appReminderActivity({this.type, this.createdAt, this.reminderType, this.appTime,this.user,});

  Activity.medReminderActivity({this.type, this.createdAt, this.reminderType, this.cycle, this.howLong, this.drugName,});

  Map toRequestActivity(Activity activity) {
    Map<String, dynamic> activityMap = Map();
    activityMap["created_at"] = activity.createdAt;
    activityMap["type"] = activity.type;
    activityMap["from_location"] = activity.fromLocation;
    activityMap["to_hospital"] = activity.toHospital;

    return activityMap;
  }

  Map toSaveActivity(Activity activity) {
    Map<String, dynamic> activityMap = Map();
    activityMap["created_at"] = activity.createdAt;
    activityMap["type"] = activity.type;
    activityMap["saved_type"] = activity.savedType;
    activityMap["patient_name"] = activity.patientName;

    return activityMap;
  }

  Map toMessageActivity(Activity activity) {
    Map<String, dynamic> activityMap = Map();
    activityMap["created_at"] = activity.createdAt;
    activityMap["type"] = activity.type;
    activityMap["message_type"] = activity.messageType;
    activityMap["receiver"] = activity.receiver;

    return activityMap;
  }

  Map toCallActivity(Activity activity) {
    Map<String, dynamic> activityMap = Map();
    activityMap["created_at"] = activity.createdAt;
    activityMap["type"] = activity.type;
    activityMap["call_type"] = activity.callType;
    activityMap["receiver"] = activity.receiver;

    return activityMap;
  }

  Map toBuyActivity(Activity activity) {
    Map<String, dynamic> activityMap = Map();
    activityMap["created_at"] = activity.createdAt;
    activityMap["type"] = activity.type;
    activityMap["buy_type"] = activity.buyType;
    activityMap["name"] = activity.drugName;
    activityMap["names"] = activity.drugNames;

    return activityMap;
  }

  Map toEditActivity(Activity activity) {
    Map<String, dynamic> activityMap = Map();
    activityMap["created_at"] = activity.createdAt;
    activityMap["type"] = activity.type;
    activityMap["edit_type"] = activity.editType;

    return activityMap;
  }

  Map toPostActivity(Activity activity) {
    Map<String, dynamic> activityMap = Map();
    activityMap["created_at"] = activity.createdAt;
    activityMap["type"] = activity.type;
    activityMap["post_heading"] = activity.postHeading;
    activityMap["post_type"] = activity.postType;

    return activityMap;
  }

  Map toEvtReminderActivity(Activity activity) {
    Map<String, dynamic> activityMap = Map();
    activityMap["created_at"] = activity.createdAt;
    activityMap["event_date"] = activity.eventDate;
    activityMap["event_title"] = activity.eventTitle;
    activityMap["reminder_type"] = activity.reminderType;
    activityMap["type"] = activity.type;

    return activityMap;
  }

  Map toMedReminderActivity(Activity activity) {
    Map<String, dynamic> activityMap = Map();
    activityMap["created_at"] = activity.createdAt;
    activityMap["cycle"] = activity.cycle;
    activityMap["how_long"] = activity.howLong;
    activityMap["name"] = activity.drugName;
    activityMap["reminder_type"] = activity.reminderType;
    activityMap["type"] = activity.type;

    return activityMap;
  }

  Map toAppReminderActivity(Activity activity) {
    Map<String, dynamic> activityMap = Map();
    activityMap["app_time"] = activity.appTime;
    activityMap["created_at"] = activity.createdAt;
    activityMap["reminder_type"] = activity.reminderType;
    activityMap["type"] = activity.type;
    activityMap["user"] = activity.user;

    return activityMap;
  }

}