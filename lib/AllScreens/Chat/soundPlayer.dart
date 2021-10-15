import 'package:creativedata_app/AllScreens/Chat/soundRecorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
/*
* Created by Mujuzi Moses
*/

class SoundPlayer {
  final String audioUrl;
  FlutterSoundPlayer _audioPlayer;
  SoundPlayer({this.audioUrl});
  bool get isPlaying => _audioPlayer.isPlaying;
  Duration d;

  Future init() async {
    _audioPlayer = FlutterSoundPlayer();

    await _audioPlayer.openAudioSession();
  }

  Future dispose() async {
    _audioPlayer.closeAudioSession();
    _audioPlayer = new FlutterSoundPlayer();
  }

  Future refresh() async {
    _audioPlayer.closeAudioSession();
    _audioPlayer = new FlutterSoundPlayer();
    await _audioPlayer.openAudioSession();
  }

  Future _play(VoidCallback whenFinished) async {
     d = await _audioPlayer.startPlayer(
      fromURI: audioUrl,
      //codec: Codec.mp3,
      whenFinished: whenFinished,
    );
  }

  Future _stop() async {
    await _audioPlayer.stopPlayer();
    await refresh();
  }

  Future togglePlaying({@required VoidCallback whenFinished}) async {
    if (_audioPlayer.isStopped) {
      await _play(whenFinished);
    } else {
      await _stop();
    }
  }
}