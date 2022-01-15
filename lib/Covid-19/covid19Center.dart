import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/Chat/cachedImage.dart';
import 'package:portfolio_app/AllScreens/siroWeb.dart';
import 'package:portfolio_app/Covid-19/causesAndSpread.dart';
import 'package:portfolio_app/Covid-19/preventiveMeasures.dart';
import 'package:portfolio_app/Covid-19/signsAndSymptoms.dart';
import 'package:portfolio_app/Covid-19/treatmentAndManagement.dart';
import 'package:portfolio_app/Covid-19/vaccinationCenters.dart';
import 'package:portfolio_app/main.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class Covid19Center extends StatefulWidget {
  final QuerySnapshot adSnap;
  const Covid19Center({Key key, @required this.adSnap}) : super(key: key);

  @override
  _Covid19CenterState createState() => _Covid19CenterState();
}

class _Covid19CenterState extends State<Covid19Center> {
  Stream vacStream;
  QuerySnapshot vacSnap;
  List vacList = [];
  List<DocumentSnapshot> vacQueryList = [];

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  getInfo() async {
    await databaseMethods.getVaccinationCenters().then((val) {
      setState(() {
        vacStream = val;
      });
    });
    vacSnap = await vacStream.first;
    for (int i = 0; i <= vacSnap.size -1; i++) {
      vacList.add(vacSnap.docs[i].id);
    }
    for (int i = 0; i <= vacList.length - 1; i++) {
      DocumentSnapshot vacCenterSnap;
      await databaseMethods.getVaccinationCentersByRegionSnap(vacList[i]).then((val) {
        setState(() {
          vacCenterSnap = val;
        });
      });
      vacQueryList.add(vacCenterSnap);
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.adSnap.docs.isEmpty ? "" : widget.adSnap.docs[0].get("url");
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.grey[100],
        title: Text("COVID-19 Center", style: TextStyle(fontFamily: "Brand Bold", color: Color(0xFFa81845)),),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Container(
                  width: 94 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 3),
                        spreadRadius: 0.5,
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("We are here to help".toUpperCase(), style: TextStyle(
                          fontFamily: "Brand Bold",
                          color: Colors.black54,
                          fontSize: 2.8 * SizeConfig.textMultiplier,
                        ),),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Container(
                          child: Text("People all-over the globe are suffering from the effects of the"
                              " Coronavirus/ Covid-19 in their lives. For that very reason, we are here to help"
                              " in any way possible, thus this SIRO application for emergency responses...",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                            fontFamily: "Brand-Regular",
                            fontSize: 2 * SizeConfig.textMultiplier,
                          ),),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                Container(
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 8,bottom: 8,
                          left: 5 * SizeConfig.widthMultiplier,
                          right: 5 * SizeConfig.widthMultiplier,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            customTiles(
                              desc: "Signs & Symptoms",
                              icon: FontAwesomeIcons.diagnoses,
                              height: 6 * SizeConfig.heightMultiplier,
                              width: 24 * SizeConfig.widthMultiplier,
                              textWidth: 30 * SizeConfig.widthMultiplier,
                              iconSize: 8 * SizeConfig.imageSizeMultiplier,
                              onTap: () => Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context) => SignsAndSymptoms(),
                              ),
                              ),
                            ),
                            customTiles(
                              desc: "Causes & Spread",
                              icon: FontAwesomeIcons.viruses,
                              height: 6 * SizeConfig.heightMultiplier,
                              width: 24 * SizeConfig.widthMultiplier,
                              textWidth: 30 * SizeConfig.widthMultiplier,
                              iconSize: 8 * SizeConfig.imageSizeMultiplier,
                              onTap: () => Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context) => CausesAndSpread(),
                              ),
                              ),
                            ),
                            customTiles(
                              desc: "Preventive Measures",
                              icon: FontAwesomeIcons.shieldVirus,
                              height: 6 * SizeConfig.heightMultiplier,
                              width: 24 * SizeConfig.widthMultiplier,
                              textWidth: 30 * SizeConfig.widthMultiplier,
                              iconSize: 8 * SizeConfig.imageSizeMultiplier,
                              onTap: () => Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context) => PreventiveMeasures(),
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.5 * SizeConfig.heightMultiplier,),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 8,bottom: 8,
                          left: 5 * SizeConfig.widthMultiplier,
                          right: 5 * SizeConfig.widthMultiplier,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            customTiles(
                              desc: "Treatment & Management",
                              icon: Icons.medical_services_rounded,
                              width: 24 * SizeConfig.widthMultiplier,
                              textWidth: 30 * SizeConfig.widthMultiplier,
                              height: 6 * SizeConfig.heightMultiplier,
                              iconSize: 8 * SizeConfig.imageSizeMultiplier,
                              onTap: () => Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context) => TreatmentAndManagement(),
                              ),
                              ),
                            ),
                            customTiles(
                              desc: "Vaccination Centers",
                              icon: FontAwesomeIcons.syringe,
                              height: 6 * SizeConfig.heightMultiplier,
                              width: 24 * SizeConfig.widthMultiplier,
                              textWidth: 30 * SizeConfig.widthMultiplier,
                              iconSize: 8 * SizeConfig.imageSizeMultiplier,
                              onTap: () async {
                                Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (context) => VaccinationCenters(
                                    vacCentersSnap: vacQueryList,
                                  ),
                                ),
                                );
                              },
                            ),
                            customTiles(
                              desc: "Check your Status",
                              icon: Icons.sick_rounded,
                              height: 6 * SizeConfig.heightMultiplier,
                              width: 24 * SizeConfig.widthMultiplier,
                              textWidth: 30 * SizeConfig.widthMultiplier,
                              iconSize: 8 * SizeConfig.imageSizeMultiplier,
                              onTap: () => Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context) => SiroWeb(url: 'https://www.cdc.gov/coronavirus/2019-ncov/symptoms-testing/coronavirus-self-checker.html/',),
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.5 * SizeConfig.heightMultiplier,),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 8,bottom: 8,
                          left: 5 * SizeConfig.widthMultiplier,
                          right: 5 * SizeConfig.widthMultiplier,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            customTiles(
                              desc: "WHO Updates",
                              icon: FontAwesomeIcons.ban,
                              height: 6 * SizeConfig.heightMultiplier,
                              width: 24 * SizeConfig.widthMultiplier,
                              textWidth: 30 * SizeConfig.widthMultiplier,
                              iconSize: 8 * SizeConfig.imageSizeMultiplier,
                              onTap: () => Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context) => SiroWeb(url: 'https://www.who.int/emergencies/diseases/novel-coronavirus-2019/',),
                              ),
                              ),
                            ),
                            customTiles(
                              desc: "COVID-19 Updates",
                              icon: Icons.coronavirus_rounded,
                              height: 6 * SizeConfig.heightMultiplier,
                              width: 24 * SizeConfig.widthMultiplier,
                              textWidth: 30 * SizeConfig.widthMultiplier,
                              iconSize: 8 * SizeConfig.imageSizeMultiplier,
                              onTap: () => Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context) => SiroWeb(url: 'https://www.worldometers.info/coronavirus/',),
                              ),
                              ),
                            ),
                            customTiles(
                              desc: "MoH Center",
                              icon: FontAwesomeIcons.ban,
                              height: 6 * SizeConfig.heightMultiplier,
                              width: 24 * SizeConfig.widthMultiplier,
                              textWidth: 30 * SizeConfig.widthMultiplier,
                              iconSize: 8 * SizeConfig.imageSizeMultiplier,
                              onTap: () => Navigator.push(
                              context, MaterialPageRoute(
                              builder: (context) => SiroWeb(url: 'https://www.health.go.ug/covid',),
                            ),
                            ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Sponsored", style: TextStyle(
                        fontFamily: "Brand Bold",
                        color: Colors.black54,
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                      ),),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: double.infinity,
                    height: 20 * SizeConfig.heightMultiplier,
                   decoration: BoxDecoration(
                     color: Colors.grey[300],
                     borderRadius: BorderRadius.circular(15),
                   ),
                    child: CachedImage(
                      isAd: true,
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      isRound: false,
                      radius: 0,
                    ),
                  ),
                ),
                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                Container(
                  width: 94 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 3),
                        spreadRadius: 0.5,
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Remember".toUpperCase(), style: TextStyle(
                          fontFamily: "Brand Bold",
                          color: Colors.black54,
                          fontSize: 2.8 * SizeConfig.textMultiplier,
                        ),),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Container(
                          child: Text("The Coronavirus does not spread itself, its the people that spread it, "
                              "Stay Safe and Keep Safe...",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                            fontFamily: "Brand-Regular",
                            fontSize: 2 * SizeConfig.textMultiplier,
                          ),),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 3 * SizeConfig.heightMultiplier,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget customTiles({String desc, Color color, IconData icon, Function onTap, textWidth, height, width, iconSize}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(1, 2),
              spreadRadius: 0.5,
              blurRadius: 2,
              color: Colors.black.withOpacity(0.3),
            ),
          ],
          color: color == null ? Colors.white : color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            splashColor: Color(0xFFa81845).withOpacity(0.6),
            highlightColor: Colors.grey.withOpacity(0.1),
            radius: 800,
            borderRadius: BorderRadius.circular(15),
            onTap: onTap,
            child: Center(
              child: Icon(icon, color: Colors.black54, size: iconSize),
            ),
          ),
        ),
      ),
      SizedBox(height: 1 * SizeConfig.heightMultiplier,),
      Container(
        width: textWidth,
        child: Wrap(
          children: <Widget>[
            Center(
              child: Text(
                desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 1.6 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Brand-Regular"
                ),),
            ),
          ],
        ),
      ),
    ],
  );
}
