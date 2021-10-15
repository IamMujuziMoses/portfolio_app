import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
/*
* Created by Mujuzi Moses
*/

var pathToSaveAudio = 'audio_example.mp3';

class SoundRecorder {
  FlutterSoundRecorder _audioRecorder;
  bool _isRecorderInitialised = false;

  bool get isRecording => _audioRecorder.isRecording;

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();

    PermissionStatus status = await PermissionHandler().checkPermissionStatus(PermissionGroup.microphone);
    if (status != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.microphone]);
    }

    await _audioRecorder.openAudioSession();
    _isRecorderInitialised = true;
  }

  void dispose() {
    if (!_isRecorderInitialised) return;
    _audioRecorder.closeAudioSession();
    _audioRecorder = new FlutterSoundRecorder();
    _isRecorderInitialised = false;
  }

  Future _record() async {
    if (!_isRecorderInitialised) return;
    await _audioRecorder.startRecorder(toFile: pathToSaveAudio);
  }

  Future _stop() async {
    if (!_isRecorderInitialised) return;
    await _audioRecorder.stopRecorder();
  }

  Future toggleRecording() async {
    if (_audioRecorder.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}