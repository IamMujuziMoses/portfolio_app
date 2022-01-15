import 'dart:io';

import 'package:portfolio_app/AllScreens/Chat/cachedImage.dart';
import 'package:portfolio_app/AllScreens/Specialities/specialitiesScreen.dart';
import 'package:portfolio_app/AllScreens/loginScreen.dart';
import 'package:portfolio_app/AllScreens/registerScreen.dart';
import 'package:portfolio_app/Services/auth.dart';
import 'package:portfolio_app/Services/database.dart';
import 'package:portfolio_app/Services/helperFunctions.dart';
import 'package:portfolio_app/Utilities/permissions.dart';
import 'package:portfolio_app/Utilities/utils.dart';
import 'package:portfolio_app/Widgets/customBottomNavBar.dart';
import 'package:portfolio_app/Widgets/progressDialog.dart';
import 'package:portfolio_app/constants.dart';
import 'package:portfolio_app/main.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
/*
* Created by Mujuzi Moses
*/

class DoctorRegistration extends StatefulWidget {
  static const String screenId = "doctorRegistration";

  final String name;
  final String email;
  final String phone;
  final String password;
  final val;

  const DoctorRegistration({Key key, this.name, this.email, this.phone, this.password, this.val}) : super(key: key);

  @override
  _DoctorRegistrationState createState() => _DoctorRegistrationState();
}

class _DoctorRegistrationState extends State<DoctorRegistration> {

  AuthMethods authMethods = new AuthMethods();
  TextEditingController specialityTEC = TextEditingController();
  TextEditingController hospitalTEC = TextEditingController();
  TextEditingController ageTEC = TextEditingController();
  TextEditingController inPersonTEC = TextEditingController();
  TextEditingController videoCallTEC = TextEditingController();
  TextEditingController voiceCallTEC = TextEditingController();
  TextEditingController aboutTEC = TextEditingController();
  List daysList = [];
  Map<String, dynamic> feesMap = Map();
  String profilePhoto;
  List specialityOnSearch = [];
  bool specialityVisible = false;

