import 'package:creativedata_app/Covid-19/covid19Center.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class SignsAndSymptoms extends StatelessWidget {
  const SignsAndSymptoms({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.grey[100],
        title: Text("Signs & Symptoms", style: TextStyle(
        fontFamily: "Brand Bold",
        color: Color(0xFFa81845),),
      ),),
      body: Container(
        color: Colors.grey[100],
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: 2 * SizeConfig.heightMultiplier,
              bottom: 2 * SizeConfig.heightMultiplier,
              left: 2 * SizeConfig.widthMultiplier,
              right: 2 * SizeConfig.widthMultiplier,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Severe", style: TextStyle(
                  fontFamily: "Brand Bold",
                  fontSize: 3 * SizeConfig.textMultiplier,
                ),),
                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                Padding(
                  padding: EdgeInsets.only(
                    left: 2 * SizeConfig.widthMultiplier,
                    right: 2 * SizeConfig.widthMultiplier,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          customTiles(
                            desc: "Shortness of Breath/ Difficulty Breathing",
                            icon: FontAwesomeIcons.ban,
                            height: 8 * SizeConfig.heightMultiplier,
                            width: 24 * SizeConfig.widthMultiplier,
                            iconSize: 10 * SizeConfig.imageSizeMultiplier,
                            textWidth: 30 * SizeConfig.widthMultiplier,
                            onTap: () {},
                          ),
                          customTiles(
                            desc: "Loss of Speech/ Mobility/ Confusion",
                            icon: FontAwesomeIcons.ban,
                            height: 8 * SizeConfig.heightMultiplier,
                            width: 24 * SizeConfig.widthMultiplier,
                            textWidth: 30 * SizeConfig.widthMultiplier,
                            iconSize: 10 * SizeConfig.imageSizeMultiplier,
                            onTap: () {},
                          ),
                          customTiles(
                            desc: "Chest Pain\n ",
                            icon: FontAwesomeIcons.ban,
                            height: 8 * SizeConfig.heightMultiplier,
                            width: 24 * SizeConfig.widthMultiplier,
                            textWidth: 30 * SizeConfig.widthMultiplier,
                            iconSize: 10 * SizeConfig.imageSizeMultiplier,
                            onTap: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                      Text("Caution:", style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                      ),),
                      Padding(
                        padding: EdgeInsets.only(left: 2 * SizeConfig.widthMultiplier),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("1. If you develop any of these symptoms, call your health care provider, or "
                                "health facility and seek medical care and attention immediately.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 2.2 * SizeConfig.textMultiplier, fontFamily: "Brand-Regular",
                              ),),
                            SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                            Text("2. This is not an Exhaustive list. These are the most common symptoms of "
                                "serious illness, but you could get very sick with other symptoms - if you "
                                "have any questions, call for help immediately.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 2.2 * SizeConfig.textMultiplier, fontFamily: "Brand-Regular",
                              ),),
                            SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                          ],
                        ),
                      ),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                    ],
                  ),
                ),
                Text("Most Common", style: TextStyle(
                  fontFamily: "Brand Bold",
                  fontSize: 2.5 * SizeConfig.textMultiplier,
                ),),
                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                Padding(
                  padding: EdgeInsets.only(
                    left: 1 * SizeConfig.widthMultiplier,
                    right: 1 * SizeConfig.widthMultiplier,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      customTiles(
                        desc: "Fever\n ",
                        icon: Icons.sick_rounded,
                        height: 8 * SizeConfig.heightMultiplier,
                        width: 20 * SizeConfig.widthMultiplier,
                        textWidth: 18 * SizeConfig.widthMultiplier,
                        iconSize: 10 * SizeConfig.imageSizeMultiplier,
                        onTap: () {},
                      ),
                      customTiles(
                        desc: "Cough\n ",
                        icon: FontAwesomeIcons.headSideCough,
                        height: 8 * SizeConfig.heightMultiplier,
                        width: 20 * SizeConfig.widthMultiplier,
                        textWidth: 20 * SizeConfig.widthMultiplier,
                        iconSize: 10 * SizeConfig.imageSizeMultiplier,
                        onTap: () {},
                      ),
                      customTiles(
                        desc: "Tiredness\n ",
                        icon: FontAwesomeIcons.ban,
                        height: 8 * SizeConfig.heightMultiplier,
                        width: 20 * SizeConfig.widthMultiplier,
                        textWidth: 18 * SizeConfig.widthMultiplier,
                        iconSize: 10 * SizeConfig.imageSizeMultiplier,
                        onTap: () {},
                      ),
                      customTiles(
                        desc: "Loss of Taste/ Smell",
                        icon: FontAwesomeIcons.ban,
                        height: 8 * SizeConfig.heightMultiplier,
                        width: 20 * SizeConfig.widthMultiplier,
                        textWidth: 18 * SizeConfig.widthMultiplier,
                        iconSize: 10 * SizeConfig.imageSizeMultiplier,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Text("Less Common", style: TextStyle(
                  fontFamily: "Brand Bold",
                  fontSize: 3 * SizeConfig.textMultiplier,
                ),),
                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                Padding(
                  padding: EdgeInsets.only(
                    left: 2.5 * SizeConfig.widthMultiplier,
                    right: 2.5 * SizeConfig.widthMultiplier,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          customTiles(
                            desc: "Sore Throat",
                            icon: FontAwesomeIcons.ban,
                            height: 8 * SizeConfig.heightMultiplier,
                            width: 24 * SizeConfig.widthMultiplier,
                            textWidth: 30 * SizeConfig.widthMultiplier,
                            iconSize: 10 * SizeConfig.imageSizeMultiplier,
                            onTap: () {},
                          ),
                          customTiles(
                            desc: "Headache",
                            icon: FontAwesomeIcons.ban,
                            height: 8 * SizeConfig.heightMultiplier,
                            width: 24 * SizeConfig.widthMultiplier,
                            textWidth: 30 * SizeConfig.widthMultiplier,
                            iconSize: 10 * SizeConfig.imageSizeMultiplier,
                            onTap: () {},
                          ),
                          customTiles(
                            desc: "Aches & Pains",
                            icon: FontAwesomeIcons.ban,
                            height: 8 * SizeConfig.heightMultiplier,
                            width: 24 * SizeConfig.widthMultiplier,
                            textWidth: 30 * SizeConfig.widthMultiplier,
                            iconSize: 10 * SizeConfig.imageSizeMultiplier,
                            onTap: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          customTiles(
                            desc: "Diarrhea",
                            icon: FontAwesomeIcons.ban,
                            height: 8 * SizeConfig.heightMultiplier,
                            width: 24 * SizeConfig.widthMultiplier,
                            textWidth: 30 * SizeConfig.widthMultiplier,
                            iconSize: 10 * SizeConfig.imageSizeMultiplier,
                            onTap: () {},
                          ),
                          customTiles(
                            desc: "Rash on Skin",
                            icon: FontAwesomeIcons.allergies,
                            height: 8 * SizeConfig.heightMultiplier,
                            width: 24 * SizeConfig.widthMultiplier,
                            textWidth: 30 * SizeConfig.widthMultiplier,
                            iconSize: 10 * SizeConfig.imageSizeMultiplier,
                            onTap: () {},
                          ),
                          customTiles(
                            desc: "Red/ Irritated Eyes",
                            icon: FontAwesomeIcons.ban,
                            height: 8 * SizeConfig.heightMultiplier,
                            width: 24 * SizeConfig.widthMultiplier,
                            textWidth: 30 * SizeConfig.widthMultiplier,
                            iconSize: 10 * SizeConfig.imageSizeMultiplier,
                            onTap: () {},
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
