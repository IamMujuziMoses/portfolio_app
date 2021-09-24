import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/VideoChat/videoViewPage.dart';
import 'package:creativedata_app/AllScreens/bookAppointmentScreen.dart';
import 'package:creativedata_app/AllScreens/loginScreen.dart';
import 'package:creativedata_app/Doctor/postArticleScreen.dart';
import 'package:creativedata_app/Models/post.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Utilities/utils.dart';
import 'package:creativedata_app/Widgets/onlineIndicator.dart';
import 'package:creativedata_app/Widgets/photoViewPage.dart';
import 'package:creativedata_app/Widgets/progressDialog.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class NewsFeedScreen extends StatefulWidget {
  final String userName;
  final String userPic;
  final bool isDoctor;
  NewsFeedScreen({Key key, this.userName, this.userPic, this.isDoctor}) : super(key: key);

  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream allPostsStream;
  Stream myPostsStream;

  @override
  void initState() {
    getPosts();
    super.initState();
  }

  void getPosts() async {
    await databaseMethods.getPosts().then((val) {
      setState(() {
        allPostsStream = val;
      });
    });
    await databaseMethods.getPostByDoctorName(widget.userName).then((val) {
      myPostsStream = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.grey[100],
          title: Text("Siro News Feed", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Colors.red[300]
          ),),
        ),
        floatingActionButton: widget.isDoctor == true ? FloatingActionButton(
          backgroundColor: Colors.red[300],
          child: Icon(FontAwesomeIcons.edit, color: Colors.white,),
          onPressed: () => Navigator.push(
            context, MaterialPageRoute(
            builder: (context) => PostArticleScreen(
              userPic: widget.userPic,
              userName: widget.userName,
            ),
          ),
          ),
        ) : Container(),
        body: PostBody(
          allPostsStream: allPostsStream,
          myPostsStream: myPostsStream,
          userName: widget.userName,
          userPic: widget.userPic,
          isDoctor: widget.isDoctor,
        ),
      ),
    );
  }
}

Widget postsList({@required Stream postStream, String userName, String userPic, bool isDoctor}) {
  ScrollController _listScrollController = new ScrollController();

  return StreamBuilder(
    stream: postStream,
    builder: (context, snapshot) {
      return snapshot.hasData
          ? ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                height: 0.5 * SizeConfig.heightMultiplier,
              ),
              padding: EdgeInsets.only(bottom: 1 * SizeConfig.heightMultiplier),
              itemCount: snapshot.data.docs.length,
              controller: _listScrollController,
              itemBuilder: (context, index) {
                String type = snapshot.data.docs[index].get("type");
                Timestamp dateStr = snapshot.data.docs[index].get("time");
                String timeStr = Utils.formatTime(dateStr.toDate());
                String date = Utils.formatDate(dateStr.toDate());
                String time = "$date, $timeStr";
                String name = snapshot.data.docs[index].get("sender_name");
                String uid = snapshot.data.docs[index].get("uid");
                String userPic = snapshot.data.docs[index].get("sender_pic");
                int likes = snapshot.data.docs[index].get("like_counter");
                DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                String docId = documentSnapshot.id;
                if (type == "IMAGE") {
                  return ImagePostCard(
                    mainUserName: userName,
                    mainUserPic: userPic,
                    type: type,
                    time: time,
                    name: name,
                    uid: uid,
                    dateStr: dateStr,
                    userPic: userPic,
                    likes: likes,
                    docId: docId,
                    heading: snapshot.data.docs[index].get("heading"),
                    message: snapshot.data.docs[index].get("post_text"),
                    imageUrl: snapshot.data.docs[index].get("post_image_url"),
                    isDoctor: isDoctor,
                  );
                } else if (type == "TEXT") {
                  return TextPostCard(
                    mainUserName: userName,
                    mainUserPic: userPic,
                    type: type,
                    time: time,
                    name: name,
                    uid: uid,
                    docId: docId,
                    dateStr: dateStr,
                    userPic: userPic,
                    likes: likes,
                    isDoctor: isDoctor,
                    message: snapshot.data.docs[index].get("post_text"),
                    heading: snapshot.data.docs[index].get("heading"),
                  );
                } else if (type == "VIDEO") {
                  List<int> intList = List<int>.from(snapshot.data.docs[index].get("thumbnail"));
                  return VideoPostCard(
                    mainUserName: userName,
                    mainUserPic: userPic,
                    type: type,
                    time: time,
                    name: name,
                    uid: uid,
                    docId: docId,
                    dateStr: dateStr,
                    userPic: userPic,
                    likes: likes,
                    isDoctor: isDoctor,
                    heading: snapshot.data.docs[index].get("heading"),
                    message: snapshot.data.docs[index].get("post_text"),
                    thumbnail: Uint8List.fromList(intList),
                    videoUrl: snapshot.data.docs[index].get("post_video_url"),
                  );
                } else if (type == "SHARED") {
                  return SharePostCard(
                    type: type,
                    time: time,
                    name: name,
                    uid: uid,
                    heading: snapshot.data.docs[index].get("heading"),
                    message: snapshot.data.docs[index].get("post_text"),
                    userPic: userPic,
                    likes: likes,
                    docId: docId,
                  );
                } else {
                  return Container();
                }
              },
            )
          : Container();
    },
  );
}

