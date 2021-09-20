import 'package:creativedata_app/AllScreens/VideoChat/videoView.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
/*
* Created by Mujuzi Moses
*/

class VideoViewPage extends StatelessWidget {
  final String message;
  final bool isSender;
  final String chatRoomId;
  const VideoViewPage({Key key, this.message, this.isSender, this.chatRoomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    String sender = chatRoomId.toString().replaceAll("_", "").replaceAll(Constants.myName, "");
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.grey[100],
        title: isSender
            ? Text("You", style: TextStyle(fontFamily: "Brand Bold", color: Colors.red[300]))
            : Text(chatRoomId != null
            ? sender
            : "Dr. "  + sender, style: TextStyle(fontFamily: "Brand Bold", color: Colors.red[300]),),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: VideoView(
          videoPlayerController: VideoPlayerController.network(message),
        ),
      ),
    );
  }
}
