import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/Chat/chatSearch.dart';
import 'package:creativedata_app/AllScreens/VideoChat/callScreen.dart';
import 'package:creativedata_app/Models/call.dart';
import 'package:creativedata_app/Provider/userProvider.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/agoraConfigs.dart';
import 'package:creativedata_app/constants.dart';
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
  const VoiceCallScreen({Key key, this.call, this.isDoctor}) : super(key: key);

  @override
  _VoiceCallScreenState createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  UserProvider userProvider;
  StreamSubscription callStreamSubscription;
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  String chatRoomId;
  Records records;

  void getInfo() {
    chatRoomId = getChatRoomId(widget.call.receiverName, widget.call.callerName);
    records = Records(
      callerId: widget.call.callerId,
      callerPic: widget.call.callerPic,
      receiverId: widget.call.receiverId,
      receiverPic: widget.call.receiverPic,
      isVoiceCall: true,
      users: [widget.call.callerName, widget.call.receiverName],
      createdBy: Constants.myName,
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
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    // await AgoraRtcEngine.setParameters(
    //     '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(null, widget.call.channelId, null, 0);
  }

  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
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
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
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

  Future<bool> _onBackPressed() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Hang Up Phone Call?"),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () async {
              await databaseMethods.endCall(call: widget.call, records: records, chatRoomId: chatRoomId);
              Navigator.pop(context);
            }
          ),
        ],
      ),
    );
  }

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

  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
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
            onPressed: () async => await databaseMethods.endCall(call: widget.call, records: records, chatRoomId: chatRoomId),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: () => CallScreen(call: widget.call),
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
    getInfo();
    addPostFrameCallback();
    initializeAgora();
  }

  @override
  void dispose() {
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    callStreamSubscription.cancel();
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
                       color: Colors.redAccent,
                     ),),
                     Spacer(),
                   ],
                 ),
               ),
              _panel(),
              _toolbar(),
            ],
          ),
        ),
      ),
    );
  }
}
