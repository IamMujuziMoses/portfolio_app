import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/Chat/cachedImage.dart';
import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:portfolio_app/AllScreens/bookAppointmentScreen.dart';
import 'package:portfolio_app/AllScreens/doctorProfileScreen.dart';
import 'package:portfolio_app/AllScreens/loginScreen.dart';
import 'package:portfolio_app/AllScreens/registerScreen.dart';
import 'package:portfolio_app/AllScreens/reviewsScreen.dart';
import 'package:portfolio_app/Doctor/doctorRegistration.dart';
import 'package:portfolio_app/Models/activity.dart';
import 'package:portfolio_app/Utilities/permissions.dart';
import 'package:portfolio_app/Widgets/progressDialog.dart';
import 'package:portfolio_app/constants.dart';
import 'package:portfolio_app/main.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
/*
* Created by Mujuzi Moses
*/

class DoctorAccount extends StatefulWidget {
  static const String screenId = "doctorAccount";

  final String uid;
  final String name;
  final String speciality;
  final String userPic;
  final String email;
  final String about;
  final String age;
  final String hospital;
  final String hours;
  final String patients;
  final String experience;
  final String reviews;
  final Map fees;
  final List days;
  const DoctorAccount({Key key,
    this.about, this.age, this.hospital, this.hours, this.patients, this.experience, this.reviews,
    this.name, this.speciality, this.userPic, this.email, this.fees, this.days, this.uid,
  }) : super(key: key);

  @override
  _DoctorAccountState createState() => _DoctorAccountState();
}

class _DoctorAccountState extends State<DoctorAccount> {