class PostBody extends StatefulWidget {
  final String userName;
  final String userPic;
  final Stream allPostsStream;
  final Stream myPostsStream;
  final bool isDoctor;
  PostBody({Key key, this.allPostsStream, this.myPostsStream, this.userName, this.userPic, this.isDoctor}) : super(key: key);

  @override
  _PostBodyState createState() => _PostBodyState();
}

class _PostBodyState extends State<PostBody> {

  bool allVisible = true;
  bool myVisible = false;
  int selectedIndex = 0;

  changeIndex(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget button({String category, int index,}) {
    return RaisedButton(
        color: selectedIndex == index ? Colors.red[300] : Colors.white,
        splashColor: selectedIndex == index ? Colors.white : Colors.red[200],
        highlightColor: Colors.grey.withOpacity(0.1),
        textColor: selectedIndex == index ? Colors.white : Colors.red[300],
        child: Container(
          height: 4 * SizeConfig.heightMultiplier,
          width: 15 * SizeConfig.widthMultiplier,
          child: Center(
            child: Text(category, style: TextStyle(
              fontFamily: "Brand Bold",
              fontSize: 2 * SizeConfig.textMultiplier,
            ),),
          ),
        ),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15),
        ),
        onPressed: () {
          changeIndex(index);
          if (category == "All") {
            setState(() {
              allVisible = true;
              myVisible = false;
            });
          } else if (category == "My Posts") {
            setState(() {
              allVisible = false;
              myVisible = true;
            });
          }
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: Column(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Visibility(
                visible: allVisible,
                child: Positioned(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: widget.isDoctor == true ? 6 * SizeConfig.heightMultiplier : 0,
                      left: 1 * SizeConfig.widthMultiplier,
                      right: 1 * SizeConfig.widthMultiplier,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[100],
                      height: widget.isDoctor == true
                          ? 83.8 * SizeConfig.heightMultiplier
                          : 89.8 * SizeConfig.heightMultiplier,
                      child: postsList(
                        postStream: widget.allPostsStream,
                        userName: widget.userName,
                        userPic: widget.userPic,
                        isDoctor: widget.isDoctor,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: myVisible,
                child: Positioned(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: widget.isDoctor == true ? 6 * SizeConfig.heightMultiplier : 0,
                      left: 1 * SizeConfig.widthMultiplier,
                      right: 1 * SizeConfig.widthMultiplier,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: widget.isDoctor == true
                          ? 83.8 * SizeConfig.heightMultiplier
                          : 89.8 * SizeConfig.heightMultiplier,
                      color: Colors.grey[100],
                      child: postsList(
                        postStream: widget.myPostsStream,
                        userPic: widget.userPic,
                        userName: widget.userName,
                        isDoctor: widget.isDoctor,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.isDoctor == true ? true : false,
                child: Positioned(
                  child: Container(
                      height: 6 * SizeConfig.heightMultiplier,
                      width: 100 * SizeConfig.widthMultiplier,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          button(
                            index: 0,
                            category: "All",
                          ),
                          SizedBox(width: 4 * SizeConfig.widthMultiplier,),
                          button(
                            index: 1,
                            category: "My Posts",
                          ),
                        ],
                      ),
                    ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class SharePostCard extends StatefulWidget {
  final String mainUserName;
  final String mainUserPic;
  final String type;
  final String heading;
  final String message;
  final String time;
  final String docId;
  final String name;
  final String uid;
  final String userPic;
  final int likes;
  final int comments;
  SharePostCard({Key key, this.type, this.heading,this.name, this.userPic, this.likes,
    this.comments, this.time, this.docId, this.message, this.mainUserName, this.mainUserPic, this.uid,
  }) : super(key: key);

  @override
  _SharePostCardState createState() => _SharePostCardState();
}

class _SharePostCardState extends State<SharePostCard> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  int _likes = 0;
  int _comments = 0;
  IconData _icon = CupertinoIcons.suit_heart;
  QuerySnapshot likesSnap;
  String sharedType = "";
  String sharedUserName = "";
  String sharedUserPic = "";
  String sharedTime = "";
  String sharedText = "";
  String sharedHeading = "";
  String sharedImageUrl = "";
  String sharedVideoUrl = "";
  Uint8List sharedThumbnail;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  getInfo() async{
    QuerySnapshot sharedPost;
    await databaseMethods.getSharedPosts(widget.docId).then((val) {
      sharedPost = val;
    });
    Timestamp timestamp = sharedPost.docs[0].get("shared_time");
    sharedType = sharedPost.docs[0].get("shared_type");
    sharedHeading = sharedPost.docs[0].get("shared_heading");
    sharedUserName = sharedPost.docs[0].get("shared_user_name");
    sharedUserPic = sharedPost.docs[0].get("shared_user_pic");
    sharedText = sharedPost.docs[0].get("shared_text");
    sharedTime = Utils.formatTime(timestamp.toDate());
    setState(() {
      _likes = widget.likes;
      _comments = widget.comments;
      if (sharedType == "TEXT") {
        sharedText = sharedText;
        sharedHeading = sharedHeading;
        sharedImageUrl = "";
        sharedVideoUrl = "";
        sharedThumbnail = null;
      } else if (sharedType == "IMAGE") {
        sharedText = sharedText;
        sharedHeading = sharedHeading;
        sharedImageUrl = sharedPost.docs[0].get("shared_image_url");
        sharedVideoUrl = "";
        sharedThumbnail = null;
      } else if (sharedType == "VIDEO") {
        sharedText = sharedText;
        sharedHeading = sharedHeading;
        sharedImageUrl = "";
        sharedVideoUrl = sharedPost.docs[0].get("shared_video_url");
        List<int> intList = List<int>.from(sharedPost.docs[0].get("shared_thumbnail"));
        sharedThumbnail = Uint8List.fromList(intList);
      }
    });
    await databaseMethods.getLikesByName(widget.mainUserName, widget.docId).then((val) {
      likesSnap = val;
      if (likesSnap.docs.isNotEmpty) {
        setState(() {
          _icon = CupertinoIcons.suit_heart_fill;
        });
      }
    });
  }

  void _incrementLikes() async {
    if (_icon == CupertinoIcons.suit_heart) {
      setState(() {
        _likes++;
        _icon = CupertinoIcons.suit_heart_fill;
      });
      Like like = Like(
        name: widget.mainUserName,
        pic: widget.mainUserPic,
      );
      Map<String, dynamic> likeMap = like.toMap(like);
      await databaseMethods.updatePostDocField({"like_counter": _likes}, widget.docId);
      await databaseMethods.createLike(likeMap, widget.docId);
    } else if (_icon == CupertinoIcons.suit_heart_fill) {
      setState(() {
        _likes--;
        _icon = CupertinoIcons.suit_heart;
      });
      await databaseMethods.updatePostDocField({"like_counter": _likes}, widget.docId);
      await databaseMethods.deleteLike(widget.mainUserName, widget.docId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            spreadRadius: 0.5,
            blurRadius: 2,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: 8, bottom: 8, left: 8
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    CachedImage(
                    imageUrl: widget.userPic,
                    isRound: true,
                    radius: 50,
                    fit: BoxFit.cover,
                  ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: OnlineIndicator(
                        uid: widget.uid,
                        isDoctor: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 2 * SizeConfig.widthMultiplier),
                Container(
                  height: 5 * SizeConfig.heightMultiplier,
                  width: 60 * SizeConfig.widthMultiplier,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Dr. ${widget.name}", style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                      ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(widget.time, style: TextStyle(
                        fontFamily: "Brand Bold",
                        color: Colors.grey[400],
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Visibility(
                  visible: widget.type == "SHARED" ? true : false,
                  child: Container(
                    height: 4 * SizeConfig.heightMultiplier,
                    width: 10 * SizeConfig.widthMultiplier,
                    child: Center(
                      child: Icon(CupertinoIcons.arrowshape_turn_up_right_fill,
                        color: Colors.grey[400],
                        size: 6 * SizeConfig.imageSizeMultiplier,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              width: 93 * SizeConfig.widthMultiplier,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(widget.heading != null ? widget.heading : "",
                  maxLines: 4,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 2.5 * SizeConfig.textMultiplier,
                    fontFamily: "Brand-Regular",
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4 * SizeConfig.widthMultiplier),
            child: Container(
              clipBehavior: Clip.hardEdge,
              width: 93 * SizeConfig.widthMultiplier,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.withOpacity(0.5),
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[100],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 8, bottom: 8, left: 8
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CachedImage(
                            imageUrl: sharedUserPic,
                            isRound: true,
                            radius: 45,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 2 * SizeConfig.widthMultiplier),
                          Container(
                            height: 5 * SizeConfig.heightMultiplier,
                            width: 45 * SizeConfig.widthMultiplier,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Dr. $sharedUserName", style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontFamily: "Brand Bold",
                                  fontSize: 2.3 * SizeConfig.textMultiplier,
                                ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(sharedTime, style: TextStyle(
                                  fontFamily: "Brand Bold",
                                  decoration: TextDecoration.none,
                                  color: Colors.grey[400],
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(sharedType == "TEXT" ? "" : sharedHeading,
                            maxLines: 4,
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontSize: 2 * SizeConfig.textMultiplier,
                              fontFamily: "Brand-Regular",
                            ),
                          ),
                        ),
                      ),
                    Visibility(
                      visible: sharedType == "IMAGE" ? true : false,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        height: 40 * SizeConfig.heightMultiplier,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[400],
                        ),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoViewPage(
                                  message: sharedImageUrl,
                                  isSender: true,
                                ),
                              )),
                          child: CachedImage(
                            imageUrl: sharedImageUrl,
                            radius: 0,
                            isRound: false,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                     Visibility(
                      visible: sharedType == "VIDEO" ? true : false,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        height: 40 * SizeConfig.heightMultiplier,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[400],
                        ),
                        child: Stack(
                          children: <Widget>[
                            sharedType == "VIDEO" ? Image.memory(
                              sharedThumbnail,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ) : Container(),
                            Positioned(
                              top: 17 * SizeConfig.heightMultiplier,
                              left: 32 * SizeConfig.widthMultiplier,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => VideoViewPage(
                                    message: sharedVideoUrl,
                                    isSender: true,
                                  ),),
                                ),
                                child: Container(
                                  height: 7 * SizeConfig.heightMultiplier,
                                  width: 14 * SizeConfig.widthMultiplier,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.red[300],
                                      size: 14 * SizeConfig.imageSizeMultiplier,),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: sharedType == "TEXT" ? true : false,
                      child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: sharedType == "IMAGE" ? Container() : DescriptionText(
                            description: sharedText,
                            maxChar: 550,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: _likes == 0 && _comments == 0 ? 0 : 1 * SizeConfig.heightMultiplier,),
          Visibility(
            visible: _likes == 0 && _comments == 0 ? false : true,
            child: Container(
              height: 3 * SizeConfig.heightMultiplier,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(left: 4 * SizeConfig.widthMultiplier,),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_likes == 0 ? "" : "$_likes like(s)", style: TextStyle(
                      fontFamily: "Brand Bold",
                      fontSize: 2 * SizeConfig.textMultiplier,
                    ),),
                    Text(_comments == 0 ? "" : "$_comments comment(s)", style: TextStyle(
                      fontFamily: "Brand Bold",
                      fontSize: 1.5 * SizeConfig.textMultiplier,
                    ),),
                  ],
                ),
              ),
            ),
          ),
          Divider(thickness: 2,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10 * SizeConfig.widthMultiplier),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: _incrementLikes,
                  child: Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Icon(
                          _icon,
                          color: Colors.red[300],
                        ),
                        SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                        Text("Like", style: TextStyle(fontFamily: "Brand-Regular", color: Colors.red[300]),),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          CupertinoIcons.bubble_middle_bottom,
                          color: Colors.red[300],
                        ),
                        SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                        Text("Comment", style: TextStyle(fontFamily: "Brand-Regular", color: Colors.red[300]),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
        ],
      ),
    );
  }
}

class ShareScreen extends StatefulWidget {
  final String userName;
  final String userPic;
  final String type;
  final String message;
  final String heading;
  final String shareTime;
  final String shareUserPic;
  final String shareName;
  final String shareImageUrl;
  final String shareVideoUrl;
  final Uint8List shareThumbnail;
  final dateStr;
  ShareScreen({Key key,
    this.type, this.shareUserPic, this.shareName, this.shareImageUrl, this.shareThumbnail,
    this.message, this.heading, this.shareTime, this.dateStr, this.userName,
    this.userPic, this.shareVideoUrl}) : super(key: key);

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController headingTEC = TextEditingController();

  Future<bool> _onBackPressed() async {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Discard Post?"),
          actions: <Widget>[
            FlatButton(
              child: Text("No"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: PickUpLayout(
        scaffold: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: Colors.grey[200],
            title: Text("Share Post", style: TextStyle(fontFamily: "Brand Bold", color: Colors.red[300]),),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey[200],
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 5 * SizeConfig.heightMultiplier,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10,),
                    child: Container(
                      width: 95 * SizeConfig.widthMultiplier,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: headingTEC,
                        keyboardType: TextInputType.multiline,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: "Heading",
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
                ),
                Positioned(
                  top: 25 * SizeConfig.heightMultiplier,
                  left: 5 * SizeConfig.widthMultiplier,
                  child: Container(
                    width: 90 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(2, 3),
                          spreadRadius: 0.5,
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 8, bottom: 8, left: 8
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CachedImage(
                                imageUrl: widget.shareUserPic,
                                isRound: true,
                                radius: 50,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 2 * SizeConfig.widthMultiplier),
                              Container(
                                height: 5 * SizeConfig.heightMultiplier,
                                width: 45 * SizeConfig.widthMultiplier,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Dr. ${widget.shareName}", style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                      fontFamily: "Brand Bold",
                                      fontSize: 2.5 * SizeConfig.textMultiplier,
                                    ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(widget.shareTime, style: TextStyle(
                                      fontFamily: "Brand Bold",
                                      decoration: TextDecoration.none,
                                      color: Colors.grey[400],
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                    ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.type == "TEXT"
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 93 * SizeConfig.widthMultiplier,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(widget.heading, maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Brand Bold",
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                  ),),
                              ),
                            ),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                            Container(
                              width: 93 * SizeConfig.widthMultiplier,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(widget.message, maxLines: 6, textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Brand-Regular",
                                    fontSize: 2 * SizeConfig.textMultiplier
                                ),),
                              ),
                            ),

                          ],
                        )
                            : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  height: 15 * SizeConfig.heightMultiplier,
                                  width: 30 * SizeConfig.widthMultiplier,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey[600],
                                  ),
                                  child: widget.type == "IMAGE" ? CachedImage(
                                      imageUrl: widget.shareImageUrl,
                                      radius: 0,
                                      isRound: false,
                                      fit: BoxFit.cover,
                                    ) : Stack(
                                    children: <Widget>[
                                      Image.memory(
                                        widget.shareThumbnail,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                      Positioned(
                                        top: 5 * SizeConfig.heightMultiplier,
                                        left: 9 * SizeConfig.widthMultiplier,
                                        child: Container(
                                            height: 5 * SizeConfig.heightMultiplier,
                                            width: 10 * SizeConfig.widthMultiplier,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(30),
                                              border: Border.all(color: Colors.red[300]),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.play_arrow_rounded,
                                                color: Colors.red[300],
                                                size: 8 * SizeConfig.imageSizeMultiplier,),
                                            ),
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 60 * SizeConfig.widthMultiplier,
                                      child: Text(widget.heading, maxLines: 1, overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: "Brand Bold",
                                            fontSize: 2.5 * SizeConfig.textMultiplier,
                                          )),
                                    ),
                                    SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                    Container(
                                      width: 60 * SizeConfig.widthMultiplier,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(widget.message, maxLines: 6, textAlign: TextAlign.justify,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                          fontFamily: "Brand-Regular",
                                          fontSize: 2 * SizeConfig.textMultiplier,
                                        ),),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2 * SizeConfig.heightMultiplier,
                  right: 25 * SizeConfig.widthMultiplier,
                  child: RaisedButton(
                    onPressed: () => sharePost(context, firebaseAuth.currentUser.uid),
                    color: Colors.red[300],
                    splashColor: Colors.white,
                    highlightColor: Colors.red.withOpacity(0.1),
                    child: Container(
                      height: 5 * SizeConfig.heightMultiplier,
                      width: 40 * SizeConfig.widthMultiplier,
                      child: Center(
                        child: Text("Share", style: TextStyle(
                          fontFamily: "Brand Bold",
                          color: Colors.white,
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),),
                      ),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  sharePost(BuildContext context, String uid) {
    if (headingTEC.text.isEmpty) {
      displaySnackBar(message: "Please provide heading for this post", context: context, label: "OK");
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
      );

      Post post = Post.sharedPost(
        senderName: widget.userName,
        senderPic: widget.userPic,
        heading: headingTEC.text,
        type: "SHARED",
        time: FieldValue.serverTimestamp(),
        likeCounter: 0,
        uid: uid,
      );
      var sharedPostMap = post.toSharedMap(post);
      SharedPost sharedPost;
      if (widget.type == "TEXT") {
        sharedPost = new SharedPost.textPost(
          sharedUserName: widget.shareName,
          sharedUserPic: widget.shareUserPic,
          sharedType: widget.type,
          sharedText: widget.message,
          sharedHeading: widget.heading,
          sharedTime: widget.dateStr,
        );
        var sharedTextPostMap = sharedPost.toTextMap(sharedPost);
        databaseMethods.createSharedPost(sharedPostMap, sharedTextPostMap);
        Navigator.pop(context);
        Navigator.pop(context);

      } else if (widget.type == "IMAGE") {
        sharedPost = new SharedPost.imagePost(
          sharedUserName: widget.shareName,
          sharedUserPic: widget.shareUserPic,
          sharedType: widget.type,
          sharedTime: widget.dateStr,
          sharedText: widget.message,
          sharedHeading: widget.heading,
          sharedImageUrl: widget.shareImageUrl,
        );
        var sharedImagePostMap = sharedPost.toImageMap(sharedPost);
        databaseMethods.createSharedPost(sharedPostMap, sharedImagePostMap);
        Navigator.pop(context);
        Navigator.pop(context);

      } else if (widget.type == "VIDEO") {
        sharedPost = new SharedPost.videoPost(
          sharedUserName: widget.shareName,
          sharedUserPic: widget.shareUserPic,
          sharedType: widget.type,
          sharedTime: widget.dateStr,
          sharedThumbnail: widget.shareThumbnail,
          sharedText: widget.message,
          sharedHeading: widget.heading,
          sharedVideoUrl: widget.shareVideoUrl,
        );
        var sharedVideoPostMap = sharedPost.toVideoMap(sharedPost);
        databaseMethods.createSharedPost(sharedPostMap, sharedVideoPostMap);
        Navigator.pop(context);
        Navigator.pop(context);

      } else {
        displayToastMessage("Nothing to post", context);
        Navigator.pop(context);
        Navigator.pop(context);
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Center(
            child: Text("Shared Post", style: TextStyle(fontFamily: "Brand Bold"),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("OK", style: TextStyle(fontFamily: "Brand-Regular"),),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

}

class VideoPostCard extends StatefulWidget {
  final String mainUserName;
  final String mainUserPic;
  final String type;
  final String heading;
  final String message;
  final String priority;
  final String videoUrl;
  final String time;
  final String name;
  final String uid;
  final String userPic;
  final String docId;
  final int likes;
  final Uint8List thumbnail;
  final Timestamp dateStr;
  final bool isDoctor;
  VideoPostCard({Key key, this.videoUrl, this.thumbnail, this.priority, this.type, this.heading, this.time,
    this.name, this.userPic, this.likes, this.dateStr, this.mainUserName, this.mainUserPic, this.message, this.docId, this.isDoctor, this.uid,
  }) : super(key: key);

  @override
  _VideoPostCardState createState() => _VideoPostCardState();
}

class _VideoPostCardState extends State<VideoPostCard> {
  DatabaseMethods databaseMethods = DatabaseMethods();

  int _likes = 0;
  IconData _icon = CupertinoIcons.suit_heart;
  QuerySnapshot likesSnap;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  getInfo() async {
    setState(() {
      _likes = widget.likes;
    });
    await databaseMethods.getLikesByName(widget.mainUserName, widget.docId).then((val) {
      likesSnap = val;
      if (likesSnap.docs.isNotEmpty) {
        setState(() {
          _icon = CupertinoIcons.suit_heart_fill;
        });
      }
    });
  }

  void _incrementLikes() async {
    if (_icon == CupertinoIcons.suit_heart) {
      setState(() {
        _likes++;
        _icon = CupertinoIcons.suit_heart_fill;
      });
      Like like = Like(
        name: widget.mainUserName,
        pic: widget.mainUserPic,
      );
      Map<String, dynamic> likeMap = like.toMap(like);
      await databaseMethods.updatePostDocField({"like_counter": _likes}, widget.docId);
      await databaseMethods.createLike(likeMap, widget.docId);
    } else if (_icon == CupertinoIcons.suit_heart_fill) {
      setState(() {
        _likes--;
        _icon = CupertinoIcons.suit_heart;
      });
      await databaseMethods.updatePostDocField({"like_counter": _likes}, widget.docId);
      await databaseMethods.deleteLike(widget.mainUserName, widget.docId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            spreadRadius: 0.5,
            blurRadius: 2,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: 8, bottom: 8, left: 8
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    CachedImage(
                      imageUrl: widget.userPic,
                      isRound: true,
                      radius: 50,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: OnlineIndicator(
                        uid: widget.uid,
                        isDoctor: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 2 * SizeConfig.widthMultiplier),
                Container(
                  height: 5 * SizeConfig.heightMultiplier,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Dr. ${widget.name}", style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                      ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(widget.time, style: TextStyle(
                        fontFamily: "Brand Bold",
                        color: Colors.grey[400],
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                clipBehavior: Clip.hardEdge,
                height: 15 * SizeConfig.heightMultiplier,
                width: 30 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.withOpacity(0.5),
                ),
                child: Stack(
                  children: <Widget>[
                    Image.memory(
                      widget.thumbnail,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      top: 5 * SizeConfig.heightMultiplier,
                      left: 9 * SizeConfig.widthMultiplier,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VideoViewPage(
                            message: widget.videoUrl,
                            isSender: true,
                          ),),
                        ),
                        child: Container(
                          height: 5 * SizeConfig.heightMultiplier,
                          width: 10 * SizeConfig.widthMultiplier,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.red[300]),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.red[300],
                              size: 8 * SizeConfig.imageSizeMultiplier,),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 65 * SizeConfig.widthMultiplier,
                    child: Text(widget.heading, maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          fontFamily: "Brand Bold",
                        ),
                      ),
                  ),
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  Container(
                    width: 65 * SizeConfig.widthMultiplier,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DescriptionText(
                        description: widget.message,
                        maxChar: 160,
                      )
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: _likes == 0 ? 0 : 1 * SizeConfig.heightMultiplier,),
          Visibility(
            visible: _likes == 0 ? false : true,
            child: Container(
              height: 3 * SizeConfig.heightMultiplier,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(left: 4 * SizeConfig.widthMultiplier,),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_likes == 0 ? "" : "$_likes like(s)", style: TextStyle(
                      fontFamily: "Brand Bold",
                      fontSize: 2 * SizeConfig.textMultiplier,
                    ),),
                  ],
                ),
              ),
            ),
          ),
          Divider(thickness: 2,),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15 * SizeConfig.widthMultiplier,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: _incrementLikes,
                  child: Container(
                    child: Icon(
                          _icon,
                          color: Colors.red[300],
                        ),
                  ),
                ),
                // GestureDetector(
                //   onTap: () async {
                //     await DatabaseMethods().deletePost("VIDEO");
                //   },
                //   child: Container(
                //     child: Icon(CupertinoIcons.trash, color: Colors.red[300],),
                //   ),
                // ),
                widget.isDoctor == true ? GestureDetector(
                  onTap: () => Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => ShareScreen(
                      userPic: widget.mainUserPic,
                      userName: widget.mainUserName,
                      type: widget.type,
                      shareTime: widget.time,
                      dateStr: widget.dateStr,
                      shareThumbnail: widget.thumbnail,
                      message: widget.message,
                      shareName: widget.name,
                      shareUserPic: widget.userPic,
                      heading: widget.heading,
                      shareVideoUrl: widget.videoUrl
                    ),
                  ),
                  ),
                  child: Container(
                    child: Icon(
                          CupertinoIcons.arrowshape_turn_up_right,
                          color: Colors.red[300],
                        ),
                  ),
                ) : Spacer(),
              ],
            ),
          ),
          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
        ],
      ),
    );
  }
}

class TextPostCard extends StatefulWidget {
  final String mainUserName;
  final String mainUserPic;
  final String message;
  final String heading;
  final String type;
  final String time;
  final String name;
  final String uid;
  final String userPic;
  final String docId;
  final int likes;
  final Timestamp dateStr;
  final bool isDoctor;
  TextPostCard({Key key, this.message, this.type, this.time, this.name, this.userPic,
    this.likes, this.dateStr, this.mainUserName, this.mainUserPic, this.heading, this.docId, this.isDoctor, this.uid,
  }) : super(key: key);

  @override
  _TextPostCardState createState() => _TextPostCardState();
}

class _TextPostCardState extends State<TextPostCard> {
  DatabaseMethods databaseMethods = DatabaseMethods();

  int _likes = 0;
  IconData _icon = CupertinoIcons.suit_heart;
  QuerySnapshot likesSnap;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  getInfo() async {
    setState(() {
      _likes = widget.likes;
    });
    await databaseMethods.getLikesByName(widget.mainUserName, widget.docId).then((val) {
      likesSnap = val;
      if (likesSnap.docs.isNotEmpty) {
        setState(() {
          _icon = CupertinoIcons.suit_heart_fill;
        });
      }
    });
  }

  void _incrementLikes() async {
    if (_icon == CupertinoIcons.suit_heart) {
      setState(() {
        _likes++;
        _icon = CupertinoIcons.suit_heart_fill;
      });
      Like like = Like(
        name: widget.mainUserName,
        pic: widget.mainUserPic,
      );
      Map<String, dynamic> likeMap = like.toMap(like);
      await databaseMethods.updatePostDocField({"like_counter": _likes}, widget.docId);
      await databaseMethods.createLike(likeMap, widget.docId);
    } else if (_icon == CupertinoIcons.suit_heart_fill) {
      setState(() {
        _likes--;
        _icon = CupertinoIcons.suit_heart;
      });
      await databaseMethods.updatePostDocField({"like_counter": _likes}, widget.docId);
      await databaseMethods.deleteLike(widget.mainUserName, widget.docId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            spreadRadius: 0.5,
            blurRadius: 2,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: 8, bottom: 8, left: 8
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    CachedImage(
                      imageUrl: widget.userPic,
                      isRound: true,
                      radius: 50,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: OnlineIndicator(
                        uid: widget.uid,
                        isDoctor: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 2 * SizeConfig.widthMultiplier),
                Container(
                  height: 5 * SizeConfig.heightMultiplier,
                  width: 60 * SizeConfig.widthMultiplier,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Dr. ${widget.name}", style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                      ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(widget.time, style: TextStyle(
                        fontFamily: "Brand Bold",
                        color: Colors.grey[400],
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 93 * SizeConfig.widthMultiplier,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(widget.heading, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Brand Bold",
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                    ),),
                ),
              ),
              SizedBox(height: 1 * SizeConfig.heightMultiplier,),
              Container(
                width: 93 * SizeConfig.widthMultiplier,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DescriptionText(
                    description: widget.message,
                    maxChar: 160,
                  ),
                ),
              ),

            ],
          ),
          SizedBox(height: _likes == 0 ? 0 : 1 * SizeConfig.heightMultiplier,),
          Visibility(
            visible: _likes == 0 ? false : true,
            child: Container(
              height: 3 * SizeConfig.heightMultiplier,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 4 * SizeConfig.widthMultiplier,
                  right: 4 * SizeConfig.widthMultiplier,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_likes == 0 ? "" : "$_likes like(s)", style: TextStyle(
                      fontFamily: "Brand Bold",
                      fontSize: 2 * SizeConfig.textMultiplier,
                    ),),
                  ],
                ),
              ),
            ),
          ),
          Divider(thickness: 2,),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15 * SizeConfig.widthMultiplier,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: _incrementLikes,
                  child: Container(
                    child: Icon(
                          _icon,
                          color: Colors.red[300],
                        ),
                  ),
                ),
                widget.isDoctor == true ? GestureDetector(
                  onTap: () => Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => ShareScreen(
                      userPic: widget.mainUserPic,
                      userName: widget.mainUserName,
                      type: widget.type,
                      shareTime: widget.time,
                      dateStr: widget.dateStr,
                      message: widget.message,
                      heading: widget.heading,
                      shareName: widget.name,
                      shareUserPic: widget.userPic,
                    ),
                  ),
                  ),
                  child: Container(
                    child: Icon(
                          CupertinoIcons.arrowshape_turn_up_right,
                          color: Colors.red[300],
                        ),
                  ),
                ) : Spacer(),
              ],
            ),
          ),
          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
        ],
      ),
    );
  }
}

