import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/loginScreen.dart';
import 'package:creativedata_app/Doctor/doctorRegistration.dart';
import 'package:creativedata_app/Services/auth.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Services/helperFunctions.dart';
import 'package:creativedata_app/Utilities/permissions.dart';
import 'package:creativedata_app/Utilities/utils.dart';
import 'package:creativedata_app/Widgets/customBottomNavBar.dart';
import 'package:creativedata_app/Widgets/progressDialog.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
/*
* Created by Mujuzi Moses
*/

class RegisterScreen extends StatefulWidget {
  static const String screenId = "registerScreen";
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController phoneTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  TextEditingController confirmPasswordTEC = TextEditingController();
  String profilePhoto;
  DropDownList _dropDownList = new DropDownList(listItems: ["User", "Doctor"], placeholder: "Register as",);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 4 * SizeConfig.heightMultiplier,),
              Image(
                image: AssetImage("images/logo.png"),
                width: 39 * SizeConfig.widthMultiplier,
                height: 25 * SizeConfig.heightMultiplier,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0,),
              Text(
                "Register here",
                style: TextStyle(fontSize: 6 * SizeConfig.imageSizeMultiplier, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 1.0,),
                    _dropDownList,
                    SizedBox(height: 10.0,),
                    TextField(
                      controller: nameTEC,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
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
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: phoneTEC,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
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
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: emailTEC,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
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
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: passwordTEC,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
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
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: confirmPasswordTEC,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
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
                    SizedBox(height: 10.0,),
                    RaisedButton(
                      clipBehavior: Clip.hardEdge,
                      padding: EdgeInsets.zero,
                      elevation: 8,
                      textColor: Colors.white,
                      child: Container(
                        height: 6.5 * SizeConfig.heightMultiplier,
                        width: 100 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          gradient: kPrimaryGradientColor,
                        ),
                        child: Center(
                          child: Text("Create Account", style: TextStyle(
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                            fontFamily: "Brand Bold",
                            color: Colors.white,
                          ),),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: () async {
                        bool hasInternet = await InternetConnectionChecker().hasConnection;
                        if (hasInternet == true) {} else {
                          displayToastMessage("No internet Connection", context);
                          return;
                        }
                        String regId = _dropDownList.selectedValue;
                        if (nameTEC.text.length <= 4) {
                          displayToastMessage("Name must be at least 4 characters ", context);
                        } else if (!emailTEC.text.contains("@")) {
                          displayToastMessage("Email address is Void", context);
                        } else if (phoneTEC.text.isEmpty) {
                          displayToastMessage("Phone Number is necessary", context);
                        } else if (passwordTEC.text.length <= 7) {
                          displayToastMessage("Password must be at least 7 Characters", context);
                        } else if (confirmPasswordTEC.text != passwordTEC.text) {
                          displayToastMessage("Passwords are not the same", context);
                        } else if (regId == "") {
                          displayToastMessage("Select How to Register", context);
                        } else {
                          if (regId == "User") {
                            String name = nameTEC.text.trim();
                            String email = emailTEC.text.trim();
                            String phone = phoneTEC.text.trim();
                            String password = passwordTEC.text.trim();
                            HelperFunctions.saveUserEmailSharedPref(email);
                            HelperFunctions.saveUserNameSharedPref(name);
                            authMethods.signUpWithEmailAndPassword(context, email, password)
                                .then((val) {
                              if (val != null) {
                                _userSelectPic(
                                    context,
                                    val,
                                    name,
                                    email,
                                    phone,
                                    password,
                                    profilePhoto
                                );
                              } else {
                                displayToastMessage("Creating New user account Failed", context);
                              }
                            });
                          } else if (regId == "Doctor") {
                            String name = nameTEC.text.trim();
                            String email = emailTEC.text.trim();
                            String phone = phoneTEC.text.trim();
                            String password = passwordTEC.text.trim();
                            HelperFunctions.saveUserEmailSharedPref(email);
                            HelperFunctions.saveUserNameSharedPref(name);
                            authMethods.signUpWithEmailAndPassword(context, email, password)
                                .then((val) {
                              if (val != null) {
                                Navigator.push(context, MaterialPageRoute
                                  (builder: (context) =>
                                    DoctorRegistration(
                                      val: val,
                                      name: name,
                                      email: email,
                                      phone: phone,
                                      password: password,
                                    ),),);
                              } else {
                                displayToastMessage("Creating New user account Failed", context);
                              }
                            });

                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.screenId, (route) => false);
                },
                child: Text("Already have an Account? Login Here", style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Color(0xFFa81845),
                  ),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _userSelectPic(BuildContext context, dynamic val, String name, String email, String phone, String password, String profilePhoto) {
    return showDialog(
        context: context,
        builder: (context) =>
            Padding(
              padding: EdgeInsets.only(top: 200, left: 50, right: 50, bottom: 240),
              child: Builder(
                builder: (context) =>
                    Container(
                      height: 10 * SizeConfig.heightMultiplier,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  height: 20 * SizeConfig.heightMultiplier,
                                  width: 40 * SizeConfig.widthMultiplier,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Color(0xFFa81845), style: BorderStyle.solid, width: 2),
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
                              Spacer(),
                              Container(
                                height: 15 * SizeConfig.heightMultiplier,
                                width: 65 * SizeConfig.widthMultiplier,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text("Select Your Profile Picture:", style: TextStyle(
                                            fontSize: 3 * SizeConfig.imageSizeMultiplier,
                                            color: Colors.black,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.bold,
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
                                            menuWidth: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.3,
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
                                                trailingIcon: Icon(
                                                  Icons.photo_library_outlined, color: Color(0xFFa81845),),
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
                                    Spacer(),
                                    RaisedButton(
                                      clipBehavior: Clip.hardEdge,
                                      padding: EdgeInsets.zero,
                                      textColor: Colors.white,
                                      child: Container(
                                        height: 5 * SizeConfig.heightMultiplier,
                                        width: 100 * SizeConfig.widthMultiplier,
                                        decoration: BoxDecoration(
                                          gradient: kPrimaryGradientColor
                                        ),
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
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return ProgressDialog(message: "Signing you up, Please wait",);
                                            });
                                        Map<String, dynamic> userDataMap = {
                                          "uid" : val,
                                          "name": name,
                                          "email": email,
                                          "phone": phone,
                                          "username" : Utils.getUsername(email),
                                          "profile_photo": profilePhoto,
                                          "state": null,
                                          "status": null,
                                          "token": null,
                                          "regId": "User",
                                        };
                                        databaseMethods.uploadUserInfo(userDataMap);
                                        HelperFunctions.saveUserLoggedInSharedPref(true);
                                        Navigator.pushReplacement(context, MaterialPageRoute(
                                            builder: (context) => CustomBottomNavBar(isDoctor: false,)
                                        ));
                                        displayToastMessage("New user account created Successfully", context);
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
            )
    );
  }
}

class DropDownList extends StatefulWidget {
  String selectedValue = "";
  final List listItems;
  final String placeholder;

  DropDownList({Key key, this.listItems, this.placeholder}) : super(key: key);

  @override
  _DropDownListState createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  String valueChoose;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            hint: Text(widget.placeholder, style: TextStyle(
              fontFamily: "Brand-Regular",
              fontSize: 2.1 * SizeConfig.textMultiplier,
              color: Colors.grey,
            ),),
            dropdownColor: Colors.white,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFFa81845),
              size: 5 * SizeConfig.imageSizeMultiplier,
            ),
            iconSize: 8 * SizeConfig.imageSizeMultiplier,
            isExpanded: true,
            value: valueChoose,
            onChanged: (newValue) {
              setState(() {
                valueChoose = newValue;
                widget.selectedValue = valueChoose;
              });
            },
            items: widget.listItems.map((valueItem) {
              return DropdownMenuItem(
                value: valueItem,
                child: Text(valueItem, style: TextStyle(
                  fontFamily: "Brand-Regular",
                  color: Colors.black,
                  fontSize: 2.5 * SizeConfig.textMultiplier
                ),),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
