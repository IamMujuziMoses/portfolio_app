import 'package:creativedata_app/AllScreens/siroWeb.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class CausesAndSpread extends StatelessWidget {
  const CausesAndSpread({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.grey[100],
        title: Text("Causes & Spread", style: TextStyle(
          fontFamily: "Brand Bold",
          color: Colors.red[300],
        ),),
      ),
      body: Container(
        color: Colors.grey[100],
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
                Text("COVID-19 Cause", style: TextStyle(
                  fontFamily: "Brand Bold",
                  fontSize: 3 * SizeConfig.textMultiplier,
                ),),
                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                Padding(
                  padding: EdgeInsets.only(
                    left: 2 * SizeConfig.widthMultiplier,
                    right: 2 * SizeConfig.widthMultiplier,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 15 * SizeConfig.heightMultiplier,
                        width: 30 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(1, 2),
                              spreadRadius: 0.5,
                              blurRadius: 2,
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset("images/covid19_2.png",
                            height: 10 * SizeConfig.heightMultiplier,
                            width: 20 * SizeConfig.widthMultiplier,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                      Container(
                        width: 60 * SizeConfig.widthMultiplier,
                        child: Text("COVID-19 is caused by infection with the severe acute "
                            "respiratory syndrome coronavirus 2 (SARS-CoV-2) virus strain.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10 * SizeConfig.heightMultiplier,),
                Text("How it's Spread", style: TextStyle(
                  fontFamily: "Brand Bold",
                  color: Colors.red[300],
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
                      Text("SARS-CoV-2 spread from person to person through close contacts.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                        fontFamily: "Brand-Regular",
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                      ),),
                      SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 10 * SizeConfig.heightMultiplier,
                            width: 20 * SizeConfig.widthMultiplier,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(1, 2),
                                  spreadRadius: 0.5,
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(FontAwesomeIcons.headSideCough,
                                color: Colors.black54,
                                size: 12 * SizeConfig.imageSizeMultiplier,
                              ),
                            ),
                          ),
                          SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                          Container(
                            width: 70 * SizeConfig.widthMultiplier,
                            child: Text("It spread from person-to-person through sneezing and coughing droplets.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontFamily: "Brand-Regular",
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                              ),),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => SiroWeb(url: 'https://www.who.int',),
                  ),
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("For more information, Visit:", textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 2 * SizeConfig.textMultiplier,
                            fontFamily: "Brand-Regular",
                          ),),
                        Text("WHO", textAlign: TextAlign.center,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.red[300],
                            fontFamily: "Brand Bold",
                            fontSize: 2 * SizeConfig.textMultiplier,
                          ),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
