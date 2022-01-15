import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/Chat/cachedImage.dart';
import 'package:portfolio_app/AllScreens/Chat/conversationScreen.dart';
import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:portfolio_app/AllScreens/VideoChat/videoView.dart';
import 'package:portfolio_app/AllScreens/bookAppointmentScreen.dart';
import 'package:portfolio_app/AllScreens/loginScreen.dart';
import 'package:portfolio_app/Models/activity.dart';
import 'package:portfolio_app/Models/notification.dart';
import 'package:portfolio_app/Models/post.dart';
import 'package:portfolio_app/Services/database.dart';
import 'package:portfolio_app/Utilities/permissions.dart';
import 'package:portfolio_app/Utilities/utils.dart';
import 'package:portfolio_app/Widgets/progressDialog.dart';
import 'package:portfolio_app/constants.dart';
import 'package:portfolio_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
/*
* Created by Mujuzi Moses
*/

class PostArticleScreen extends StatefulWidget {
  final String userName;
  final String userPic;
  const PostArticleScreen({Key key, this.userName, this.userPic}) : super(key: key);

  @override
  _PostArticleScreenState createState() => _PostArticleScreenState();
}

class _PostArticleScreenState extends State<PostArticleScreen> with TickerProviderStateMixin {

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController postTEC = TextEditingController();
  TextEditingController headingTEC = TextEditingController();
  TextEditingController messageTEC = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  double shareHeight = 35 * SizeConfig.heightMultiplier;
  double postWidth = 0;
  bool isWriting = false;
  bool imageVisible = false;
  bool videoVisible = false;
  bool messageVisible = false;
  bool textVisible = true;
  File videoFile;
  File photoFile;

  @override
  void initState() {
    super.initState();
  }

  setWritingTo(bool val) {
    setState(() {
      isWriting = val;
    });
    if (isWriting == true) {
      setState(() {
        postWidth = 15 * SizeConfig.widthMultiplier;
      });
    } else if (isWriting == false) {
      setState(() {
        postWidth = 0;
      });
    }
  }

  hideShareContainer() {
    setState(() {
      shareHeight = 0;
    });
  }
  hideMessageField() {
    if (imageVisible == true || videoVisible == true) {
      setState(() {
        messageVisible = false;
      });
    } else if (textVisible == true) {
      setState(() {
        shareHeight = 0;
      });
    }
  }

