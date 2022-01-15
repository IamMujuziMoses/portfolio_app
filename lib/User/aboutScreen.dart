import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:portfolio_app/constants.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class AboutScreen extends StatelessWidget {
  final String title;
  final String heading;
  const AboutScreen({Key key,@required this.title, this.heading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          title: Text(title, style: TextStyle(
            fontFamily: "Brand Bold",
            color: Color(0xFFa81845),
          ),),
          backgroundColor: Colors.grey[100],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey[100],
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Row(
                  children: <Widget>[
                    Text(heading.toUpperCase(), style: TextStyle(
                      fontSize: 2 * SizeConfig.textMultiplier,
                      fontFamily: "Brand Bold",
                      fontWeight: FontWeight.w900,
                      color: Colors.black54,
                    ),),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Row(
                    children: <Widget>[
                      _tiles(
                        onTap: () {},
                        message: "Website",
                        image: "images/website.png",
                      ),
                      Spacer(),
                      _tiles(
                        onTap: () {},
                        message: "Instagram",
                        image: "images/instagram.png",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Row(
                    children: <Widget>[
                      _tiles(
                        onTap: () {},
                        message: "Twitter",
                        image: "images/twitter.png",
                      ),
                      Spacer(),
                      _tiles(
                        onTap: () {},
                        message: "Facebook",
                        image: "images/facebook.png",
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

  Widget _tiles({String message, String image, Function onTap}) {
    return Container(
      height: 20 * SizeConfig.heightMultiplier,
      width: 46 * SizeConfig.widthMultiplier,
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
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(2),
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 13 * SizeConfig.heightMultiplier,
                width: 50 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                  gradient: kPrimaryGradientColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Image.asset(image,
                    height: 12 * SizeConfig.heightMultiplier,
                    width: 16 * SizeConfig.widthMultiplier,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(2),
              child: Container(
                height: 5.7 * SizeConfig.heightMultiplier,
                width: 50 * SizeConfig.widthMultiplier,
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    splashColor: Color(0xFFa81845).withOpacity(0.6),
                    highlightColor: Colors.grey.withOpacity(0.1),
                    radius: 800,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                    onTap: onTap,
                    child: Center(
                      child: Text(message, style: TextStyle(
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Brand Bold",
                        color: Color(0xFFa81845),
                      ),),
                    ),
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
