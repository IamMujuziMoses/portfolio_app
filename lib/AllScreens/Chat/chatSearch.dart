import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/Chat/cachedImage.dart';
import 'package:portfolio_app/AllScreens/Chat/chatScreen.dart';
import 'package:portfolio_app/AllScreens/Chat/conversationScreen.dart';
import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:portfolio_app/AllScreens/loginScreen.dart';
import 'package:portfolio_app/Models/activity.dart';
import 'package:portfolio_app/Utilities/permissions.dart';
import 'package:portfolio_app/Widgets/onlineIndicator.dart';
import 'package:portfolio_app/Widgets/progressDialog.dart';
import 'package:portfolio_app/constants.dart';
import 'package:portfolio_app/main.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class ChatSearch extends StatefulWidget {
  final bool isDoctor;
  final List users;
  const ChatSearch({Key key, this.isDoctor, this.users}) : super(key: key);
  @override
  _ChatSearchState createState() => _ChatSearchState();
}

class _ChatSearchState extends State<ChatSearch> {

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController searchTEC = TextEditingController();

  QuerySnapshot userSnap;
  String myProfilePhoto = "";
  List users = [];
  List userOnSearch = [];

  @override
  void initState() {
    getUsersList();
    super.initState();
  }

  getUsersList() async {
    await databaseMethods.getProfilePhoto().then((val) {
      setState(() {
        myProfilePhoto = val;
      });
    });
    setState(() {
      users = widget.users;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0,),
              child: Container(
                height: 20 * SizeConfig.heightMultiplier,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(18.0),
                      bottomRight: Radius.circular(18.0),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFa81845),
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 25.0, right: 20.0, bottom: 15.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 5.0),
                      Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back,
                              color: Color(0xFFa81845),
                            ),
                          ),
                          Center(
                            child: Text(
                              widget.isDoctor == true ? "Search User" : "Search Doctor",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Brand Bold",
                                color: Color(0xFFa81845),
                              ),),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0,),
                      Expanded(
                        child: Container(
                          height: 5 * SizeConfig.heightMultiplier,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                userOnSearch = users.where((element) => element.toLowerCase()
                                    .contains(value.toLowerCase())).toList();
                              });
                            },
                            controller: searchTEC,
                            maxLines: 1,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Search for ${widget.isDoctor == true ? "user" : "doctor"}...",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Brand-Regular",
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                              fontFamily: "Brand-Regular",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            searchTEC.text.isNotEmpty && userOnSearch.length > 0
                ? Container(
                  height: MediaQuery.of(context).size.height - 21.5 * SizeConfig.heightMultiplier,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[100],
                  child: ListView.builder(
                      itemCount: userOnSearch.length,
                      itemBuilder: (context, index) => SearchTile(
                          userName: userOnSearch[index],
                          isDoctor: widget.isDoctor,
                          myProfilePhoto: myProfilePhoto
                        ),
                    ),
                )
                : Container(),
          ],
        ),
      ),
    );
  }
}

goToChat(String username, String profilePhoto, bool isDoctor, String uid,
    String myProfilePhoto, BuildContext context) async {
  if (username != Constants.myName) {
    String chatRoomId = getChatRoomId(username: username, myName: Constants.myName);
    List<String> users = [username, Constants.myName];

    Map<String, dynamic> chartRoomMap = {
      "users" : users,
      "chatroomId" : chatRoomId,
      "sender_counter": "0",
      "sender_status": "online",
      "receiver_counter": "0",
      "receiver_status": "offline",
      "createdBy" : Constants.myName,
      "receiver_profile_photo" : profilePhoto,
      "sender_profile_photo" : myProfilePhoto,
      "receiver_uid": uid,
      "last_time": FieldValue.serverTimestamp(),
      "sender_uid": firebaseAuth.currentUser.uid,
    };
    databaseMethods.createChatRoom(chatRoomId, chartRoomMap);
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => ConversationScreen(
        isDoctor: isDoctor,
        chatRoomId: chatRoomId,
        userName: username,
        profilePhoto: profilePhoto,
      ),
    ));
  } else {
    displayToastMessage("Cannot perform Operation", context);
  }
}

class SearchTile extends StatefulWidget {
  final String userName;
  final String myProfilePhoto;
  final bool isDoctor;
  const SearchTile({Key key, this.userName, this.myProfilePhoto, this.isDoctor}) : super(key: key);

