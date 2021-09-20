import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/Chat/messageCachedImage.dart';
import 'package:creativedata_app/AllScreens/Chat/chatScreen.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/VideoChat/videoViewPage.dart';
import 'package:creativedata_app/AllScreens/loginScreen.dart';
import 'package:creativedata_app/Enum/viewState.dart';
import 'package:creativedata_app/Models/message.dart';
import 'package:creativedata_app/Provider/imageUploadProvider.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Utilities/permissions.dart';
import 'package:creativedata_app/Utilities/utils.dart';
import 'package:creativedata_app/Widgets/customTile.dart';
import 'package:creativedata_app/Widgets/photoViewPage.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
/*
* Created by Mujuzi Moses
*/

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String userName;
  final String profilePhoto;
  final bool isDoctor;
  const ConversationScreen({Key key, this.chatRoomId, this.userName, this.profilePhoto, this.isDoctor}) : super(key: key);


  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  TextEditingController sendMessageTEC = new TextEditingController();
  ScrollController _listScrollController = new ScrollController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  FocusNode textFieldFocus = new FocusNode();
  Stream chatMessageStream;
  ImageUploadProvider _imageUploadProvider;
  bool isWriting = false;
  bool showEmojiPicker = false;

  setWritingTo(bool val) {
    setState(() {
      isWriting = val;
    });
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
        return snapshot.hasData ? ListView.builder(
            padding: EdgeInsets.only(
              left: 3 * SizeConfig.widthMultiplier,
              right: 3 * SizeConfig.widthMultiplier,
              bottom: 1 * SizeConfig.heightMultiplier,
            ),
            itemCount: snapshot.data.docs.length,
            reverse: true,
            controller: _listScrollController,
            itemBuilder: (context, index) {
              var type = snapshot.data.docs[index].get("type");
              if (type == "image") {
                return ImageMessageTile(
                  isSender: snapshot.data.docs[index].get("sendBy") == Constants.myName,
                  message: snapshot.data.docs[index].get("photoUrl"),
                  chatRoomId: widget.chatRoomId,
                );
              } else if (type == "text") {
                return MessageTile(
                  isSender: snapshot.data.docs[index].get("sendBy") == Constants.myName,
                  message: snapshot.data.docs[index].get("message"),
                  chatRoomId: widget.chatRoomId,
                );
              } else if (type == "video") {
                List<int> intList = List<int>.from(snapshot.data.docs[index].get("thumbnail"));
                return VideoMessageTile(
                  isSender: snapshot.data.docs[index].get("sendBy") == Constants.myName,
                  message: snapshot.data.docs[index].get("videoUrl"),
                  chatRoomId: widget.chatRoomId,
                  thumbnail: Uint8List.fromList(intList),
                  size: snapshot.data.docs[index].get("size"),
                );
              } else {
                return Container();
              }
            },
          ) : Container();
      },
    ) : Container();
  }

  sendMessage() {

    if (sendMessageTEC.text.isNotEmpty) {
      setState(() {
        isWriting = false;
      });
      Message message = new Message(
        message: sendMessageTEC.text,
        sendBy: Constants.myName,
        time: FieldValue.serverTimestamp(),
        type: "text",
      );

      var messageMap = message.toMap();
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      sendMessageTEC.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
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
    if (selectedImage != null) {
      databaseMethods.uploadImage(
        widget.chatRoomId,
        selectedImage,
        Constants.myName,
        _imageUploadProvider,
      );
    } else {}
  }

  pickVideo({@required ImageSource source}) async {
    File selectedVideo = await Utils.pickVideo(source: source);

    if (selectedVideo != null) {
      databaseMethods.uploadVideo(
        widget.chatRoomId,
        selectedVideo,
        Constants.myName,
        _imageUploadProvider,
      );
    } else {}
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    SizeConfig().init(context);
    return PickUpLayout(
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
                        color: Colors.red[300],
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
                      icon: Icon(CupertinoIcons.video_camera_solid, color: Colors.red[300],),
                      onPressed: () async =>
                      await Permissions.cameraAndMicrophonePermissionsGranted() ?
                      goToVideoChat(databaseMethods, widget.userName, context, widget.isDoctor,) : {},
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 2 * SizeConfig.widthMultiplier,
                  ),
                  child: Container(
                    width: 8 * SizeConfig.widthMultiplier,
                    child: IconButton(
                      icon: Icon(Icons.phone_rounded, color: Colors.red[300],),
                      onPressed: () async =>
                      await Permissions.cameraAndMicrophonePermissionsGranted() ?
                      goToVoiceCall(databaseMethods, widget.userName, context, widget.isDoctor,) : {},
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
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
                      bottom: 3 * SizeConfig.widthMultiplier,
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
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red[300],
                                    Colors.red[200],
                                  ],
                                ),
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
                                    onTap: () => hideEmojiContainer(),
                                    decoration: InputDecoration(
                                      hintText: "Type Message...",
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
                                    IconButton(
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
                                          ? Icon(Icons.keyboard_outlined, color: Colors.red[300],)
                                          : Icon(Icons.emoji_emotions_outlined, color: Colors.red[300],),
                                    ),
                                  ],
                                ),
                          ),
                          SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                          isWriting ? Container()
                              : GestureDetector(
                            onTap: () {},
                                child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(Icons.mic_rounded, color: Colors.red[300],),
                          ),
                              ),
                          isWriting ? Container()
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
                                  color: Colors.red[300], fontWeight: FontWeight.w500),),
                                  onPressed: () async =>
                                  await Permissions.cameraAndMicrophonePermissionsGranted() ?
                                  pickVideo(source: ImageSource.camera) : {},
                                  trailingIcon: Icon(Icons.videocam_outlined, color: Colors.red[300],),
                              ),
                              FocusedMenuItem(title: Text("Capture", style: TextStyle(
                                  color: Colors.red[300], fontWeight: FontWeight.w500),),
                                  onPressed: () async =>
                                  await Permissions.cameraAndMicrophonePermissionsGranted() ?
                                  pickImage(source: ImageSource.camera) : {},
                                  trailingIcon: Icon(Icons.camera, color: Colors.red[300],),
                              ),
                            ],
                            child: Icon(Icons.camera_alt_outlined, color: Colors.red[300],),
                          ),
                          isWriting ? GestureDetector(
                            onTap: () {
                              sendMessage();
                            },
                            child: Container(
                              height: 4 * SizeConfig.heightMultiplier,
                              width: 8 * SizeConfig.widthMultiplier,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red[300],
                                    Colors.red[200],
                                  ],
                                ),
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
              //),],
            ),
          ),
        );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: Colors.grey[300],
      indicatorColor: Colors.red[300],
      categoryIcons: CategoryIcons(
        recentIcon: CategoryIcon(icon: Icons.access_time_outlined, color: Colors.grey, selectedColor: Colors.red[300]),
        smileyIcon: CategoryIcon(icon: Icons.emoji_emotions_outlined, color: Colors.grey, selectedColor: Colors.red[300]),
        flagIcon: CategoryIcon(icon: Icons.flag, color: Colors.grey, selectedColor: Colors.red[300]),
        objectIcon: CategoryIcon(icon: Icons.lightbulb, color: Colors.grey, selectedColor: Colors.red[300]),
        activityIcon: CategoryIcon(icon: Icons.directions_run, color: Colors.grey, selectedColor: Colors.red[300]),
        symbolIcon: CategoryIcon(icon: Icons.euro, color: Colors.grey, selectedColor: Colors.red[300]),
        foodIcon: CategoryIcon(icon: Icons.cake, color: Colors.grey, selectedColor: Colors.red[300]),
        animalIcon: CategoryIcon(icon: Icons.pets, color: Colors.grey, selectedColor: Colors.red[300]),
        travelIcon: CategoryIcon(icon: Icons.apartment, color: Colors.grey, selectedColor: Colors.red[300]),
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
                          child: Icon(Icons.close_rounded, color: Colors.red[300],),
                      ),
                      Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Contents and Tools", style: TextStyle(
                              color: Colors.red[300],
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
                        ),
                         ModalTile(
                          title: "Location",
                          subTitle: "Share your Location",
                          icon: Icons.add_location_outlined,
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
  const VideoMessageTile({Key key,
    this.message,
    this.isSender,
    this.chatRoomId,
    this.thumbnail,
    this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0.5 * SizeConfig.heightMultiplier),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 1 * SizeConfig.widthMultiplier,
            vertical: 0.5 * SizeConfig.heightMultiplier,
          ),
          decoration: BoxDecoration(
            color: isSender ? Colors.red[300] : Colors.black87,
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
          child: Stack(
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
                        color: isSender ? Colors.red[300] : Colors.black87,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: isSender
                        ? Center(child: Text("$size MBs", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),))
                        : Center(child: Text("$size MBs", style: TextStyle(color: Colors.red[300], fontWeight: FontWeight.w500),)),
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
                          color: isSender ? Colors.red[300] : Colors.black87,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: isSender ? Colors.black87 : Colors. red[300],
                            size: 14 * SizeConfig.imageSizeMultiplier,),
                        ),
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

