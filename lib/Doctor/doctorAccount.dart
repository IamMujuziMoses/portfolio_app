import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/bookAppointmentScreen.dart';
import 'package:creativedata_app/AllScreens/doctorProfileScreen.dart';
import 'package:creativedata_app/AllScreens/loginScreen.dart';
import 'package:creativedata_app/AllScreens/registerScreen.dart';
import 'package:creativedata_app/AllScreens/reviewsScreen.dart';
import 'package:creativedata_app/Doctor/doctorRegistration.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Utilities/permissions.dart';
import 'package:creativedata_app/Widgets/progressDialog.dart';
import 'package:creativedata_app/sizeConfig.dart';
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
  Map fees;
  List days;
  DoctorAccount({Key key,
    this.about, this.age, this.hospital, this.hours, this.patients, this.experience, this.reviews,
    this.name, this.speciality, this.userPic, this.email, this.fees, this.days, this.uid,
  }) : super(key: key);

  @override
  _DoctorAccountState createState() => _DoctorAccountState();
}

class _DoctorAccountState extends State<DoctorAccount> {
  
  DatabaseMethods databaseMethods = DatabaseMethods();
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
                                                        border: Border.all(color: Colors.red[300], style: BorderStyle.solid, width: 2),
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
                                                    width: 55 * SizeConfig.widthMultiplier,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text("Update Your Profile Picture", style: TextStyle(
                                                          fontFamily: "Brand-Regular",
                                                          fontSize: 2 * SizeConfig.textMultiplier,
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
                                                            //blurBackgroundColor: Colors.transparent,
                                                            duration: Duration(milliseconds: 500),
                                                            menuWidth: MediaQuery.of(context).size.width * 0.3,
                                                            menuItemExtent: 40,
                                                            onPressed: () {
                                                              displayToastMessage("Tap & Hold to make selection", context);
                                                            },
                                                            menuItems: <FocusedMenuItem>[
                                                              FocusedMenuItem(title: Text("Gallery", style: TextStyle(
                                                                  color: Colors.red[300], fontWeight: FontWeight.w500),),
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
                                                                trailingIcon: Icon(Icons.photo_library_outlined, color: Colors.red[300],),
                                                              ),
                                                              FocusedMenuItem(title: Text("Capture", style: TextStyle(
                                                                  color: Colors.red[300], fontWeight: FontWeight.w500),),
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
                                                                trailingIcon: Icon(Icons.camera, color: Colors.red[300],),
                                                              ),
                                                            ],
                                                            child: Icon(Icons.camera_alt_outlined, color: Colors.red[300],),
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
                                              fontSize: 2 * SizeConfig.textMultiplier,
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
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
                                            );
                                            await databaseMethods.updateDoctorDocField({"profile_photo": profilePhoto}, widget.uid);
                                            await databaseMethods.updateDoctorDocField({"years": _yearsList.selectedValue}, widget.uid);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            displaySnackBar(message: "Changes will be seen next time you open the app", label: "OK", context: context);
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
                                color: Colors.red[300],
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
                      right: 5 * SizeConfig.widthMultiplier,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("My Bio", style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                              fontFamily: "Brand Bold",
                              fontSize: 3 * SizeConfig.textMultiplier,
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
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
                                        );
                                        await databaseMethods.updateDoctorDocField({"about": bioTEC.text.trim()}, widget.uid);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        displaySnackBar(message: "Changes will be seen next time you open the app", label: "OK", context: context);
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
                                color: Colors.red[300],
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
                              fontSize: 3 * SizeConfig.textMultiplier,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {},
                            child: Text("Edit", style: TextStyle(
                              color: Colors.red[300],
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
                  ),///TODO fee and days in doc register
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
                          fontSize: 3 * SizeConfig.textMultiplier,
                        ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: Text("Edit", style: TextStyle(
                            color: Colors.red[300],
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
                color: Colors.red[300],
                fontSize: 2 * SizeConfig.textMultiplier,
              ),)
                  : Icon(icon,
                color: Colors.red[300],
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
              fontSize: 2.3 * SizeConfig.textMultiplier,
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
          color: Colors.red[300],
        ),
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
      ],
    );
  } else if (amount >= 9 && amount != 10) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_half,
          color: Colors.red[300],
        ),
      ],
    );
  } else if (amount >= 8 && amount != 9) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
      ],
    );
  } else if (amount >= 7 && amount != 8) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_half,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
      ],
    );
  } else if (amount >= 6 && amount != 7) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
      ],
    );
  } else if (amount >= 5 && amount != 6) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_half,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
      ],
    );
  } else if (amount >= 4 && amount != 5) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
      ],
    );
  } else if (amount >= 3 && amount != 4) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_half,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
      ],
    );
  } else if (amount >= 2 && amount != 3) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
      ],
    );
  } else if (amount >= 0 && amount != 2) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star_half,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
        ),
        Icon(
          Icons.star_border_rounded,
          color: Colors.red[300],
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
  return Padding(
    padding: EdgeInsets.only(
      left: 3 * SizeConfig.widthMultiplier,
      right: 3 * SizeConfig.widthMultiplier,
    ),
    child: desc == ""
        ? Row(
            children: <Widget>[
              _getStar(amount2),
              SizedBox(width: 2 * SizeConfig.widthMultiplier,),
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
                  fontSize: 2.2 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
  );
}
