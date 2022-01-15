import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/Chat/chatSearch.dart';
import 'package:creativedata_app/AllScreens/loginScreen.dart';
import 'package:creativedata_app/Models/activity.dart';
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
import 'package:flutter/foundation.dart';
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
            String senderCounter = snapshot.data.docs[index].get("sender_counter");
            String receiverPic = snapshot.data.docs[index].get("receiver_profile_photo");
            String receiverCounter = snapshot.data.docs[index].get("receiver_counter");
            String profilePhoto = isCreator ? receiverPic : senderPic;
            int newMessages = isCreator ? int.parse(receiverCounter) : int.parse(senderCounter);
            String receiverUID = snapshot.data.docs[index].get("receiver_uid");
            String senderUID = snapshot.data.docs[index].get("sender_uid");
            String uid = isCreator ? receiverUID : senderUID;
            String username = snapshot.data.docs[index].get("chatroomId").toString()
                .replaceAll("_", "").replaceAll(Constants.myName, "");
            String chatRoomId = snapshot.data.docs[index].get("chatroomId");
            return ChatRoomTile(
              newMessages: newMessages,
              isCreator: isCreator,
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
                  color: Color(0xFFa81845)
                ),),
              ),
              floatingActionButton: FloatingActionButton(
                clipBehavior: Clip.hardEdge,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradientColor
                  ),
                  child: Icon(Icons.search_rounded, color: Colors.white,),
                ),
                onPressed: () async {
                  List users = [];
                  Stream usersStream = widget.isDoctor == true
                      ? await databaseMethods.getUsers()
                      : await databaseMethods.getDoctors();
                  QuerySnapshot usersSnap = await usersStream.first;
                  for (int i = 0; i <= usersSnap.size - 1; i++) {
                    users.add(usersSnap.docs[i].get("name"));
                  }
                  Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => ChatSearch(
                      users: users,
                      isDoctor: widget.isDoctor,
                    ),
                  ),);
                },
              ),
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.grey[100],
                child: chatRoomList(),
              ),
            ),
          ),
    );
  }
}

class ChatRoomTile extends StatefulWidget {
  final String userName;
  final String chatRoomId;
  final String profilePhoto;
  final String receiverUID;
  final bool isDoctor;
  final bool isCreator;
  final int newMessages;
  const ChatRoomTile({Key key,
    this.userName,
    this.chatRoomId,
    this.profilePhoto,
    this.isDoctor,
    this.receiverUID,
    this.isCreator,
    this.newMessages,
  }) : super(key: key);

  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
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
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0.5 * SizeConfig.heightMultiplier,
        horizontal: 1.5 * SizeConfig.widthMultiplier,
      ),
      child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            splashColor: Color(0xFFa81845).withOpacity(0.6),
            highlightColor: Colors.grey.withOpacity(0.1),
            radius: 200,
            onTap: () async {
              Stream messagesStream;
              await databaseMethods.getConversationMessages(widget.chatRoomId).then((val) {
                setState(() {
                  messagesStream = val;
                });
              });
              QuerySnapshot messagesSnap = await messagesStream.first;
              for (int i = 0; i <= messagesSnap.size - 1; i++) {
                String sendBy = messagesSnap.docs[i].get("sendBy");
                if (sendBy != Constants.myName) {
                  String docId = messagesSnap.docs[i].id;
                  Map<String, dynamic> update = {
                    "status": "seen",
                  };
                  await databaseMethods.updateConversationMessage(widget.chatRoomId, update, docId);
                }
              }

              if (widget.isCreator == true) {
                await databaseMethods.chatRoomCollection.doc(widget.chatRoomId).update({"sender_status": "online"});
                await databaseMethods.chatRoomCollection.doc(widget.chatRoomId).update({"receiver_counter": "0"});
              } else {
                await databaseMethods.chatRoomCollection.doc(widget.chatRoomId).update({"receiver_status": "online"});
                await databaseMethods.chatRoomCollection.doc(widget.chatRoomId).update({"sender_counter": "0"});
              }
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ConversationScreen(
                    isDoctor: widget.isDoctor,
                    chatRoomId: widget.chatRoomId,
                    userName: widget.userName,
                    profilePhoto: widget.profilePhoto,
                  )),
              );
            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 1 * SizeConfig.heightMultiplier,
                    horizontal: 2.5 * SizeConfig.widthMultiplier,
                  ),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => profilePicView(
                          postSnap: postSnap,
                          callSnap: callSnap,
                          chatSnap: chatSnap,
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
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Visibility(
                                visible: widget.newMessages > 0 ? true : false,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: kPrimaryGradientColor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 3,
                                    ),
                                    child: Center(
                                      child: Text("${widget.newMessages}", style: TextStyle(
                                          fontFamily: "Brand-Regular",
                                          color: Colors.white
                                      ),),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                      Container(
                        height: 6 * SizeConfig.heightMultiplier,
                        width: 55 * SizeConfig.widthMultiplier,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(widget.isDoctor == true ? widget.userName : "Dr. " + widget.userName, style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: "Brand Bold",
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                            ), overflow: TextOverflow.ellipsis,),
                            LastMessageContainer(
                              stream: databaseMethods.fetchLastMessageBetween(chatRoomId: widget.chatRoomId,),
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
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Icon(
                              CupertinoIcons.video_camera_solid,
                              color: Color(0xFFa81845),
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
                      ),
                    ],
                  ),
                ),
              ),
          ),
        ),
    );
  }
}

