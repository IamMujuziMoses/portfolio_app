import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/Chat/chatSearch.dart';
import 'package:creativedata_app/AllScreens/VideoChat/callScreen.dart';
import 'package:creativedata_app/Models/call.dart';
import 'package:creativedata_app/Provider/userProvider.dart';
import 'package:creativedata_app/Utilities/callUtils.dart';
import 'package:creativedata_app/Widgets/timerWidget.dart';
import 'package:creativedata_app/agoraConfigs.dart';
import 'package:creativedata_app/main.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
/*
* Created by Mujuzi Moses
*/

class VoiceCallScreen extends StatefulWidget {
  final Call call;
  final bool isDoctor;
  final bool isReceiving;
  const VoiceCallScreen({Key key, this.call, this.isDoctor, @required this.isReceiving}) : super(key: key);

  @override
  _VoiceCallScreenState createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {

  TimerController timerController = TimerController();
  UserProvider userProvider;
  StreamSubscription callStreamSubscription;
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  String chatRoomId;
  Records records;

  void getInfo() {
    chatRoomId = getChatRoomId(username: widget.call.receiverName, myName: widget.call.callerName, isVoiceCall: true);
    records = Records(
      callerId: widget.call.callerId,
      callerPic: widget.call.callerPic,
      receiverId: widget.call.receiverId,
      receiverPic: widget.call.receiverPic,
      isVoiceCall: true,
      users: [widget.call.callerName, widget.call.receiverName],
      createdBy: widget.call.callerName,
      time: FieldValue.serverTimestamp(),
    );
  }

  Future<void> initializeAgora() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    if (widget.isReceiving == true) {} else {
      assetsAudioPlayer.open(Audio("sounds/dail_tone.mp3"));
      assetsAudioPlayer.play();
    }
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    // await AgoraRtcEngine.setParameters(
    //     '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(widget.call.token, widget.call.channelId, null, 0);
  }

  void _addAgoraEventHandlers() {
    // AgoraRtcEngine.onError = (dynamic code) {
    //   setState(() {
    //     final info = 'onError: $code';
    //     _infoStrings.add(info);
    //   });
    // };

    AgoraRtcEngine.onTokenPrivilegeWillExpire = (token) async {
      print("Renewed Token ::: soon");
      await CallUtils.getToken(widget.call.channelId).then((val) {
        setState(() {
          token = val;
        });
      });
      await AgoraRtcEngine.renewToken(token);
      print("Renewed Token ::: $token");
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
        String channel,
        int uid,
        int elapsed,
        ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      assetsAudioPlayer.stop();
      assetsAudioPlayer = new AssetsAudioPlayer();
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
        if (_users.length > 0) {
          timerController.startTimer();
        }
      });
    };

    AgoraRtcEngine.onUpdatedUserInfo = (AgoraUserInfo userInfo, int i) {
      setState(() {
        final info = 'onUpdatedUserInfo: ${userInfo.toString()}';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onRejoinChannelSuccess = (String string, int a, int b) {
      setState(() {
        final info = 'onRejoinChannelSuccess: $string';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onUserOffline = (int a, int b) async {
      await databaseMethods.endCall(call: widget.call, records: records, chatRoomId: chatRoomId);
      setState(() {
        final info = 'onUserOffline: a: ${a.toString()}, b: ${b.toString()}';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onRegisteredLocalUser = (String s, int i) {
      setState(() {
        final info = 'onRegisteredLocalUser: string s, i: ${i.toString()}';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        final info = 'onLeaveChannel';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onConnectionLost = () {
      setState(() {
        final info = 'onConnectionLost';
        _infoStrings.add(info);
      });
    };

  }

  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
  }

  Future<bool> _onBackPressed() async {}

  addPostFrameCallback() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);

      callStreamSubscription = widget.isDoctor == true
          ? databaseMethods.callStream(uid: userProvider.getDoctor.uid).listen((DocumentSnapshot ds) {
        switch (ds.data()) {
          case null:
            Navigator.pop(context);
            break;
          default:
            break;
        }
      })
          : databaseMethods.callStream(uid: userProvider.getUser.uid).listen((DocumentSnapshot ds) {
        switch (ds.data()) {
          case null:
            Navigator.pop(context);
            break;
          default:
            break;
        }
      }) ;
    });
  }

  Widget _toolbar() {
    //if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () async {
              timerController.stopTimer();
              assetsAudioPlayer.stop();
              assetsAudioPlayer = new AssetsAudioPlayer();
              await databaseMethods.endCall(
                call: widget.call,
                records: records,
                chatRoomId: chatRoomId,);
            },
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Color(0xFFa81845),
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: () => CallScreen(isReceiving: false, call: widget.call, isDoctor:widget.isDoctor,),
            child: Icon(
              CupertinoIcons.video_camera_solid,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  @override
  void initState() {
    super.initState();
    userAvailableTone();
    getInfo();
    addPostFrameCallback();
    initializeAgora();
  }

  userAvailableTone() async {
    Future.delayed(Duration(seconds: 40), () {
      assetsAudioPlayer.stop();
      assetsAudioPlayer = new AssetsAudioPlayer();
      if (mounted == true) {
        _users.length == 0 ? widget.isDoctor == true
            ? assetsAudioPlayer.open(Audio("sounds/user_unavailable.mp3"))
            : assetsAudioPlayer.open(Audio("sounds/doc_unavailable.mp3")) : {};
        Future.delayed(Duration(seconds: 7), () async {
          assetsAudioPlayer.stop();
          assetsAudioPlayer = new AssetsAudioPlayer();
          _users.length == 0 ? await databaseMethods
              .endCall(call: widget.call, records: records, chatRoomId: chatRoomId,) : {};
        });
      }
    });
  }


  @override
  void dispose() {
    _users.clear();
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    callStreamSubscription.cancel();
    assetsAudioPlayer.stop();
    assetsAudioPlayer = new AssetsAudioPlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: <Widget>[
               Center(
                 child: Column(
                   children: <Widget>[
                     SizedBox(height: 15 * SizeConfig.heightMultiplier,),
                     Text("Voice Call", style: TextStyle(
                       fontSize: 5 * SizeConfig.textMultiplier,
                       color: Colors.green,
                     ),),Text("...........................", style: TextStyle(
                       fontSize: 5 * SizeConfig.textMultiplier,
                       color: Colors.green,
                     ),),
                     SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                     CachedImage(
                        imageUrl: widget.call.hasDialled == true
                            ? widget.call.receiverPic
                            : widget.call.callerPic,
                        isRound: true,
                        radius: 180,
                      ),
                     SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                     Text(widget.isDoctor == true
                         ? widget.call.hasDialled == true
                         ? widget.call.receiverName
                         : widget.call.callerName
                         : widget.call.hasDialled == true
                         ? "Dr. " + widget.call.receiverName
                         : "Dr. " + widget.call.callerName, style: TextStyle(
                       fontSize: 3 * SizeConfig.textMultiplier,
                       color: Color(0xFFa81845),
                     ),),
                     SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                     Visibility(
                       visible: _users.length > 0 ? true : false,
                       child: AvatarGlow(
                         glowColor: Color(0xFFa81845),
                         showTwoGlows: true,
                         animate: true,
                         endRadius: 100,
                         repeatPauseDuration: Duration(milliseconds: 100),
                         child: TimerWidget(controller: timerController,),
                       ),
                     ),
                     Spacer(),
                   ],
                 ),
               ),
              _toolbar(),
            ],
          ),
        ),
      ),
    );
  }
}
