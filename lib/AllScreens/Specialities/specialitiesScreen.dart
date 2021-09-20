import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/newsFeedScreen.dart';
import 'package:creativedata_app/AllScreens/specialityScreen.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class SpecialitiesScreen extends StatefulWidget {
  static const String screenId = "specialitiesScreen";
  SpecialitiesScreen({Key key}) : super(key: key);

  @override
  _SpecialitiesScreenState createState() => _SpecialitiesScreenState();
}

class _SpecialitiesScreenState extends State<SpecialitiesScreen> {

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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.grey[100],
          title: Text("Specialities", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Colors.red[300],
          ),),
          actions: <Widget>[
            IconButton(
              splashColor: Colors.red[200],
              highlightColor: Colors.grey.withOpacity(0.1),
              padding: EdgeInsets.only(right: 4 * SizeConfig.widthMultiplier),
              onPressed: () {},
              icon: Icon(CupertinoIcons.search, color: Colors.red[300],),
            ),
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[100],
          child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.5 * SizeConfig.widthMultiplier),
                child: Container(
                  child: ListView.separated(
                    itemCount: specialitiesList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(5),
                    physics: ClampingScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(height: 2 * SizeConfig.widthMultiplier,),
                    itemBuilder: (context,index) {
                      return GestureDetector(
                        onTap: ()  => Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => SpecialityScreen(speciality: specialitiesList[index],),
                        ),),
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
                                    color: Colors.red[100],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Icon(FontAwesomeIcons.userMd, color: Colors.red[300],),
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
