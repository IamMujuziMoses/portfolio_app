import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/registerScreen.dart';
import 'package:portfolio_app/Enum/userState.dart';
import 'package:portfolio_app/Services/auth.dart';
import 'package:portfolio_app/Services/helperFunctions.dart';
import 'package:portfolio_app/Widgets/customBottomNavBar.dart';
import 'package:portfolio_app/constants.dart';
import 'package:portfolio_app/main.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
/*
* Created by Mujuzi Moses
*/

class LoginScreen extends StatelessWidget {
  static const String screenId = "loginScreen";
  
  AuthMethods authMethods = new AuthMethods();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  TextEditingController resetPasswordEmailTEC = TextEditingController();
  QuerySnapshot snapshot;
  String regId;
  String hospital;

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
              SizedBox(
                height: 35.0,
              ),
              Image(
                image: AssetImage("images/logo.png"),
                width: 39 * SizeConfig.widthMultiplier,
                height: 25 * SizeConfig.heightMultiplier,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 1.0,
              ),
              Text(
                "Login here",
                style: TextStyle(fontSize: 3.5 * SizeConfig.textMultiplier, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
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
                    SizedBox(height: 5 * SizeConfig.heightMultiplier,),
                    RaisedButton(
                      clipBehavior: Clip.hardEdge,
                      padding: EdgeInsets.zero,
                      textColor: Colors.white,
                      elevation: 8,
                      child: Container(
                        height: 6.5 * SizeConfig.heightMultiplier,
                        width: 100 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          gradient: kPrimaryGradientColor,
                        ),
                        child: Center(
                          child: Text("Login", style: TextStyle(
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
                        if (!emailTEC.text.contains("@")) {
                          displayToastMessage("Email address is Void", context);
                        } else if (passwordTEC.text.isEmpty) {
                          displayToastMessage("Input Password", context);
                        } else {
                          HelperFunctions.saveUserEmailSharedPref(emailTEC.text.trim());
                          databaseMethods.getUserByUserEmail(emailTEC.text).then((val) {
                            snapshot = val;
                            HelperFunctions.saveUserNameSharedPref(snapshot.docs[0].get("name"));
                            regId = snapshot.docs[0].get("regId");
                            authMethods.signInWithEmailAndPassword(context, emailTEC.text, passwordTEC.text)
                                .then((val) {
                              if (val != null) {
                                switch (regId) {
                                  case "Doctor":
                                    HelperFunctions.saveUserLoggedInSharedPref(true);
                                    databaseMethods.setUserState(uid: snapshot.docs[0].get("uid"), userState: UserState.Online, isDoctor: true);
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                        builder: (context) => CustomBottomNavBar(isDoctor: true,)
                                    ));
                                    displayToastMessage("Logged in Successfully", context);
                                    break;
                                  case "User":
                                    HelperFunctions.saveUserLoggedInSharedPref(true);
                                    databaseMethods.setUserState(uid: snapshot.docs[0].get("uid"), userState: UserState.Online, isDoctor: false);
                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                        builder: (context) => CustomBottomNavBar(isDoctor: false,)
                                    ));
                                    displayToastMessage("Logged in Successfully", context);
                                    break;
                                }
                              } else {
                                displayToastMessage("Login Failed", context);
                              }
                            }).catchError((e) {
                              displayToastMessage("Wrong email or password", context);
                            });
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20 * SizeConfig.heightMultiplier,),
              TextButton(
                onPressed: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: Text("Reset Password", style: TextStyle(
                    fontFamily: "Brand Bold",
                    fontSize: 2.5 * SizeConfig.textMultiplier,
                  ),),
                  content: Container(
                    height: 10 * SizeConfig.heightMultiplier,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          controller: resetPasswordEmailTEC,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Enter your email address...",
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
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    FlatButton(
                      child: Text("Reset"),
                      onPressed: () async {
                        if (resetPasswordEmailTEC.text.isEmpty) {
                          displayToastMessage("Input Email", context);
                        } else if (!resetPasswordEmailTEC.text.contains("@")){
                          displayToastMessage("Invalid Email", context);
                        } else {
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: resetPasswordEmailTEC.text.trim());
                          Navigator.of(context).pop();
                          showSimpleNotification(
                            Text("A password reset link has been sent to ${resetPasswordEmailTEC.text.trim()}", style: TextStyle(
                              fontFamily: "Brand Bold",
                              color: Colors.grey[100],
                            ),),
                            background: Colors.black54,
                            duration: Duration(seconds: 5),
                            elevation: 0,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
                child: Text("Forgot Password?!", style: TextStyle(
                  color: Color(0xFFa81845),
                ),),
              ),
              TextButton(
                onPressed: () {
                 Navigator.pushNamedAndRemoveUntil(context, RegisterScreen.screenId, (route) => false);
                },
                child: Text("Don't have an Account? Register Here", style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Color(0xFFa81845)
                ),),
              ),

            ],
          ),
        ),
      ),
    );
  }

}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
