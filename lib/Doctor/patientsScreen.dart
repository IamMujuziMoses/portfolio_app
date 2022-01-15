import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/Doctor/addPatientScreen.dart';
import 'package:creativedata_app/Doctor/patientProfile.dart';
import 'package:creativedata_app/Doctor/privatePatientProfile.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class PatientsScreen extends StatelessWidget {
  final Stream patientsStream;
  const PatientsScreen({Key key, this.patientsStream}) : super(key: key);

  Widget patientList() {
    return StreamBuilder(
      stream: patientsStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? Container(
          child: ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              bool private = snapshot.data.docs[index].get("private");
              String name = snapshot.data.docs[index].get("name");
              String pic = snapshot.data.docs[index].get("pic");
              String phone = snapshot.data.docs[index].get("phone");
              List medicine = snapshot.data.docs[index].get("medicine");
              if (private == true) {
                return PrivatePatientTile(
                  pic: pic,
                  phone: phone,
                  name: name,
                  med: medicine,
                );
              } else if (private == false) {
                String healthDep = snapshot.data.docs[index].get("health_department");
                String height = snapshot.data.docs[index].get("height");
                String weight = snapshot.data.docs[index].get("weight");
                String bmi = snapshot.data.docs[index].get("bmi");
                String pressure = snapshot.data.docs[index].get("pressure");
                String pulse = snapshot.data.docs[index].get("pulse");
                String fileNo = snapshot.data.docs[index].get("file_number");
                String dob = snapshot.data.docs[index].get("date_of_birth");
                String recruited = snapshot.data.docs[index].get("recruited");
                String pt = snapshot.data.docs[index].get("pt_no");
                String diagnosis = snapshot.data.docs[index].get("diagnosis");
                String residence = snapshot.data.docs[index].get("residence");
                String street = snapshot.data.docs[index].get("street");
                String city = snapshot.data.docs[index].get("city");
                String email = snapshot.data.docs[index].get("email");
                String kin = snapshot.data.docs[index].get("next_of_kin");
                String smoking = snapshot.data.docs[index].get("smoking");
                String famDiabetes = snapshot.data.docs[index].get("family_with_diabetes");
                String famPressure = snapshot.data.docs[index].get("family_with_pressure");
                String famCancer = snapshot.data.docs[index].get("family_with_cancer");
                String alcoholic = snapshot.data.docs[index].get("alcoholic");
                String allergies = snapshot.data.docs[index].get("allergies");
                String sex = snapshot.data.docs[index].get("sex");
                List allergyMed = snapshot.data.docs[index].get("allergies_medication");
                return PatientTile(
                  healthDep: healthDep,
                  height: height,
                  weight: weight,
                  bmi: bmi,
                  pressure: pressure,
                  pulse: pulse,
                  fileNo: fileNo,
                  name: name,
                  pic: pic,
                  dob: dob,
                  recruited: recruited,
                  pt: pt,
                  diagnosis: diagnosis,
                  residence: residence,
                  street: street,
                  city: city,
                  phone: phone,
                  email: email,
                  kin: kin,
                  smoking: smoking,
                  famDiabetes: famDiabetes,
                  famPressure: famPressure,
                  famCancer: famCancer,
                  alcoholic: alcoholic,
                  allergies: allergies,
                  sex: sex,
                  medicine: medicine,
                  allergyMed: allergyMed,
                );
              } else {
                return Container();
              }
            },
          ),
        ) : Container(
          child: Center(
            child: Text("You have no saved patients"),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.grey[100],
          title: Text("My Patients", style: TextStyle(
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
            child: Icon(CupertinoIcons.person_add_solid, color: Colors.white,),
          ),
          onPressed: () => Navigator.push(
            context, MaterialPageRoute(
            builder: (context) => AddPatientScreen(),
          ),
          ),
        ),
        body: Container(
          color: Colors.grey[100],
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.only(
              left: 4, right: 4,
            ),
            child: patientList(),
          ),
        ),
      ),
    );
  }
}

