import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:portfolio_app/AllScreens/specialityScreen.dart';
import 'package:portfolio_app/constants.dart';
import 'package:portfolio_app/main.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class SpecialitiesScreen extends StatefulWidget {
  static const String screenId = "specialitiesScreen";
  const SpecialitiesScreen({Key key}) : super(key: key);

  @override
  _SpecialitiesScreenState createState() => _SpecialitiesScreenState();
}

List<String> specialitiesList = ["General Doctor", "Cardiology", "Dentist",
  "Pediatrics", "Ophthalmology", "Pneumology", "Neurology", "Obstetrics",
  "Gynecology", "Surgery", "Rheumatology", "Nephrology", "Gastroenterology",
  "Dermatology", "Psychiatry", "Oncology", "Plastic Surgery", "Orthopedic Surgery",
  "Allergist/Immunologist", "Radiology", "Endocrinology", "Otolaryngology",
  "Osteopaths", "Urology", "Internist", "Podiatry", "Physiology", "Medical Geneticist",
  "Vascular Surgery", "Colon Surgery", "Rectal Surgery", "Sleep Medicine Specialist",
  "Sport Medicine Specialist", "Infectious Disease Specialist", "Geriatric Medicine Specialist",
  "Cardiovascular Surgery", "Thoracic Surgery", "Occupational Medicine Specialist",
  "Physical, Medical and Rehabilitation",
];

class _SpecialitiesScreenState extends State<SpecialitiesScreen> {

  TextEditingController searchTEC = TextEditingController();
  bool searchVisible = false;
  bool titleVisible = true;
  List specialityOnSearch = [];

  showHideSearchBar() {
    if (searchVisible == false && titleVisible == true) {
      setState(() {
        searchVisible = true;
        titleVisible = false;
      });
    } else if (searchVisible == true && titleVisible == false) {
      setState(() {
        searchVisible = false;
        titleVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.grey[100],
          title: Stack(
              children: <Widget>[
                Visibility(
                  visible: titleVisible,
                  child: Text("Specialities", style: TextStyle(
                    fontFamily: "Brand Bold",
                    color: Color(0xFFa81845),
                  ),),
                ),
                Visibility(
                  visible: searchVisible,
                  child: Container(
                    height: 5 * SizeConfig.heightMultiplier,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          specialityOnSearch = specialitiesList.where((element) => element.toLowerCase()
                              .contains(value.toLowerCase())).toList();
                        });
                      },
                      controller: searchTEC,
                      maxLines: 1,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Search for speciality...",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                        fontFamily: "Brand-Regular",
                      ),
                    ),
                  ),
                ),
              ]
          ),
          actions: <Widget>[
            Stack(
              children: <Widget>[
                Visibility(
                  visible: titleVisible,
                  child: IconButton(
                    onPressed: () => showHideSearchBar(),
                    splashColor: Color(0xFFa81845).withOpacity(0.6),
                    icon: Icon(CupertinoIcons.search, color: Color(0xFFa81845),
                    ),),
                ),
                Visibility(
                  visible: searchVisible,
                  child: IconButton(
                    onPressed: () {
                      searchTEC.text = "";
                      specialityOnSearch.clear();
                      showHideSearchBar();
                    },
                    color: Color(0xFFa81845),
                    splashColor: Color(0xFFa81845).withOpacity(0.6),
                    icon: Icon(CupertinoIcons.clear,
                    ),),
                ),
              ],
            ),
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[100],
          child: searchTEC.text.isNotEmpty && specialityOnSearch.length > 0 ? ListView.builder(
            itemCount: specialityOnSearch.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 0.5 * SizeConfig.heightMultiplier,
                  horizontal: 3.5 * SizeConfig.widthMultiplier,
                ),
                child: GestureDetector(
                  onTap: () async {
                    QuerySnapshot doctorSnap;
                    await databaseMethods.getAllDoctorsBySpecialitySnap(specialityOnSearch[index]).then((val) {
                      setState(() {
                        doctorSnap= val;
                      });
                    });
                    List doctorsList = [];
                    for (int i = 0; i <= doctorSnap.size - 1; i++) {
                      doctorsList.add(doctorSnap.docs[i].get("name"));
                    }
                    Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) => SpecialityScreen(
                        doctors: doctorsList,
                        speciality: specialityOnSearch[index],
                      ),
                    ),);
                    Future.delayed(Duration(seconds: 1), () {
                      setState(() {
                        searchTEC.text = "";
                        specialityOnSearch.clear();
                        searchVisible = false;
                        titleVisible = true;
                      });
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 5 * SizeConfig.heightMultiplier,
                        width: 10 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          gradient: kPrimaryGradientColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Icon(FontAwesomeIcons.userMd, color: Colors.white,),
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
          ) : Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.5 * SizeConfig.widthMultiplier),
                child: Container(
                  child: ListView.builder(
                    itemCount: specialitiesList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(5),
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context,index) {
                      return GestureDetector(
                        onTap: () async {
                          QuerySnapshot doctorSnap;
                          await databaseMethods.getAllDoctorsBySpecialitySnap(specialitiesList[index]).then((val) {
                            setState(() {
                              doctorSnap= val;
                            });
                          });
                          List doctorsList = [];
                          for (int i = 0; i <= doctorSnap.size - 1; i++) {
                            doctorsList.add(doctorSnap.docs[i].get("name"));
                          }
                          Navigator.push(
                            context, MaterialPageRoute(
                            builder: (context) => SpecialityScreen(
                              doctors: doctorsList,
                              speciality: specialitiesList[index],
                            ),
                          ),);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.5 * SizeConfig.heightMultiplier),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(2, 3),
                                  spreadRadius: 0.5,
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 16 * SizeConfig.widthMultiplier,
                                    height: 8 * SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                      gradient: kPrimaryGradientColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Icon(FontAwesomeIcons.userMd, color: Colors.white,),
                                    ),
                                  ),
                                  SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                  Container(
                                    width: 68 * SizeConfig.widthMultiplier,
                                    child: Text(specialitiesList[index], overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: "Brand Bold",
                                          fontSize: 2.5 * SizeConfig.textMultiplier,
                                      ),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
