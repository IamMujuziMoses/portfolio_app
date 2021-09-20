import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/VideoChat/videoView.dart';
import 'package:creativedata_app/AllScreens/specialityScreen.dart';
import 'package:creativedata_app/AllScreens/Specialities/specialitiesScreen.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/Hospitals/hospitalProfileScreen.dart';
import 'package:creativedata_app/Doctor/doctorAccount.dart';
import 'package:creativedata_app/Hospitals/hospitalsScreen.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
/*
* Created by Mujuzi Moses
*/

class FindADoctorScreen extends StatefulWidget {
  final QuerySnapshot ihkSnap;
  final QuerySnapshot mulagoSnap;
  final QuerySnapshot caseSnap;
  final QuerySnapshot kibuliSnap;
  final QuerySnapshot adSnap;
  static const String screenId = "findADoctorScreen";

  const FindADoctorScreen({Key key, this.ihkSnap, this.mulagoSnap, this.caseSnap, this.kibuliSnap, this.adSnap}) : super(key: key);

  @override
  _FindADoctorScreenState createState() => _FindADoctorScreenState();
}

class _FindADoctorScreenState extends State<FindADoctorScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
        scaffold: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[100],
            titleSpacing: 0,
            elevation: 0,
            title: Text("Find A Doctor", style: TextStyle(
              fontFamily: "Brand Bold",
              color: Colors.red[300],
            ),),
            actions: <Widget>[
              IconButton(
                  onPressed: () {},
                  color: Colors.red[300],
                  splashColor: Colors.red[200],
                  icon: Icon(CupertinoIcons.search,
                  ),),
            ],
          ),
          body: Stack(
            fit: StackFit.loose,
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        Container(
                            height: 4 * SizeConfig.heightMultiplier,
                            width: 94 * SizeConfig.widthMultiplier,
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Row(
                                children: <Widget>[
                                  Text("Specialities", style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Brand Bold",
                                      fontSize: 3.3 * SizeConfig.textMultiplier,
                                    ),),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                      context, MaterialPageRoute(
                                      builder: (context) => SpecialitiesScreen(),
                                    ),),
                                    child: Text("View All", style: TextStyle(
                                      color: Colors.red[300],
                                      fontFamily: "Brand Bold",
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Container(
                          width: 94 * SizeConfig.widthMultiplier,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                                left: 5,
                                right: 1,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      _getSpec(logo:"images/stethoscope.png", speciality: "General Doctor"),
                                      SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                      _getSpec(logo: "images/heart.png", speciality: "Cardiology"),
                                      SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                      _getSpec(logo: "images/tooth.png",speciality: "Dentist"),
                                      SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                      _getSpec(icon: FontAwesomeIcons.baby, speciality: "Pediatrics"),
                                    ],
                                  ),
                                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                  Row(
                                    children: <Widget>[
                                      _getSpec(logo: "images/eye.png",speciality: "Ophthalmology"),
                                      SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                      _getSpec(logo: "images/lungs.png",speciality: "Pneumology"),
                                      SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                      _getSpec(logo: "images/brain.png", speciality: "Neurology"),
                                      SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                      _getSpec(icon: Icons.do_not_disturb, speciality: "Obstetrics"),
                                    ],
                                  ),
                                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                  Row(
                                    children: <Widget>[
                                      _getSpec(icon: Icons.do_not_disturb, speciality: "Gynecology"),
                                      SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                      _getSpec(icon: Icons.do_not_disturb, speciality: "Rheumatology"),
                                      SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                      _getSpec(icon: Icons.do_not_disturb, speciality: "Nephrology"),
                                      SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                      _getSpec(icon: Icons.do_not_disturb, speciality: "Gastroenterology"),
                                    ],
                                  ),
                                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                  Row(
                                    children: <Widget>[
                                      _getSpec(icon: Icons.do_not_disturb, speciality: "Dermatology"),
                                      SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                      _getSpec(icon: Icons.do_not_disturb, speciality: "Psychiatry"),
                                      SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                      _getSpec(icon: Icons.do_not_disturb, speciality: "Oncology"),
                                      SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                      _getSpec(icon: Icons.do_not_disturb, speciality: "Plastic Surgery"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Container(
                          height: 4 * SizeConfig.heightMultiplier,
                          width: 94 * SizeConfig.widthMultiplier,
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Row(
                              children: <Widget>[
                                Text("Health Centers", style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Brand Bold",
                                  fontSize: 3.3 * SizeConfig.textMultiplier,
                                ),),
                                Spacer(),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                      context, MaterialPageRoute(
                                    builder: (context) => HospitalsScreen(),
                                  ),),
                                  child: Text("View All", style: TextStyle(
                                    color: Colors.red[300],
                                    fontFamily: "Brand Bold",
                                    fontSize: 2 * SizeConfig.textMultiplier,
                                  ),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 3 * SizeConfig.widthMultiplier,
                            right: 3 * SizeConfig.widthMultiplier,
                          ),
                          child: Container(
                            height: 25 * SizeConfig.heightMultiplier,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                              ),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                  _topRatedHC(
                                    hospitalSnap: widget.mulagoSnap,
                                  ),
                                  SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                  _topRatedHC(
                                    hospitalSnap: widget.caseSnap,
                                  ),
                                  SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                  _topRatedHC(
                                    hospitalSnap: widget.kibuliSnap,
                                  ),
                                  SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                  _topRatedHC(
                                    hospitalSnap: widget.ihkSnap,
                                  ),
                                  SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
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
                            child: widget.adSnap.docs.isEmpty ? Center(
                              child: Text("AD", style: TextStyle(fontSize: 10 * SizeConfig.textMultiplier, color: Colors.black12),),
                            ) : VideoView(
                              showControls: false,
                              videoPlayerController: VideoPlayerController.network(widget.adSnap.docs[0].get("url"),
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
      );
  }

  _getSpec({String logo, String speciality, IconData icon}) {
    return FlatButton(
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 2,
      ),
      splashColor: Colors.red[300],
      highlightColor: Colors.red[100],
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10),
      ),
      onPressed: () => Navigator.push(
      context, MaterialPageRoute(
      builder: (context) => SpecialityScreen(speciality: speciality,),
    ),),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 8 * SizeConfig.heightMultiplier,
            width:  16 * SizeConfig.widthMultiplier,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: logo != null ? Image.asset(logo,
                    color: Colors.black54,
                    height: 5 * SizeConfig.imageSizeMultiplier,
                    width: 10 * SizeConfig.imageSizeMultiplier,
                    fit: BoxFit.contain,
                  ) : Icon(icon,
                color: Colors.black54,
                size: 14 * SizeConfig.imageSizeMultiplier,
              ),
            ),
          ),
          SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
          Container(
            width: 21 * SizeConfig.widthMultiplier,
            child: Text(speciality, textAlign: TextAlign.center ,style: TextStyle(
              color: Colors.black54,
              fontFamily: "Brand Bold",
              fontSize: 1.8 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.w500,
            ),),
          )
        ],
      ),
    );
  }

  _topRatedHC({QuerySnapshot hospitalSnap}) {
    String name = hospitalSnap.docs[0].get("name");
    String imageUrl = hospitalSnap.docs[0].get("hospital_photo");
    String about = hospitalSnap.docs[0].get("about");
    Map ratingsMap = hospitalSnap.docs[0].get("ratings");
    String ratings = ratingsMap["percentage"];
    String phone = hospitalSnap.docs[0].get("phone");
    String people = ratingsMap["people"];
    String uid = hospitalSnap.docs[0].get("uid");
    String email = hospitalSnap.docs[0].get("email");
    String address = hospitalSnap.docs[0].get("address");
    List services = hospitalSnap.docs[0].get("services");

    onTap() => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HospitalProfileScreen(
          uid: uid,
          imageUrl: imageUrl,
          ratings: ratings,
          people: people,
          phone: phone,
          name: name,
          email: email,
          about: about,
          address: address,
          services: services,
        ),
      ),
    );

    return Container(
        width: 50 * SizeConfig.widthMultiplier,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              spreadRadius: 0.5,
              blurRadius: 2,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.red[300], width: 1.0),
        ),
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(2),
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  height: 13 * SizeConfig.heightMultiplier,
                  width: 50 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: CachedImage(
                    height: 10 * SizeConfig.heightMultiplier,
                    width: double.infinity,
                    imageUrl: imageUrl,
                    radius: 10,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.all(2),
                child: Container(
                  height: 8 * SizeConfig.heightMultiplier,
                  width: 50 * SizeConfig.widthMultiplier,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                    child: InkWell(
                      splashColor: Colors.red[200],
                      highlightColor: Colors.grey.withOpacity(0.1),
                      radius: 800,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                      onTap: onTap,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(name, style: TextStyle(
                                fontFamily: "Brand Bold",
                                fontSize: 2.5 * SizeConfig.textMultiplier,
                              ), overflow: TextOverflow.ellipsis,),
                            ),
                            Container(
                              child: Text(about, style: TextStyle(
                                fontFamily: "Brand-Regular",
                                fontSize: 2 * SizeConfig.textMultiplier,
                              ), overflow: TextOverflow.ellipsis,),
                            ),
                            getReviews(ratings, ""),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      );
  }
}

