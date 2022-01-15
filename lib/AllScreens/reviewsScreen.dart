import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/Chat/cachedImage.dart';
import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:portfolio_app/AllScreens/bookAppointmentScreen.dart';
import 'package:portfolio_app/AllScreens/loginScreen.dart';
import 'package:portfolio_app/Doctor/doctorAccount.dart';
import 'package:portfolio_app/Utilities/utils.dart';
import 'package:portfolio_app/constants.dart';
import 'package:portfolio_app/main.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
/*
* Created by Mujuzi Moses
*/

class ReviewsScreen extends StatefulWidget {

  static const String screenId = "reviewsScreen";
  final bool isDoctor;
  final Stream reviewStream;
  final String doctorsName;
  final String doctorsUID;
  final String userPic;
  final String doctorsRating;
  final int size;
  const ReviewsScreen({Key key, this.isDoctor, this.reviewStream, this.doctorsName, this.doctorsUID,
    this.userPic, this.doctorsRating, this.size,
  }) : super(key: key);

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {

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
    return new PickUpLayout(
        scaffold: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: Colors.grey[100],
            title: Text(widget.isDoctor == true ? "My Reviews" : "Doctor's Reviews",
              style: TextStyle(
                fontFamily: "Brand Bold",
                color: Color(0xFFa81845),
            ),),
          ),
          floatingActionButton: widget.isDoctor != true ? FloatingActionButton(
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
                title: Text("Rate Doctor", style: TextStyle(
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
                        int oldPercentage = int.parse(widget.doctorsRating);
                        int oldReviews = oldPercentage * widget.size;
                        int newReviews = (oldReviews + starCounter).round();
                        int newPercentage = (newReviews / (widget.size + 1)).round();

                        Map<String, dynamic> reviewMap = {
                          "created_at": FieldValue.serverTimestamp(),
                          "name": Constants.myName,
                          "percentage": "${starCounter.toInt()}",
                          "profile_photo": widget.userPic,
                          "review_text": reviewTEC.text,
                        };
                        await databaseMethods.addDoctorReview(reviewMap, widget.doctorsUID);
                        await databaseMethods.updateDoctorDocField({"reviews": "$newPercentage"}, widget.doctorsUID);
                        displaySnackBar(message: "Thank you for reviewing Dr. ${widget.doctorsName}", context: context);
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
            ) : Container(),
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

Widget reviewTile({DateTime dateTime, userName, percentage, userPhoto, reviewText, BuildContext context}) {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: 2 * SizeConfig.widthMultiplier,
        vertical: 0.3 * SizeConfig.heightMultiplier
    ),
    child: Container(
      width: MediaQuery.of(context).size.width,
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
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CachedImage(
                  imageUrl: userPhoto,
                  isRound: true,
                  radius: 40,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                Text(userName, style: TextStyle(
                  fontFamily: "Brand Bold",
                  fontSize: 2.3 * SizeConfig.textMultiplier,
                ),),
              ],
            ),
            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                getReviews(percentage, ""),
                Spacer(),
                Text(Utils.formatDate(dateTime), style: TextStyle(
                  fontFamily: "Brand-Regular",
                  fontSize: 2 * SizeConfig.textMultiplier,
                ),),
              ],
            ),
            SizedBox(height: 2 * SizeConfig.heightMultiplier,),
            getAbout(reviewText),
          ],
        ),
      ),
    ),
  );
}