class ImagePostCard extends StatefulWidget {
  final String mainUserName;
  final String mainUserPic;
  final String imageUrl;
  final String type;
  final String heading;
  final String message;
  final String time;
  final String name;
  final String uid;
  final String userPic;
  final int likes;
  final String docId;
  final Timestamp dateStr;
  final bool isDoctor;
  ImagePostCard({Key key, this.imageUrl, this.type, this.heading, this.time, this.name,
    this.userPic, this.likes, this.dateStr, this.mainUserName, this.mainUserPic, this.message, this.docId, this.isDoctor, this.uid,
  }) : super(key: key);

  @override
  _ImagePostCardState createState() => _ImagePostCardState();
}

class _ImagePostCardState extends State<ImagePostCard> {
  DatabaseMethods databaseMethods = DatabaseMethods();

  int _likes = 0;
  IconData _icon = CupertinoIcons.suit_heart;
  QuerySnapshot likesSnap;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  getInfo() async {
    setState(() {
      _likes = widget.likes;
    });
    await databaseMethods.getLikesByName(widget.mainUserName, widget.docId).then((val) {
      likesSnap = val;
      if (likesSnap.docs.isNotEmpty) {
        setState(() {
          _icon = CupertinoIcons.suit_heart_fill;
        });
      }
    });
  }

