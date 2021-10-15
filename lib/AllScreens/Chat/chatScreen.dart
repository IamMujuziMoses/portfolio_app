import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/Chat/chatSearch.dart';
import 'package:creativedata_app/AllScreens/loginScreen.dart';
import 'package:creativedata_app/Models/message.dart';
import 'package:creativedata_app/Models/user.dart' as myUser;
import 'package:creativedata_app/Models/doctor.dart';
import 'package:creativedata_app/AllScreens/Chat/conversationScreen.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/userProfileScreen.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Services/helperFunctions.dart';
import 'package:creativedata_app/Utilities/callUtils.dart';
import 'package:creativedata_app/Utilities/permissions.dart';
import 'package:creativedata_app/Widgets/onlineIndicator.dart';
import 'package:creativedata_app/Widgets/progressDialog.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/main.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class ChatScreen extends StatefulWidget {
  static const String screenId = "chatScreen";
  final bool isDoctor;
  const ChatScreen({Key key, this.isDoctor}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  Stream chatRoomStream;
  String myProfilePic;

  Widget chatRoomList() {

    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            bool isCreator = snapshot.data.docs[index].get("createdBy") == Constants.myName;
            String senderPic = snapshot.data.docs[index].get("sender_profile_photo");
            String receiverPic = snapshot.data.docs[index].get("receiver_profile_photo");
            String profilePhoto = isCreator ? receiverPic : senderPic;
            String receiverUID = snapshot.data.docs[index].get("receiver_uid");
            String senderUID = snapshot.data.docs[index].get("sender_uid");
            String uid = isCreator ? receiverUID : senderUID;
            String username = snapshot.data.docs[index].get("chatroomId").toString()
                .replaceAll("_", "").replaceAll(Constants.myName, "");
            String chatRoomId = snapshot.data.docs[index].get("chatroomId");
            return ChatRoomTile(
              receiverUID: uid,
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
    Constants.myName = await HelperFunctions.getUserNameSharedPref();
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPref();
    databaseMethods.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomStream = val;
      });
    });

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
                title: Text("Chats", style: TextStyle(
                  fontFamily: "Brand Bold",
                  color: Colors.red[300]
                ),),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.red[300],
                child: Icon(Icons.search_rounded, color: Colors.white,),
                onPressed: () async {
                  List users = [];
                  Stream usersStream = widget.isDoctor == true
                      ? await databaseMethods.getUsers()
                      : await databaseMethods.getDoctors();
                  QuerySnapshot usersSnap = await usersStream.first;
                  for (int i = 0; i <= usersSnap.size - 1; i++) {
                    users.add(usersSnap.docs[i].get("name"));
                  }
                  print("Size ::: ${usersSnap.size}");
                  Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => ChatSearch(
                      users: users,
                      isDoctor: widget.isDoctor,
                    ),
                  ),);
                },
              ),
              body: chatRoomList(),
            ),
          ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final String profilePhoto;
  final String receiverUID;
  final bool isDoctor;
  ChatRoomTile({Key key,
    this.userName,
    this.chatRoomId,
    this.profilePhoto,
    this.isDoctor,
    this.receiverUID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseMethods databaseMethods = new DatabaseMethods();
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(
              isDoctor: isDoctor,
              chatRoomId: chatRoomId,
              userName: userName,
              profilePhoto: profilePhoto,
            )),
        ),
      child: Container(
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
                right: 2 *SizeConfig.widthMultiplier,
            ),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () => profilePicView(
                    isDoctor: isDoctor,
                    isUser: false,
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
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                Container(
                  height: 5 * SizeConfig.heightMultiplier,
                  width: 55 * SizeConfig.widthMultiplier,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(isDoctor == true ? userName : "Dr. " + userName, style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: "Brand Bold",
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                      ), overflow: TextOverflow.ellipsis,),
                      LastMessageContainer(
                        stream: databaseMethods.fetchLastMessageBetween(chatRoomId: chatRoomId,),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) => ProgressDialog(message: "Please wait...",),
                    );
                    await Permissions.cameraAndMicrophonePermissionsGranted() ?
                    goToVideoChat(databaseMethods, userName, context, isDoctor) : {};
                  },
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
                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) => ProgressDialog(message: "Please wait...",),
                    );
                    await Permissions.cameraAndMicrophonePermissionsGranted() ?
                    goToVoiceCall(databaseMethods, userName, context, isDoctor) : {};
                  },
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

