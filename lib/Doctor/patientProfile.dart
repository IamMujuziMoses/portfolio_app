import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/bookAppointmentScreen.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Widgets/progressDialog.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
/*
* Created by Mujuzi Moses
*/

class PatientProfile extends StatefulWidget {
  final String healthDep;
  final String height;
  final String weight;
  final String bmi;
  final String pressure;
  final String pulse;
  final String fileNo;
  final String name;
  final String pic;
  final String dob;
  final String recruited;
  final String pt;
  final String diagnosis;
  final String residence;
  final String street;
  final String city;
  final String phone;
  final String email;
  final String kin;
  final String smoking;
  final String famDiabetes;
  final String famPressure;
  final String famCancer;
  final String alcoholic;
  final String allergies;
  final String sex;
  final List medicine;
  final List allergyMed;
  bool private;
  PatientProfile({Key key, this.healthDep, this.height, this.weight, this.bmi, this.pressure, this.pulse,
    this.fileNo, this.name, this.dob, this.recruited, this.pt, this.diagnosis, this.residence, this.street,
    this.city, this.phone, this.email, this.private, this.kin, this.smoking, this.famDiabetes, this.famPressure,
    this.famCancer, this.alcoholic, this.allergies, this.sex, this.medicine, this.allergyMed, this.pic,
  }) : super(key: key);

  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> with TickerProviderStateMixin {

  DatabaseMethods databaseMethods = DatabaseMethods();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool pHeaderVisible = true;
  bool pAddVisible = false;
  bool apHeaderVisible = true;
  bool apAddVisible = false;
  List med = [];
  List allergyMed = [];

  @override
  void initState() {
    med = widget.medicine;
    allergyMed = widget.allergyMed;
    super.initState();
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
            color: Colors.red[300],
          ),),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red[300],
          child: Icon(CupertinoIcons.trash_fill, color: Colors.white,),
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
                        color: Colors.red[300],
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
                          color: Colors.red[300],
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white,
                            border: Border.all(color: Colors.red[300], style: BorderStyle.solid, width: 2),
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
                      Container(
                        width: 50 * SizeConfig.widthMultiplier,
                        child: Text(widget.name, style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 3.5 * SizeConfig.textMultiplier,
                        ),),
                      ),
                      Spacer(),
                      Container(
                              height: 4 * SizeConfig.heightMultiplier,
                              width: 8 * SizeConfig.widthMultiplier,
                              child: RaisedButton(
                                onPressed: () => launch(('tel:${widget.phone}')),
                                color: Colors.red[300],
                                padding: EdgeInsets.all(0),
                                splashColor: Colors.white,
                                highlightColor: Colors.grey.withOpacity(0.1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: Icon(Icons.phone_rounded,
                                    color: Colors.white,
                                    size: 6 * SizeConfig.imageSizeMultiplier,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Text("Basic Information", style: TextStyle(
                    fontFamily: "Brand Bold",
                    color: Colors.grey,
                    fontSize: 3 * SizeConfig.textMultiplier,
                  ),),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      infoTile(title: "File No.:", message: widget.fileNo),
                      infoTile(title: "Pt No:", message: widget.pt,
                        width: 40 * SizeConfig.widthMultiplier,
                        containerWidth: 20 * SizeConfig.widthMultiplier,
                      ),
                    ],
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      infoTile(title: "D.O.B:", message: widget.dob),
                      infoTile(title: "Recr on:", message: widget.recruited,
                        width: 40 * SizeConfig.widthMultiplier,
                        containerWidth: 25 * SizeConfig.widthMultiplier,
                      ),
                    ],
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      infoTile(title: "Sex:", message: widget.sex),
                      infoTile(title: "Height:", message: widget.height,
                        width: 40 * SizeConfig.widthMultiplier,
                        containerWidth: 20 * SizeConfig.widthMultiplier,
                      ),
                    ],
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      infoTile(title: "Weight:", message: widget.weight),
                      infoTile(title: "BMI:", message: widget.bmi != null ? widget.bmi : "N/A",
                        width: 40 * SizeConfig.widthMultiplier,
                        containerWidth: 20 * SizeConfig.widthMultiplier,
                      ),
                    ],
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      infoTile(title: "Pressure:", message: widget.pressure),
                      infoTile(title: "Pulse:", message: widget.pulse,
                        width: 40 * SizeConfig.widthMultiplier,
                        containerWidth: 20 * SizeConfig.widthMultiplier,
                      ),
                    ],
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  infoTile(title: "Diagnosis:", message: widget.diagnosis,
                    width: 70 * SizeConfig.widthMultiplier,
                    containerWidth: 50 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                  infoTile(title: "Smoking:", message: widget.smoking,
                    width: 40 * SizeConfig.widthMultiplier,
                    containerWidth: 20 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  infoTile(title: "Alcoholic:", message: widget.alcoholic,
                    width: 40 * SizeConfig.widthMultiplier,
                    containerWidth: 20 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  infoTile(title: "Allergies:", message: widget.allergies,
                    width: 40 * SizeConfig.widthMultiplier,
                    containerWidth: 20 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 60 * SizeConfig.widthMultiplier,
                        child: Text("Prescription", overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: "Brand Bold",
                            color: Colors.black54,
                            fontSize: 2.5 * SizeConfig.textMultiplier,
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
                            padding: EdgeInsets.all(0),
                            color: Colors.white,
                            splashColor: Colors.red[200],
                            highlightColor: Colors.grey.withOpacity(0.1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text("Add", style: TextStyle(
                                fontFamily: "Brand Bold",
                                color: Colors.red[300],
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                              ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  med.isNotEmpty && med.length > 0
                      ? presCard(list: med, hint: "Medication")
                      : Container(),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Visibility(
                    visible: pAddVisible,
                    child: prescriptionAdd(hint: "Add prescription",),
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 60 * SizeConfig.widthMultiplier,
                        child: Text("Prescription for Allergies", overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: "Brand Bold",
                            color: Colors.black54,
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: apHeaderVisible,
                        child: Container(
                          width: 15 * SizeConfig.widthMultiplier,
                          height: 4 * SizeConfig.heightMultiplier,
                          child: RaisedButton(
                            onPressed: () {
                              if (widget.allergies == "Yes") {
                                setState(() {
                                  apAddVisible = true;
                                  apHeaderVisible = false;
                                });
                              } else {
                                displaySnackBar(message: "Can't add allergy prescription, patient has no allergies!",
                                    context: context, label: "OK",
                                );
                              }
                            },
                            padding: EdgeInsets.all(0),
                            color: Colors.white,
                            splashColor: Colors.red[200],
                            highlightColor: Colors.grey.withOpacity(0.1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text("Add", style: TextStyle(
                                fontFamily: "Brand Bold",
                                color: Colors.red[300],
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                              ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  widget.allergyMed.isNotEmpty && widget.allergyMed.length > 0
                      ? presCard(list: widget.allergyMed, hint: "AllergiesMed")
                      : Container(),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Visibility(
                    visible: apAddVisible,
                    child: prescriptionAdd(hint: "Add allergy prescription",),
                  ),
                  SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                  Text("Other Records", overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Brand Bold",
                      color: Colors.black,
                      fontSize: 3 * SizeConfig.textMultiplier,
                    ),
                  ),
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  Text("Family Health History", overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Brand Bold",
                      color: Colors.black54,
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                    ),
                  ),
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  infoTile(title: "Anyone with Diabetes:", message: widget.famDiabetes,
                    width: 60 * SizeConfig.widthMultiplier,
                    containerWidth: 20 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  infoTile(title: "Anyone with Pressure:", message: widget.famPressure,
                    width: 60 * SizeConfig.widthMultiplier,
                    containerWidth: 20 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  infoTile(title: "Anyone with Cancer:", message: widget.famCancer,
                    width: 60 * SizeConfig.widthMultiplier,
                    containerWidth: 20 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                  Text("Patient's Contacts", style: TextStyle(
                    fontFamily: "Brand Bold",
                    color: Colors.black45,
                    fontSize: 2.5 * SizeConfig.textMultiplier,
                  ),),
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  infoTile(title: "Residence:", message: widget.residence,
                    width: 70 * SizeConfig.widthMultiplier,
                    containerWidth: 40 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  infoTile(title: "City:", message: widget.city,
                    width: 70 * SizeConfig.widthMultiplier,
                    containerWidth: 40 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  infoTile(title: "Street:", message: widget.street,
                    width: 70 * SizeConfig.widthMultiplier,
                    containerWidth: 40 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  infoTile(title: "Tel:", message: widget.phone,
                    width: 70 * SizeConfig.widthMultiplier,
                    containerWidth: 40 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  infoTile(title: "E-mail:", message: widget.email,
                    width: 70 * SizeConfig.widthMultiplier,
                    containerWidth: 40 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  infoTile(title: "Next of Kin Tel:", message: widget.kin,
                    width: 70 * SizeConfig.widthMultiplier,
                    containerWidth: 40 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                ],
              ),
            ),
          ),
        ),
      ),
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
                    fontSize: 2 * SizeConfig.textMultiplier,
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
                      if (apHeaderVisible == false) {
                        setState(() {
                          allergyMed.add(controller.text);
                          controller.text = "";
                        });
                        await databaseMethods.updateSavedPatientDocField({"allergies_medication": allergyMed}, widget.name,
                          firebaseAuth.currentUser.uid,
                        );
                      }
                    }
                  },
                  padding: EdgeInsets.all(0),
                  color: Colors.white,
                  splashColor: Colors.red[200],
                  highlightColor: Colors.grey.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text("Add", style: TextStyle(
                        fontFamily: "Brand Bold",
                        color: Colors.red[300],
                        fontSize: 2.5 * SizeConfig.textMultiplier,
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
                    if (pHeaderVisible == false) {
                      setState(() {
                        pAddVisible = false;
                        pHeaderVisible = true;
                      });
                    }
                    if (apHeaderVisible == false) {
                      setState(() {
                        apAddVisible = false;
                        apHeaderVisible = true;
                      });
                    }
              },
              padding: EdgeInsets.all(0),
                  color: Colors.red[300],
                  splashColor: Colors.white,
                  highlightColor: Colors.grey.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text("Cancel", style: TextStyle(
                        fontFamily: "Brand Bold",
                        color: Colors.white,
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
  }

  Widget presCard({List list, String hint}) {
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
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (hint == "Medication") {
                        setState(() {
                          list.removeAt(index);
                        });
                        await databaseMethods.updateSavedPatientDocField({"medicine": list}, widget.name,
                            firebaseAuth.currentUser.uid);
                      }
                      if (hint == "AllergiesMed") {
                        setState(() {
                          list.removeAt(index);
                        });
                        await databaseMethods.updateSavedPatientDocField({"allergies_medication": list},
                            widget.name, firebaseAuth.currentUser.uid);
                      }
                    },
                    padding: EdgeInsets.all(2),
                    icon: Icon(
                      CupertinoIcons.clear_thick,
                      color: Colors.red[300],
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

  Widget infoTile({String title, String message, width, containerWidth}) {
    return Container(
      width: width == null ? 50 * SizeConfig.widthMultiplier : width,
      height: 4 * SizeConfig.heightMultiplier,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(
            fontFamily: "Brand Bold",
            fontSize: 2.3 * SizeConfig.textMultiplier,
          ),),
          Container(
            width: containerWidth == null ? 30 * SizeConfig.widthMultiplier : containerWidth,
            child: Text(message, textAlign: TextAlign.right, overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: "Brand-Regular",
                color: Colors.grey,
                fontSize: 2.3 * SizeConfig.textMultiplier,
            ),),
          ),
        ],
      ),
    );
  }
}