  DropDownList _yearsList = new DropDownList(
    listItems: ["1-2 years", "3 -5 years", "5-10 years", "10+ years"],
    placeholder: "Years Of Experience",
  );
  DropDownList _hoursList = new DropDownList(
    listItems: ["Morning: 08:00am - 11:30am", "Afternoon: 03:00am - 04:30pm"],
    placeholder: "Consultation Hours",
  );
  DropDownList _patientsList = new DropDownList(
    listItems: ["100 - 200", "300 - 500", "500 -1000", "1000+"],
    placeholder: "Patients",
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        titleSpacing: 0,
        elevation: 0,
        title: Text("Doctor's Registration", style: TextStyle(
          fontFamily: "Brand Bold",
          color: Color(0xFFa81845),
        ),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 1 * SizeConfig.heightMultiplier,),
              Text("Doctor's Information", style: TextStyle(
                fontSize: 6 * SizeConfig.imageSizeMultiplier,
                fontFamily: "Brand Bold",),
                textAlign: TextAlign.center,
              ),
              Text("Fill in every field please", style: TextStyle(
                fontSize: 3 * SizeConfig.imageSizeMultiplier, fontFamily: "Brand-Regular"),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1 * SizeConfig.heightMultiplier,),
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
                      width: 55 * SizeConfig.widthMultiplier,
                      child: Row(
                        children: <Widget>[
                          Text("Select Your Profile Picture:", style: TextStyle(
                              fontSize: 3.5 * SizeConfig.imageSizeMultiplier,
                            fontWeight: FontWeight.w500
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
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0,),
                    TextField(
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            specialityVisible = true;
                            specialityOnSearch = specialitiesList.where((element) => element.toLowerCase()
                                .contains(value.toLowerCase())).toList();
                          });
                          if (specialityOnSearch.isEmpty) {
                            setState(() {
                              specialityOnSearch.add("No Speciality Found!");
                            });
                          }
                        } else {
                          setState(() {
                            specialityVisible = false;
                          });
                        }
                      },
                      controller: specialityTEC,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: "Speciality",
                        labelStyle: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 1.5 * SizeConfig.textMultiplier,
                        ),
                      ),
                      style: TextStyle(fontSize: 2 * SizeConfig.textMultiplier),
                    ),
                    SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                    Visibility(
                      visible: specialityVisible,
                      child: Container(
                        width: 100 * SizeConfig.widthMultiplier,
                        height: 15 * SizeConfig.heightMultiplier,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 6.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2 * SizeConfig.widthMultiplier,
                            vertical: 0.5 * SizeConfig.heightMultiplier,
                          ),
                          child: CupertinoScrollbar(
                            child: ListView.builder(
                              itemCount: specialityOnSearch.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 0.5 * SizeConfig.heightMultiplier,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (specialityOnSearch[index] == "No Speciality Found!") {
                                        setState(() {
                                          specialityVisible = false;
                                        });
                                        specialityOnSearch.clear();
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => AlertDialog(
                                            title: Text("Request To Add Speciality (${specialityTEC.text})?"),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text("No"),
                                                onPressed: () => Navigator.of(context).pop(),
                                              ),
                                              FlatButton(
                                                child: Text("Yes"),
                                                onPressed: () {
                                                  displayToastMessage("Operation Successful! Request Sent", context);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        setState(() {
                                          specialityTEC.text = specialityOnSearch[index];
                                          specialityVisible = false;
                                        });
                                        specialityOnSearch.clear();
                                      }
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 3 * SizeConfig.heightMultiplier,
                                          width: 6 * SizeConfig.widthMultiplier,
                                          decoration: BoxDecoration(
                                            gradient: kPrimaryGradientColor,
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Center(
                                            child: Icon(FontAwesomeIcons.userMd,
                                              color: Colors.white,
                                              size: 3 * SizeConfig.imageSizeMultiplier,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                        Text(specialityOnSearch[index], style: TextStyle(
                                          fontFamily: "Brand Bold",
                                        ),),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: hospitalTEC,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Hospital's Name",
                        labelStyle: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 1.5 * SizeConfig.textMultiplier,
                        ),
                      ),
                      style: TextStyle(fontSize: 2 * SizeConfig.textMultiplier),
                    ),
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: ageTEC,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Age",
                        labelStyle: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 1.5 * SizeConfig.textMultiplier,
                        ),
                      ),
                      style: TextStyle(fontSize: 2 * SizeConfig.textMultiplier),
                    ),
                    SizedBox(height: 10,),
                    _yearsList,
                    SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Working days:", style: TextStyle(
                            fontFamily: "Brand Bold",
                            fontSize: 2 * SizeConfig.textMultiplier,
                            color: Colors.grey,
                          ),),
                          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _daysTile(day: "Mon"),
                              _daysTile(day: "Tue"),
                              _daysTile(day: "Wed"),
                              _daysTile(day: "Thur"),
                              _daysTile(day: "Fri"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    _hoursList,
                    SizedBox(height: 10,),
                    _patientsList,
                    SizedBox(height: 10,),
                    TextField(
                      controller: aboutTEC,
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      minLines: 1,
                      decoration: InputDecoration(
                        labelText: "About",
                        labelStyle: TextStyle(fontSize: 2 * SizeConfig.textMultiplier,),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 1.5 * SizeConfig.textMultiplier,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      style: TextStyle(fontSize: 2 * SizeConfig.textMultiplier),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Consultation fees:", style: TextStyle(
                            fontFamily: "Brand Bold",
                            fontSize: 2 * SizeConfig.textMultiplier,
                            color: Colors.grey,
                          ),),
                          Padding(
                            padding: const EdgeInsets.only(left: 20,),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                _editFeeTile(
                                  textEditingController: inPersonTEC,
                                  hintText: "In-person fee",
                                ),
                                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                _editFeeTile(
                                  textEditingController: videoCallTEC,
                                  hintText: "Video call fee",
                                ),
                                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                _editFeeTile(
                                  textEditingController: voiceCallTEC,
                                  hintText: "Voice call fee",
                                ),
                                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.5 * SizeConfig.heightMultiplier,),
                    RaisedButton(
                      clipBehavior: Clip.hardEdge,
                      padding: EdgeInsets.zero,
                      textColor: Colors.white,
                      child: Container(
                        height: 6.5 * SizeConfig.heightMultiplier,
                        width: 30 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          gradient: kPrimaryGradientColor,
                        ),
                        child: Center(
                          child: Text("Submit", style: TextStyle(
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                            fontFamily: "Brand Bold",
                            color: Colors.white,
                          ),),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(14),
                      ),
                      onPressed: () {
                        String years = _yearsList.selectedValue;
                        String hours = _hoursList.selectedValue;
                        String patients = _patientsList.selectedValue;
                        if (specialityTEC.text.isEmpty) {
                          displayToastMessage("Provide Your Speciality", context);
                        } else if (hospitalTEC.text.isEmpty) {
                          displayToastMessage("Provide Your Hospital", context);
                        } else if (ageTEC.text.isEmpty) {
                          displayToastMessage("Provide Your Age", context);
                        } else if (aboutTEC.text.isEmpty) {
                          displayToastMessage("Provide Your About Info", context);
                        } else if (years == "") {
                          displayToastMessage("Provide Your Years of Experience", context);
                        } else if (hours == "") {
                          displayToastMessage("Provide Your Consultation Hours", context);
                        } else if (daysList.isEmpty) {
                          displayToastMessage("Provide Your Working days", context);
                        } else if (inPersonTEC.text.isEmpty || voiceCallTEC.text.isEmpty || videoCallTEC.text.isEmpty) {
                          displayToastMessage("Provide Your Consultation Fees", context);
                        } else if (patients == "") {
                          displayToastMessage("Provide the Number of Patients Worked-on", context);
                        } else {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return ProgressDialog(message: "Signing you up, Please wait",);
                              });
                          feesMap = {
                            "in_person": inPersonTEC.text,
                            "video_call": videoCallTEC.text,
                            "voice_call": voiceCallTEC.text,
                          };

                          Map<String, dynamic> userDataMap = {
                            "uid" : widget.val,
                            "name": widget.name,
                            "email": widget.email,
                            "phone": widget.phone,
                            "speciality": specialityTEC.text.trim(),
                            "hospital": hospitalTEC.text.trim(),
                            "age": ageTEC.text.trim(),
                            "years": years,
                            "hours": hours,
                            "fee": feesMap,
                            "days": daysList,
                            "patients": patients,
                            "username" : Utils.getUsername(widget.email),
                            "profile_photo": profilePhoto,
                            "state": null,
                            "status": "unapproved",
                            "token": null,
                            "about": aboutTEC.text,
                            "regId": "Doctor",
                            "reviews": "10",
                          };
                          databaseMethods.uploadDoctorInfo(userDataMap);
                          HelperFunctions.saveUserLoggedInSharedPref(true);
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => CustomBottomNavBar(isDoctor: true,)
                          ));
                          displayToastMessage("New user account created Successfully", context);
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
    );
  }

  Widget _editFeeTile({TextEditingController textEditingController, String hintText}) {
    return TextField(
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
    );
  }

  Widget _daysTile({String day}) {
    bool selected = false;
    return StatefulBuilder(
      builder: (context, setState) => GestureDetector(
        onTap: () {
          if (selected == false) {
            setState(() {
              selected = true;
              daysList.add(day);
            });
          } else {
            setState(() {
              selected = false;
              daysList.remove(day);
            });
          }
        },
        child: Container(
            width: 15 * SizeConfig.widthMultiplier,
            height: 5 * SizeConfig.heightMultiplier,
            decoration: BoxDecoration(
              color: selected == true ? Color(0xFFa81845) : Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(day, style: TextStyle(
                fontFamily: "Brand Bold",
                fontSize: 2.5 * SizeConfig.textMultiplier,
                color: selected == true ? Colors.white : Colors.grey,
              ),),
            )
        ),
      ),
    );
  }

}

pickImage({ImageSource source, BuildContext context, DatabaseMethods databaseMethods}) async {
  File selectedImage = await Utils.pickImage(source: source);
  if (selectedImage != null) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
    );
    String url = await databaseMethods.uploadFileToStorage(selectedImage);
    Navigator.pop(context);
    return url;
  } else {
    displayToastMessage("No Image Selected!", context);
  }
}

pickVideo({ImageSource source, BuildContext context, DatabaseMethods databaseMethods}) async {
  File selectedVideo = await Utils.pickVideo(source: source);
  if (selectedVideo != null) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
    );
    String url = await databaseMethods.uploadFileToStorage(selectedVideo);
    Navigator.pop(context);
    return url;
  } else {
    displayToastMessage("No Video Selected!", context);
  }
}


