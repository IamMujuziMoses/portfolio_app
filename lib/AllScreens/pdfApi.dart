import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
/*
* Created by Mujuzi Moses
*/

class PDFApi {
  static Future<File> loadFirebase(String url) async {
    try {
      Reference refPDF =  FirebaseStorage.instance.ref(url);
      Uint8List bytes = await refPDF.getData();

      return _storeFile(url, bytes);
    } catch (e) {
      print("Error load PDF ::: ${e.toString()}");
      return null;
    }
  }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    String fileName = basename(url);
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/$fileName');

    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}