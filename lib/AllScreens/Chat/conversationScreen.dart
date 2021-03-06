import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/Chat/cachedImage.dart';
import 'package:portfolio_app/AllScreens/Chat/messageCachedImage.dart';
import 'package:portfolio_app/AllScreens/Chat/chatScreen.dart';
import 'package:portfolio_app/AllScreens/Chat/soundPlayer.dart';
import 'package:portfolio_app/AllScreens/Chat/soundRecorder.dart';
import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:portfolio_app/AllScreens/VideoChat/videoViewPage.dart';
import 'package:portfolio_app/AllScreens/loginScreen.dart';
import 'package:portfolio_app/AllScreens/pdfViewerPage.dart';
import 'package:portfolio_app/AllScreens/pdfApi.dart';
import 'package:portfolio_app/Assistants/assistantMethods.dart';
import 'package:portfolio_app/Enum/viewState.dart';
import 'package:portfolio_app/Models/activity.dart';
import 'package:portfolio_app/Models/message.dart';
import 'package:portfolio_app/Models/notification.dart';
import 'package:portfolio_app/Provider/imageUploadProvider.dart';
import 'package:portfolio_app/Utilities/permissions.dart';
import 'package:portfolio_app/Utilities/utils.dart';
import 'package:portfolio_app/Widgets/customTile.dart';
import 'package:portfolio_app/Widgets/photoViewPage.dart';
import 'package:portfolio_app/Widgets/progressDialog.dart';
import 'package:portfolio_app/Widgets/timerWidget.dart';
import 'package:portfolio_app/constants.dart';
import 'package:portfolio_app/main.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
/*
* Created by Mujuzi Moses
*/

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String userName;
  final String profilePhoto;
  final bool isDoctor;
  const ConversationScreen({Key key, this.chatRoomId, this.userName, this.profilePhoto, this.isDoctor,}) : super(key: key);


  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  TimerController timerController = TimerController();
  SoundRecorder recorder = SoundRecorder();
  TextEditingController sendMessageTEC = new TextEditingController();
  ScrollController _listScrollController = new ScrollController();
  FocusNode textFieldFocus = new FocusNode();
  Stream chatMessageStream;
  ImageUploadProvider _imageUploadProvider;
  QuerySnapshot userSnap;
  QuerySnapshot mySnap;
  bool isWriting = false;
  bool isRecording = false;
  bool showEmojiPicker = false;
  String userUid = "";
  String myProfilePhoto = "";
  String status = "";
  int _messages = 0;
  bool isCreator = false;
  Stream chatStream;
  QuerySnapshot chatSnap;

  setWritingTo(bool val) {
    setState(() {
      isWriting = val;
    });
  }

  @override
  void initState() {
    if (!mounted) return;
    getInfo();
    recorder.init();
    super.initState();
  }

  @override
  void dispose() {
    recorder.dispose();
    assetsAudioPlayer.stop();
    assetsAudioPlayer = new AssetsAudioPlayer();
    super.dispose();
  }

  getInfo() async {
    assetsAudioPlayer.stop();
    assetsAudioPlayer = new AssetsAudioPlayer();
    await databaseMethods.getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });

    await databaseMethods.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatStream = val;
      });
    });
    chatSnap = await chatStream.first;
    for (int i = 0; i <= chatSnap.size -1; i++) {
      if (chatSnap.docs[i].get("chatroomId") == widget.chatRoomId) {
        setState(() {
          isCreator = chatSnap.docs[i].get("createdBy") == Constants.myName;
        });
        if (isCreator == true) {
          setState(() {
            _messages = int.parse(chatSnap.docs[i].get("sender_counter"));
            status = chatSnap.docs[i].get("receiver_status");
          });
        } else {
          setState(() {
            _messages = int.parse(chatSnap.docs[i].get("receiver_counter"));
            status = chatSnap.docs[i].get("sender_status");
          });
        }
      }
    }

    await databaseMethods.getUserByUsername(widget.userName).then((val) {
      setState(() {
        userSnap = val;
        userUid = userSnap.docs[0].get("uid");
      });
    });
    await databaseMethods.getUserByUsername(Constants.myName).then((val) {
      setState(() {
        mySnap = val;
        myProfilePhoto = mySnap.docs[0].get("profile_photo");
      });
    });
  }

  void _incrementMessages() async {
    _messages++;
    if (isCreator == true) {
      await databaseMethods.chatRoomCollection.doc(widget.chatRoomId).update({"sender_counter": "$_messages"});
    } else {
      await databaseMethods.chatRoomCollection.doc(widget.chatRoomId).update({"receiver_counter": "$_messages"});
    }
  }

  Widget chatMessageList() {
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   _listScrollController.animateTo(
    //     _listScrollController.position.minScrollExtent,
    //     duration: Duration(milliseconds: 250),
    //     curve: Curves.easeInOut,
    //   );
    // });

    return chatMessageStream != null ? StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? GroupedListView(
            padding: EdgeInsets.only(
              left: 2 * SizeConfig.widthMultiplier,
              right: 2 * SizeConfig.widthMultiplier,
              bottom: 1 * SizeConfig.heightMultiplier,
            ),
            reverse: true,
            elements: snapshot.data.docs,
            groupBy: (element) {
              Timestamp timeStr = element["time"];
              DateTime time = timeStr == null ? DateTime.now() : timeStr.toDate();
              if (Utils.formatDate(time) == Utils.formatDate(DateTime.now())) {
                return "Today";
              } else if (Utils.formatDate(time) == Utils.formatDate(DateTime.now().subtract(Duration(days: 1)))) {
                return "Yesterday";
              } else {
                return Utils.formatDate(time);
              }
            },
          groupComparator: (val1, val2) => val2.compareTo(val1),
          itemComparator: (item1, item2) =>
          item1["time"].compareTo(item2["time"]),
          useStickyGroupSeparators: false,
          stickyHeaderBackgroundColor: Colors.transparent,
          sort: false,
          groupSeparatorBuilder: (val) => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 36 * SizeConfig.widthMultiplier,
              vertical: 1 * SizeConfig.heightMultiplier,
            ),
            child: Container(
              height: 3 * SizeConfig.heightMultiplier,
              decoration: BoxDecoration(
                color: Color(0xFFa81845).withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(2, 3),
                    spreadRadius: 0.5,
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
              child: Center(
                child: Text(val, maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "Brand-Regular",
                    fontSize: 1.6 * SizeConfig.textMultiplier,
                    color: Colors.white,
                  ),),
              ),
            ),
          ),
            controller: _listScrollController,
            itemBuilder: (context, element) {
              var status = element["status"];
              var type = element["type"];
              Timestamp timeStr = element["time"];
              DateTime dateTime = timeStr == null ? DateTime.now() : timeStr.toDate();
              var time = Utils.formatTime(dateTime);
              var isSender = element["sendBy"] == Constants.myName;
              if (type == "image") {
                var message = element["photoUrl"];
                var size = element["size"];
                return ImageMessageTile(
                  status: status,
                  time: time,

                  isSender: isSender,
                  message: message,
                  chatRoomId: widget.chatRoomId,
                  size: size,
                );
              } else if (type == "audio") {
                var message = element["audioUrl"];
                var size = element["size"];
                return AudioMessageTile(
                  status: status,
                  time: time,
                  isSender: isSender,
                  message: message,
                  chatRoomId: widget.chatRoomId,
                  size: size,
                );
              } else if (type == "document") {
                var message = element["docUrl"];
                var size = element["size"];
                return DocumentMessageTile(
                  status: status,
                  time: time,
                  isSender: isSender,
                  message: message,
                  chatRoomId: widget.chatRoomId,
                  size: size,
                );
              } else if (type == "text") {
                var message = element["message"];
                return MessageTile(
                  status: status,
                  time: time,
                  isSender: isSender,
                  message: message,
                  chatRoomId: widget.chatRoomId,
                );
              } else if (type == "video") {
                var size = element["size"];
                var message = element["videoUrl"];
                List<int> intList = List<int>.from(element["thumbnail"]);
                return VideoMessageTile(
                  status: status,
                  time: time,
                  isSender: isSender,
                  message: message,
                  chatRoomId: widget.chatRoomId,
                  thumbnail: Uint8List.fromList(intList),
                  size: size,
                );
              } else {
                return Container();
              }
            },
          ) : Container();
      },
    ) : Container();
  }

  sendAudioMessage() {
    setState(() {
      isRecording = false;
      isWriting = false;
    });
    File selectedAudio = new File("/data/user/0/com.mujuzimoses.emalert/cache/$pathToSaveAudio");
    CustomNotification notification = CustomNotification.newMessage(
      createdAt: FieldValue.serverTimestamp(),
      type: "message",
      messageType: "audio",
      counter: "1",
      senderName: Constants.myName,
      senderPhoto: myProfilePhoto,
      senderUid: currentUser.uid,
      receiverUid: userUid,
      receiverPhoto: widget.profilePhoto,
      receiverName: widget.userName,
    );

    Activity activity = Activity.messageActivity(
      createdAt: FieldValue.serverTimestamp(),
      type: "message",
      messageType: "audio",
      receiver: widget.userName,
    );

    if (selectedAudio != null) {
      databaseMethods.uploadAudio(
        widget.chatRoomId,
        selectedAudio,
        Constants.myName,
        _imageUploadProvider,
        notification,
        activity,
        widget.isDoctor,
      );
      if (status == "offline") {
        _incrementMessages();
        notifyUser();
      }
    } else {}
  }

  sendMessage() {
    if (sendMessageTEC.text.isNotEmpty) {
      setState(() {
        isWriting = false;
      });
      assetsAudioPlayer = new AssetsAudioPlayer();
      assetsAudioPlayer.open(Audio("sounds/msg_sent.mp3"));
      assetsAudioPlayer.play();
      CustomNotification notification = CustomNotification.newMessage(
        createdAt: FieldValue.serverTimestamp(),
        type: "message",
        messageType: "text",
        counter: "1",
        senderName: Constants.myName,
        senderPhoto: myProfilePhoto,
        senderUid: currentUser.uid,
        receiverUid: userUid,
        receiverPhoto: widget.profilePhoto,
        receiverName: widget.userName,
      );

      Activity activity = Activity.messageActivity(
        createdAt: FieldValue.serverTimestamp(),
        type: "message",
        messageType: "text",
        receiver: widget.userName,
      );

      Message message = new Message(
        message: sendMessageTEC.text,
        sendBy: Constants.myName,
        status: "waiting",
        time: FieldValue.serverTimestamp(),
        type: "text",
      );

      var messageMap = message.toMap();

      databaseMethods.addConversationMessages(
        widget.chatRoomId,
        messageMap,
        notification,
        activity,
        widget.isDoctor,
      );
      if (status == "offline") {
        _incrementMessages();
        notifyUser();
      }
      sendMessageTEC.text = "";
    }
  }

  void notifyUser() async {
    QuerySnapshot snapshot;
    String token = "";
    await databaseMethods.getUserByUsername(widget.userName).then((val) {
      snapshot = val;
      token = snapshot.docs[0].get("token");
      if (token != null) {
        if (widget.isDoctor == true) {
          AssistantMethods.alertNewMessage(token, context, Constants.myName, currentUser.uid, myProfilePhoto, false, widget.chatRoomId);
        } else {
          AssistantMethods.alertNewMessage(token, context, Constants.myName, currentUser.uid, myProfilePhoto, true, widget.chatRoomId);
        }
      } else return;
    });
  }

  showKeyboard() => textFieldFocus.requestFocus();
  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);
    CustomNotification notification = CustomNotification.newMessage(
      createdAt: FieldValue.serverTimestamp(),
      type: "message",
      messageType: "image",
      counter: "1",
      senderName: Constants.myName,
      senderPhoto: myProfilePhoto,
      senderUid: currentUser.uid,
      receiverUid: userUid,
      receiverPhoto: widget.profilePhoto,
      receiverName: widget.userName,
    );

    Activity activity = Activity.messageActivity(
      createdAt: FieldValue.serverTimestamp(),
      type: "message",
      messageType: "image",
      receiver: widget.userName,
    );

    if (selectedImage != null) {
      databaseMethods.uploadImage(
        widget.chatRoomId,
        selectedImage,
        Constants.myName,
        _imageUploadProvider,
        notification,
        activity,
        widget.isDoctor,
      );
      if (status == "offline") {
        _incrementMessages();
        notifyUser();
      }
    } else {}
  }

  pickAudio() async {
    File selectedAudio = await Utils.pickAudio();
    CustomNotification notification = CustomNotification.newMessage(
      createdAt: FieldValue.serverTimestamp(),
      type: "message",
      messageType: "audio",
      counter: "1",
      senderName: Constants.myName,
      senderPhoto: myProfilePhoto,
      senderUid: currentUser.uid,
      receiverUid: userUid,
      receiverPhoto: widget.profilePhoto,
      receiverName: widget.userName,
    );

    Activity activity = Activity.messageActivity(
      createdAt: FieldValue.serverTimestamp(),
      type: "message",
      messageType: "audio",
      receiver: widget.userName,
    );

    if (selectedAudio != null) {
      databaseMethods.uploadAudio(
        widget.chatRoomId,
        selectedAudio,
        Constants.myName,
        _imageUploadProvider,
        notification,
        activity,
        widget.isDoctor,
      );
      if (status == "offline") {
        _incrementMessages();
        notifyUser();
      }
    } else {}
  }

  pickDocument() async {
    File selectedDoc = await Utils.pickDoc();
    CustomNotification notification = CustomNotification.newMessage(
      createdAt: FieldValue.serverTimestamp(),
      type: "message",
      messageType: "document",
      counter: "1",
      senderName: Constants.myName,
      senderPhoto: myProfilePhoto,
      senderUid: currentUser.uid,
      receiverUid: userUid,
      receiverPhoto: widget.profilePhoto,
      receiverName: widget.userName,
    );

    Activity activity = Activity.messageActivity(
      createdAt: FieldValue.serverTimestamp(),
      type: "message",
      messageType: "document",
      receiver: widget.userName,
    );

    if (selectedDoc != null) {
     databaseMethods.uploadDocument(
       widget.chatRoomId,
       selectedDoc,
       Constants.myName,
       _imageUploadProvider,
       notification,
       activity,
       widget.isDoctor,
     );
     if (status == "offline") {
       _incrementMessages();
       notifyUser();
     }
    } else {}
  }

  pickVideo({@required ImageSource source}) async {
    File selectedVideo = await Utils.pickVideo(source: source);
    CustomNotification notification = CustomNotification.newMessage(
      createdAt: FieldValue.serverTimestamp(),
      type: "message",
      messageType: "video",
      counter: "1",
      senderName: Constants.myName,
      senderPhoto: myProfilePhoto,
      senderUid: currentUser.uid,
      receiverUid: userUid,
      receiverPhoto: widget.profilePhoto,
      receiverName: widget.userName,
    );

    Activity activity = Activity.messageActivity(
      createdAt: FieldValue.serverTimestamp(),
      type: "message",
      messageType: "video",
      receiver: widget.userName,
    );

    if (selectedVideo != null) {
      databaseMethods.uploadVideo(
        widget.chatRoomId,
        selectedVideo,
        Constants.myName,
        _imageUploadProvider,
        notification,
        activity,
        widget.isDoctor,
      );
      if (status == "offline") {
        _incrementMessages();
        notifyUser();
      }
    } else {}
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  Future<bool> _onBackPressed() async {
    // Make sender_status/receiver_status Offline
    if (isCreator == true) {
      databaseMethods.chatRoomCollection.doc(widget.chatRoomId).update({"sender_status": "offline"});
    } else {
      databaseMethods.chatRoomCollection.doc(widget.chatRoomId).update({"receiver_status": "offline"});
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    SizeConfig().init(context);
    return
      WillPopScope(
        onWillPop: _onBackPressed,
        child: PickUpLayout(
            scaffold: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.grey[100],
                titleSpacing: 0,
                title: Container(
                  child: Row(
                    children: <Widget>[
                      CachedImage(
                          imageUrl: widget.profilePhoto,
                          isRound: true,
                          radius: 40,
                          fit: BoxFit.cover,
                        ),
                      SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                      Container(
                        height: 3.5 * SizeConfig.heightMultiplier,
                        width: 52 * SizeConfig.widthMultiplier,
                        child: Text(widget.isDoctor == false ? "Dr. " + widget.userName : widget.userName, style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontFamily: "Brand Bold",
                          color: Color(0xFFa81845),
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Container(
                      width: 8 * SizeConfig.widthMultiplier,
                      child: IconButton(
                        icon: Icon(CupertinoIcons.video_camera_solid, color: Color(0xFFa81845),),
                        onPressed: () async {
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
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 1 * SizeConfig.widthMultiplier,
                      vertical: 1.5 * SizeConfig.heightMultiplier,
                    ),
                    child: Container(
                       width: 8 * SizeConfig.widthMultiplier,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        gradient: kPrimaryGradientColor,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.phone_rounded,
                          color: Colors.white,
                          size: 5 * SizeConfig.imageSizeMultiplier,
                        ),
                        onPressed: () async {
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
                      ),
                    ),
                  ),
                ],
              ),
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.grey[100],
                child: Column(
                    children: <Widget>[
                      Flexible(
                          child: chatMessageList()
                      ),
                      _imageUploadProvider.getViewState == ViewState.LOADING
                          ? Container(
                        alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 15),
                        child: CircularProgressIndicator(),
                      )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 3 * SizeConfig.widthMultiplier,
                          left: 3 * SizeConfig.widthMultiplier,
                          bottom: 1 * SizeConfig.widthMultiplier,
                        ),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => addMediaModal(context),
                                child: Container(
                                  height: 4 * SizeConfig.heightMultiplier,
                                  width: 8 * SizeConfig.widthMultiplier,
                                  decoration: BoxDecoration(
                                    gradient: kPrimaryGradientColor,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Icon(Icons.add, color: Colors.white, size: 4.5 * SizeConfig.imageSizeMultiplier,),
                                ),
                              ),
                              SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                              Expanded(
                                    child: Stack(
                                      children: <Widget>[
                                        TextField(
                                        controller: sendMessageTEC,
                                        style: TextStyle(fontSize: 2.5 * SizeConfig.textMultiplier),
                                        focusNode: textFieldFocus,
                                        enabled: isRecording == true ? false : true,
                                        onTap: () => hideEmojiContainer(),
                                        decoration: InputDecoration(
                                          hintText: isRecording == true ? "" : "Type Message...",
                                          fillColor: Colors.grey[300],
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(
                                              const Radius.circular(50),
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding: EdgeInsets.only(
                                            left: 10 * SizeConfig.widthMultiplier,
                                            right: 3 * SizeConfig.widthMultiplier,
                                          ),
                                        ),
                                        onChanged: (val) {
                                          (val.length > 0 && val.trim() != "")
                                              ? setWritingTo(true)
                                              : setWritingTo(false);
                                        },
                                      ),
                                        isRecording == true
                                            ? Padding(
                                              padding: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier),
                                              child: Container(
                                                height: 4 * SizeConfig.heightMultiplier,
                                                width: 75 * SizeConfig.widthMultiplier,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    TimerWidget(controller: timerController,),
                                                    TextButton(
                                                      onPressed: () async {
                                                        assetsAudioPlayer.stop();
                                                        assetsAudioPlayer = new AssetsAudioPlayer();
                                                        assetsAudioPlayer.open(Audio("sounds/recording.mp3"));
                                                        assetsAudioPlayer.play();
                                                        await recorder.toggleRecording();
                                                        setState(() {
                                                          isRecording = recorder.isRecording;
                                                        });

                                                        if (isRecording == true) {
                                                          timerController.startTimer();
                                                        } else {
                                                          timerController.stopTimer();
                                                        }
                                                        displayToastMessage("Audio recording cancelled", context);
                                                      },
                                                      child: Text("Cancel".toUpperCase(), style: TextStyle(
                                                        color: Color(0xFFa81845),
                                                      ),),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            : IconButton(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onPressed: () {
                                            if (!showEmojiPicker) {
                                              hideKeyboard();
                                              showEmojiContainer();
                                            } else {
                                              hideEmojiContainer();
                                              showKeyboard();
                                            }
                                          },
                                          icon: showEmojiPicker
                                              ? Icon(Icons.keyboard_outlined, color: Color(0xFFa81845),)
                                              : Icon(Icons.emoji_emotions_outlined, color: Color(0xFFa81845),),
                                        ),
                                      ],
                                    ),
                              ),
                              SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                              isWriting == true || isRecording == true ? Container()
                                  : GestureDetector(
                                onTap: () async {
                                  assetsAudioPlayer.stop();
                                  assetsAudioPlayer = new AssetsAudioPlayer();
                                  assetsAudioPlayer.open(Audio("sounds/recording.mp3"));
                                  assetsAudioPlayer.play();
                                  await recorder.toggleRecording();
                                  setState(() {
                                    isRecording = recorder.isRecording;
                                  });

                                  if (isRecording == true) {
                                    timerController.startTimer();
                                  } else {
                                    timerController.stopTimer();
                                  }
                                },
                                    child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(Icons.mic_rounded, color: Color(0xFFa81845),),
                              ),
                                  ),
                              isWriting || isRecording ? Container()
                                  : FocusedMenuHolder(
                                blurSize: 0,
                                //blurBackgroundColor: Colors.transparent,
                                duration: Duration(milliseconds: 500),
                                menuWidth: MediaQuery.of(context).size.width * 0.3,
                                menuItemExtent: 40,
                                onPressed: () {
                                  displayToastMessage("Tap & Hold to make selection", context);
                                },
                                menuItems: <FocusedMenuItem>[
                                  FocusedMenuItem(title: Text("Record", style: TextStyle(
                                      color: Color(0xFFa81845), fontWeight: FontWeight.w500),),
                                      onPressed: () async =>
                                      await Permissions.cameraAndMicrophonePermissionsGranted() ?
                                      pickVideo(source: ImageSource.camera) : {},
                                      trailingIcon: Icon(Icons.videocam_outlined, color: Color(0xFFa81845),),
                                  ),
                                  FocusedMenuItem(title: Text("Capture", style: TextStyle(
                                      color: Color(0xFFa81845), fontWeight: FontWeight.w500),),
                                      onPressed: () async =>
                                      await Permissions.cameraAndMicrophonePermissionsGranted() ?
                                      pickImage(source: ImageSource.camera) : {},
                                      trailingIcon: Icon(Icons.camera, color: Color(0xFFa81845),),
                                  ),
                                ],
                                child: Icon(Icons.camera_alt_outlined, color: Color(0xFFa81845),),
                              ),
                              isWriting || isRecording ? GestureDetector(
                                onTap: () async {
                                  if (isWriting) {
                                    sendMessage();
                                  }
                                  if (isRecording) {
                                    sendAudioMessage();
                                    await recorder.toggleRecording();
                                    timerController.stopTimer();
                                  }
                                },
                                child: Container(
                                  height: 4 * SizeConfig.heightMultiplier,
                                  width: 8 * SizeConfig.widthMultiplier,
                                  decoration: BoxDecoration(
                                    gradient: kPrimaryGradientColor,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Icon(Icons.send_rounded, color: Colors.white, size: 4.5 * SizeConfig.imageSizeMultiplier,),
                                ),
                              ) : Container(),
                             ],
                          ),
                        ),
                      ),
                      showEmojiPicker ? Container(child: emojiContainer()) : Container(),
                    ],
                ),
              ),
            ),
          )
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: Colors.grey[300],
      indicatorColor: Color(0xFFa81845),
      categoryIcons: CategoryIcons(
        recentIcon: CategoryIcon(icon: Icons.access_time_outlined, color: Colors.grey, selectedColor: Color(0xFFa81845)),
        smileyIcon: CategoryIcon(icon: Icons.emoji_emotions_outlined, color: Colors.grey, selectedColor: Color(0xFFa81845)),
        flagIcon: CategoryIcon(icon: Icons.flag, color: Colors.grey, selectedColor: Color(0xFFa81845)),
        objectIcon: CategoryIcon(icon: Icons.lightbulb, color: Colors.grey, selectedColor: Color(0xFFa81845)),
        activityIcon: CategoryIcon(icon: Icons.directions_run, color: Colors.grey, selectedColor: Color(0xFFa81845)),
        symbolIcon: CategoryIcon(icon: Icons.euro, color: Colors.grey, selectedColor: Color(0xFFa81845)),
        foodIcon: CategoryIcon(icon: Icons.cake, color: Colors.grey, selectedColor: Color(0xFFa81845)),
        animalIcon: CategoryIcon(icon: Icons.pets, color: Colors.grey, selectedColor: Color(0xFFa81845)),
        travelIcon: CategoryIcon(icon: Icons.apartment, color: Colors.grey, selectedColor: Color(0xFFa81845)),
      ),
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });
        sendMessageTEC.text = sendMessageTEC.text + emoji.emoji;
      },
    );
  }

  addMediaModal(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40)
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.grey[200],
        builder: (context) {
          return Container(
            height: 35 * SizeConfig.heightMultiplier,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 0.5 * SizeConfig.heightMultiplier),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Icon(Icons.close_rounded, color: Color(0xFFa81845),),
                      ),
                      Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Contents and Tools", style: TextStyle(
                              color: Color(0xFFa81845),
                              fontFamily: "Brand Bold",
                              fontSize: 3 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                    child: ListView(
                      children: <Widget>[
                        ModalTile(
                          title: "Photo Gallery",
                          subTitle: "Share Photos from Gallery",
                          icon: Icons.image_outlined,
                          onTap: () async =>
                          await Permissions.cameraAndMicrophonePermissionsGranted() ?
                          pickImage(source: ImageSource.gallery) : {},
                        ),
                         ModalTile(
                          title: "Audio",
                          subTitle: "Share Audio and Voice notes",
                          icon: Icons.headset_outlined,
                           onTap: () async =>
                           await Permissions.cameraAndMicrophonePermissionsGranted() ?
                           pickAudio() : {},
                        ),
                         ModalTile(
                          title: "Video Gallery",
                          subTitle: "Share Videos from Gallery",
                          icon: Icons.video_library_outlined,
                           onTap: () async =>
                           await Permissions.cameraAndMicrophonePermissionsGranted() ?
                           pickVideo(source: ImageSource.gallery) : {},
                        ),
                         ModalTile(
                          title: "Document",
                          subTitle: "Share Documents",
                          icon: Icons.description_outlined,
                           onTap: () async =>
                           await Permissions.cameraAndMicrophonePermissionsGranted() ?
                           pickDocument() : {},
                        ),
                      ],
                    ),
                ),
              ],
            ),
          );
        }
    );
  }
}

