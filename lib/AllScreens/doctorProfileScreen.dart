import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/Chat/chatScreen.dart';
import 'package:creativedata_app/AllScreens/Chat/chatSearch.dart';
import 'package:creativedata_app/AllScreens/Chat/conversationScreen.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/bookAppointmentScreen.dart';
import 'package:creativedata_app/AllScreens/loginScreen.dart';
import 'package:creativedata_app/AllScreens/reviewsScreen.dart';
import 'package:creativedata_app/Doctor/doctorAccount.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Utilities/permissions.dart';
import 'package:creativedata_app/Widgets/photoViewPage.dart';
import 'package:creativedata_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../sizeConfig.dart';
/*
* Created by Mujuzi Moses
*/

class DoctorProfileScreen extends StatefulWidget {
  static const String screenId = "doctorProfileScreen";

  final String imageUrl;
  final String doctorsName;
  final String speciality;
  final String hospital;
  final String reviews;
  final String uid;
  final String doctorsEmail;
  final String about;
  final String doctorsAge;
  final String hours;
  final String phone;
  final String patients;
  final String experience;
  final List days;
  final Map fee;

  DoctorProfileScreen({Key key,
    this.imageUrl, this.doctorsName, this.speciality, this.hospital, this.reviews,
    this.uid, this.doctorsEmail, this.about, this.doctorsAge, this.hours,
    this.patients, this.experience, this.days, this.fee, this.phone,}) : super(key: key);

  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {

  DatabaseMethods databaseMethods = DatabaseMethods();
  String myName;
  String myProfilePic;

  void getUserInfo() async {
    myName = await databaseMethods.getName();
    myProfilePic = await databaseMethods.getProfilePhoto();
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
        scaffold: Scaffold(
          body: custom(
            isDoctor: true,
            body: _doctorBody(context),
            imageUrl: widget.imageUrl,
            doctorsName: widget.doctorsName,
            context: context,
          ),
        ),
      );
  }

