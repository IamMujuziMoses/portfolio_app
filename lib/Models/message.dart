import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
/*
* Created by Mujuzi Moses
*/

class Message{

  String message;
  String sendBy;
  FieldValue time;
  String type;
  String photoUrl;
  Uint8List thumbnail;
  String size;
  String videoUrl;
  String audioUrl;
  String docUrl;

  Message({this.message, this.sendBy, this.time, this.type});

  Message.imageMessage({this.message, this.sendBy, this.time, this.type, this.photoUrl, this.size,});

  Message.videoMessage({this.message, this.sendBy, this.time, this.type, this.videoUrl, this.thumbnail, this.size});

  Message.audioMessage({this.message, this.sendBy, this.time, this.type, this.audioUrl, this.size,});

  Message.documentMessage({this.message, this.sendBy, this.time, this.type, this.docUrl, this.size,});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['message'] = this.message;
    map['sendBy'] = this.sendBy;
    map['time'] = this.time;
    map['type'] = this.type;
    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['message'] = this.message;
    map['sendBy'] = this.sendBy;
    map['size'] = this.size;
    map['time'] = this.time;
    map['type'] = this.type;
    map['photoUrl'] = this.photoUrl;
    return map;
  }

  Map toVideoMap() {
    var map = Map<String, dynamic>();
    map['message'] = this.message;
    map['sendBy'] = this.sendBy;
    map['time'] = this.time;
    map['type'] = this.type;
    map['videoUrl'] = this.videoUrl;
    map['thumbnail'] = this.thumbnail;
    map['size'] = this.size;
    return map;
  }

  Map toAudioMap() {
    var map = Map<String, dynamic>();
    map['message'] = this.message;
    map['sendBy'] = this.sendBy;
    map['time'] = this.time;
    map['type'] = this.type;
    map['audioUrl'] = this.audioUrl;
    map['size'] = this.size;
    return map;
  }

  Map toDocumentMap() {
    var map = Map<String, dynamic>();
    map['message'] = this.message;
    map['sendBy'] = this.sendBy;
    map['time'] = this.time;
    map['type'] = this.type;
    map['docUrl'] = this.docUrl;
    map['size'] = this.size;
    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    this.message = map['message'];
    this.sendBy = map['sendBy'];
    this.time = map['time'];
    this.type = map['type'];
    this.photoUrl = map['photoUrl'];
    this.videoUrl = map['videoUrl'];
  }

  Message.fromMapLM(Map<String, dynamic> map) {
    this.message = map['message'];
    this.sendBy = map['sendBy'];
    this.type = map['type'];
    this.photoUrl = map['photoUrl'];
    this.videoUrl = map['videoUrl'];
  }

}