goToVoiceCall(DatabaseMethods databaseMethods, String username, context, bool isDoctor) async {

  User firebaseUser = FirebaseAuth.instance.currentUser;
  String uid = firebaseUser.uid;
  String myName;
  QuerySnapshot nameSnap;
  await databaseMethods.getUserByUid(uid).then((val) {
    nameSnap = val;
    myName = nameSnap.docs[0].get("name");
  });

  if (username != myName) {
    try {
      if (isDoctor == true) {
        Map<String, dynamic> fromMap;
        QuerySnapshot fromSnap;
        fromMap = await databaseMethods.userSnapToMap(username, fromSnap);

        Map<String, dynamic> toMap;
        QuerySnapshot toSnap;
        toMap = await databaseMethods.doctorSnapToMap(myName, toSnap);

        Doctor to = Doctor.fromMap(toMap);
        myUser.User from = myUser.User.fromMap(fromMap);

        CallUtils.voiceDialDoctor(to, from, context);
      } else if (isDoctor == false) {
        Map<String, dynamic> fromMap;
        QuerySnapshot fromSnap;
        fromMap = await databaseMethods.doctorSnapToMap(username, fromSnap);

        Map<String, dynamic> toMap;
        QuerySnapshot toSnap;
        toMap = await databaseMethods.userSnapToMap(myName, toSnap);

        Doctor from = Doctor.fromMap(fromMap);
        myUser.User to = myUser.User.fromMap(toMap);

        CallUtils.voiceDialUser(to, from, context);
      }
    } catch (e) {
      print("Go To VideoChat Error ::: " + e.toString());
    }
  } else {
    displayToastMessage("Cannot Perform Operation", context);
  }


}

goToVideoChat(DatabaseMethods databaseMethods, String username, context, bool isDoctor) async {

  User firebaseUser = FirebaseAuth.instance.currentUser;
  String uid = firebaseUser.uid;
  String myName;
  QuerySnapshot nameSnap;
  await databaseMethods.getUserByUid(uid).then((val) {
    nameSnap = val;
    myName = nameSnap.docs[0].get("name");
  });

  if (username != myName) {
    try {
      if (isDoctor == true) {
        Map<String, dynamic> fromMap;
        QuerySnapshot fromSnap;
        fromMap = await databaseMethods.userSnapToMap(username, fromSnap);

        Map<String, dynamic> toMap;
        QuerySnapshot toSnap;
        toMap = await databaseMethods.doctorSnapToMap(myName, toSnap);

        Doctor to = Doctor.fromMap(toMap);
        myUser.User from = myUser.User.fromMap(fromMap);

        CallUtils.videoDialDoctor(to, from, context);
      } else if (isDoctor == false) {
        Map<String, dynamic> fromMap;
        QuerySnapshot fromSnap;
        fromMap = await databaseMethods.doctorSnapToMap(username, fromSnap);

        Map<String, dynamic> toMap;
        QuerySnapshot toSnap;
        toMap = await databaseMethods.userSnapToMap(myName, toSnap);

        Doctor from = Doctor.fromMap(fromMap);
        myUser.User to = myUser.User.fromMap(toMap);

        CallUtils.videoDialUser(to, from, context);
      }
    } catch (e) {
      print("Go To VideoChat Error ::: " + e.toString());
    }
  } else {
    displayToastMessage("Cannot Perform Operation", context);
  }

}

class LastMessageContainer extends StatelessWidget {
  final stream;
  LastMessageContainer({Key key, @required this.stream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data.docs;
          if (docList.isNotEmpty) {
            Message message = Message.fromMapLM(docList.last.data());
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(message.message, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "Brand-Regular",
                  fontSize: 2 * SizeConfig.textMultiplier,
                ),
              ),
            );
          }
          return Text("No Message...", style: TextStyle(
            color: Colors.grey,
            fontSize: 2 * SizeConfig.textMultiplier,
          ),);
        }
        return Text("...", style: TextStyle(
          color: Colors.grey,
          fontSize: 2 * SizeConfig.textMultiplier,
        ),);
      },
    );
  }
}

