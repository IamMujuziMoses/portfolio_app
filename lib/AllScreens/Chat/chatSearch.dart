import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/Chat/chatScreen.dart';
import 'package:creativedata_app/AllScreens/Chat/conversationScreen.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/loginScreen.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Utilities/permissions.dart';
import 'package:creativedata_app/Widgets/onlineIndicator.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class ChatSearch extends StatefulWidget {
  final bool isDoctor;
  const ChatSearch({Key key, this.isDoctor}) : super(key: key);
  @override
  _ChatSearchState createState() => _ChatSearchState();
}

class _ChatSearchState extends State<ChatSearch> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController searchDocTEC = TextEditingController();

  QuerySnapshot searchSnapshot;
  String myProfilePhoto;

  initiateSearch() {
    databaseMethods.getUserByUsername(searchDocTEC.text).then((val) {
      setState(() {
        searchSnapshot = val;
        if (widget.isDoctor == true) {
          if (searchSnapshot.docs[0].get("regId") == "Doctor") {
            displayToastMessage("This is a Doctor not a User", context);
            searchSnapshot = null;
          }
        } else if (widget.isDoctor == false) {
          if (searchSnapshot.docs[0].get("regId") == "User") {
            displayToastMessage("This is a User not a Doctor", context);
            searchSnapshot = null;
          }
        }
      });
    });
    databaseMethods.getProfilePhoto().then((val) {
      myProfilePhoto = val;
    });
  }

  goToChat(String username, String profilePhoto, bool isDoctor, String uid) async {
    if (username != Constants.myName) {
      String chatRoomId = getChatRoomId(username, Constants.myName);
      List<String> users = [username, Constants.myName];

      Map<String, dynamic> chartRoomMap = {
        "users" : users,
        "chatroomId" : chatRoomId,
        "createdBy" : Constants.myName,
        "receiver_profile_photo" : profilePhoto,
        "sender_profile_photo" : myProfilePhoto,
        "receiver_uid": uid,
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

  Widget searchList() {
    return searchSnapshot != null ? ListView.builder(
      itemCount: searchSnapshot.docs.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index){
        return searchTile(
          userName: searchSnapshot.docs[index].get("name"),
          userEmail: searchSnapshot.docs[index].get("email"),
          profilePhoto: searchSnapshot.docs[index].get("profile_photo"),
          uid: searchSnapshot.docs[index].get("uid"),
        );
      },
    ) : Container();
  }

  Widget searchTile({String userName, String userEmail, String profilePhoto, String uid}) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
          left: 4 * SizeConfig.widthMultiplier,
          right: 4 * SizeConfig.widthMultiplier,
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
                  child: Text(widget.isDoctor == false ? "Dr. " + userName : userName, style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 2.3 * SizeConfig.textMultiplier,
                  ), overflow: TextOverflow.ellipsis,),
                ),
                Container(
                  height: 2 * SizeConfig.heightMultiplier,
                  width: 44 * SizeConfig.widthMultiplier,
                  child: Text(userEmail, overflow: TextOverflow.ellipsis,),
                ),
              ],
            ),
            Spacer(),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    /// this here
                    goToChat(userName, profilePhoto, widget.isDoctor, uid);
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
                          Icons.message_rounded,
                          size: 5 * SizeConfig.imageSizeMultiplier,
                          color: Colors.redAccent,
                        ),),
                  ),
                ),
                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                GestureDetector(
                  onTap: () async =>
                  await Permissions.cameraAndMicrophonePermissionsGranted() ?
                  goToVideoChat(databaseMethods, userName, context, widget.isDoctor) : {},
                  child: Container(
                    height: 5 * SizeConfig.heightMultiplier,
                    width: 10 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.video_camera_solid,
                        size: 5 * SizeConfig.imageSizeMultiplier,
                        color: Colors.redAccent,
                      ),),
                  ),
                ),
                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                GestureDetector(
                  onTap: () async =>
                  await Permissions.cameraAndMicrophonePermissionsGranted() ?
                  goToVoiceCall(databaseMethods, userName, context, widget.isDoctor) : {},
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
                        color: Colors.redAccent,
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0,),
              child: Container(
                height: 20 * SizeConfig.heightMultiplier,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(18.0), bottomRight: Radius.circular(18.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),

                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 25.0, right: 20.0, bottom: 15.0),
                  child: Column(
                    children: [
                      SizedBox(height: 5.0),
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.redAccent,
                            ),
                          ),
                          Center(
                            child: Text(widget.isDoctor == true ? "Search User" : "Search Doctor", style: TextStyle(
                              fontSize: 20.0, fontFamily: "Brand Bold",
                            ),),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0,),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(3.0),
                                child: TextField(
                                  controller: searchDocTEC,
                                  decoration: InputDecoration(
                                    hintText: widget.isDoctor == true ? "...User's Name" : "...Doctor's Name",
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                          GestureDetector(
                            onTap: () {
                              initiateSearch();
                            },
                            child: Container(
                              height: 4 * SizeConfig.heightMultiplier,
                              width: 8 * SizeConfig.widthMultiplier,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.redAccent,
                                    Colors.red[200],
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Icon(Icons.search_rounded, color: Colors.white, size: 4.5 * SizeConfig.imageSizeMultiplier,),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}