  Widget _doctorBody(BuildContext context) {
    int idx = widget.hours.indexOf(":");
    String time = widget.hours.substring(0, idx+1).trim();
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 8,
          left: 2 * SizeConfig.widthMultiplier,
          right: 2 * SizeConfig.widthMultiplier,
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: 95 * SizeConfig.widthMultiplier,
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
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    specTile(
                      icon: FontAwesomeIcons.userMd,
                      title: widget.speciality,
                      width: 29 * SizeConfig.widthMultiplier,
                      textWidth: 20 * SizeConfig.widthMultiplier,
                    ),
                    SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                    specTile(
                      icon: FontAwesomeIcons.hospital,
                      title: widget.hospital,
                      width: 32 * SizeConfig.widthMultiplier,
                      textWidth: 23 * SizeConfig.widthMultiplier,
                    ),
                    SizedBox(width: 2.5 * SizeConfig.widthMultiplier,),
                    Container(
                      width: 28 * SizeConfig.widthMultiplier,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          circleIconButton(
                            color: Colors.red[300],
                            iconColor: Colors.white,
                            icon: CupertinoIcons.video_camera,
                            onTap: () async => await Permissions.cameraAndMicrophonePermissionsGranted()
                                ? goToVideoChat(databaseMethods, widget.doctorsName, context, false)
                                : {},
                          ),
                          circleIconButton(
                            color: Colors.white,
                            iconColor: Colors.red[300],
                            icon: Icons.phone_outlined,
                            onTap: () => launch(('tel:${widget.phone}')),
                          ),
                          circleIconButton(
                            color: Colors.white,
                            iconColor: Colors.red[300],
                            icon: CupertinoIcons.ellipses_bubble,
                            onTap: () {
                              if (widget.doctorsName != myName) {
                                String chatRoomId = getChatRoomId(widget.doctorsName, myName);
                                List<String> users = [widget.doctorsName, Constants.myName];

                                Map<String, dynamic> chartRoomMap = {
                                  "users" : users,
                                  "chatroomId" : chatRoomId,
                                  "createdBy" : myName,
                                  "receiver_profile_photo" : widget.imageUrl,
                                  "sender_profile_photo" : myProfilePic,
                                };
                                databaseMethods.createChatRoom(chatRoomId, chartRoomMap);
                                Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (context) => ConversationScreen(
                                    isDoctor: false,
                                    chatRoomId: chatRoomId,
                                    userName: widget.doctorsName,
                                    profilePhoto: widget.imageUrl,
                                  ),
                                ));
                              } else {
                                displayToastMessage("Cannot perform Operation", context);
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
            SizedBox(height: 2 * SizeConfig.heightMultiplier,),
            Padding(
              padding: EdgeInsets.only(
                left: 2 * SizeConfig.widthMultiplier,
                right: 2 * SizeConfig.widthMultiplier,
              ),
              child: Row(
                children: <Widget>[
                  _getDetails(widget.experience, "Experience"),
                  SizedBox(width: 3 * SizeConfig.widthMultiplier,),
                  _getDetails(widget.reviews, "Ratings"),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => ReviewsScreen()));
                    },
                    child: getReviews(widget.reviews, "See All Reviews"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3 * SizeConfig.heightMultiplier,),
            Padding(
              padding: EdgeInsets.only(
                left: 2 * SizeConfig.widthMultiplier,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Bio", style: TextStyle(
                      color: Colors.grey[700],
                      fontFamily: "Brand Bold",
                      fontWeight: FontWeight.bold,
                      fontSize: 3 * SizeConfig.textMultiplier,
                    ),),
                ],
              ),
            ),
            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
            Padding(
              padding: EdgeInsets.only(
                left: 2 * SizeConfig.widthMultiplier,
              ),
              child: getAbout(widget.about),
            ),
            SizedBox(height: 3 * SizeConfig.heightMultiplier,),
            Padding(
              padding: EdgeInsets.only(
                left: 2 * SizeConfig.widthMultiplier,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Appointment Hours", style: TextStyle(
                      color: Colors.grey[700],
                      fontFamily: "Brand Bold",
                      fontWeight: FontWeight.bold,
                      fontSize: 3 * SizeConfig.textMultiplier,
                    ),),
                ],
              ),
            ),
            SizedBox(height: 2 * SizeConfig.heightMultiplier,),
            Container(
              width: 100 * SizeConfig.widthMultiplier,
              child: Column(
                children: <Widget>[
                  getConsHours(widget.hours),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  getDays(widget.days),
                ],
              ),
            ),
            SizedBox(height: 5 * SizeConfig.heightMultiplier,),
            Padding(
              padding: EdgeInsets.only(
                left: 2 * SizeConfig.widthMultiplier,
                right: 2 * SizeConfig.widthMultiplier,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Consultation Fees", style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontFamily: "Brand Bold",
                    fontSize: 3 * SizeConfig.textMultiplier,
                  ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3 * SizeConfig.heightMultiplier,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4 * SizeConfig.widthMultiplier),
              child: Container(
                width: 95 * SizeConfig.widthMultiplier,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    specTile(
                      text: "In-Person",
                      title: widget.fee["in_person"],
                    ),
                    specTile(
                      icon: CupertinoIcons.videocam_fill,
                      title: widget.fee["video_call"],
                    ),
                    specTile(
                      icon: Icons.local_phone_rounded,
                      title: widget.fee["voice_call"],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 6 * SizeConfig.heightMultiplier,),
            Padding(
              padding: EdgeInsets.only(
                left: 4 * SizeConfig.widthMultiplier,
                right: 4 * SizeConfig.widthMultiplier,
                bottom: 2 * SizeConfig.heightMultiplier,
              ),
              child: RaisedButton(
                color: Colors.red[300],
                textColor: Colors.white,
                child: Container(
                  height: 4 * SizeConfig.heightMultiplier,
                  width: 60 * SizeConfig.widthMultiplier,
                  child: Center(
                    child: Text("Book an Appointment",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "Brand Bold",
                      ),
                    ),
                  ),
                ),
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25),
                ),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => BookAppointmentScreen(
                      time: time,
                      doctorsName: widget.doctorsName,
                      hospital: widget.hospital,
                      type: widget.speciality,
                    ))),
              ),
            ),
            SizedBox(height: 11 * SizeConfig.heightMultiplier,),
          ],
        ),
      ),
    );
  }

  _getDetails(String amount, String details) {
    return Column(
      children: <Widget>[
        Text(details, style: TextStyle(
          color: Colors.black,
          fontFamily: "Brand Bold",
          fontSize: 2 * SizeConfig.textMultiplier,
          fontWeight: FontWeight.bold,
        ),),
        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
        Container(
          height: 5 * SizeConfig.heightMultiplier,
          width: 16 * SizeConfig.widthMultiplier,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                offset: Offset(3, 5),
                spreadRadius: 1,
                blurRadius: 10,
                color: Colors.black.withOpacity(0.4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(4,),
            child: Center(
              child: Text(
                amount,
                style: TextStyle(
                  color: Colors.red[300],
                  fontFamily: "Brand Bold",
                  fontSize: 1.5 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget circleIconButton({Function onTap, Color color, Color iconColor, IconData icon}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 4 * SizeConfig.heightMultiplier,
      width: 8 * SizeConfig.widthMultiplier,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            offset: Offset(3, 5),
            spreadRadius: 1,
            blurRadius: 10,
            color: Colors.black.withOpacity(0.4),
          ),
        ],
      ),
      child: Icon(icon,
        color: iconColor,
        size: 4 * SizeConfig.imageSizeMultiplier,
      ),
    ),
  );
}

Widget actionButton({String action, IconData icon, Function onTap, Color color}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 7 * SizeConfig.heightMultiplier,
      width: 25 * SizeConfig.widthMultiplier,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 6.0,
            spreadRadius: 0.5,
            offset: Offset(0.7, 0.7),
          ),
        ],
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            Text(action, style: TextStyle(
              fontSize: 1.7 * SizeConfig.textMultiplier,
              fontFamily: "Brand-Regular",
              color: Colors.white,
            ),),
          ],
        ),
      ),
    ),
  );
}

Widget custom({@required Widget body, String doctorsName, imageUrl, BuildContext context, @required bool isDoctor}) {
  return CustomScrollView(
    slivers: <Widget>[
      SliverAppBar(
        backgroundColor: Colors.grey[100],
        expandedHeight: 350,
        floating: false,
        pinned: true,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(isDoctor == true ? "Dr. " + doctorsName : doctorsName, style: TextStyle(
            color: Colors.red[300],
            fontFamily: "Brand Bold",
            fontSize: 2.5 * SizeConfig.textMultiplier,
          ),),
          background: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoViewPage(
                    message: imageUrl,
                    isSender: isDoctor == true ? false : true,
                    doctorsName: doctorsName,
                  ),
                )),
            child: CachedImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              isRound: false,
              radius: 0,
            ),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Center(
          child: body,
        ),
      ),
    ],
  );
}
