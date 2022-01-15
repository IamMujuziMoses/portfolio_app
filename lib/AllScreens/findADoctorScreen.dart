import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/VideoChat/videoView.dart';
import 'package:creativedata_app/AllScreens/doctorProfileScreen.dart';
import 'package:creativedata_app/AllScreens/specialityScreen.dart';
import 'package:creativedata_app/AllScreens/Specialities/specialitiesScreen.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/Hospitals/hospitalProfileScreen.dart';
import 'package:creativedata_app/Doctor/doctorAccount.dart';
import 'package:creativedata_app/Hospitals/hospitalsScreen.dart';
import 'package:creativedata_app/Widgets/progressDialog.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/main.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
/*
* Created by Mujuzi Moses
*/

class FindADoctorScreen extends StatefulWidget {
  final QuerySnapshot adSnap;
  final List<QuerySnapshot> hospSnap;
  final List doctors;
  static const String screenId = "findADoctorScreen";

  const FindADoctorScreen({Key key, this.adSnap, this.doctors, this.hospSnap}) : super(key: key);

  @override
  _FindADoctorScreenState createState() => _FindADoctorScreenState();
}

class _FindADoctorScreenState extends State<FindADoctorScreen> {

  TextEditingController searchTEC = TextEditingController();
  bool searchVisible = false;
  bool titleVisible = true;
  List doctorOnSearch = [];
  List doctors = [];
  VideoPlayerController controller;