goToVoiceCall(DatabaseMethods databaseMethods, String username, context, bool isDoctor, Activity activity) async {

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

        var activityMap = activity.toCallActivity(activity);
        CallUtils.voiceDialDoctor(to, from, context);
        databaseMethods.createDoctorActivity(activityMap, currentUser.uid);
      } else if (isDoctor == false) {
        Map<String, dynamic> fromMap;
        QuerySnapshot fromSnap;
        fromMap = await databaseMethods.doctorSnapToMap(username, fromSnap);

        Map<String, dynamic> toMap;
        QuerySnapshot toSnap;
        toMap = await databaseMethods.userSnapToMap(myName, toSnap);

        Doctor from = Doctor.fromMap(fromMap);
        myUser.User to = myUser.User.fromMap(toMap);

        var activityMap = activity.toCallActivity(activity);
        CallUtils.voiceDialUser(to, from, context);
        databaseMethods.createUserActivity(activityMap, currentUser.uid);
      }
    } catch (e) {
      print("Go To VideoChat Error ::: " + e.toString());
    }
  } else {
    displayToastMessage("Cannot Perform Operation", context);
  }


}

goToVideoChat(DatabaseMethods databaseMethods, String username, context, bool isDoctor, Activity activity) async {

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

        var activityMap = activity.toCallActivity(activity);
        CallUtils.videoDialDoctor(to, from, context);
        databaseMethods.createDoctorActivity(activityMap, currentUser.uid);
      } else if (isDoctor == false) {
        Map<String, dynamic> fromMap;
        QuerySnapshot fromSnap;
        fromMap = await databaseMethods.doctorSnapToMap(username, fromSnap);

        Map<String, dynamic> toMap;
        QuerySnapshot toSnap;
        toMap = await databaseMethods.userSnapToMap(myName, toSnap);

        Doctor from = Doctor.fromMap(fromMap);
        myUser.User to = myUser.User.fromMap(toMap);

        var activityMap = activity.toCallActivity(activity);
        CallUtils.videoDialUser(to, from, context);
        databaseMethods.createUserActivity(activityMap, currentUser.uid);
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
  const LastMessageContainer({Key key, @required this.stream}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data.docs;
          if (docList.isNotEmpty) {
            Message message = Message.fromMapLM(docList.last.data());
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: message.message.toLowerCase() == "Video".toLowerCase() ? true : false,
                  child: Icon(CupertinoIcons.play_rectangle_fill,
                    color: Color(0xFFa81845),
                    size: 4 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
                Visibility(
                  visible: message.message.toLowerCase() == "Image".toLowerCase() ? true : false,
                  child: Icon(CupertinoIcons.photo,
                    color: Color(0xFFa81845),
                    size: 4 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
                Visibility(
                  visible: message.message.toLowerCase() == "Audio".toLowerCase() ? true : false,
                  child: Icon(Icons.mic_rounded,
                    color: Color(0xFFa81845),
                    size: 4 * SizeConfig.imageSizeMultiplier,
                  ),
                ),

                SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(message.message, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Brand-Regular",
                      fontSize: 2 * SizeConfig.textMultiplier,
                    ),
                  ),
                ),
              ],
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