class ImageMessageTile extends StatelessWidget {
  final dynamic message;
  final bool isSender;
  final String chatRoomId;
  final bool isDoctor;
  const ImageMessageTile({Key key, this.message, this.isSender, this.chatRoomId, this.isDoctor}) : super(key: key);

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
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 1 * SizeConfig.widthMultiplier,
              vertical: 0.5 * SizeConfig.heightMultiplier,
            ),
            decoration: BoxDecoration(
              color: isSender ? Colors.red[300] : Colors.black87,
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
              ],
            ),
          ),
        ),
      );
  }
}


class MessageTile extends StatelessWidget {
  final dynamic message;
  final bool isSender;
  final String chatRoomId;
  const MessageTile({Key key, this.message, this.isSender, this.chatRoomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0.5 * SizeConfig.heightMultiplier),
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.70,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 2.5 * SizeConfig.widthMultiplier,
            vertical: 1 * SizeConfig.heightMultiplier,
          ),
          decoration: BoxDecoration(
            color: isSender ? Colors.red[300] : Colors.black87,
            borderRadius: isSender ? BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23),
            ) :
            BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23),
            ),
          ),
          child:Text(message, style: TextStyle(
              fontSize: 2 * SizeConfig.textMultiplier,
              color: Colors.white,
            ),),
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
            color: Colors.grey[300],
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Colors.red[300],
            size: 5 * SizeConfig.imageSizeMultiplier,
          ),
        ),
        subTitle: Text(subTitle, style: TextStyle(
          color: Colors.grey,
          fontFamily: "Brand-Regular",
          fontSize: 1.5 * SizeConfig.textMultiplier,
        ),),
        title: Text(title, style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: "Brand Bold",
          color: Colors.red[300],
          fontSize: 2 * SizeConfig.textMultiplier,
        ),),
      ),
    );
  }
}
