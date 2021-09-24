import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey[100],
          titleSpacing: 0,
          title: Text("Notifications", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Colors.red[300],
          ),),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[100],
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: <Widget>[
                Container(
                  height: 11 * SizeConfig.heightMultiplier,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
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
                          height: 8 * SizeConfig.heightMultiplier,
                          width: 16 * SizeConfig.widthMultiplier,
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Icon(FontAwesomeIcons.newspaper,
                              color: Colors.red[300],
                            ),
                          ),
                        ),
                        SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("New post from Dr. Aaron Paul", style: TextStyle(
                              fontFamily: "Brand Bold",
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                            ),),
                            Container(
                              width: 68 * SizeConfig.widthMultiplier,
                              child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do "
                                  "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad "
                                  "minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex "
                                  "ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate "
                                  "velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat "
                                  "cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id "
                                  "est laborum.", maxLines: 3, overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: "Brand-Regular",
                                  fontSize: 2 * SizeConfig.textMultiplier,
                                  color: Colors.black54,
                              ),),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: Clip.hardEdge,
                              height: 4 * SizeConfig.heightMultiplier,
                              width: 6 * SizeConfig.widthMultiplier,
                              child: IconButton(
                                splashColor: Colors.red[200],
                                highlightColor: Colors.grey.withOpacity(0.1),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => AlertDialog(
                                      title: Text("Remove this notification?"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("No"),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                        FlatButton(
                                          child: Text("Yes"),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                padding: EdgeInsets.all(0),
                                icon: Icon(CupertinoIcons.clear, size: 3 * SizeConfig.imageSizeMultiplier,),
                                ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Container(
                  height: 11 * SizeConfig.heightMultiplier,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
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
                          height: 8 * SizeConfig.heightMultiplier,
                          width: 16 * SizeConfig.widthMultiplier,
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Container(
                              width: 6.4 * SizeConfig.widthMultiplier,
                              child: Stack(
                                children: <Widget>[
                                  Icon(CupertinoIcons.alarm_fill, color: Colors.red[300],),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.red[100]
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: 2
                                        ),
                                        child: Icon(FontAwesomeIcons.pills, color: Colors.red[300],
                                          size: 3 * SizeConfig.imageSizeMultiplier,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("New medicine reminder", style: TextStyle(
                              fontFamily: "Brand Bold",
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                            ),),
                            Container(
                              width: 68 * SizeConfig.widthMultiplier,
                              child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do "
                                  "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad "
                                  "minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex "
                                  "ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate "
                                  "velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat "
                                  "cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id "
                                  "est laborum.", maxLines: 3, overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: "Brand-Regular",
                                  fontSize: 2 * SizeConfig.textMultiplier,
                                  color: Colors.black54,
                              ),),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: Clip.hardEdge,
                              height: 4 * SizeConfig.heightMultiplier,
                              width: 6 * SizeConfig.widthMultiplier,
                              child: IconButton(
                                splashColor: Colors.red[200],
                                highlightColor: Colors.grey.withOpacity(0.1),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => AlertDialog(
                                      title: Text("Remove this notification?"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("No"),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                        FlatButton(
                                          child: Text("Yes"),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                padding: EdgeInsets.all(0),
                                icon: Icon(CupertinoIcons.clear, size: 3 * SizeConfig.imageSizeMultiplier,),
                                ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Container(
                  height: 11 * SizeConfig.heightMultiplier,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
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
                          height: 8 * SizeConfig.heightMultiplier,
                          width: 16 * SizeConfig.widthMultiplier,
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Icon(FontAwesomeIcons.exclamationTriangle,
                              color: Colors.red[300],
                            ),
                          ),
                        ),
                        SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("New health alert", style: TextStyle(
                              fontFamily: "Brand Bold",
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                            ),),
                            Container(
                              width: 68 * SizeConfig.widthMultiplier,
                              child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do "
                                  "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad "
                                  "minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex "
                                  "ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate "
                                  "velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat "
                                  "cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id "
                                  "est laborum.", maxLines: 3, overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: "Brand-Regular",
                                  fontSize: 2 * SizeConfig.textMultiplier,
                                  color: Colors.black54,
                              ),),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: Clip.hardEdge,
                              height: 4 * SizeConfig.heightMultiplier,
                              width: 6 * SizeConfig.widthMultiplier,
                              child: IconButton(
                                splashColor: Colors.red[200],
                                highlightColor: Colors.grey.withOpacity(0.1),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => AlertDialog(
                                      title: Text("Remove this notification?"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("No"),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                        FlatButton(
                                          child: Text("Yes"),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                padding: EdgeInsets.all(0),
                                icon: Icon(CupertinoIcons.clear, size: 3 * SizeConfig.imageSizeMultiplier,),
                                ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Container(
                  height: 11 * SizeConfig.heightMultiplier,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
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
                          height: 8 * SizeConfig.heightMultiplier,
                          width: 16 * SizeConfig.widthMultiplier,
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Container(
                              width: 6.4 * SizeConfig.widthMultiplier,
                              child: Stack(
                                children: <Widget>[
                                  Icon(CupertinoIcons.alarm_fill, color: Colors.red[300],),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: Colors.red[100]
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 2
                                        ),
                                        child: Icon(FontAwesomeIcons.calendarAlt, color: Colors.red[300],
                                          size: 3 * SizeConfig.imageSizeMultiplier,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("New appointment reminder", style: TextStyle(
                              fontFamily: "Brand Bold",
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                            ),),
                            Container(
                              width: 68 * SizeConfig.widthMultiplier,
                              child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do "
                                  "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad "
                                  "minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex "
                                  "ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate "
                                  "velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat "
                                  "cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id "
                                  "est laborum.", maxLines: 3, overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: "Brand-Regular",
                                  fontSize: 2 * SizeConfig.textMultiplier,
                                  color: Colors.black54,
                                ),),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: Clip.hardEdge,
                              height: 4 * SizeConfig.heightMultiplier,
                              width: 6 * SizeConfig.widthMultiplier,
                              child: IconButton(
                                splashColor: Colors.red[200],
                                highlightColor: Colors.grey.withOpacity(0.1),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => AlertDialog(
                                      title: Text("Remove this notification?"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("No"),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                        FlatButton(
                                          child: Text("Yes"),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                padding: EdgeInsets.all(0),
                                icon: Icon(CupertinoIcons.clear, size: 3 * SizeConfig.imageSizeMultiplier,),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Container(
                  height: 11 * SizeConfig.heightMultiplier,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
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
                          height: 8 * SizeConfig.heightMultiplier,
                          width: 16 * SizeConfig.widthMultiplier,
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Icon(CupertinoIcons.calendar_badge_plus,
                              color: Colors.red[300],
                            ),
                          ),
                        ),
                        SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("New event alert", style: TextStyle(
                              fontFamily: "Brand Bold",
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                            ),),
                            Container(
                              width: 68 * SizeConfig.widthMultiplier,
                              child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do "
                                  "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad "
                                  "minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex "
                                  "ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate "
                                  "velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat "
                                  "cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id "
                                  "est laborum.", maxLines: 3, overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: "Brand-Regular",
                                  fontSize: 2 * SizeConfig.textMultiplier,
                                  color: Colors.black54,
                                ),),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: Clip.hardEdge,
                              height: 4 * SizeConfig.heightMultiplier,
                              width: 6 * SizeConfig.widthMultiplier,
                              child: IconButton(
                                splashColor: Colors.red[200],
                                highlightColor: Colors.grey.withOpacity(0.1),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => AlertDialog(
                                      title: Text("Remove this notification?"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("No"),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                        FlatButton(
                                          child: Text("Yes"),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                padding: EdgeInsets.all(0),
                                icon: Icon(CupertinoIcons.clear, size: 3 * SizeConfig.imageSizeMultiplier,),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
