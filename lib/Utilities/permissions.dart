import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/services.dart';
/*
* Created by Mujuzi Moses
*/

class Permissions {
  static Future<bool> cameraAndMicrophonePermissionsGranted() async {
    PermissionStatus cameraPermissionStatus = await _getCameraPermission();
    PermissionStatus microphonePermissionStatus = await _getMicrophonePermission();
    PermissionStatus storagePermissionStatus = await _getStoragePermission();

    if (cameraPermissionStatus == PermissionStatus.granted && 
        microphonePermissionStatus == PermissionStatus.granted &&
        storagePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissions(cameraPermissionStatus, microphonePermissionStatus, storagePermissionStatus);
      return false;
    }
    
  }

  static Future<PermissionStatus> _getCameraPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.camera);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus = await PermissionHandler()
          .requestPermissions([PermissionGroup.camera]);
      return permissionStatus[PermissionGroup.camera] ?? PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  static Future<PermissionStatus> _getStoragePermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus = await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      return permissionStatus[PermissionGroup.storage] ?? PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  static Future<PermissionStatus> _getMicrophonePermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.microphone);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus = await PermissionHandler()
          .requestPermissions([PermissionGroup.microphone]);
      return permissionStatus[PermissionGroup.microphone] ?? PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  static void _handleInvalidPermissions(PermissionStatus cameraPermissionStatus,
      PermissionStatus microphonePermissionStatus, PermissionStatus storagePermissionStatus) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied &&
        storagePermissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
        code: "PERMISSION_DENIED",
        message: "Access to camera and microphone denied",
        details: null,
      );
    } else if (cameraPermissionStatus == PermissionStatus.disabled &&
        microphonePermissionStatus == PermissionStatus.disabled &&
        storagePermissionStatus == PermissionStatus.disabled) {
      throw new PlatformException(
        code: "PERMISSION_DISABLED",
        message: "Location data is not available on device",
        details: null,
      );
    }
  }
}