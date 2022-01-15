import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class TripEndedDialog extends StatelessWidget {
  const TripEndedDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.grey[100],
      child: Container(
        margin: EdgeInsets.all(5),
        height: 30 * SizeConfig.heightMultiplier,
        width: 80 * SizeConfig.widthMultiplier,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
            Text("You Have Arrived", style: TextStyle(
              fontSize: 3 * SizeConfig.textMultiplier,
              color: Color(0xFFa81845),
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
            Divider(height: 0.5 * SizeConfig.heightMultiplier, color: Color(0xFFa81845), thickness: 2,),
            SizedBox(height: 2 * SizeConfig.heightMultiplier,),
            Container(
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
              child: Expanded(
                flex: 0,
                child: Container(
                  width: 76 * SizeConfig.widthMultiplier,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      children: [
                        Text("You have arrived at the Hospital, have a nice day, and get well soon", style: TextStyle(
                        fontSize: 2 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Brand Bold",
                      ),),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: RaisedButton(
                clipBehavior: Clip.hardEdge,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: () => Navigator.pop(context, "close"),
                textColor: Colors.white,
                child: Container(
                  width: 100 * SizeConfig.widthMultiplier,
                  height: 6 * SizeConfig.heightMultiplier,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 6.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7),
                        ),
                      ],
                      gradient: kPrimaryGradientColor
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2 * SizeConfig.widthMultiplier),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Finish Trip".toUpperCase(), style: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),),
                        Icon(FontAwesomeIcons.hospitalUser,
                          color: Colors.white,
                          size: 6 * SizeConfig.imageSizeMultiplier,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
          ],
        ),
      ),
    );
  }
}