  @override
  _SearchTileState createState() => _SearchTileState();
}

class _SearchTileState extends State<SearchTile> {
  QuerySnapshot userSnap;
  String name = "";
  String profilePhoto = "";
  String email = "";
  String uid = "";


  getInfo() async {
    await databaseMethods.getUserByUsername(widget.userName).then((val) {
      setState(() {
        userSnap = val;
      });
    });
    name = userSnap.docs[0].get("name");
    profilePhoto = userSnap.docs[0].get("profile_photo");
    email = userSnap.docs[0].get("email");
    uid = userSnap.docs[0].get("uid");
  }

  @override
  Widget build(BuildContext context) {
    getInfo();
    return name == "" ? Padding(
      padding: EdgeInsets.symmetric(
        vertical: 1.5 * SizeConfig.heightMultiplier,
        horizontal: 1.5 * SizeConfig.heightMultiplier,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 4 * SizeConfig.heightMultiplier,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFa81845)),
          ),
        ),
      ),
    ) :
    Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 1.5 * SizeConfig.heightMultiplier,
          horizontal: 1.5 * SizeConfig.heightMultiplier,
        ),
        child: Row(
          children: <Widget>[
            Stack(
              children: <Widget>[
                CachedImage(
                  imageUrl: profilePhoto,
                  isRound: true,
                  radius: 45,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 0, bottom: 0,
                  child: OnlineIndicator(
                    uid: uid,
                    isDoctor: !widget.isDoctor,
                  ),
                ),
              ],
            ),
            SizedBox(width: 2 * SizeConfig.widthMultiplier,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 3 * SizeConfig.heightMultiplier,
                  width: 44 * SizeConfig.widthMultiplier,
                  child: Text(widget.isDoctor == false ? "Dr. " + name : name, style: TextStyle(
                    fontFamily: "Brand Bold",
                    fontSize: 2.3 * SizeConfig.textMultiplier,
                  ), overflow: TextOverflow.ellipsis,),
                ),
                Container(
                  height: 2 * SizeConfig.heightMultiplier,
                  width: 44 * SizeConfig.widthMultiplier,
                  child: Text(email, overflow: TextOverflow.ellipsis, style: TextStyle(
                    fontFamily: "Brand-Regular",
                    color: Colors.black54,
                  ),),
                ),
              ],
            ),
            Spacer(),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () =>
                      goToChat(name, profilePhoto, widget.isDoctor, uid,
                    widget.myProfilePhoto, context,
                  ),
                  child: Container(
                    height: 5 * SizeConfig.heightMultiplier,
                    width: 10 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.message_rounded,
                        size: 5 * SizeConfig.imageSizeMultiplier,
                        color: Color(0xFFa81845),
                      ),),
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
                      callType: "video",
                      receiver: name,
                    );
                    await Permissions.cameraAndMicrophonePermissionsGranted() ?
                    goToVideoChat(databaseMethods, name, context, widget.isDoctor, activity) : {};
                  },
                  child: Container(
                    height: 5 * SizeConfig.heightMultiplier,
                    width: 10 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                      gradient: kPrimaryGradientColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.video_camera_solid,
                        size: 5 * SizeConfig.imageSizeMultiplier,
                        color: Colors.white,
                      ),),
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
                      receiver: name,
                    );
                    await Permissions.cameraAndMicrophonePermissionsGranted() ?
                    goToVoiceCall(databaseMethods, name, context, widget.isDoctor, activity) : {};
                  },
                  child: Container(
                    height: 5 * SizeConfig.heightMultiplier,
                    width: 10 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.phone_rounded,
                        size: 5 * SizeConfig.imageSizeMultiplier,
                        color: Color(0xFFa81845),
                      ),),
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

getChatRoomId({String username, String myName, bool isVoiceCall}) {
  if (isVoiceCall == false) {
    if (username.substring(0,1).codeUnitAt(0) > myName.substring(0,1).codeUnitAt(0)) {
      return "$myName\_$username\_video";
    } else {
      return "$username\_$myName\_video";
    }
  } else {
    if (username.substring(0,1).codeUnitAt(0) > myName.substring(0,1).codeUnitAt(0)) {
      return "$myName\_$username";
    } else {
      return "$username\_$myName";
    }
  }
}