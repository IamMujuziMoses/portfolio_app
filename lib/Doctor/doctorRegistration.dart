import 'dart:io';

import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/loginScreen.dart';
import 'package:creativedata_app/AllScreens/registerScreen.dart';
import 'package:creativedata_app/Doctor/doctorProfile.dart';
import 'package:creativedata_app/Services/auth.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Services/helperFunctions.dart';
import 'package:creativedata_app/Utilities/permissions.dart';
import 'package:creativedata_app/Utilities/utils.dart';
import 'package:creativedata_app/Widgets/customBottomNavBar.dart';
import 'package:creativedata_app/Widgets/progressDialog.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
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
  final dynamic val;

  const DoctorRegistration({Key key, this.name, this.email, this.phone, this.password, this.val}) : super(key: key);

  @override
  _DoctorRegistrationState createState() => _DoctorRegistrationState();
}

class _DoctorRegistrationState extends State<DoctorRegistration> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController specialityTEC = TextEditingController();
  TextEditingController hospitalTEC = TextEditingController();
  TextEditingController ageTEC = TextEditingController();
  TextEditingController aboutTEC = TextEditingController();
  String profilePhoto;

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
          color: Colors.red[300],
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
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0,),
                    TextField(
                      controller: specialityTEC,
                      keyboardType: TextInputType.text,
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
                    SizedBox(height: 1.0,),
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
                    SizedBox(height: 2.5 * SizeConfig.heightMultiplier,),
                    RaisedButton(
                      color: Colors.red[300],
                      textColor: Colors.white,
                      child: Container(
                        height: 6.5 * SizeConfig.heightMultiplier,
                        width: 30 * SizeConfig.widthMultiplier,
                        child: Center(
                          child: Text("Submit", style: TextStyle(
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                            fontFamily: "Brand Bold",
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
                        } else if (patients == "") {
                          displayToastMessage("Provide the Number of Patients Worked-on", context);
                        } else {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return ProgressDialog(message: "Signing you up, Please wait",);
                              });
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
                            "patients": patients,
                            "username" : Utils.getUsername(widget.email),
                            "profile_photo": profilePhoto,
                            "state": null,
                            "status": null,
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