Widget arrowBox({String greeting, String message, String image, IconData icon, Function onTap}) {
  return Container(
    width: 80 * SizeConfig.widthMultiplier,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          offset: Offset(1, 3),
          spreadRadius: 0.5,
          blurRadius: 2,
          color: Colors.black.withOpacity(0.1),
        ),
      ],
      color: Colors.white,
    ),
    child: Padding(
            padding: EdgeInsets.only(
              left: 8,
              right: 8
            ),
            child: Row(
              children: <Widget>[
                Container(
                  height: 6 * SizeConfig.heightMultiplier,
                  width: 15 * SizeConfig.widthMultiplier,
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: icon == null ? Image.asset(image,
                        color: Colors.black54,
                      ) : Icon(icon,
                      color: Colors.black54,
                      size: 10 * SizeConfig.imageSizeMultiplier,
                    ),
                  ),
                ),
                SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                Container(
                  width: 58 * SizeConfig.widthMultiplier,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 1 * SizeConfig.heightMultiplier,
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(greeting, style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Brand Bold",
                              fontSize: 2 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w500
                            ),),
                            Spacer(),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 0.5 * SizeConfig.heightMultiplier,
                            bottom: 1 * SizeConfig.heightMultiplier,
                          ),
                          child: Container(
                                width: 85 * SizeConfig.widthMultiplier,
                                child: Wrap(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 2 * SizeConfig.widthMultiplier),
                                      child: Text(message,
                                        maxLines: 3, style: TextStyle(
                                          fontFamily: "Brand-Regular",
                                          fontSize: 1.7 * SizeConfig.textMultiplier,
                                        ), overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    height: 4 * SizeConfig.heightMultiplier,
                    width: 6 * SizeConfig.widthMultiplier,
                    child: Center(
                      child: Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.red,
                        size: 4 * SizeConfig.imageSizeMultiplier,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
  );
}
