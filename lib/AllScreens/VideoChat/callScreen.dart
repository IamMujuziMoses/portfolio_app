import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/chatSearch.dart';
import 'package:creativedata_app/Models/call.dart';
import 'package:creativedata_app/Provider/userProvider.dart';
import 'package:creativedata_app/Utilities/callUtils.dart';
import 'package:creativedata_app/Widgets/timerWidget.dart';
import 'package:creativedata_app/agoraConfigs.dart';
import 'package:creativedata_app/main.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
/*
* Created by Mujuzi Moses
*/

class CallScreen extends StatefulWidget {
  static const String screenId = "callScreen";
  final Call call;
  final bool isDoctor;
  final bool isReceiving;
  const CallScreen({Key key, @required this.call, this.isDoctor, this.isReceiving}) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {

  TimerController timerController = TimerController();
  UserProvider userProvider;
  StreamSubscription callStreamSubscription;
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  String chatRoomId;
  Records records;

  void getInfo() {
    chatRoomId = getChatRoomId(username: widget.call.receiverName, myName: widget.call.callerName, isVoiceCall: false);
    records = Records(
      callerId: widget.call.callerId,
      callerPic: widget.call.callerPic,
      receiverId: widget.call.receiverId,
      receiverPic: widget.call.receiverPic,
      isVoiceCall: false,
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
    await AgoraRtcEngine.setParameters(
      '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(widget.call.token, widget.call.channelId, null, 0);
  }

  void _addAgoraEventHandlers() {
    // AgoraRtcEngine.onError = (dynamic code) {
    //   setState(() {
    //     final info = 'onError: $code';
    //     _infoStrings.add(info);
    //   });
    // };

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

    AgoraRtcEngine.onTokenPrivilegeWillExpire = (token) async {
      await CallUtils.getToken(widget.call.channelId).then((val) {
        token = val;
      });
      await AgoraRtcEngine.renewToken(token);
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

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
        int uid,
        int width,
        int height,
        int elapsed,
        ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }


  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
  }

  Future<bool> _onBackPressed()  {}

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

  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true,),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
              children: <Widget>[_videoView(views[0])],
            ));
      case 2:
        return Container(
            child: Stack(
              children: <Widget>[
                _receiverVideoView([views[1]]),
                _callerVideoView([views[0]]),
              ],
            ));
      case 3:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 3))
              ],
            ));
      case 4:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 4))
              ],
            ));
      default:
    }
    return Container();
  }

  Widget _receiverVideoView(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget _callerVideoView(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Container(
      height: MediaQuery.of(context).size.height - 70 * SizeConfig.heightMultiplier,
      width: MediaQuery.of(context).size.width - 60 * SizeConfig.widthMultiplier,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: Offset(2, 3),
            spreadRadius: 0.5,
            blurRadius: 2,
            color: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  Widget _toolbar() {
    //if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
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
          Row(
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
                    chatRoomId: chatRoomId,
                  );
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
                onPressed: _onSwitchCamera,
                child: Icon(
                  Icons.switch_camera,
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

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: <Widget>[
              _viewRows(),
              Positioned(
                right: 15 * SizeConfig.widthMultiplier,
                bottom:  0,
                child: _toolbar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