  @override
  void initState() {
    if (!mounted) return;
    getDoctorsList();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  getDoctorsList() {
    controller = VideoPlayerController.network(widget.adSnap.docs[0].get("url"));
    setState(() {
      doctors = widget.doctors;
    });
  }

  showHideSearchBar() {
    if (searchVisible == false && titleVisible == true) {
      setState(() {
        searchVisible = true;
        titleVisible = false;
      });
    } else if (searchVisible == true && titleVisible == false) {
      setState(() {
        searchVisible = false;
        titleVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
        scaffold: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[100],
            titleSpacing: 0,
            elevation: 0,
            title: Stack(
                children: <Widget>[
                  Visibility(
                    visible: titleVisible,
                    child: Text("Find A Doctor", style: TextStyle(
                      fontFamily: "Brand Bold",
                      color: Color(0xFFa81845),
                    ),),
                  ),
                  Visibility(
                    visible: searchVisible,
                    child: Container(
                      height: 5 * SizeConfig.heightMultiplier,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            doctorOnSearch = doctors.where((element) => element.toLowerCase()
                                .contains(value.toLowerCase())).toList();
                          });
                        },
                        controller: searchTEC,
                        maxLines: 1,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Search for doctor...",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: "Brand-Regular",
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          fontFamily: "Brand-Regular",
                        ),
                      ),
                    ),
                  ),
                ]
            ),
            actions: <Widget>[
              Stack(
                children: <Widget>[
                  Visibility(
                    visible: titleVisible,
                    child: IconButton(
                      onPressed: () => showHideSearchBar(),
                      splashColor: Color(0xFFa81845).withOpacity(0.6),
                      icon: Icon(CupertinoIcons.search, color: Color(0xFFa81845),
                      ),),
                  ),
                  Visibility(
                    visible: searchVisible,
                    child: IconButton(
                      onPressed: () {
                        searchTEC.text = "";
                        doctorOnSearch.clear();
                        showHideSearchBar();
                      },
                      color: Color(0xFFa81845),
                      splashColor: Color(0xFFa81845).withOpacity(0.6),
                      icon: Icon(CupertinoIcons.clear,
                      ),),
                  ),
                ],
              ),
            ],
          ),
          body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                  ),
                  child: searchTEC.text.isNotEmpty && doctorOnSearch.length > 0 ? ListView.builder(
                    itemCount: doctorOnSearch.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () async {
                        controller.pause();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
                        );
                        QuerySnapshot doctorSnap;
                        await databaseMethods.getUserByUsername(doctorOnSearch[index]).then((val) {
                          setState(() {
                            doctorSnap = val;
                          });
                        });
                        Navigator.pop(context);
                        Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => DoctorProfileScreen(
                            imageUrl: doctorSnap.docs[0].get("profile_photo"),
                            doctorsName: doctorSnap.docs[0].get("name"),
                            speciality: doctorSnap.docs[0].get("speciality"),
                            hospital: doctorSnap.docs[0].get("hospital"),
                            reviews: doctorSnap.docs[0].get("reviews"),
                            uid: doctorSnap.docs[0].get("uid"),
                            doctorsAge: doctorSnap.docs[0].get("age"),
                            phone: doctorSnap.docs[0].get("phone"),
                            hours: doctorSnap.docs[0].get("hours"),
                            patients: doctorSnap.docs[0].get("patients"),
                            experience: doctorSnap.docs[0].get("years"),
                            doctorsEmail: doctorSnap.docs[0].get("email"),
                            about: doctorSnap.docs[0].get("about"),
                            days: doctorSnap.docs[0].get("days"),
                            fee: doctorSnap.docs[0].get("fee"),
                          ),
                        ),);
                        Future.delayed(Duration(seconds: 1), () {
                          setState(() {
                            searchTEC.text = "";
                            doctorOnSearch.clear();
                            searchVisible = false;
                            titleVisible = true;
                          });
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 4,
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 5 * SizeConfig.heightMultiplier,
                              width: 10 * SizeConfig.widthMultiplier,
                              decoration: BoxDecoration(
                                gradient: kPrimaryGradientColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Icon(FontAwesomeIcons.userMd, color: Colors.white,),
                              ),
                            ),
                            SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                            Text("Dr. ${doctorOnSearch[index]}", style: TextStyle(
                              fontFamily: "Brand Bold",
                            ),),
                          ],
                        ),
                      ),
                    ),
                  ) : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Row(
                              children: <Widget>[
                                Text("Specialities", style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Brand Bold",
                                  fontSize: 2.8 * SizeConfig.textMultiplier,
                                ),),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    controller.pause();
                                    Navigator.push(
                                      context, MaterialPageRoute(
                                      builder: (context) => SpecialitiesScreen(),
                                    ),);
                                  },
                                  child: Text("View All", style: TextStyle(
                                    color: Color(0xFFa81845),
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
                          width: double.infinity,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    _getSpec(logo:"images/stethoscope.png", speciality: "General Doctor"),
                                    _getSpec(logo: "images/heart.png", speciality: "Cardiology"),
                                    _getSpec(logo: "images/tooth.png",speciality: "Dentist"),
                                    _getSpec(icon: FontAwesomeIcons.baby, speciality: "Pediatrics"),
                                  ],
                                ),
                                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    _getSpec(logo: "images/eye.png",speciality: "Ophthalmology"),
                                    _getSpec(logo: "images/lungs.png",speciality: "Pneumology"),
                                    _getSpec(logo: "images/brain.png", speciality: "Neurology"),
                                    _getSpec(icon: Icons.do_not_disturb, speciality: "Obstetrics"),
                                  ],
                                ),
                                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    _getSpec(icon: Icons.do_not_disturb, speciality: "Gynecology"),
                                    _getSpec(icon: Icons.do_not_disturb, speciality: "Rheumatology"),
                                    _getSpec(icon: Icons.do_not_disturb, speciality: "Nephrology"),
                                    _getSpec(icon: Icons.do_not_disturb, speciality: "Gastroenterology"),
                                  ],
                                ),
                                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    _getSpec(icon: Icons.do_not_disturb, speciality: "Dermatology"),
                                    _getSpec(icon: Icons.do_not_disturb, speciality: "Psychiatry"),
                                    _getSpec(icon: Icons.do_not_disturb, speciality: "Oncology"),
                                    _getSpec(icon: Icons.do_not_disturb, speciality: "Plastic Surgery"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Container(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Row(
                              children: <Widget>[
                                Text("Health Centers", style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Brand Bold",
                                  fontSize: 2.8 * SizeConfig.textMultiplier,
                                ),),
                                Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    controller.pause();
                                    Stream allStream;
                                    List hospitals = [];
                                    QuerySnapshot hospitalSnap;
                                    await databaseMethods.getHospitals().then((val) {
                                      setState(() {
                                        allStream = val;
                                      });
                                    });
                                    hospitalSnap = await allStream.first;
                                    for (int i = 0; i <= hospitalSnap.size - 1; i++) {
                                      setState(() {
                                        hospitals.add(hospitalSnap.docs[i].get("name"));
                                      });
                                    }
                                    Navigator.push(
                                      context, MaterialPageRoute(
                                      builder: (context) => HospitalsScreen(
                                        hospitals: hospitals,
                                      ),
                                    ),);
                                  },
                                  child: Text("View All", style: TextStyle(
                                    color: Color(0xFFa81845),
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
                          ),
                          child: Container(
                            height: 28 * SizeConfig.heightMultiplier,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: widget.hospSnap.length <= 0 ? Center(
                                  child: Text("No Health Centers Currently", style: TextStyle(
                                    fontSize: 3 * SizeConfig.textMultiplier,
                                    color: Colors.black12,
                                  ),),
                                ) : ListView.builder(
                                itemCount: widget.hospSnap.length <= 5 ? widget.hospSnap.length : 5,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return _topRatedHC(
                                      hospitalSnap: widget.hospSnap[index],
                                    );
                                },
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
                              isAd: true,
                              videoPlayerController: controller,
                            ),
                          ),
                        ),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                      ],
                    ),
                  ),
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
      splashColor: Color(0xFFa81845),
      highlightColor: Colors.grey[100],
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10),
      ),
      onPressed: () async {
        controller.pause();
        QuerySnapshot doctorSnap;
        await databaseMethods.getAllDoctorsBySpecialitySnap(speciality).then((val) {
          setState(() {
            doctorSnap= val;
          });
        });
        List doctorsList = [];
        for (int i = 0; i <= doctorSnap.size - 1; i++) {
          doctorsList.add(doctorSnap.docs[i].get("name"));
        }
        Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => SpecialityScreen(
            doctors: doctorsList,
            speciality: speciality,
          ),
        ),);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 8 * SizeConfig.heightMultiplier,
            width:  16 * SizeConfig.widthMultiplier,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: logo != null ? Image.asset(logo,
                    color: Colors.black54,
                    fit: BoxFit.contain,
                  ) : Icon(icon,
                color: Colors.black54,
                size: 10 * SizeConfig.imageSizeMultiplier,
              ),
            ),
          ),
          SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
          Container(
            width: 22 * SizeConfig.widthMultiplier,
            child: Text(speciality, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(
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
    String docId = hospitalSnap.docs[0].id;
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

    onTap() {
      controller.pause();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HospitalProfileScreen(
            docId: docId,
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
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
          width: 50 * SizeConfig.widthMultiplier,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(2, 3),
                spreadRadius: 0.5,
                blurRadius: 2,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Color(0xFFa81845), width: 1),
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
                    width: double.infinity,
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
                    width: double.infinity,
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
                        splashColor: Color(0xFFa81845).withOpacity(0.6),
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
                                child: Text(name, maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: "Brand Bold",
                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                ), overflow: TextOverflow.ellipsis,),
                              ),
                              Container(
                                child: Text(about, maxLines: 2,
                                  style: TextStyle(
                                    fontFamily: "Brand-Regular",
                                    fontSize: 1.8 * SizeConfig.textMultiplier,
                                ), overflow: TextOverflow.ellipsis,),
                              ),
                              getReviews(ratings, ""),
                            ],
                          ),
                        ),
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
                        color: Color(0xFFa81845),
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