  Future<bool> _onBackPressed() async {
    if (isWriting == true) {
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
    } else if (imageVisible == true || videoVisible == true) {
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
                resetPage();
              },
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  resetPage() {
    setState(() {
      isWriting = false;
      postTEC.text = "";
      headingTEC.text = "";
      messageTEC.text = "";
      shareHeight = 35 * SizeConfig.heightMultiplier;
      postWidth = 0;
      imageVisible = false;
      videoVisible = false;
      messageVisible = false;
      textVisible = true;
      photoFile = null;
      videoFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    KeyboardVisibilityNotification().addNewListener(
        onHide: () {
          if (imageVisible == true || videoVisible == true) {
            setState(() {
              shareHeight = 0 * SizeConfig.heightMultiplier;
              messageVisible = true;
            });
          } else {
            setState(() {
              shareHeight = 35 * SizeConfig.heightMultiplier;
            });
          }
        }
    );
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: PickUpLayout(
        scaffold: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: Colors.grey[100],
            title: Text("Post Article", style: TextStyle(
                fontFamily: "Brand Bold",
                color: Color(0xFFa81845)
            ),),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => createPost(context, firebaseAuth.currentUser.uid),
                  //onTap: () => createAd(),
                  child: AnimatedSize(
                    vsync: this,
                    curve: Curves.bounceOut,
                    duration: new Duration(milliseconds: 400),
                    child: Container(
                      width: postWidth,
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradientColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Center(
                          child: Text("POST", style: TextStyle(
                            fontSize: 2.3 * SizeConfig.textMultiplier,
                            color: Colors.white,
                            fontFamily: "Brand-Regular",
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Container(
            color: Colors.grey[100],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.only(
                top: 10, left: 10, right: 10,
              ),
              child: Stack(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CachedImage(
                        imageUrl: widget.userPic,
                        isRound: true,
                        radius: 50,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 2 * SizeConfig.widthMultiplier),
                      Container(
                        height: 5 * SizeConfig.heightMultiplier,
                        width: 60 * SizeConfig.widthMultiplier,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Text("Dr. " + widget.userName, style: TextStyle(
                              fontFamily: "Brand Bold",
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 7 * SizeConfig.heightMultiplier,
                    child: Container(
                      width: 95 * SizeConfig.widthMultiplier,
                      child: Divider(thickness: 2,),
                    ),
                  ),
                  Positioned(
                    top: 10 * SizeConfig.heightMultiplier,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2 * SizeConfig.widthMultiplier),
                      child: Container(
                          width: 90 * SizeConfig.widthMultiplier,
                          child: TextField(
                            onTap: () => hideMessageField(),
                            controller: headingTEC,
                            keyboardType: TextInputType.multiline,
                            maxLines: 2,
                            minLines: 1,
                            decoration: InputDecoration(
                              hintText: "Heading",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Brand-Regular",
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
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
                    top: 20 * SizeConfig.heightMultiplier,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2 * SizeConfig.widthMultiplier),
                      child: Visibility(
                        visible: textVisible,
                        child: Container(
                          width: 90 * SizeConfig.widthMultiplier,
                          child: TextField(
                            onTap: () => hideShareContainer(),
                            controller: postTEC,
                            keyboardType: TextInputType.multiline,
                            maxLines: 16,
                            minLines: 12,
                            decoration: InputDecoration(
                              hintText: "Post Article",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Brand-Regular",
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            style: TextStyle(
                                fontSize: 2.5 * SizeConfig.textMultiplier, fontFamily: "Brand-Regular"),
                            onChanged: (val) {
                              (val.length > 0 && val.trim() != "")
                                  ? setWritingTo(true)
                                  : setWritingTo(false);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18 * SizeConfig.heightMultiplier,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1 * SizeConfig.widthMultiplier),
                      child: Visibility(
                        visible: imageVisible,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          height: 60 * SizeConfig.heightMultiplier,
                          width: 93 * SizeConfig.widthMultiplier,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[600],
                          ),
                          child: photoFile == null ? Container() : Image.file(
                            photoFile,
                            fit: BoxFit.cover,
                            errorBuilder: (context, url, error) => Image.asset("images/user_icon.png"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18 * SizeConfig.heightMultiplier,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1 * SizeConfig.widthMultiplier),
                      child: Visibility(
                        visible: videoVisible,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          height: 60 * SizeConfig.heightMultiplier,
                          width: 93 * SizeConfig.widthMultiplier,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[600],
                          ),
                          child: videoFile == null ? Container() : VideoView(
                            videoPlayerController: VideoPlayerController.file(videoFile),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0, right: 0, bottom: 10,
                    child: Padding(
                      padding: EdgeInsets.only(left: 4, right: 4,),
                      child: Visibility(
                        visible: messageVisible,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              controller: messageTEC,
                              keyboardType: TextInputType.multiline,
                              maxLines: 8,
                              minLines: 1,
                              decoration: InputDecoration(
                                hintText: "Type message",
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
                  ),
                  Positioned(
                    left: 0, right: 0, bottom: 0,
                    child: AnimatedSize(
                      vsync: this,
                      curve: Curves.bounceOut,
                      duration: Duration(microseconds: 800),
                      child: Padding(
                        padding: EdgeInsets.only(left: 4, right: 4,),
                        child: Container(
                          height: shareHeight,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFa81845),
                                blurRadius: 16.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7),
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 0.5 * SizeConfig.heightMultiplier,
                                  horizontal: 2 * SizeConfig.widthMultiplier,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Share",
                                    style: TextStyle(
                                      color: Color(0xFFa81845),
                                      fontFamily: "Brand Bold",
                                      fontSize: 3 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: ListView(
                                  children: <Widget>[
                                    ModalTile(
                                        title: "Photo Gallery",
                                        subTitle: "Share photos from the Gallery",
                                        icon: Icons.image_outlined,
                                        onTap: () async {
                                          bool granted = await Permissions
                                              .cameraAndMicrophonePermissionsGranted();
                                          setState(() {
                                            textVisible = false;
                                            messageVisible = true;
                                            imageVisible = true;
                                            shareHeight = 0;
                                            postWidth = 15 * SizeConfig.widthMultiplier;
                                          });
                                          if (granted) {
                                            await Utils.pickImage(source:ImageSource.gallery).then((val) {
                                              setState(() {
                                                photoFile = val;
                                              });
                                              if (val == null) {
                                                resetPage();
                                              }
                                            });
                                          }
                                        },
                                    ),
                                    ModalTile(
                                      title: "Capture Image",
                                      subTitle: "Share photos from the Camera",
                                      icon: Icons.camera_alt,
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
                                        );
                                        bool granted = await Permissions
                                            .cameraAndMicrophonePermissionsGranted();
                                        setState(() {
                                          textVisible = false;
                                          messageVisible = true;
                                          imageVisible = true;
                                          shareHeight = 0;
                                          postWidth = 15 * SizeConfig.widthMultiplier;
                                        });
                                        if (granted) {
                                          await Utils.pickImage(source: ImageSource.camera).then((val) {
                                            setState(() {
                                              photoFile = val;
                                            });
                                            Navigator.pop(context);
                                            if (val == null) {
                                              resetPage();
                                            }
                                          });
                                        }
                                      },
                                    ),
                                    ModalTile(
                                      title: "Video Gallery",
                                      subTitle: "Share videos from the Gallery",
                                      icon: Icons.video_library_outlined,
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
                                        );
                                        bool granted = await Permissions
                                            .cameraAndMicrophonePermissionsGranted();
                                        setState(() {
                                          textVisible = false;
                                          messageVisible = true;
                                          videoVisible = true;
                                          shareHeight = 0;
                                          postWidth = 15 * SizeConfig.widthMultiplier;
                                        });
                                        if (granted) {
                                          await Utils.pickVideo(source: ImageSource.gallery).then((val) {
                                            setState(() {
                                              videoFile = val;
                                            });
                                            Navigator.pop(context);
                                            if (val == null) {
                                              resetPage();
                                            }
                                          });
                                        }
                                      },
                                    ),
                                    ModalTile(
                                      title: "Record Video",
                                      subTitle: "Share videos from the Camera",
                                      icon: CupertinoIcons.videocam_circle_fill,
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
                                        );
                                        bool granted = await Permissions
                                            .cameraAndMicrophonePermissionsGranted();
                                        setState(() {
                                          textVisible = false;
                                          videoVisible = true;
                                          messageVisible = true;
                                          shareHeight = 0;
                                          postWidth = 15 * SizeConfig.widthMultiplier;
                                        });
                                        if (granted) {
                                          await Utils.pickVideo(source: ImageSource.camera).then((val) {
                                            setState(() {
                                              videoFile = val;
                                            });
                                            Navigator.pop(context);
                                            if (val == null) {
                                              resetPage();
                                            }
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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

  // createAd() async {
  //   if (videoVisible == true && videoFile != null) {
  //     String postVideoUrl = await databaseMethods.uploadVideoToStorage(videoFile);
  //     Map<String, dynamic> videoAdMap = {
  //       "adTitle": "Vaccination",
  //       "adType": "Video",
  //       "addesc": "Covid Vaccination will take place at New Mulago",
  //       "adfile": "C:\\fakepath\\Balance Sheet for Commercial Banks I A Level and IB Economics.mp4",
  //       "url": postVideoUrl,
  //     };
  //     await databaseMethods.createAd(videoAdMap);
  //
  //   } else if (imageVisible == true && photoFile != null) {
  //     String postImageUrl = await databaseMethods.uploadImageToStorage(photoFile);
  //     Map<String, dynamic> imageAdMap = {
  //       "adTitle": "Immunisation",
  //       "adType": "Image",
  //       "addesc": "Immunisation day",
  //       "adfile": "C:\\fakepath\\hos1.jpg",
  //       "url": postImageUrl,
  //     };
  //     await databaseMethods.createAd(imageAdMap);
  //   }
  // }

  createPost(BuildContext context, String uid) async {
    if (headingTEC.text.isEmpty) {
      displaySnackBar(message: "Please provide heading for the post", context: context, label: "OK");
    } else if ((imageVisible == true || videoVisible == true) && messageTEC.text.isEmpty) {
      displaySnackBar(message: "Please provide message for the post", context: context, label: "OK");
    }
    else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
      );

      Activity activity;

      String msg = "";
      if (imageVisible == true || videoVisible == true) {
        msg = messageTEC.text.trim();
      } else {
        msg = postTEC.text.trim();
      }

      CustomNotification notification = CustomNotification.newPost(
        createdAt: FieldValue.serverTimestamp(),
        type: "post",
        counter: "1",
        postText: msg,
        from: widget.userName,
        postHeading: headingTEC.text.trim(),
        heading: null,
        eventTitle: null,
        drugName: null,
        appType: null,
      );
      var notificationMap = notification.toPostNotification(notification);
      Post post;
      if (imageVisible == true && photoFile != null) {
        String postImageUrl = await databaseMethods.uploadFileToStorage(photoFile);
        post = new Post.imagePost(
          heading: headingTEC.text.trim(),
          postImageUrl: postImageUrl,
          senderName: widget.userName,
          senderPic: widget.userPic,
          type: "IMAGE",
          postText: messageTEC.text.trim(),
          time: FieldValue.serverTimestamp(),
          likeCounter: 0,
          shareCounter: 0,
          uid: uid,
        );
        activity = Activity.postActivity(
          createdAt: FieldValue.serverTimestamp(),
          type: "post",
          postHeading: headingTEC.text.trim(),
          postType: "image",
        );
        var activityMap = activity.toPostActivity(activity);
        await databaseMethods.createDoctorActivity(activityMap, currentUser.uid);
        var imagePostMap = post.toImageMap(post);
        await databaseMethods.createPost(imagePostMap);
        await databaseMethods.createNotification(notificationMap);
        Navigator.pop(context);

      } else if (videoVisible == true && videoFile != null) {
        Uint8List thumbnail = await Utils.generateThumbnail(videoFile);
        String postVideoUrl = await databaseMethods.uploadFileToStorage(videoFile);
        post = new Post.videoPost(
          heading: headingTEC.text.trim(),
          postVideoUrl: postVideoUrl,
          thumbnail: thumbnail,
          postText: messageTEC.text.trim(),
          senderName: widget.userName,
          senderPic: widget.userPic,
          type: "VIDEO",
          time: FieldValue.serverTimestamp(),
          likeCounter: 0,
          shareCounter: 0,
          uid: uid,
        );
        activity = Activity.postActivity(
          createdAt: FieldValue.serverTimestamp(),
          type: "post",
          postHeading: headingTEC.text.trim(),
          postType: "video",
        );
        var activityMap = activity.toPostActivity(activity);
        await databaseMethods.createDoctorActivity(activityMap, currentUser.uid);
        var videoPostMap = post.toVideoMap(post);
        await databaseMethods.createPost(videoPostMap);
        await databaseMethods.createNotification(notificationMap);
        Navigator.pop(context);

      } else if (postTEC.text.isNotEmpty) {
        post = new Post.textPost(
          postText: postTEC.text.trim(),
          heading: headingTEC.text.trim(),
          senderName: widget.userName,
          senderPic: widget.userPic,
          type: "TEXT",
          time: FieldValue.serverTimestamp(),
          likeCounter: 0,
          shareCounter: 0,
          uid: uid,
        );
        activity = Activity.postActivity(
          createdAt: FieldValue.serverTimestamp(),
          type: "post",
          postHeading: headingTEC.text.trim(),
          postType: "text",
        );
        var activityMap = activity.toPostActivity(activity);
        await databaseMethods.createDoctorActivity(activityMap, currentUser.uid);
        var textPostMap = post.toTextMap(post);
        await databaseMethods.createPost(textPostMap);
        await databaseMethods.createNotification(notificationMap);
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
            child: Text("Created Post", style: TextStyle(fontFamily: "Brand Bold"),
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