  void _incrementLikes() async {
    if (_icon == CupertinoIcons.suit_heart) {
      setState(() {
        _likes++;
        _icon = CupertinoIcons.suit_heart_fill;
      });
      Like like = Like(
        name: widget.mainUserName,
        pic: widget.mainUserPic,
      );
      Map<String, dynamic> likeMap = like.toMap(like);
      await databaseMethods.updatePostDocField({"like_counter": _likes}, widget.docId);
      await databaseMethods.createLike(likeMap, widget.docId);
    } else if (_icon == CupertinoIcons.suit_heart_fill) {
      setState(() {
        _likes--;
        _icon = CupertinoIcons.suit_heart;
      });
      await databaseMethods.updatePostDocField({"like_counter": _likes}, widget.docId);
      await databaseMethods.deleteLike(widget.mainUserName, widget.docId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              spreadRadius: 0.5,
              blurRadius: 2,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: 8, bottom: 8, left: 8
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      CachedImage(
                        imageUrl: widget.userPic,
                        isRound: true,
                        radius: 50,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: OnlineIndicator(
                          uid: widget.uid,
                          isDoctor: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 2 * SizeConfig.widthMultiplier),
                  Container(
                    height: 5 * SizeConfig.heightMultiplier,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Dr. ${widget.name}", style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(widget.time, style: TextStyle(
                          fontFamily: "Brand Bold",
                          color: Colors.grey[400],
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  clipBehavior: Clip.hardEdge,
                  height: 15 * SizeConfig.heightMultiplier,
                  width: 30 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[600],
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoViewPage(
                            message: widget.imageUrl,
                            isSender: true,
                          ),
                        )),
                    child: CachedImage(
                      imageUrl: widget.imageUrl,
                      radius: 0,
                      isRound: false,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 65 * SizeConfig.widthMultiplier,
                      child: Text(widget.heading, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                      )),
                    ),
                    SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                    Container(
                        width: 65 * SizeConfig.widthMultiplier,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: DescriptionText(
                            description: widget.message,
                            maxChar: 160,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: _likes == 0 ? 0 : 1 * SizeConfig.heightMultiplier,),
            Visibility(
              visible: _likes == 0 ? false : true,
              child: Container(
                height: 3 * SizeConfig.heightMultiplier,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 4 * SizeConfig.widthMultiplier,
                    right: 4 * SizeConfig.widthMultiplier,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_likes == 0 ? "" : "$_likes like(s)", style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2 * SizeConfig.textMultiplier,
                      ),),
                    ],
                  ),
                ),
              ),
            ),
            Divider(thickness: 2,),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15 * SizeConfig.widthMultiplier,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: _incrementLikes,
                    child: Container(
                      child: Icon(_icon,
                        color: Colors.red[300],
                      ),
                    ),
                  ),
                  widget.isDoctor == true ? GestureDetector(
                    onTap: () => Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) => ShareScreen(
                        userPic: widget.mainUserPic,
                        userName: widget.mainUserName,
                        type: widget.type,
                        shareTime: widget.time,
                        dateStr: widget.dateStr,
                        shareImageUrl: widget.imageUrl,
                        shareName: widget.name,
                        shareUserPic: widget.userPic,
                        heading: widget.heading,
                        message: widget.message,
                      ),
                    ),
                    ),
                    child: Container(
                      child: Icon(
                            CupertinoIcons.arrowshape_turn_up_right,
                            color: Colors.red[300],
                          ),
                    ),
                  ) : Spacer(),
                ],
              ),
            ),
            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
          ],
        ),
      );

  }
}

class DescriptionText extends StatefulWidget {
  final String description;
  final int maxChar;
  DescriptionText({Key key, this.description, this.maxChar}) : super(key: key);

  @override
  _DescriptionTextState createState() => _DescriptionTextState();
}

class _DescriptionTextState extends State<DescriptionText> {

  String firstHalf;
  String secondHalf;
  bool flag = true;

  @override
  void initState() {
    super.initState();
    if (widget.description.length > widget.maxChar) {
      firstHalf = widget.description.substring(0, widget.maxChar);
      secondHalf = widget.description.substring(widget.maxChar, widget.description.length);
    } else {
      firstHalf = widget.description;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return secondHalf.isEmpty
        ? Text(
            firstHalf,
            maxLines: 1000,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: "Brand-Regular",
              fontSize: 2 * SizeConfig.heightMultiplier,
            ),
          )
        : Column(
            children: <Widget>[
              Text(
                flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                maxLines: 1000,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: "Brand-Regular",
                  fontSize: 2 * SizeConfig.heightMultiplier,
                ),
              ),
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      flag ? "show more" : "show less",
                      style: TextStyle(color: Colors.red[300], fontFamily: "Brand-Regular"),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    flag = !flag;
                  });
                },
              ),
            ],
          );
  }
}
