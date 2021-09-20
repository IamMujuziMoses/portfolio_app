import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/Chat/chatScreen.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/userProfileScreen.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Utilities/permissions.dart';
import 'package:creativedata_app/Widgets/onlineIndicator.dart';
import 'package:creativedata_app/constants.dart';
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

  DatabaseMethods databaseMethods = new DatabaseMethods();
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
              color: Colors.red[300]
            ),),
          ),
          body: callRecordsList(),
        ),
      ),
    );
  }
}

class CallRecordsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final String profilePhoto;
  final String receiverUID;
  final bool isDoctor;
  final bool isVoiceCall;
  final bool isCreator;
  final Timestamp time;
  CallRecordsTile({Key key,
    this.userName,
    this.chatRoomId,
    this.profilePhoto,
    this.isDoctor,
    this.isVoiceCall,
    this.isCreator,
    this.time, this.receiverUID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    int mo = time.toDate().month.toInt();
    String month = months[mo-1];
    String amPm;
    String hour;
    String day = time.toDate().day.toString();
    int h = time.toDate().hour.toInt();
    if (h > 12) {
      amPm = "pm";
      int h2 = h - 12;
      hour = "$h2";
    } else {
      amPm = "am";
      hour = "$h";
    }
    String min;
    int mi = time.toDate().minute.toInt();
    if (mi < 10) {
      min = "0$mi";
    } else {
      min = "$mi";
    }

    String time2 = day + " " + month + ", " + hour + ":" + min + " " + amPm;
    DatabaseMethods databaseMethods = new DatabaseMethods();
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
                  imageUrl: profilePhoto,
                  context: context,
                  isSender: false,
                  chatRoomId: chatRoomId,
                ),
                child: Stack(
                  children: <Widget>[
                  CachedImage(
                  imageUrl: profilePhoto,
                  isRound: true,
                  radius: 50,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: OnlineIndicator(
                    uid: receiverUID,
                    isDoctor: !isDoctor,
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
                          isDoctor == true ? userName : "Dr. " + userName,
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
                        Icon(isCreator == true ? CupertinoIcons.arrow_up_right : CupertinoIcons.arrow_down_left,
                          color: Colors.green[800],
                          size: 5 * SizeConfig.imageSizeMultiplier,
                        ),
                        SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                        Text("$time2", style: TextStyle(
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
              isVoiceCall == true ?
              GestureDetector(
                onTap: () async =>
                await Permissions.cameraAndMicrophonePermissionsGranted() ?
                goToVoiceCall(databaseMethods, userName, context, isDoctor) : {},
                child: Container(
                  height: 4 * SizeConfig.heightMultiplier,
                  width: 8 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    Icons.phone_rounded,
                    color: Colors.red[300],
                    size: 5 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
              )
              : GestureDetector(
                onTap: () async => await Permissions.cameraAndMicrophonePermissionsGranted()
                    ? goToVideoChat(databaseMethods, userName, context, isDoctor)
                    : {},
                child: Container(
                  height: 4 * SizeConfig.heightMultiplier,
                  width: 8 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    CupertinoIcons.video_camera_solid,
                    color: Colors.red[300],
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
