import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
/*
* Created by Mujuzi Moses
*/

class PhotoViewPage extends StatelessWidget {
  final String message;
  final bool isSender;
  final String chatRoomId;
  final String doctorsName;
  const PhotoViewPage({Key key, this.message, this.isSender, this.chatRoomId, this.doctorsName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    String sender = chatRoomId.toString().replaceAll("_", "").replaceAll(Constants.myName, "");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        titleSpacing: 0,
        elevation: 0,
        title: isSender
            ? Text("You", style: TextStyle(fontFamily: "Brand Bold", color: Colors.red[300]))
            : Text(chatRoomId != null
            ? sender
            : "Dr. "  + doctorsName, style: TextStyle(fontFamily: "Brand Bold", color: Colors.red[300]),),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black
        ),
        child: message != null ? PhotoView(
          imageProvider: NetworkImage(
            message,
          ),
          maxScale: PhotoViewComputedScale.covered * 2,
          minScale: PhotoViewComputedScale.contained,
          initialScale: PhotoViewComputedScale.contained,
          enableRotation: false,
          loadingBuilder: (context, event) => Center(
            child: CircularProgressIndicator(
               value: event == null
                   ? 0
                   : event.cumulativeBytesLoaded / event.expectedTotalBytes,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red[300]),
            ),
          ),
        ) : Container(
          color: Colors.black,
          child: Center(
            child: Image.asset("images/user_icon.png"),
          ),
        ),
      ),
    );
  }
}
