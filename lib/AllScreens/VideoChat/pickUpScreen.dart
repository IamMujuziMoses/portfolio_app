import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/Chat/cachedImage.dart';
import 'package:portfolio_app/AllScreens/Chat/chatSearch.dart';
import 'package:portfolio_app/AllScreens/Chat/voiceCallScreen.dart';
import 'package:portfolio_app/AllScreens/VideoChat/callScreen.dart';
import 'package:portfolio_app/Models/call.dart';
import 'package:portfolio_app/Utilities/permissions.dart';
import 'package:portfolio_app/constants.dart';
import 'package:portfolio_app/main.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class PickUpScreen extends StatelessWidget {
  final Call call;
  final bool isDoctor;
  final bool isVoiceCall;
  const PickUpScreen({Key key, @required this.call, this.isDoctor, this.isVoiceCall}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10 * SizeConfig.heightMultiplier),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(isVoiceCall == true ? "Incoming Voice Call" : "Incoming Video Call", style: TextStyle(
              fontSize: 5 * SizeConfig.textMultiplier,
              color: Colors.green,
            ),),
            Text(".............", style: TextStyle(
              fontSize: 5 * SizeConfig.textMultiplier,
              color: Colors.green,
            ),),
            SizedBox(height: 50,),
            CachedImage(
              imageUrl: call.callerPic,
              isRound: true,
              radius: 180,
            ),
            SizedBox(height: 15,),
            Text(isDoctor == true
                ? call.callerName
                : "Dr. " + call.callerName, style: TextStyle(
              color: Color(0xFFa81845),
              fontWeight: FontWeight.bold,
              fontSize: 3 * SizeConfig.textMultiplier,
            ),),
            SizedBox(height: 75,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 5 * SizeConfig.heightMultiplier,
                  width: 10 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.call_end_rounded),
                    color: Color(0xFFa81845),
                    onPressed: () async {
                      assetsAudioPlayer.stop();
                      assetsAudioPlayer = new AssetsAudioPlayer();
                      String chatRoomId = getChatRoomId(username: call.receiverName, myName: call.callerName, isVoiceCall: true);
                      Records records = Records(
                        callerId: call.callerId,
                        callerPic: call.callerPic,
                        receiverId: call.receiverId,
                        receiverPic: call.receiverPic,
                        isVoiceCall: true,
                        users: [call.callerName, call.receiverName],
                        createdBy: Constants.myName,
                        time: FieldValue.serverTimestamp(),
                      );
                      await databaseMethods.endCall(call: call, records: records, chatRoomId: chatRoomId);
                    },
                  ),
                ),
                SizedBox(width: 25,),
                Container(
                  height: 5 * SizeConfig.heightMultiplier,
                  width: 10 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.call_rounded),
                    color: Colors.green,
                    onPressed: () async {
                      assetsAudioPlayer.stop();
                      assetsAudioPlayer = new AssetsAudioPlayer();
                      await Permissions.cameraAndMicrophonePermissionsGranted() ?
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => isVoiceCall == true
                              ? VoiceCallScreen(isReceiving: true, call: call, isDoctor: isDoctor,)
                              : CallScreen(isReceiving: true, call: call, isDoctor: isDoctor,),
                        ),
                      ) : {};
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}
