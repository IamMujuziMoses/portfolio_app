import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/bookAppointmentScreen.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Widgets/progressDialog.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
/*
* Created by Mujuzi Moses
*/

class PrivatePatientProfile extends StatefulWidget {
  final String name;
  final String phone;
  final String pic;
  final List medicine;
  const PrivatePatientProfile({Key key, this.name, this.phone, this.pic, this.medicine}) : super(key: key);

  @override
  _PrivatePatientProfileState createState() => _PrivatePatientProfileState();
}

class _PrivatePatientProfileState extends State<PrivatePatientProfile> {

  DatabaseMethods databaseMethods = DatabaseMethods();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List med = [];
  bool pHeaderVisible = false;
  bool addPVisible = true;
  bool pAddVisible = false;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  getInfo() {
    med = widget.medicine;
    if (med.isNotEmpty && med.length > 0) {
      setState(() {
        pHeaderVisible = true;
        addPVisible = false;
      });
    } else if (med == null) {
      setState(() {
        pHeaderVisible = false;
        addPVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.grey[100],
          title: Text("Patient's Profile", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Color(0xFFa81845),
          ),),
        ),
        floatingActionButton: FloatingActionButton(
          clipBehavior: Clip.hardEdge,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: kPrimaryGradientColor
            ),
            child: Icon(CupertinoIcons.trash_fill, color: Colors.white,),
          ),
          onPressed: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Center(
                      child: Text("Delete Patient", style: TextStyle(
                        fontFamily: "Brand Bold",
                        color: Color(0xFFa81845),
                        fontSize: 3 * SizeConfig.textMultiplier,
                      ),),
                    ),
                    content: Container(
                      height: 10 * SizeConfig.heightMultiplier,
                      width: 20 * SizeConfig.widthMultiplier,
                      child: Center(
                        child: Text("Do you want to delete ${widget.name}'s Profile?!", textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Brand-Regular",
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                          ),
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Delete", style: TextStyle(
                          fontFamily: "Brand Bold",
                          color: Color(0xFFa81845),
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
                          );
                          await databaseMethods.deleteSavedPatient(widget.name, firebaseAuth.currentUser.uid);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          displaySnackBar(message: "Deleted saved patient", context: context, label: "OK");
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
        ),
        body: Container(
          color: Colors.grey[100],
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          width: 20 * SizeConfig.widthMultiplier,
                          height: 10 * SizeConfig.heightMultiplier,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                            border: Border.all(color: Color(0xFFa81845), style: BorderStyle.solid, width: 2),
                          ),
                          child: widget.pic == null
                              ? Image.asset("images/user_icon.png")
                              : CachedImage(
                            imageUrl: widget.pic,
                            isRound: true,
                            radius: 10,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                      Column(
                        children: <Widget>[
                          Container(
                            width: 50 * SizeConfig.widthMultiplier,
                            child: Text(widget.name, style: TextStyle(
                              fontFamily: "Brand Bold",
                              fontSize: 3.5 * SizeConfig.textMultiplier,
                            ),),
                          ),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                          Container(
                              width: 50 * SizeConfig.widthMultiplier,
                              child: Text("This account is private", textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Brand Bold",
                                  color: Colors.grey,
                                  fontSize: 2 * SizeConfig.textMultiplier,
                              ),),
                            ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        height: 4 * SizeConfig.heightMultiplier,
                        width: 8 * SizeConfig.widthMultiplier,
                        child: RaisedButton(
                          onPressed: () => launch(('tel:${widget.phone}')),
                          padding: EdgeInsets.zero,
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: kPrimaryGradientColor,
                            ),
                            child: Center(
                              child: Icon(Icons.phone_rounded,
                                color: Colors.white,
                                size: 6 * SizeConfig.imageSizeMultiplier,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 60 * SizeConfig.widthMultiplier,
                        child: Text("Prescription", overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: "Brand Bold",
                            color: Colors.black54,
                            fontSize: 2.8 * SizeConfig.textMultiplier,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: pHeaderVisible,
                        child: Container(
                          width: 15 * SizeConfig.widthMultiplier,
                          height: 4 * SizeConfig.heightMultiplier,
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                pAddVisible = true;
                                pHeaderVisible = false;
                              });
                            },
                            padding: EdgeInsets.zero,
                            color: Colors.white,
                            splashColor: Colors.red[200],
                            highlightColor: Colors.grey.withOpacity(0.1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text("Add", style: TextStyle(
                                fontFamily: "Brand Bold",
                                color: Color(0xFFa81845),
                                fontSize: 2 * SizeConfig.textMultiplier,
                              ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  med.isNotEmpty && med.length > 0
                      ? presCard(list: med)
                      : Container(),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Visibility(
                    visible: pAddVisible,
                    child: prescriptionAdd(hint: "Add prescription",),
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Visibility(
                    visible: addPVisible,
                    child: Container(
                      width: 95 * SizeConfig.widthMultiplier,
                      height: 5 * SizeConfig.heightMultiplier,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20 * SizeConfig.widthMultiplier),
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              pAddVisible = true;
                              addPVisible = false;
                            });
                          },
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          clipBehavior: Clip.hardEdge,
                          child: Container(
                            width: 100 * SizeConfig.widthMultiplier,
                            height: 5 * SizeConfig.heightMultiplier,
                            decoration: BoxDecoration(
                              gradient: kPrimaryGradientColor,
                            ),
                            child: Center(
                              child: Text("Add Prescription", style: TextStyle(
                                fontFamily: "Brand Bold",
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                                color: Colors.white,
                              ),),
                            ),
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

  Widget presCard({List list}) {
    return Container(
      width: 60 * SizeConfig.widthMultiplier,
      child: list.isNotEmpty && list.length > 0
          ? ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          height: 1 * SizeConfig.heightMultiplier,
        ),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Container(
            height: 5 * SizeConfig.heightMultiplier,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  spreadRadius: 0.5,
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    list[index],
                    style: TextStyle(
                      fontFamily: "Brand Bold",
                      fontSize: 2.2 * SizeConfig.textMultiplier,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                        setState(() {
                          list.removeAt(index);
                        });
                        await databaseMethods.updateSavedPatientDocField({"medicine": list}, widget.name,
                            firebaseAuth.currentUser.uid);
                        if (list.isEmpty) {
                          setState(() {
                            addPVisible = true;
                            pHeaderVisible = false;
                          });
                        }
                    },
                    padding: EdgeInsets.all(2),
                    icon: Icon(
                      CupertinoIcons.clear_thick,
                      color: Color(0xFFa81845),
                      size: 4 * SizeConfig.imageSizeMultiplier,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      )
          : Container(),
    );
  }

  Widget prescriptionAdd({String hint,}) {
    TextEditingController controller = TextEditingController();
    return Container(
      width: double.infinity,
      height: 4 * SizeConfig.heightMultiplier,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 60 * SizeConfig.widthMultiplier,
            child: TextField(
              controller: controller,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontFamily: "Brand-Regular",
                  color: Colors.grey,
                  fontSize: 2 * SizeConfig.textMultiplier,
                ),
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(5, 10, 10, 5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              style: TextStyle(
                fontSize: 1.8 * SizeConfig.textMultiplier,
                fontFamily: "Brand-Regular",
              ),
            ),
          ),
          Container(
            width: 15 * SizeConfig.widthMultiplier,
            height: 4 * SizeConfig.heightMultiplier,
            child: RaisedButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  if (pHeaderVisible == false) {
                    setState(() {
                      med.add(controller.text);
                      controller.text = "";
                    });
                    await databaseMethods.updateSavedPatientDocField({"medicine": med}, widget.name,
                      firebaseAuth.currentUser.uid,
                    );
                  }
                }
              },
              padding: EdgeInsets.all(0),
              color: Colors.white,
              splashColor: Color(0xFFa81845).withOpacity(0.6),
              highlightColor: Colors.grey.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Text("Add", style: TextStyle(
                  fontFamily: "Brand Bold",
                  color: Color(0xFFa81845),
                  fontSize: 2 * SizeConfig.textMultiplier,
                ),
                ),
              ),
            ),
          ),
          Container(
            width: 15 * SizeConfig.widthMultiplier,
            height: 4 * SizeConfig.heightMultiplier,
            child: RaisedButton(
              onPressed: () {
                if (med.isEmpty) {
                  setState(() {
                    pAddVisible = false;
                    addPVisible = true;
                  });
                } else if (med.isNotEmpty && med.length > 0) {
                  setState(() {
                    pAddVisible = false;
                    pHeaderVisible = true;
                  });
                }
              },
              padding: EdgeInsets.all(0),
              color: Color(0xFFa81845),
              splashColor: Colors.white,
              highlightColor: Colors.grey.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Text("Cancel", style: TextStyle(
                  fontFamily: "Brand Bold",
                  color: Colors.white,
                  fontSize: 2 * SizeConfig.textMultiplier,
                ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