class PrivatePatientTile extends StatelessWidget {
  final String name;
  final String pic;
  final String phone;
  final List med;
  const PrivatePatientTile({Key key, this.name, this.pic, this.phone, this.med}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 1 * SizeConfig.heightMultiplier,
        horizontal: 1 * SizeConfig.heightMultiplier,
      ),
      child: RaisedButton(
        onPressed: () => Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => PrivatePatientProfile(
            name: name,
            pic: pic,
            phone: phone,
            medicine: med,
          ),
        ),
        ),
        padding: EdgeInsets.all(0),
        color: Colors.white,
        highlightColor: Colors.grey.withOpacity(0.1),
        splashColor: Color(0xFFa81845),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: 15 * SizeConfig.heightMultiplier,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 1 * SizeConfig.heightMultiplier,
              horizontal: 1 * SizeConfig.widthMultiplier,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 20 * SizeConfig.widthMultiplier,
                      height: 10 * SizeConfig.heightMultiplier,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        border: Border.all(color: Color(0xFFa81845), style: BorderStyle.solid, width: 2),
                      ),
                      child: pic == null
                          ? Image.asset("images/user_icon.png")
                          : CachedImage(
                        imageUrl: pic,
                        isRound: true,
                        radius: 10,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                Container(
                  width: 70 * SizeConfig.widthMultiplier,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 45 * SizeConfig.widthMultiplier,
                        child: Text(name, overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: "Brand Bold",
                            fontSize: 2.7 * SizeConfig.textMultiplier,
                          ),),
                      ),
                      Container(
                        width: 22 * SizeConfig.widthMultiplier,
                        child: Text("Contacted you", overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: "Brand-Regular",
                            fontSize: 1.8 * SizeConfig.textMultiplier,
                          ),),
                      ),
                    ],
                  ),
                      Center(
                        child: Text("Access Restricted", style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                          color: Colors.grey,
                        ),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PatientTile extends StatelessWidget {
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
  const PatientTile({Key key, this.healthDep, this.height, this.weight, this.bmi, this.pressure, this.pulse,
    this.fileNo, this.name, this.dob, this.recruited, this.pt, this.diagnosis, this.residence, this.street,
    this.city, this.phone, this.email, this.kin, this.smoking, this.famDiabetes, this.famPressure,
    this.famCancer, this.alcoholic, this.allergies, this.sex, this.medicine, this.allergyMed, this.pic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 1 * SizeConfig.heightMultiplier,
        horizontal: 1 * SizeConfig.heightMultiplier,
      ),
      child: RaisedButton(
        onPressed: () => Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => PatientProfile(
            healthDep: healthDep,
            height: height,
            weight: weight,
            bmi: bmi,
            pressure: pressure,
            pulse: pulse,
            fileNo: fileNo,
            name: name,
            pic: pic,
            dob: dob,
            recruited: recruited,
            pt: pt,
            diagnosis: diagnosis,
            residence: residence,
            street: street,
            city: city,
            phone: phone,
            email: email,
            kin: kin,
            smoking: smoking,
            famDiabetes: famDiabetes,
            famPressure: famPressure,
            famCancer: famCancer,
            alcoholic: alcoholic,
            allergies: allergies,
            sex: sex,
            medicine: medicine,
            allergyMed: allergyMed,
          ),
        ),
        ),
        padding: EdgeInsets.all(0),
        color: Colors.white,
        highlightColor: Colors.grey.withOpacity(0.1),
        splashColor: Color(0xFFa81845),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: 15 * SizeConfig.heightMultiplier,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 1 * SizeConfig.heightMultiplier,
              horizontal: 1 * SizeConfig.widthMultiplier,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 20 * SizeConfig.widthMultiplier,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        border: Border.all(color: Color(0xFFa81845), style: BorderStyle.solid, width: 2),
                      ),
                      child: pic == null
                          ? Image.asset("images/user_icon.png")
                          : CachedImage(
                        imageUrl: pic,
                        isRound: true,
                        radius: 10,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                Container(
                  width: 70 * SizeConfig.widthMultiplier,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 45 * SizeConfig.widthMultiplier,
                            child: Text(name, overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                              fontFamily: "Brand Bold",
                              fontSize: 2.7 * SizeConfig.textMultiplier,
                            ),),
                          ),
                          Container(
                            width: 22 * SizeConfig.widthMultiplier,
                            child: Text("Added by you", overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Brand-Regular",
                                fontSize: 1.8 * SizeConfig.textMultiplier,
                            ),),
                          ),
                        ],
                      ),
                     Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 40 * SizeConfig.widthMultiplier,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 3 * SizeConfig.heightMultiplier,
                                  width: 6 * SizeConfig.widthMultiplier,
                                  decoration: BoxDecoration(
                                    gradient: kPrimaryGradientColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Icon(FontAwesomeIcons.fileMedicalAlt,
                                      size: 3 * SizeConfig.imageSizeMultiplier,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 33 * SizeConfig.widthMultiplier,
                                  child: Text(diagnosis, overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                    fontFamily: "Brand-Regular",
                                    color: Color(0xFFa81845),
                                    fontSize: 2 * SizeConfig.textMultiplier,
                                  ),),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 28 * SizeConfig.widthMultiplier,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 3 * SizeConfig.heightMultiplier,
                                  width: 6 * SizeConfig.widthMultiplier,
                                  decoration: BoxDecoration(
                                    gradient: kPrimaryGradientColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Icon(FontAwesomeIcons.pills,
                                      size: 3 * SizeConfig.imageSizeMultiplier,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 22 * SizeConfig.widthMultiplier,
                                  height: 3 * SizeConfig.heightMultiplier,
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) => Center(
                                      child: Text(", ", style: TextStyle(
                                        fontFamily: "Brand-Regular",
                                        color: Color(0xFFa81845),
                                        fontSize: 2 * SizeConfig.textMultiplier,
                                      ),),
                                    ),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: medicine.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: Center(
                                          child: Text(medicine[index], style: TextStyle(
                                            fontFamily: "Brand-Regular",
                                            color: Color(0xFFa81845),
                                            fontSize: 2 * SizeConfig.textMultiplier,
                                          ),),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
