import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/Chat/chatScreen.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/userProfileScreen.dart';
import 'package:creativedata_app/Models/activity.dart';
import 'package:creativedata_app/Utilities/permissions.dart';
import 'package:creativedata_app/Utilities/utils.dart';
import 'package:creativedata_app/Widgets/onlineIndicator.dart';
import 'package:creativedata_app/Widgets/progressDialog.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/main.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class AllCallsScreen extends StatefulWidget {
  static const String screenId = "allCallsScreen";
  final bool isDoctor;
  final Stream callRecordsStream;
  const AllCallsScreen({Key key, this.isDoctor, this.callRecordsStream}) : super(key: key);

  @override
  _AllCallsScreenState createState() => _AllCallsScreenState();
}

class _AllCallsScreenState extends State<AllCallsScreen> {
  String myProfilePic;

  Widget callRecordsList() {
    return StreamBuilder(
      stream: widget.callRecordsStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            bool isCreator = snapshot.data.docs[index].get("createdBy") == Constants.myName;
            String senderPic = snapshot.data.docs[index].get("caller_pic");
            String receiverPic = snapshot.data.docs[index].get("receiver_pic");
            String receiverUID = snapshot.data.docs[index].get("receiver_id");
            String callerUID = snapshot.data.docs[index].get("caller_id");
            bool isVoiceCall = snapshot.data.docs[index].get("is_voice_call");
            Timestamp time = snapshot.data.docs[index].get("call_time");
            String profilePhoto = isCreator ? receiverPic : senderPic;
            String uid = isCreator ? receiverUID : callerUID;
            String chatRoomId = isVoiceCall == true
                ? snapshot.data.docs[index].get("chatroomId").toString()
                : snapshot.data.docs[index].get("chatroomId").toString().replaceAll("_video", "");
            String username = chatRoomId.replaceAll("_", "").replaceAll(Constants.myName, "");
            return CallRecordsTile(
              receiverUID: uid,
              isCreator: isCreator,
              time: time,
              isVoiceCall: isVoiceCall,
              isDoctor: widget.isDoctor,
              chatRoomId: chatRoomId,
              userName: username,
              profilePhoto: profilePhoto,
            );
          },
        ) : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = await databaseMethods.getName();
    databaseMethods.getProfilePhoto().then((val) {
      myProfilePic = val;
    });
  }

  Future<bool> _onBackPressed() async {}

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: PickUpLayout(
        scaffold: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[100],
            elevation: 0,
            title: Text("Calls", style: TextStyle(
              fontFamily: "Brand Bold",
              color: Color(0xFFa81845),
            ),),
          ),
          body: callRecordsList(),
        ),
      ),
    );
  }
}

class CallRecordsTile extends StatefulWidget {
  final String userName;
  final String chatRoomId;
  final String profilePhoto;
  final String receiverUID;
  final bool isDoctor;
  final bool isVoiceCall;
  final bool isCreator;
  final Timestamp time;
  const CallRecordsTile({Key key,
    this.userName,
    this.chatRoomId,
    this.profilePhoto,
    this.isDoctor,
    this.isVoiceCall,
    this.isCreator,
    this.time, this.receiverUID}) : super(key: key);

  @override
  _CallRecordsTileState createState() => _CallRecordsTileState();
}

class _CallRecordsTileState extends State<CallRecordsTile> {
  QuerySnapshot chatSnap;
  QuerySnapshot callSnap;
  QuerySnapshot postSnap;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  getInfo() async {
    try {
      await databaseMethods.getPostByDoctorNameSnap(Constants.myName).then((val) {
        setState(() {
          postSnap = val;
        });
      });
    } catch (e) {
      print("User is not a Doctor ::: ${e.toString()}");
    }
    await databaseMethods.getChatRoomsSnap(Constants.myName).then((val) {
      setState(() {
        chatSnap = val;
      });
    });
    await databaseMethods.getCallRecordsSnap(Constants.myName).then((val) {
      setState(() {
        callSnap = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 9 * SizeConfig.heightMultiplier,
      color: Colors.grey[100],
      padding: EdgeInsets.only(
        top: 0.5 * SizeConfig.heightMultiplier,
        left: 2 * SizeConfig.widthMultiplier,
        right: 2 * SizeConfig.widthMultiplier,
        bottom: 0.5 * SizeConfig.heightMultiplier,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 2 * SizeConfig.widthMultiplier,
            right: 2 * SizeConfig.widthMultiplier,
          ),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => profilePicView(
                  postSnap: postSnap,
                  chatSnap: chatSnap,
                  callSnap: callSnap,
                  isDoctor: widget.isDoctor,
                  isUser: false,
                  imageUrl: widget.profilePhoto,
                  context: context,
                  isSender: false,
                  chatRoomId: widget.chatRoomId,
                ),
                child: Stack(
                  children: <Widget>[
                  CachedImage(
                  imageUrl: widget.profilePhoto,
                  isRound: true,
                  radius: 50,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: OnlineIndicator(
                    uid: widget.receiverUID,
                    isDoctor: !widget.isDoctor,
                  ),
                ),],
              ),),
              SizedBox(width: 2 * SizeConfig.widthMultiplier,),
              Container(
                height: 6 * SizeConfig.heightMultiplier,
                width: 65 * SizeConfig.widthMultiplier,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          widget.isDoctor == true ? widget.userName : "Dr. " + widget.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: "Brand Bold",
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: <Widget>[
                        Icon(widget.isCreator == true ? CupertinoIcons.arrow_up_right : CupertinoIcons.arrow_down_left,
                          color: Colors.green[800],
                          size: 5 * SizeConfig.imageSizeMultiplier,
                        ),
                        SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                        Text("${Utils.formatDate(widget.time.toDate())}, ${Utils.formatTime(widget.time.toDate())}", style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: "Brand-Regular",
                          fontSize: 2.3 * SizeConfig.textMultiplier,
                        ),overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              widget.isVoiceCall == true ?
              GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) => ProgressDialog(message: "Please wait...",),
                  );
                  Activity activity = Activity.callActivity(
                    createdAt: FieldValue.serverTimestamp(),
                    type: "call",
                    callType: "voice",
                    receiver: widget.userName,
                  );
                  await Permissions.cameraAndMicrophonePermissionsGranted() ?
                  goToVoiceCall(databaseMethods, widget.userName, context, widget.isDoctor, activity) : {};
                },
                child: Container(
                  height: 4 * SizeConfig.heightMultiplier,
                  width: 8 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradientColor,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    Icons.phone_rounded,
                    color: Colors.white,
                    size: 5 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
              )
              : GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) => ProgressDialog(message: "Please wait...",),
                  );
                  Activity activity = Activity.callActivity(
                    createdAt: FieldValue.serverTimestamp(),
                    type: "call",
                    callType: "video",
                    receiver: widget.userName,
                  );
                  await Permissions.cameraAndMicrophonePermissionsGranted() ?
                  goToVideoChat(databaseMethods, widget.userName, context, widget.isDoctor, activity) : {};
                },
                child: Container(
                  height: 4 * SizeConfig.heightMultiplier,
                  width: 8 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradientColor,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    CupertinoIcons.video_camera_solid,
                    color: Colors.white,
                    size: 5 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
