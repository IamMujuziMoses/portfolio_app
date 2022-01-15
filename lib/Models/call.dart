import 'package:cloud_firestore/cloud_firestore.dart';
/*
* Created by Mujuzi Moses
*/

class Records{
  String callerId;
  String callerPic;
  String receiverId;
  String receiverPic;
  String createdBy;
  String chatRoomId;
  List<String> users;
  FieldValue time;
  bool isVoiceCall;

  Records({
    this.callerId, this.callerPic, this.receiverId, this.receiverPic, this.isVoiceCall,
    this.time, this.users, this.createdBy, this.chatRoomId,
  });

  Map<String, dynamic> toMap(Records records) {
    Map<String, dynamic> recordsMap = Map();
    recordsMap["caller_id"] = records.callerId;
    recordsMap["users"] = records.users;
    recordsMap["createdBy"] = records.createdBy;
    recordsMap["chatroomId"] = records.chatRoomId;
    recordsMap["caller_pic"] = records.callerPic;
    recordsMap["receiver_id"] = records.receiverId;
    recordsMap["receiver_pic"] = records.receiverPic;
    recordsMap["call_time"] = records.time;
    recordsMap["is_voice_call"] = records.isVoiceCall;

    return recordsMap;
  }

  Records.fromMap(Map recordsMap) {
    this.callerId = recordsMap["caller_id"];
    this.callerPic = recordsMap["caller_pic"];
    this.receiverId = recordsMap["receiver_id"];
    this.users = recordsMap["users"];
    this.createdBy = recordsMap["createdBy"];
    this.chatRoomId = recordsMap["chatroomId"];
    this.receiverPic = recordsMap["receiver_pic"];
    this.time = recordsMap["call_time"];
    this.isVoiceCall = recordsMap["is_voice_call"];
  }
}

class Call{
  String callerId;
  String callerName;
  String callerPic;
  String receiverId;
  String receiverName;
  String receiverPic;
  String channelId;
  String token;
  bool hasDialled;
  bool isVoiceCall;

  Call({
    this.callerId, this.callerName, this.callerPic, this.receiverId, this.receiverName, this.receiverPic,
    this.channelId, this.hasDialled, this.isVoiceCall, this.token,
  });

  Map<String, dynamic> toMap(Call call) {
    Map<String, dynamic> callMap = Map();
    callMap["caller_id"] = call.callerId;
    callMap["caller_name"] = call.callerName;
    callMap["caller_pic"] = call.callerPic;
    callMap["receiver_id"] = call.receiverId;
    callMap["receiver_name"] = call.receiverName;
    callMap["receiver_pic"] = call.receiverPic;
    callMap["token"] = call.token;
    callMap["channel_id"] = call.channelId;
    callMap["has_dialled"] = call.hasDialled;
    callMap["is_voice_call"] = call.isVoiceCall;

    return callMap;
  }

  Call.fromMap(Map callMap) {
    this.callerId = callMap["caller_id"];
    this.callerName = callMap["caller_name"];
    this.callerPic = callMap["caller_pic"];
    this.receiverId = callMap["receiver_id"];
    this.receiverName = callMap["receiver_name"];
    this.token = callMap["token"];
    this.receiverPic = callMap["receiver_pic"];
    this.channelId = callMap["channel_id"];
    this.hasDialled = callMap["has_dialled"];
    this.isVoiceCall = callMap["is_voice_call"];

  }
}