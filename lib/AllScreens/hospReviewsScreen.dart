import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/bookAppointmentScreen.dart';
import 'package:creativedata_app/AllScreens/loginScreen.dart';
import 'package:creativedata_app/AllScreens/reviewsScreen.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/main.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
/*
* Created by Mujuzi Moses
*/

class HospReviewsScreen extends StatefulWidget {
  final Stream reviewStream;
  final String hospName;
  final String hospDocId;
  final String hospRating;
  final String myPhoto;
  final int size;
  const HospReviewsScreen({Key key, this.reviewStream, this.hospRating, this.size, this.hospName,
    this.hospDocId, this.myPhoto,
  }) : super(key: key);

  @override
  _HospReviewsScreenState createState() => _HospReviewsScreenState();
}

class _HospReviewsScreenState extends State<HospReviewsScreen> {

  TextEditingController reviewTEC = TextEditingController();
  double starCounter = 5;

  Widget reviewList() {
    return StreamBuilder(
      stream: widget.reviewStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            Timestamp dateStr = snapshot.data.docs[index].get("created_at");
            DateTime dateTime = dateStr != null ? dateStr.toDate() : DateTime.now();
            String userName = snapshot.data.docs[index].get("name");
            String percentage = snapshot.data.docs[index].get("percentage");
            String userPhoto = snapshot.data.docs[index].get("profile_photo");
            String reviewText = snapshot.data.docs[index].get("review_text");
            return reviewTile(
              dateTime: dateTime,
              userName: userName,
              userPhoto: userPhoto,
              percentage: percentage,
              reviewText: reviewText,
              context: context,
            );
          },
        )
            : Container();
      },
    );
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
          title: Text("Hospital's Reviews",
            style: TextStyle(
              fontFamily: "Brand Bold",
              color: Color(0xFFa81845),
            ),),
        ),
        floatingActionButton: FloatingActionButton(
          clipBehavior: Clip.hardEdge,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: kPrimaryGradientColor,
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.auto_awesome, color: Colors.white,),
                  Text("Rate", style: TextStyle(
                    fontFamily: "Brand Bold",
                    color: Colors.white,
                  ),),
                ],
              ),
            ),
          ),
          onPressed: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text("Rate Hospital", style: TextStyle(
                fontFamily: "Brand Bold",
                fontSize: 2.5 * SizeConfig.textMultiplier,
              ),),
              content: Container(
                height: 30 * SizeConfig.heightMultiplier,
                width: 80 * SizeConfig.widthMultiplier,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Center(
                      child: SmoothStarRating(
                        rating: starCounter,
                        color: Color(0xFFa81845),
                        allowHalfRating: false,
                        starCount: 5,
                        size: 8 * SizeConfig.imageSizeMultiplier,
                        onRated: (val) {
                          if (val == 1) {
                            setState(() {
                              starCounter = 5;
                            });
                          }
                          if (val == 2) {
                            setState(() {
                              starCounter = 25;
                            });
                          }
                          if (val == 3) {
                            setState(() {
                              starCounter = 50;
                            });
                          }
                          if (val == 4) {
                            setState(() {
                              starCounter = 75;
                            });
                          }
                          if (val == 5) {
                            setState(() {
                              starCounter = 100;
                            });
                          }
                        },
                      ),
                    ),
                    TextField(
                      controller: reviewTEC,
                      keyboardType: TextInputType.multiline,
                      maxLines: 14,
                      minLines: 8,
                      decoration: InputDecoration(
                        hintText: "Enter your review...",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Brand-Regular",
                          fontSize: 1.5 * SizeConfig.textMultiplier,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 2 * SizeConfig.textMultiplier,
                        fontFamily: "Brand-Regular",
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel", style: TextStyle(
                    fontFamily: "Brand Bold",
                  ),),
                  onPressed: () {
                    setState(() {
                      starCounter = 5;
                      reviewTEC.text = "";
                    });
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Submit", style: TextStyle(
                    fontFamily: "Brand Bold",
                  ),),
                  onPressed: () async {
                    if (reviewTEC.text.isEmpty) {
                      displayToastMessage("Enter your review comment", context);
                    } else {
                      int oldPercentage = int.parse(widget.hospRating);
                      int oldReviews = oldPercentage * widget.size;
                      int newReviews = (oldReviews + starCounter).round();
                      int newPercentage = (newReviews / (widget.size + 1)).round();

                      Map ratingsMap = {
                        "people": "${widget.size + 1}",
                        "percentage": "$newPercentage",
                      };

                      Map<String, dynamic> update = {
                        "ratings": ratingsMap,
                      };

                      Map<String, dynamic> reviewMap = {
                        "created_at": FieldValue.serverTimestamp(),
                        "name": Constants.myName,
                        "percentage": "${starCounter.toInt()}",
                        "profile_photo": widget.myPhoto,
                        "review_text": reviewTEC.text,
                      };
                      await databaseMethods.addHospitalReview(reviewMap, widget.hospDocId);
                      await databaseMethods.updateHospitalDocField({"percentage": "$newPercentage"}, widget.hospDocId);
                      await databaseMethods.updateHospitalDocField(update, widget.hospDocId);
                      displaySnackBar(message: "Thank you for reviewing; ${widget.hospName}", context: context);
                      setState(() {
                        starCounter = 5;
                        reviewTEC.text = "";
                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[100],
          child: widget.reviewStream.first != null ? reviewList() : Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.auto_awesome,
                  size: 20 * SizeConfig.imageSizeMultiplier,
                  color: Colors.grey,
                ),
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Text("No Reviews Available", style: TextStyle(
                  fontFamily: "Brand Bold",
                  color: Colors.grey,
                  fontSize: 3 * SizeConfig.textMultiplier,
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