class VideoMessageTile extends StatelessWidget {
  final dynamic message;
  final bool isSender;
  final String chatRoomId;
  final Uint8List thumbnail;
  final String size;
  final String status;
  final String time;
  const VideoMessageTile({Key key,
    this.message,
    this.isSender,
    this.chatRoomId,
    this.thumbnail,
    this.size,
    this.time,
    this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {

      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0.5 * SizeConfig.heightMultiplier),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 1 * SizeConfig.widthMultiplier,
                vertical: 0.5 * SizeConfig.heightMultiplier,
              ),
              decoration: BoxDecoration(
                gradient: isSender ? kPrimaryGradientColor : null,
                color: isSender ? null : Colors.black87,
                borderRadius: isSender
                    ?  BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(50),
                ) :  BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                  bottomLeft: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: isSender == true
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(time, style: TextStyle(
                    fontSize: 1.5 * SizeConfig.textMultiplier,
                    color: Colors.white70,
                  ),),
                  SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                  Stack(
                        children: <Widget>[
                          message != null
                              ? ClipRRect(
                            borderRadius: isSender
                                ?  BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(50),
                              bottomLeft: Radius.circular(5),
                            ) :  BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                              bottomLeft: Radius.circular(50),
                            ) ,
                                child: Image.memory(
                            thumbnail,
                            fit: BoxFit.fill,
                            height: 30 * SizeConfig.heightMultiplier,
                            width: 50 * SizeConfig.widthMultiplier,
                          ),
                              ) : Text("VideoUrl is null"),
                          Positioned(
                            top: 27 * SizeConfig.heightMultiplier,
                            left: isSender ? 2 * SizeConfig.widthMultiplier : 27 * SizeConfig.widthMultiplier,
                            child: Container(
                              height: 2 * SizeConfig.heightMultiplier,
                              width: 20 * SizeConfig.widthMultiplier,
                              decoration: BoxDecoration(
                                color: isSender ? Color(0xFFa81845) : Colors.black87,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: isSender
                                ? Center(child: Text(size, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),))
                                : Center(child: Text(size, style: TextStyle(color: Color(0xFFa81845), fontWeight: FontWeight.w500),)),
                            ),
                          ),
                          Positioned(
                            top: 11 * SizeConfig.heightMultiplier,
                            left: 18 * SizeConfig.widthMultiplier,
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VideoViewPage(
                                  message: message,
                                  isSender: isSender,
                                  chatRoomId: chatRoomId,
                                ),),
                              ),
                              child: Container(
                                height: 7 * SizeConfig.heightMultiplier,
                                width: 14 * SizeConfig.widthMultiplier,
                                decoration: BoxDecoration(
                                  color: isSender ? Color(0xFFa81845) : Colors.black87,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: isSender ? Colors.black87 : Color(0xFFa81845),
                                    size: 14 * SizeConfig.imageSizeMultiplier,),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                ],
              ),
            ),
            Visibility(
              visible: isSender == true ? true : false,
              child: status == "waiting" ? Container(
                child: Icon(Icons.done_rounded,
                  color: Colors.grey,
                  size: 3.5 * SizeConfig.imageSizeMultiplier,
                ),
              ) : Container(
                child: Icon(Icons.done_all_rounded,
                  color: Color(0xFFa81845),
                  size: 3.5 * SizeConfig.imageSizeMultiplier,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DocumentMessageTile extends StatelessWidget {
  final dynamic message;
  final bool isSender;
  final String chatRoomId;
  final String size;
  final String status;
  final String time;
  final bool isDoctor;
  const DocumentMessageTile({Key key, this.message, this.isSender, this.chatRoomId, this.size, this.isDoctor, this.time, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) => ProgressDialog(message: "Please wait...",),
        );
        int index = path.basename(message).indexOf("?");
        String msg = path.basename(message).substring(0, index);
        File file = await PDFApi.loadFirebase(msg);
        if (file == null) return;
        openPDF(context, file);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0.5 * SizeConfig.heightMultiplier),
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.60,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 1 * SizeConfig.widthMultiplier,
                vertical: 1 * SizeConfig.heightMultiplier,
              ),
              decoration: BoxDecoration(
                gradient: isSender ? kPrimaryGradientColor : null,
                color: isSender ? null : Colors.black87,
                borderRadius: isSender ? BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ) :
                BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: isSender == true
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(time, style: TextStyle(
                    fontSize: 1.5 * SizeConfig.textMultiplier,
                    color: Colors.white70,
                  ),),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 6 * SizeConfig.heightMultiplier,
                        width: 14 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          color: isSender ? Color(0xFFa81845).withOpacity(0.6) : Colors.grey[800],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Icon(CupertinoIcons.doc_fill,
                            color: Color(0xFFa81845),
                          ),
                        ),
                      ),
                      SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 40 * SizeConfig.widthMultiplier,
                            child: Text("siroDoc_${path.basename(message)}", maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Brand Bold",
                                fontSize: 2 * SizeConfig.textMultiplier,
                              ),),
                          ),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                          Container(
                            width: 40 * SizeConfig.widthMultiplier,
                            child: Row(
                              children: <Widget>[
                                Spacer(),
                                Container(
                                  height: 2.5 * SizeConfig.heightMultiplier,
                                  width: 20 * SizeConfig.widthMultiplier,
                                  child: isSender
                                      ? Center(child: Text("$size", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),))
                                      : Center(child: Text("$size", style: TextStyle(color: Color(0xFFa81845), fontWeight: FontWeight.w500),)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isSender == true ? true : false,
              child: status == "waiting" ? Container(
                child: Icon(Icons.done_rounded,
                  color: Colors.grey,
                  size: 3.5 * SizeConfig.imageSizeMultiplier,
                ),
              ) : Container(
                child: Icon(Icons.done_all_rounded,
                  color: Color(0xFFa81845),
                  size: 3.5 * SizeConfig.imageSizeMultiplier,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openPDF(BuildContext context, File file) {
    Navigator.pop(context);
    Navigator.push(
      context, MaterialPageRoute(
        builder: (context) => PDFViewerPage(file: file)
    ),
    );
  }
}

class AudioMessageTile extends StatefulWidget {
  final dynamic message;
  final bool isSender;
  final String chatRoomId;
  final String size;
  final String status;
  final String time;
  final bool isDoctor;
  const AudioMessageTile({Key key, this.message, this.isSender, this.chatRoomId, this.size, this.isDoctor, this.time, this.status,}) : super(key: key);

  @override
  _AudioMessageTileState createState() => _AudioMessageTileState();
}

class _AudioMessageTileState extends State<AudioMessageTile> {
  SoundPlayer player = SoundPlayer();
  bool isPlaying = false;
  int finalProgress = 0;
  IconData icon = CupertinoIcons.play_fill;
  TimerController timerController = TimerController();

  Duration duration;
  Timer timer;

  void startTimer() {
    reset();
    setState(() {
      timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
    });
  }

  void addTime() {
    final addSeconds = 1;

    setState(() {
      int seconds = duration.inSeconds + addSeconds;

      if (seconds < 0) {
        timer.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void reset() => setState(() => duration = Duration());

  void stopTimer() {
    reset();
    setState(() => timer.cancel());
  }

  @override
  void initState() {
    setState(() {
      player = new SoundPlayer(audioUrl: widget.message);
    });
    player.init();
    duration = Duration();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    duration = Duration();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5 * SizeConfig.heightMultiplier),
      alignment: widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.60,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 1 * SizeConfig.widthMultiplier,
              vertical: 1 * SizeConfig.heightMultiplier,
            ),
            decoration: BoxDecoration(
              gradient: widget.isSender ? kPrimaryGradientColor : null,
              color: widget.isSender ? null : Colors.black87,
              borderRadius: widget.isSender ? BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ) :
              BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: widget.isSender == true
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(widget.time, style: TextStyle(
                  fontSize: 1.5 * SizeConfig.textMultiplier,
                  color: Colors.white70,
                ),),
                Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            Duration d;
                            await player.togglePlaying(whenFinished: () {
                              setState(() {
                                icon = CupertinoIcons.play_fill;
                              });
                              timerController.stopTimer();
                              stopTimer();
                              player.refresh();
                            });
                            setState(() {
                              isPlaying = player.isPlaying;
                              d = player.d;
                              finalProgress = d.inSeconds;
                            });
                            if (isPlaying == true) {
                              setState(() {
                                icon = CupertinoIcons.stop_fill;
                              });
                              timerController.startTimer();
                              startTimer();
                            } else {
                              setState(() {
                                icon = CupertinoIcons.play_fill;
                              });
                              timerController.stopTimer();
                              stopTimer();
                            }
                          },
                          child: widget.isSender
                              ? Icon(icon, color: Colors.black87, size: 6 * SizeConfig.imageSizeMultiplier,)
                              : Icon(icon, color: Color(0xFFa81845), size: 6 * SizeConfig.imageSizeMultiplier,),
                        ),
                        SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                        Container(
                          clipBehavior: Clip.hardEdge,
                          height: 3,
                          width: 50 * SizeConfig.widthMultiplier,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: LinearProgressIndicator(
                            value: isPlaying == true ? duration.inSeconds / finalProgress : 0,
                            backgroundColor: Colors.white,
                            valueColor: widget.isSender
                                ? AlwaysStoppedAnimation<Color>(Color(0xFFa81845).withOpacity(0.6))
                                : AlwaysStoppedAnimation<Color>(Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        widget.isSender
                            ? TimerWidget(controller: timerController, height: 2.5 * SizeConfig.heightMultiplier,)
                            : TimerWidget(controller: timerController, height: 2.5 * SizeConfig.heightMultiplier, color: Colors.grey[800],),
                        Spacer(),
                        Container(
                          height: 2.5 * SizeConfig.heightMultiplier,
                          width: 20 * SizeConfig.widthMultiplier,
                          child: widget.isSender
                              ? Center(child: Text("${widget.size}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),))
                              : Center(child: Text("${widget.size}", style: TextStyle(color: Color(0xFFa81845), fontWeight: FontWeight.w500),)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: widget.isSender == true ? true : false,
            child: widget.status == "waiting" ? Container(
              child: Icon(Icons.done_rounded,
                color: Colors.grey,
                size: 3.5 * SizeConfig.imageSizeMultiplier,
              ),
            ) : Container(
              child: Icon(Icons.done_all_rounded,
                color: Color(0xFFa81845),
                size: 3.5 * SizeConfig.imageSizeMultiplier,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageMessageTile extends StatelessWidget {
  final dynamic message;
  final bool isSender;
  final String chatRoomId;
  final String size;
  final String status;
  final String time;
  final bool isDoctor;
  const ImageMessageTile({Key key, this.message, this.isSender, this.chatRoomId, this.isDoctor, this.size, this.time, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhotoViewPage(
                message: message,
                isSender: isSender,
                chatRoomId: chatRoomId,
              ),
        )),
        onLongPress: () {},
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 0.5 * SizeConfig.heightMultiplier),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.65,
          ),
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 1 * SizeConfig.widthMultiplier,
                  vertical: 0.5 * SizeConfig.heightMultiplier,
                ),
                decoration: BoxDecoration(
                  gradient: isSender ? kPrimaryGradientColor : null,
                  color: isSender ? null : Colors.black87,
                  borderRadius: isSender
                      ?  BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(50),
                  ) :  BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                    bottomLeft: Radius.circular(50),
                  ) ,
                ),
                child: Column(
                  crossAxisAlignment: isSender == true
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(time, style: TextStyle(
                      fontSize: 1.5 * SizeConfig.textMultiplier,
                      color: Colors.white70,
                    ),),
                    SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                    Stack(
                      children: <Widget>[
                        message != null
                            ? MessageCachedImage(
                          imageUrl: message,
                          isSender: isSender,
                          height: 30 * SizeConfig.heightMultiplier,
                          width: 50 * SizeConfig.widthMultiplier,
                          radius: 10,
                        )
                            : Text("PhotoUrl is null"),
                        Positioned(
                          top: 27 * SizeConfig.heightMultiplier,
                          left: isSender ? 2 * SizeConfig.widthMultiplier : 27 * SizeConfig.widthMultiplier,
                          child: Container(
                            height: 2 * SizeConfig.heightMultiplier,
                            width: 20 * SizeConfig.widthMultiplier,
                            decoration: BoxDecoration(
                              color: isSender ? Color(0xFFa81845) : Colors.black87,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: isSender
                                ? Center(child: Text(size, style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),))
                                : Center(child: Text(size, style: TextStyle(color: Color(0xFFa81845), fontWeight: FontWeight.w500),)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isSender == true ? true : false,
                child: status == "waiting" ? Container(
                  child: Icon(Icons.done_rounded,
                    color: Colors.grey,
                    size: 3.5 * SizeConfig.imageSizeMultiplier,
                  ),
                ) : Container(
                  child: Icon(Icons.done_all_rounded,
                    color: Color(0xFFa81845),
                    size: 3.5 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

class MessageTile extends StatelessWidget {
  final dynamic message;
  final bool isSender;
  final String chatRoomId;
  final String status;
  final String time;
  const MessageTile({Key key, this.message, this.isSender, this.chatRoomId, this.time, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0.5 * SizeConfig.heightMultiplier),
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.70,),
              padding: EdgeInsets.symmetric(
                horizontal: 2.5 * SizeConfig.widthMultiplier,
                vertical: 1 * SizeConfig.heightMultiplier,
              ),
              decoration: BoxDecoration(
                gradient: isSender ? kPrimaryGradientColor : null,
                color: isSender ? null : Colors.black87,
                borderRadius: isSender
                    ? BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
              ),
              child: Column(
                crossAxisAlignment: isSender == true
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(time, style: TextStyle(
                    fontSize: 1.5 * SizeConfig.textMultiplier,
                    color: Colors.white70,
                  ),),
                  SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                  Text(message, style: TextStyle(
                      fontSize: 2 * SizeConfig.textMultiplier,
                      color: Colors.white,
                    ),),
                ],
              ),
            ),
            Visibility(
              visible: isSender == true ? true : false,
              child: status == "waiting" ? Container(
                child: Icon(Icons.done_rounded,
                  color: Colors.grey,
                  size: 3.5 * SizeConfig.imageSizeMultiplier,
                ),
              ) : Container(
                child: Icon(Icons.done_all_rounded,
                  color: Color(0xFFa81845),
                  size: 3.5 * SizeConfig.imageSizeMultiplier,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Function onTap;
  const ModalTile({Key key,
    @required this.title,
    @required this.subTitle,
    @required this.icon,
    this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        onTap: onTap,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: kPrimaryGradientColor
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Colors.white,
            size: 5 * SizeConfig.imageSizeMultiplier,
          ),
        ),
        subTitle: Text(subTitle, style: TextStyle(
          color: Color(0xFFa81845).withOpacity(0.6),
          fontFamily: "Brand-Regular",
          fontSize: 1.5 * SizeConfig.textMultiplier,
        ),),
        title: Text(title, style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: "Brand Bold",
          color: Color(0xFFa81845),
          fontSize: 2 * SizeConfig.textMultiplier,
        ),),
      ),
    );
  }
}
