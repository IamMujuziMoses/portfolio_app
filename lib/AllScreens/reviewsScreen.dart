import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class ReviewsScreen extends StatefulWidget {

  static const String screenId = "reviewsScreen";
  final bool isDoctor;
  const ReviewsScreen({Key key, this.isDoctor}) : super(key: key);

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new PickUpLayout(
        scaffold: new Scaffold(
          appBar: new AppBar(
            title: new Text("Reviews Screen"),
          ),
          body: Center(
            child: Text("This is Reviews Screen"),
          ),
        ),
      );
  }
}
