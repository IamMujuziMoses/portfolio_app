import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/Enum/userState.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:video_compress/video_compress.dart';
/*
* Created by Mujuzi Moses
*/

class Utils{

  static String getUsername(String email) {
    return "siro:${email.split('@')[0]}";
  }

  static Future<File> pickImage({@required ImageSource source}) async {

    File selectedImage;
    PickedFile pickedFile = await ImagePicker().getImage(
        source: source,
    );
    if ( pickedFile != null) {
      selectedImage = File(pickedFile.path);
      return compressImage(selectedImage);
    } else {
      return null;
    }
  }

  static Future<File> compressImage(File imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int random = Random().nextInt(1000);

    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    Im.copyResize(image, width: 500, height: 500);

    return new File('$path/img_siro2021_$random.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }

  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;
      case UserState.Online:
        return 1;
      default:
        return 2;
    }
  }

  static UserState numToState(int number) {
    switch (number) {
      case 0:
        return UserState.Offline;
      case 1:
        return UserState.Online;
      default:
        return UserState.Waiting;
    }
  }

  static Future<File> compressVideo(File videoToCompress) async {
    try {
      await VideoCompress.setLogLevel(0);

      MediaInfo videoInfo = await VideoCompress.compressVideo(
        videoToCompress.path,
        quality: VideoQuality.LowQuality,
        includeAudio: true,
        deleteOrigin: true,
      );

      return new File('${videoInfo.path}');
    } catch (e) {
      print ("Compress Video Error ::: " + e.toString());
      VideoCompress.cancelCompression();
      return null;
    }
  }

  static Future<File> pickDoc() async {
    File selectedDocument;
    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (pickedFile != null) {
      selectedDocument = File(pickedFile.files.first.path);
      return selectedDocument;
    } else return null;
  }

  static Future<File> pickAudio() async {
    File selectedAudio;
    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );
    if (pickedFile != null) {
      selectedAudio = File(pickedFile.files.first.path);
      return selectedAudio;
    } else return null;
  }


  static Future<File> pickVideo({@required ImageSource source}) async {

    File selectedVideo;
    PickedFile pickedFile = await ImagePicker().getVideo(source: source);
    if (pickedFile != null) {
      selectedVideo = File(pickedFile.path);
      return compressVideo(selectedVideo);
    } else {
      return null;
    }
  }

  static Future generateThumbnail(File video) async {
    return await VideoCompress.getByteThumbnail(video.path);
  }

  static Future getFileSize(File file) async {
    return await file.length();
  }

  static String toDate(DateTime startTime) {
    final date = DateFormat.MMMMEEEEd().format(startTime);

    return "$date";
  }

  static String toTime(DateTime startTime) {
    final time = DateFormat.Hm().format(startTime);

    return "$time";
  }

  static String toDateTime(DateTime startTime) {
    final date = DateFormat.MMMMEEEEd().format(startTime);
    final time = DateFormat.Hm().format(startTime);

    return "$date $time";
  }

  static String formatDate(date) {
    //DateTime dateTime = DateTime.parse(date);
    String formattedDate = "${DateFormat.MMMd().format(date)}, ${DateFormat.y().format(date)}";
    return formattedDate;
  }

  static String formatForAlarm(String dateTime) {
    int idx = dateTime.indexOf(",");
    String month;
    String monthDay = dateTime.substring(0, idx);
    String day = dateTime.substring(idx-2, idx);
    int dayInt = int.parse(day);
    String monthStr = monthDay.replaceAll(day, "").trim();
    String dateTime2 = dateTime.substring(idx+1);
    int idx2 = dateTime2.indexOf(",");
    String year = dateTime2.substring(0, idx2).trim();
    String dateTime3 = dateTime2.substring(idx2+1);
    int idx3 = dateTime3.indexOf(",");
    String hour = dateTime3.substring(0, idx3).trim();
    int hourInt = int.parse(hour);
    String min = dateTime3.substring(idx3+1).trim();
    int minInt = int .parse(min);

    if (monthStr.contains("Jan")) {
      month = "01";
    } else if (monthStr.contains("Feb")) {
      month = "02";
    } else if (monthStr.contains("Mar")) {
      month = "03";
    } else if (monthStr.contains("Apr")) {
      month = "04";
    } else if (monthStr.contains("May")) {
      month = "05";
    } else if (monthStr.contains("Jun")) {
      month = "06";
    } else if (monthStr.contains("Jul")) {
      month = "07";
    } else if (monthStr.contains("Aug")) {
      month = "08";
    } else if (monthStr.contains("Sep")) {
      month = "09";
    } else if (monthStr.contains("Oct")) {
      month = "10";
    } else if (monthStr.contains("Nov")) {
      month = "11";
    } else if (monthStr.contains("Dec")) {
      month = "12";
    }

    if (minInt < 10) {
      min = "0$min";
    }
    if (dayInt < 10) {
      day = "0$day";
    }
    if (hourInt < 10) {
      hour = "0$hour";
    }
    return year + month + day + "T" +hour + min + "00";
  }

  static String formatTime(date) {
    //DateTime dateTime = DateTime.parse(date);
    String formattedTime = "${DateFormat.jm().format(date)}";
    return formattedTime;
  }
}