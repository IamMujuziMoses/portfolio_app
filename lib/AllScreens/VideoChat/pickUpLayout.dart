import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpScreen.dart';
import 'package:creativedata_app/Models/call.dart';
import 'package:creativedata_app/Provider/userProvider.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/main.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
/*
* Created by Mujuzi Moses
*/

class PickUpLayout extends StatelessWidget {
  final Widget scaffold;
  final DatabaseMethods databaseMethods = new DatabaseMethods();

  PickUpLayout({Key key, @required this.scaffold}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    if (userProvider != null) {
      if (userProvider.getUser != null) {
        return StreamBuilder<DocumentSnapshot>(
          stream: databaseMethods.callStream(
            uid: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.data() != null) {
              Call call = Call.fromMap(snapshot.data.data());

              if (call.hasDialled == false) {
                assetsAudioPlayer.open(Audio("sounds/alert.mp3"));
                assetsAudioPlayer.play();
                return PickUpScreen(call: call, isDoctor: false, isVoiceCall: call.isVoiceCall);
              }
              return scaffold;
            }
            return scaffold;
          },
        );
      } else if (userProvider.getDoctor != null) {
        return StreamBuilder<DocumentSnapshot>(
          stream: databaseMethods.callStream(
            uid: userProvider.getDoctor.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.data() != null) {
              Call call = Call.fromMap(snapshot.data.data());

              if (call.hasDialled == false) {
                assetsAudioPlayer.open(Audio("sounds/alert.mp3"));
                assetsAudioPlayer.play();
                return PickUpScreen(call: call, isDoctor: true, isVoiceCall: call.isVoiceCall);
              }
              return scaffold;
            }
            return scaffold;
          },
        );
      } else {
        return Scaffold(
          body: Container(
            color: Colors.grey[200],
            child: Center(
              child: Image(
                image: AssetImage("images/logo.png"),
                width: 39 * SizeConfig.widthMultiplier,
                height: 25 * SizeConfig.heightMultiplier,
                alignment: Alignment.center,
              ),
            ),
          ),
        );
      }
    } else {
      return Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: Image(
              image: AssetImage("images/logo.png"),
              width: 39 * SizeConfig.widthMultiplier,
              height: 25 * SizeConfig.heightMultiplier,
              alignment: Alignment.center,
            ),
          ),
        ),
      );
    }
  }
}
