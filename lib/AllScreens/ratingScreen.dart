import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Widgets/divider.dart';
import 'package:creativedata_app/configMaps.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
/*
* Created by Mujuzi Moses
*/

class RatingScreen extends StatefulWidget {
  final String driverPic;
  final String driverName;
  RatingScreen({Key key, this.driverPic, this.driverName}) : super(key: key);

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {

  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text("Rating", style: TextStyle(fontFamily: "Brand Bold"),),
          backgroundColor: Colors.red[300],
        ),
        body: Container(
          color: Colors.grey[100],
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                height: 20 * SizeConfig.heightMultiplier,
                child: Center(
                  child: Container(
                    height: 15 * SizeConfig.heightMultiplier,
                    width: 30 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      border: Border.all(color: Colors.redAccent, style: BorderStyle.solid, width: 2),
                    ),
                    child: widget.driverPic == null
                        ? Image.asset("images/user_icon.png")
                        : CachedImage(
                      imageUrl: widget.driverPic,
                      isRound: true,
                      radius: 10,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Text(widget.driverName, textAlign: TextAlign.center ,style: TextStyle(
                fontSize: 3.5 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.bold,
                fontFamily: "Brand Bold",
                color: Colors.red[300],
              ),),
              SizedBox(height: 3 * SizeConfig.widthMultiplier,),
              Container(
                width: 88 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Rate this Ambulance Driver", style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Brand Bold",
                        fontSize: 3 * SizeConfig.textMultiplier,
                      ),),
                      SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                      DividerWidget(),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                      SmoothStarRating(
                        rating: starCounter,
                        color: Colors.red[300],
                        allowHalfRating: false,
                        starCount: 5,
                        size: 8 * SizeConfig.imageSizeMultiplier,
                        onRated: (val) {
                          if (val == 1) {
                            starCounter = 5;
                            setState(() {
                              title = "Very Bad Driver";
                            });
                          }
                           if (val == 2) {
                             starCounter = 25;
                            setState(() {
                              title = "Bad Driver";
                            });
                          }
                           if (val == 3) {
                             starCounter = 50;
                            setState(() {
                              title = "Good Driver";
                            });
                          }
                           if (val == 4) {
                             starCounter = 75;
                            setState(() {
                              title = "Very Good Driver";
                            });
                          }
                           if (val == 5) {
                             starCounter = 100;
                            setState(() {
                              title = "Excellent Driver";
                            });
                          }

                        },
                      ),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                      DividerWidget(),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                      Text(title, style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Brand Bold",
                        fontSize: 3.5 * SizeConfig.textMultiplier,
                      ),),
                      SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          onPressed: () => Navigator.pop(context, starCounter),
                          color: Colors.red[300],
                          textColor: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("Submit".toUpperCase(), style: TextStyle(
                                  fontSize: 2.2 * SizeConfig.textMultiplier,
                                ),),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2 * SizeConfig.heightMultiplier,),
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
