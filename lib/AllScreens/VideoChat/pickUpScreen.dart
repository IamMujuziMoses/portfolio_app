import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/Chat/chatSearch.dart';
import 'package:creativedata_app/AllScreens/Chat/voiceCallScreen.dart';
import 'package:creativedata_app/AllScreens/VideoChat/callScreen.dart';
import 'package:creativedata_app/Models/call.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Utilities/permissions.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class PickUpScreen extends StatelessWidget {
  final Call call;
  final bool isDoctor;
  final bool isVoiceCall;
  PickUpScreen({Key key, @required this.call, this.isDoctor, this.isVoiceCall}) : super(key: key);

  final DatabaseMethods databaseMethods = new DatabaseMethods();

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
              color: Colors.redAccent,
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
                    color: Colors.redAccent,
                    onPressed: () async {
                      String chatRoomId = getChatRoomId(call.receiverName, call.callerName);
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
                    onPressed: () async =>
                    await Permissions.cameraAndMicrophonePermissionsGranted() ?
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => isVoiceCall == true
                            ? VoiceCallScreen(call: call, isDoctor: isDoctor,)
                            : CallScreen(call: call, isDoctor: isDoctor,),
                      ),
                    ) : {},
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
