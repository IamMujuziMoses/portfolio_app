import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/doctorProfileScreen.dart';
import 'package:portfolio_app/Services/database.dart';
import 'package:portfolio_app/Widgets/progressDialog.dart';
import 'package:portfolio_app/constants.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class HospDoctors extends StatefulWidget {
  final String service;
  final IconData icon;
  final String hospitalName;
  final List doctorsList;
  const HospDoctors({Key key, this.service, this.icon, this.hospitalName, this.doctorsList}) : super(key: key);

  @override
  _HospDoctorsState createState() => _HospDoctorsState();
}

class _HospDoctorsState extends State<HospDoctors> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        titleSpacing: 0,
        elevation: 0,
        title: Text(widget.service, style: TextStyle(
          fontFamily: "Brand Bold",
          color: Color(0xFFa81845)
        ),),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[100],
        child: Padding(
          padding: EdgeInsets.only(
            left: 2, right: 2, bottom: 20,
          ),
          child: widget.doctorsList != null && widget.doctorsList.length > 0
              ? ListView.separated(
            itemBuilder: (context, index) {
              return DoctorsTile(
                doctorsName: widget.doctorsList[index],
                icon: widget.icon,
              );
            },
            separatorBuilder: (context, index) => Divider(thickness: 2,),
            itemCount: widget.doctorsList.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
          ) : Container(
            height: 10 * SizeConfig.heightMultiplier,
            child: Center(
              child: Text("No Doctors at the moment"),
            ),
          ),
        ),
      ),
    );
  }
}

class DoctorsTile extends StatelessWidget {
  final IconData icon;
  final String doctorsName;
  DoctorsTile({Key key, this.icon, this.doctorsName}) : super(key: key);

  DatabaseMethods databaseMethods = DatabaseMethods();
  String imageUrl = "";
  String speciality = "";
  String hospital = "";
  String reviews = "";
  String uid = "";
  String age = "";
  String hours = "";
  String patients = "";
  String experience = "";
  String email = "";
  String about = "";
  List days = [];
  Map fee = Map();

  getDoctorInfo() async {
    QuerySnapshot snap;
    await databaseMethods.getUserByUsername(doctorsName).then((val) {
      snap = val;
      imageUrl = snap.docs[0].get("profile_photo");
      speciality = snap.docs[0].get("speciality");
      hospital = snap.docs[0].get("hospital");
      reviews = snap.docs[0].get("reviews");
      uid = snap.docs[0].get("uid");
      age = snap.docs[0].get("age");
      hours = snap.docs[0].get("hours");
      patients = snap.docs[0].get("patients");
      experience = snap.docs[0].get("years");
      email = snap.docs[0].get("email");
      about = snap.docs[0].get("about");
      days = snap.docs[0].get("days");
      fee = snap.docs[0].get("fee");
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      splashColor: Color(0xFFa81845).withOpacity(0.6),
      highlightColor: Colors.grey.withOpacity(0.1),
      onPressed: () async{
        showDialog(
            context: context,
            builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
        );
        await getDoctorInfo();

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorProfileScreen(
              imageUrl: imageUrl,
              doctorsName: doctorsName,
              speciality: speciality,
              hospital: hospital,
              reviews: reviews,
              uid: uid,
              doctorsAge: age,
              hours: hours,
              patients: patients,
              experience: experience,
              doctorsEmail: email,
              about: about,
              days: days,
              fee: fee,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 4 * SizeConfig.heightMultiplier,
              width:  8 * SizeConfig.widthMultiplier,
              decoration: BoxDecoration(
                gradient: kPrimaryGradientColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 4 * SizeConfig.imageSizeMultiplier,
                ),
              ),
            ),
            SizedBox(width: 1.4 * SizeConfig.widthMultiplier,),
            Container(
              width: 60 * SizeConfig.widthMultiplier,
              child: Text("Dr. $doctorsName", overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Brand Bold",
                  ),),
            ),
          ],
        ),
      ),
    );
  }
}