  TextEditingController appointmentTEC = TextEditingController();
  TextEditingController inPersonTEC = TextEditingController();
  TextEditingController videoCallTEC = TextEditingController();
  TextEditingController voiceCallTEC = TextEditingController();
  List<String> updateDays = [];
  Future<bool> _onBackPressed() async {}

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: PickUpLayout(
        scaffold: Scaffold(
          body: custom(
            isDoctor: true,
            body: _doctorAccBody(context),
            imageUrl: widget.userPic,
            doctorsName: widget.name,
            context: context,
          ),
        ),
      ),
    );
  }

  Widget _doctorAccBody(BuildContext context) {
    return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 15 * SizeConfig.heightMultiplier,
            decoration: BoxDecoration(
              color: Colors.grey[100],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
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
                            width: 34 * SizeConfig.widthMultiplier,
                            textWidth: 23 * SizeConfig.widthMultiplier,
                          ),
                          SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                          specTile(
                            icon: FontAwesomeIcons.hospital,
                            title: widget.hospital,
                            width: 34 * SizeConfig.widthMultiplier,
                            textWidth: 23 * SizeConfig.widthMultiplier,
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              String profilePhoto;
                              DropDownList _yearsList = new DropDownList(
                                listItems: ["1-2 years", "3 -5 years", "5-10 years", "10+ years"],
                                placeholder: "Years Of Experience",
                              );
                              return showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text("Edit Profile", style: TextStyle(
                                        fontFamily: "Brand Bold",
                                        fontSize: 2.5 * SizeConfig.textMultiplier,
                                      ),),
                                      content: Container(
                                        height: 30 * SizeConfig.heightMultiplier,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Center(
                                              child: Column(
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(50),
                                                    child: Container(
                                                      height: 10 * SizeConfig.heightMultiplier,
                                                      width: 20 * SizeConfig.widthMultiplier,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(50),
                                                        color: Colors.white,
                                                        border: Border.all(color: Color(0xFFa81845), style: BorderStyle.solid, width: 2),
                                                      ),
                                                      child: profilePhoto == null
                                                          ? Image.asset("images/user_icon.png")
                                                          : CachedImage(
                                                        imageUrl: profilePhoto,
                                                        isRound: true,
                                                        radius: 10,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 6 * SizeConfig.heightMultiplier,
                                                    width: 60 * SizeConfig.widthMultiplier,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text("Update Your Profile Picture", style: TextStyle(
                                                          fontFamily: "Brand-Regular",
                                                          fontSize: 1.8 * SizeConfig.textMultiplier,
                                                          fontWeight: FontWeight.w500,
                                                        ),),
                                                        Spacer(),
                                                        Container(
                                                          height: 5 * SizeConfig.heightMultiplier,
                                                          width: 10 * SizeConfig.widthMultiplier,
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey[300],
                                                            borderRadius: BorderRadius.circular(14),
                                                          ),
                                                          child: FocusedMenuHolder(
                                                            blurSize: 0,
                                                            duration: Duration(milliseconds: 500),
                                                            menuWidth: MediaQuery.of(context).size.width * 0.3,
                                                            menuItemExtent: 40,
                                                            onPressed: () {
                                                              displayToastMessage("Tap & Hold to make selection", context);
                                                            },
                                                            menuItems: <FocusedMenuItem>[
                                                              FocusedMenuItem(title: Text("Gallery", style: TextStyle(
                                                                  color: Color(0xFFa81845), fontWeight: FontWeight.w500),),
                                                                onPressed: () async =>
                                                                await Permissions.cameraAndMicrophonePermissionsGranted() ?
                                                                pickImage(
                                                                    source: ImageSource.gallery,
                                                                    context: context,
                                                                    databaseMethods: databaseMethods).then((val) {
                                                                  setState(() {
                                                                    profilePhoto = val;
                                                                  });
                                                                }) : {},
                                                                trailingIcon: Icon(Icons.photo_library_outlined, color: Color(0xFFa81845),),
                                                              ),
                                                              FocusedMenuItem(title: Text("Capture", style: TextStyle(
                                                                  color: Color(0xFFa81845), fontWeight: FontWeight.w500),),
                                                                onPressed: () async =>
                                                                await Permissions.cameraAndMicrophonePermissionsGranted() ?
                                                                pickImage(
                                                                    source: ImageSource.camera,
                                                                    context: context,
                                                                    databaseMethods: databaseMethods).then((val) {
                                                                  setState(() {
                                                                    profilePhoto = val;
                                                                  });
                                                                }) : {},
                                                                trailingIcon: Icon(Icons.camera, color: Color(0xFFa81845),),
                                                              ),
                                                            ],
                                                            child: Icon(Icons.camera_alt_outlined, color: Color(0xFFa81845),),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                                            Text("Update your experience", style: TextStyle(
                                              fontFamily: "Brand-Regular",
                                              fontSize: 1.8 * SizeConfig.textMultiplier,
                                            ),),
                                            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                            _yearsList,
                                            SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("Update", style: TextStyle(
                                            fontFamily: "Brand Bold",
                                            fontSize: 2 * SizeConfig.textMultiplier,
                                          ),),
                                          onPressed: () async {
                                            if ((profilePhoto == null || profilePhoto.isEmpty) && _yearsList.selectedValue.isEmpty) {
                                              displaySnackBar(message: "Select new Profile Picture or years of experience to update", context: context, label: "OK");
                                            } else {
                                              QuerySnapshot chatSnap;
                                              QuerySnapshot callSnap;
                                              QuerySnapshot postSnap;

                                              await databaseMethods.getPostByDoctorNameSnap(Constants.myName).then((val) {
                                                setState(() {
                                                  postSnap = val;
                                                });
                                              });
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

                                              Activity activity;
                                              if (profilePhoto.isNotEmpty && _yearsList.selectedValue.isEmpty) {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (BuildContext context) => ProgressDialog(message: "Please wait...",),
                                              );
                                              activity = Activity.editActivity(
                                                createdAt: FieldValue.serverTimestamp(),
                                                type: "edit",
                                                editType: "profile photo",
                                              );
                                              var activityMap = activity.toEditActivity(activity);
                                              await databaseMethods.createDoctorActivity(activityMap, currentUser.uid);
                                              await databaseMethods.updateDoctorDocField({"profile_photo": profilePhoto}, widget.uid);
                                              await updatePostChatCallPics(
                                                postSnap: postSnap,
                                                chatSnap: chatSnap,
                                                callSnap : callSnap,
                                                updatePic: profilePhoto,
                                              );
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              displaySnackBar(message: "Changes will be seen next time you open the app", label: "OK", context: context);

                                              } else if (_yearsList.selectedValue.isNotEmpty && profilePhoto.isEmpty) {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (BuildContext context) => ProgressDialog(message: "Please wait...",),
                                              );
                                              activity = Activity.editActivity(
                                                createdAt: FieldValue.serverTimestamp(),
                                                type: "edit",
                                                editType: "years of experience",
                                              );
                                              var activityMap = activity.toEditActivity(activity);
                                              await databaseMethods.createDoctorActivity(activityMap, currentUser.uid);
                                              await databaseMethods.updateDoctorDocField({"years": _yearsList.selectedValue}, widget.uid);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              displaySnackBar(message: "Changes will be seen next time you open the app", label: "OK", context: context);
                                              } else if (_yearsList.selectedValue.isNotEmpty && profilePhoto.isNotEmpty){
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (BuildContext context) => ProgressDialog(message: "Please wait...",),
                                                );
                                                activity = Activity.editActivity(
                                                  createdAt: FieldValue.serverTimestamp(),
                                                  type: "edit",
                                                  editType: "profile",
                                                );
                                                var activityMap = activity.toEditActivity(activity);
                                                await databaseMethods.createDoctorActivity(activityMap, currentUser.uid);
                                                await databaseMethods.updateDoctorDocField({"profile_photo": profilePhoto}, widget.uid);
                                                await updatePostChatCallPics(
                                                  postSnap: postSnap,
                                                  chatSnap: chatSnap,
                                                  callSnap: callSnap,
                                                  updatePic: profilePhoto,
                                                );
                                                await databaseMethods.updateDoctorDocField({"years": _yearsList.selectedValue}, widget.uid);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                displaySnackBar(message: "Changes will be seen next time you open the app", label: "OK", context: context);
                                              }
                                            }
                                            },
                                        ),
                                        FlatButton(
                                          child: Text("Cancel", style: TextStyle(
                                            fontFamily: "Brand Bold",
                                            fontSize: 2 * SizeConfig.textMultiplier,
                                          ),),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: kPrimaryGradientColor,
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
                                padding: EdgeInsets.all(5),
                                child: Center(
                                  child: Text("Edit Profile", style: TextStyle(
                                    fontFamily: "Brand Bold",
                                    color: Colors.white,
                                    fontSize: 2 * SizeConfig.textMultiplier,
                                  ),),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 5 * SizeConfig.widthMultiplier,
                      right: 2 * SizeConfig.widthMultiplier,
                    ),
                    child: Row(
                        children: <Widget>[
                          _getDetails(widget.experience, "Experience"),
                          SizedBox(width: 3 * SizeConfig.widthMultiplier,),
                          _getDetails(widget.reviews, "Ratings"),
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (context) => ProgressDialog(message: "Please wait..."),
                              );
                              Stream reviewStream;
                              await databaseMethods.getDoctorsReviews(widget.uid).then((val) {
                                setState(() {
                                  reviewStream = val;
                                });
                              });
                              Navigator.pop(context);
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => ReviewsScreen(
                                isDoctor: true,
                                reviewStream: reviewStream,
                                doctorsName: widget.name,
                                doctorsUID: widget.uid,
                              ),
                              ),);
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
                      right: 5 * SizeConfig.widthMultiplier,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("My Bio", style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                              fontFamily: "Brand Bold",
                              fontSize: 2.8 * SizeConfig.textMultiplier,
                            ),),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              TextEditingController bioTEC = TextEditingController();
                              return showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => AlertDialog(
                                  title: Text("Edit Bio", style: TextStyle(
                                    fontFamily: "Brand Bold",
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                  ),),

                                  content: Container(
                                    height: 30 * SizeConfig.heightMultiplier,
                                    child:TextField(
                                          controller: bioTEC,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 14,
                                          minLines: 14,
                                          decoration: InputDecoration(
                                            hintText: "Update your Bio",
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: "Brand-Regular",
                                              fontSize: 2 * SizeConfig.textMultiplier,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontSize: 2 * SizeConfig.textMultiplier,
                                            fontFamily: "Brand-Regular",
                                          ),
                                        ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Update", style: TextStyle(
                                        fontFamily: "Brand Bold",
                                        fontSize: 2 * SizeConfig.textMultiplier,
                                      ),),
                                      onPressed: () async {
                                        if (bioTEC.text.isEmpty) {
                                          displaySnackBar(message: "Input Bio to Update", context: context, label: "OK");
                                        } else {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
                                        );
                                        Activity activity = Activity.editActivity(
                                          createdAt: FieldValue.serverTimestamp(),
                                          type: "edit",
                                          editType: "bio",
                                        );
                                        var activityMap = activity.toEditActivity(activity);
                                        await databaseMethods.createDoctorActivity(activityMap, currentUser.uid);
                                        await databaseMethods.updateDoctorDocField({"about": bioTEC.text.trim()}, widget.uid);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        displaySnackBar(message: "Changes will be seen next time you open the app", label: "OK", context: context);
                                      }},
                                    ),
                                    FlatButton(
                                      child: Text("Cancel", style: TextStyle(
                                        fontFamily: "Brand Bold",
                                        fontSize: 2 * SizeConfig.textMultiplier,
                                      ),),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text("Edit", style: TextStyle(
                                color: Color(0xFFa81845),
                                fontWeight: FontWeight.bold,
                                fontFamily: "Brand Bold",
                                fontSize: 2 * SizeConfig.textMultiplier,
                              ),),
                          ),
                        ],
                      ),
                  ),
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                   getAbout(widget.about),
                  SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 2 * SizeConfig.widthMultiplier,
                      right: 5 * SizeConfig.widthMultiplier,
                    ),
                    child: Row(
                        children: <Widget>[
                          Text("Appointment Hours", style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                              fontFamily: "Brand Bold",
                              fontSize: 2.8 * SizeConfig.textMultiplier,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              return showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => AlertDialog(
                                  title: Text("Edit Appointment hours", style: TextStyle(
                                    fontFamily: "Brand Bold",
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                  ),),
                                  content: Container(
                                    height: 20 * SizeConfig.heightMultiplier,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                        _radioTile(title: "Choose appointment period:", controller: appointmentTEC),
                                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Update", style: TextStyle(
                                        fontFamily: "Brand Bold",
                                        fontSize: 2 * SizeConfig.textMultiplier,
                                      ),),
                                      onPressed: () async {
                                        if (appointmentTEC.text == null || appointmentTEC.text.isEmpty) {
                                          displaySnackBar(message: "Choose appointment hours to update", context: context, label: "OK");
                                        } else if (appointmentTEC.text.isNotEmpty) {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
                                          );
                                          Activity activity = Activity.editActivity(
                                            createdAt: FieldValue.serverTimestamp(),
                                            type: "edit",
                                            editType: "appointment hours",
                                          );
                                          var activityMap = activity.toEditActivity(activity);
                                          await databaseMethods.createDoctorActivity(activityMap, currentUser.uid);
                                          await databaseMethods.updateDoctorDocField({"hours": appointmentTEC.text}, widget.uid);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          displaySnackBar(message: "Changes will be seen next time you open the app", label: "OK", context: context);
                                        }
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Cancel", style: TextStyle(
                                        fontFamily: "Brand Bold",
                                        fontSize: 2 * SizeConfig.textMultiplier,
                                      ),),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text("Edit", style: TextStyle(
                              color: Color(0xFFa81845),
                              fontWeight: FontWeight.bold,
                              fontFamily: "Brand Bold",
                              fontSize: 2 * SizeConfig.textMultiplier,
                            ),),
                          ),
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
                      right: 5 * SizeConfig.widthMultiplier,
                    ),
                    child: Row(
                      children: <Widget>[
                        Text("Consultation Fees", style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontFamily: "Brand Bold",
                          fontSize: 2.8 * SizeConfig.textMultiplier,
                        ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            return showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => AlertDialog(
                                title: Text("Edit Consultation fees", style: TextStyle(
                                  fontFamily: "Brand Bold",
                                  fontSize: 2.5 * SizeConfig.textMultiplier,
                                ),),
                                content: Container(
                                  height: 34 * SizeConfig.heightMultiplier,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                      _editFeeTile(
                                        title: "In-Person fee",
                                        textEditingController: inPersonTEC,
                                        hintText: "Edit in-person fee...",
                                      ),
                                      SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                      _editFeeTile(
                                        title: "Video call fee",
                                        textEditingController: videoCallTEC,
                                        hintText: "Edit video call fee...",
                                      ),
                                      SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                      _editFeeTile(
                                        title: "Voice call fee",
                                        textEditingController: voiceCallTEC,
                                        hintText: "Edit voice call fee...",
                                      ),
                                      SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Update", style: TextStyle(
                                      fontFamily: "Brand Bold",
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                    ),),
                                    onPressed: () async {
                                      Map feesToUp = await databaseMethods.getFees();
                                      if (inPersonTEC.text.isEmpty && videoCallTEC.text.isEmpty && voiceCallTEC.text.isEmpty) {
                                        displaySnackBar(message: "Edit all or any fee to update", context: context, label: "OK");
                                      } else {
                                        Activity activity;
                                        if (inPersonTEC.text.isNotEmpty && videoCallTEC.text.isEmpty && voiceCallTEC.text.isEmpty) {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
                                          );

                                          String voiceCall = feesToUp["voice_call"];
                                          String videoCall = feesToUp["video_call"];

                                          Map updateMap = {
                                            "in_person": inPersonTEC.text,
                                            "voice_call": voiceCall,
                                            "video_call": videoCall,
                                          };
                                          activity = Activity.editActivity(
                                            createdAt: FieldValue.serverTimestamp(),
                                            type: "edit",
                                            editType: "in-person fee",
                                          );
                                          var activityMap = activity.toEditActivity(activity);
                                          await databaseMethods.createDoctorActivity(activityMap, widget.uid);
                                          await databaseMethods.updateDoctorDocField({"fee": updateMap}, widget.uid);
                                          inPersonTEC.text = "";
                                          videoCallTEC.text = "";
                                          voiceCallTEC.text = "";
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          displaySnackBar(message: "In-Person fee Changes will be seen next time you open the app", label: "OK", context: context);
                                        } else if (inPersonTEC.text.isEmpty && videoCallTEC.text.isNotEmpty && voiceCallTEC.text.isEmpty) {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
                                          );
                                          String voiceCall = feesToUp["voice_call"];
                                          String inPerson = feesToUp["in_person"];

                                          Map updateMap = {
                                            "in_person": inPerson,
                                            "voice_call": voiceCall,
                                            "video_call": videoCallTEC.text,
                                          };
                                          activity = Activity.editActivity(
                                            createdAt: FieldValue.serverTimestamp(),
                                            type: "edit",
                                            editType: "video call fee",
                                          );
                                          var activityMap = activity.toEditActivity(activity);
                                          await databaseMethods.createDoctorActivity(activityMap, currentUser.uid);
                                          await databaseMethods.updateDoctorDocField({"fee": updateMap}, widget.uid);
                                          inPersonTEC.text = "";
                                          videoCallTEC.text = "";
                                          voiceCallTEC.text = "";
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          displaySnackBar(message: "Video call fee Changes will be seen next time you open the app", label: "OK", context: context);
                                        } else if (inPersonTEC.text.isEmpty && videoCallTEC.text.isEmpty && voiceCallTEC.text.isNotEmpty) {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
                                          );
                                          String inPerson = feesToUp["in_person"];
                                          String videoCall = feesToUp["video_call"];

                                          Map updateMap = {
                                            "in_person": inPerson,
                                            "voice_call": voiceCallTEC.text,
                                            "video_call": videoCall,
                                          };
                                          activity = Activity.editActivity(
                                            createdAt: FieldValue.serverTimestamp(),
                                            type: "edit",
                                            editType: "voice call fee",
                                          );
                                          var activityMap = activity.toEditActivity(activity);
                                          await databaseMethods.createDoctorActivity(activityMap, currentUser.uid);
                                          await databaseMethods.updateDoctorDocField({"fee": updateMap}, widget.uid);
                                          inPersonTEC.text = "";
                                          videoCallTEC.text = "";
                                          voiceCallTEC.text = "";
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          displaySnackBar(message: "Voice call fee Changes will be seen next time you open the app", label: "OK", context: context);
                                        } else {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
                                          );
                                          Map updateMap = {
                                            "in_person": inPersonTEC.text,
                                            "voice_call": voiceCallTEC.text,
                                            "video_call": videoCallTEC.text,
                                          };
                                          activity = Activity.editActivity(
                                            createdAt: FieldValue.serverTimestamp(),
                                            type: "edit",
                                            editType: "consultation fee",
                                          );
                                          var activityMap = activity.toEditActivity(activity);
                                          await databaseMethods.createDoctorActivity(activityMap, currentUser.uid);
                                          await databaseMethods.updateDoctorDocField({"fee": updateMap}, widget.uid);
                                          inPersonTEC.text = "";
                                          videoCallTEC.text = "";
                                          voiceCallTEC.text = "";
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          displaySnackBar(message: "Changes will be seen next time you open the app", label: "OK", context: context);
                                        }
                                      }
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Cancel", style: TextStyle(
                                      fontFamily: "Brand Bold",
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                    ),),
                                    onPressed: () {
                                      inPersonTEC.text = "";
                                      videoCallTEC.text = "";
                                      voiceCallTEC.text = "";
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text("Edit", style: TextStyle(
                            color: Color(0xFFa81845),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Brand Bold",
                            fontSize: 2 * SizeConfig.textMultiplier,
                          ),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                  Container(
                    width: 95 * SizeConfig.widthMultiplier,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        specTile(
                          text: "In-Person",
                          title: widget.fees["in_person"],
                          //width: 30 * SizeConfig.widthMultiplier
                        ),
                        specTile(
                          icon: CupertinoIcons.videocam_fill,
                          title: widget.fees["video_call"],
                          //width: 30 * SizeConfig.widthMultiplier
                        ),
                        specTile(
                          icon: Icons.local_phone_rounded,
                          title: widget.fees["voice_call"],
                          //width: 30 * SizeConfig.widthMultiplier
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _editFeeTile({String title, TextEditingController textEditingController, String hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: TextStyle(
            fontFamily: "Brand Bold",
            color: Colors.grey,
          ),),
        TextField(
          controller: textEditingController,
          keyboardType: TextInputType.number,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontFamily: "Brand-Regular",
              fontSize: 2 * SizeConfig.textMultiplier,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          style: TextStyle(
            fontSize: 2 * SizeConfig.textMultiplier,
            fontFamily: "Brand-Regular",
          ),
        ),
      ],
    );
  }

  Widget _radioTile({String title, width, TextEditingController controller}) {
    String group = "";
    return Container(
      width: width == null ? 60 * SizeConfig.widthMultiplier : width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: TextStyle(
            fontFamily: "Brand Bold",
            color: Colors.grey,
          ),),
          Container(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 7 * SizeConfig.widthMultiplier,
                          child: Radio(
                            value: "Morning: 08:00am - 11:30am",
                            activeColor: Color(0xFFa81845),
                            groupValue: group,
                            onChanged: (T) {
                              setState(() {
                                group = T;
                                controller.text = T;
                              });
                            },
                          ),
                        ),
                        Text("Morning (8:00am - 11:30am)", style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 7 * SizeConfig.widthMultiplier,
                          child: Radio(
                            value: "Afternoon: 03:00pm - 04:30pm",
                            activeColor: Color(0xFFa81845),
                            groupValue: group,
                            onChanged: (T) {
                              setState(() {
                                group = T;
                                controller.text = T;
                              });
                            },
                          ),
                        ),
                        Text("Afternoon (3:00pm - 4:30pm)", style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
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
            width: 18 * SizeConfig.widthMultiplier,
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
                        color: Color(0xFFa81845),
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

Future<void> updatePostChatCallPics({QuerySnapshot postSnap, QuerySnapshot chatSnap, QuerySnapshot callSnap,
  updatePic,}) async {

  if (postSnap != null) {
    for (int i = 0; i <= (postSnap.size - 1); i++) {
      String docId = postSnap.docs[i].id;
      await databaseMethods.updatePostDocField({"sender_pic": updatePic}, docId);
    }
  }

  for (int i = 0; i <= (chatSnap.size - 1); i++) {
    String docId = chatSnap.docs[i].id;
    String createdBy = chatSnap.docs[i].get("createdBy");
    if (createdBy == Constants.myName) {
      await databaseMethods.updateChatRoomDocField({"sender_profile_photo": updatePic}, docId);
    } else {
      await databaseMethods.updateChatRoomDocField({"receiver_profile_photo": updatePic}, docId);
    }
  }

  for (int i = 0; i <= (callSnap.size - 1); i++) {
    String docId = callSnap.docs[i].id;
    String createdBy = callSnap.docs[i].get("createdBy");
   if (createdBy == Constants.myName) {
     await databaseMethods.updateCallRecordDocField({"caller_pic": updatePic}, docId);
   } else {
     await databaseMethods.updateCallRecordDocField({"receiver_pic": updatePic}, docId);
   }
  }
}

getDays(List<dynamic> daysList) {
  return Padding(
    padding: EdgeInsets.only(left: 15.0, right: 15.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Day(s):", style: TextStyle(
          fontSize: 2.7 * SizeConfig.textMultiplier,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),),
        Container(
          height: 4 * SizeConfig.heightMultiplier,
          child: ListView.separated(
            separatorBuilder: (context, index) => Center(
              child: Text(", ", style: TextStyle(
                fontFamily: "Brand-Regular",
                fontSize: 2.5 * SizeConfig.textMultiplier,
              ),),
            ),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: ClampingScrollPhysics(),
            itemCount: daysList.length,
            itemBuilder: (context, index) {
              return Container(
                child: Center(
                  child: Text(daysList[index], style: TextStyle(
                    fontFamily: "Brand-Regular",
                    fontSize: 2.5 * SizeConfig.textMultiplier,
                  ),),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

getConsHours(hours) {
  int idx = hours.indexOf(":");
  String time = hours.substring(0, idx+1).trim();
  String hour = hours.substring(idx+1).trim();
  return Padding(
    padding: EdgeInsets.only(left: 15.0, right: 15.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(time, style: TextStyle(fontSize: 2.7 * SizeConfig.textMultiplier, fontWeight: FontWeight.bold,
            color: Colors.black87),
        ),
        Text(hour, style: TextStyle(
          fontSize: 2.5 * SizeConfig.textMultiplier,
          color: Colors.black,
        ),),
      ],
    ),
  );
}

getAbout(String about) {
  return Container(
    width: 95 * SizeConfig.widthMultiplier,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(about, textAlign: TextAlign.justify ,style: TextStyle(
      fontSize: 2.4 * SizeConfig.textMultiplier,
      fontFamily: "Brand-Regular",
    ),
    ),
  );
}

Widget specTile({IconData icon, String title, String text, double width, double textWidth}) {
  return Container(
    width: width,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 4 * SizeConfig.heightMultiplier,
          decoration: BoxDecoration(
            color: Colors.white,
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Center(
              child: icon == null
                  ? Text(text, style: TextStyle(
                fontFamily: "Brand Bold",
                color: Color(0xFFa81845),
                fontSize: 1.8 * SizeConfig.textMultiplier,
              ),)
                  : Icon(icon,
                color: Color(0xFFa81845),
                size: 5 * SizeConfig.imageSizeMultiplier,
              ),
            ),
          ),
        ),
        SizedBox(width: 1 * SizeConfig.widthMultiplier,),
        Container(
          width: textWidth != null ? textWidth : null,
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: "Brand-Regular",
              fontSize: 1.8 * SizeConfig.textMultiplier,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

_getStar(amount) {
  if (amount == 10) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
      ],
    );
  } else if (amount >= 9 && amount != 10) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_half,
          color: Color(0xFFa81845),
        ),
      ],
    );
  } else if (amount >= 8 && amount != 9) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
      ],
    );
  } else if (amount >= 7 && amount != 8) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_half,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
      ],
    );
  } else if (amount >= 6 && amount != 7) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
      ],
    );
  } else if (amount >= 5 && amount != 6) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_half,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
      ],
    );
  } else if (amount >= 4 && amount != 5) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
      ],
    );
  } else if (amount >= 3 && amount != 4) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_half,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
      ],
    );
  } else if (amount >= 2 && amount != 3) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
      ],
    );
  } else if (amount >= 0 && amount != 2) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star_half,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
        Icon(
          Icons.star_border_rounded,
          color: Color(0xFFa81845),
        ),
      ],
    );
  }
}

getReviews(amount, String desc) {
  int amountInt = int.parse(amount);
  dynamic amount2 = 100;
  try {
    amount2 = amountInt / 10;
  } catch (e) {
    amount2 = 0;
  }
  return desc == ""
        ? Row(
            children: <Widget>[
              _getStar(amount2),
              Text(amount2.toString(), style: TextStyle(fontFamily: "Brand-Regular"),),
            ],
          )
        : Column(
            children: <Widget>[
              _getStar(amount2),
              SizedBox(height: 10.0),
              Text(
                desc,
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: "Brand Bold",
                  fontSize: 1.8 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
}
