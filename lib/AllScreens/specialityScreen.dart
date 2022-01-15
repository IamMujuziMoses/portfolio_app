import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/doctorProfileScreen.dart';
import 'package:creativedata_app/AllScreens/userProfileScreen.dart';
import 'package:creativedata_app/Widgets/progressDialog.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/main.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class SpecialityScreen extends StatefulWidget {
  static const String screenId = "specialityScreen";
  final String speciality;
  final List doctors;
  const SpecialityScreen({Key key, this.speciality, this.doctors}) : super(key: key);

  @override
  _SpecialityScreenState createState() => _SpecialityScreenState();
}

class _SpecialityScreenState extends State<SpecialityScreen> {

  Stream allStream;
  Stream topStream;
  Stream seniorStream;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    String topReviews = "70";
    String seniorsAge = "30";
    await databaseMethods.getAllDoctorsBySpeciality(widget.speciality).then((val) {
      setState(() {
        allStream = val;
      });
    });
    await databaseMethods.getTopDoctorsBySpeciality(widget.speciality, topReviews).then((val) {
      setState(() {
        topStream = val;
      });
    });
    await databaseMethods.getSeniorDoctorsBySpeciality(widget.speciality, seniorsAge).then((val) {
      setState(() {
        seniorStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
        scaffold: Scaffold(
          body: SpecCustom(
            doctors: widget.doctors,
            body: SpecBody(
              allStream: allStream,
              topStream: topStream,
              seniorStream: seniorStream,
            ),
            speciality: widget.speciality,
          ),
        ),
      );
  }

}

Widget doctorsList({@required Stream doctorStream}) {
  return StreamBuilder(
    stream: doctorStream,
    builder: (context, snapshot) {
      return snapshot.hasData
          ? Container(
            height: (snapshot.data.docs.length * 22.5) * SizeConfig.heightMultiplier,
            child: ListView.builder(
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              String profilePic = snapshot.data.docs[index].get("profile_photo");
              String doctorsName = snapshot.data.docs[index].get("name");
              String speciality = snapshot.data.docs[index].get("speciality");
              String hospital = snapshot.data.docs[index].get("hospital");
              String reviews = snapshot.data.docs[index].get("reviews");
              String uid = snapshot.data.docs[index].get("uid");
              return InfoView(
                doctorsName: doctorsName,
                speciality: speciality,
                hospital: hospital,
                imageUrl: profilePic,
                reviews: reviews,
                uid: uid,
              );
            }
      ),
          ) : Container();
    },
  );
}

class SpecBody extends StatefulWidget {
  final Stream allStream;
  final Stream topStream;
  final Stream seniorStream;
  const SpecBody({Key key, this.allStream, this.topStream, this.seniorStream}) : super(key: key);

  @override
  _SpecBodyState createState() => _SpecBodyState();
}

class _SpecBodyState extends State<SpecBody> {

  bool allVisible = true;
  bool topVisible = false;
  bool seniorsVisible = false;

  Widget button(String category) {
    return Padding(
      padding: EdgeInsets.only(left: 1.8 * SizeConfig.widthMultiplier),
      child: RaisedButton(
        color: Colors.white,
        textColor: Color(0xFFa81845),
        child: Container(
          height: 5 * SizeConfig.heightMultiplier,
          width: 20.8 * SizeConfig.widthMultiplier,
          child: Center(
            child: Text(category, style: TextStyle(
              fontFamily: "Brand-Regular",
              fontSize: 2 * SizeConfig.textMultiplier,
            ),),
          ),
        ),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        onPressed: () {
            if (category == "All") {
              setState(() {
                allVisible = true;
                topVisible = false;
                seniorsVisible = false;
              });
            } else if (category == "Top Rated") {
              setState(() {
                allVisible = false;
                topVisible = true;
                seniorsVisible = false;
              });
            } else if (category == "Seniors") {
              setState(() {
                allVisible = false;
                topVisible = false;
                seniorsVisible = true;
              });
            }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: Column(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Visibility(
                visible: allVisible,
                child: Positioned(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 8 * SizeConfig.heightMultiplier,
                      left: 3 * SizeConfig.widthMultiplier,
                      right: 3 * SizeConfig.widthMultiplier,
                    ),
                    child: doctorsList(doctorStream: widget.allStream),
                  ),
                ),
              ),
              Visibility(
                visible: topVisible,
                child: Positioned(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 8 * SizeConfig.heightMultiplier,
                      left: 3 * SizeConfig.widthMultiplier,
                      right: 3 * SizeConfig.widthMultiplier,
                    ),
                    child: doctorsList(doctorStream: widget.topStream),
                  ),
                ),
              ),
              Visibility(
                visible: seniorsVisible,
                child: Positioned(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 8 * SizeConfig.heightMultiplier,
                      left: 3 * SizeConfig.widthMultiplier,
                      right: 3 * SizeConfig.widthMultiplier,
                    ),
                    child: doctorsList(doctorStream: widget.seniorStream)
                  ),
                ),
              ),
              Positioned(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 2 * SizeConfig.heightMultiplier,
                    left: 2 * SizeConfig.widthMultiplier,
                    right: 2 * SizeConfig.widthMultiplier,
                    bottom: 2 * SizeConfig.heightMultiplier,
                  ),
                  child: Container(
                    height: 6 * SizeConfig.heightMultiplier,
                    width: 100 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                        children: <Widget>[
                          button("All"),
                          SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                          button("Top Rated"),
                          SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                          button("Seniors"),
                        ],
                      ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SpecCustom extends StatefulWidget {
  final Widget body;
  final String speciality;
  final bool appointment;
  final List doctors;
  const SpecCustom({Key key, this.body, this.speciality, this.appointment, this.doctors}) : super(key: key);

  @override
  _SpecCustomState createState() => _SpecCustomState();
}

class _SpecCustomState extends State<SpecCustom> {

  TextEditingController searchTEC = TextEditingController();
  bool searchVisible = false;
  bool titleVisible = true;
  List doctorOnSearch = [];
  List doctors = [];

  @override
  void initState() {
    getDoctorsList();
    super.initState();
  }

  getDoctorsList() {
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
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.grey[100],
          expandedHeight: 200,
          pinned: true,
          elevation: 0,
          actions: <Widget>[
            widget.appointment == true ? Container() : Stack(
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
                      // drugOnSearch.clear();
                      showHideSearchBar();
                    },
                    color: Color(0xFFa81845),
                    splashColor: Color(0xFFa81845).withOpacity(0.5),
                    icon: Icon(CupertinoIcons.clear,
                    ),),
                ),
              ],
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            title: Stack(
                children: <Widget>[
                  Visibility(
                    visible: titleVisible,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(widget.speciality, style: TextStyle(
                          fontFamily: "Brand Bold",
                          color: Color(0xFFa81845),
                        ),),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: searchVisible,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 4 * SizeConfig.heightMultiplier,
                        left: 10 * SizeConfig.widthMultiplier,
                        right: 10 * SizeConfig.widthMultiplier,
                      ),
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
                            hintText: "Search for ${widget.speciality}...",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Brand-Regular",
                              fontSize: 2 * SizeConfig.textMultiplier,
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
                  ),
                ]
            ),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: searchTEC.text.isNotEmpty && doctorOnSearch.length > 0 ?
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 10 * SizeConfig.heightMultiplier,
            color: Colors.grey[100],
            child: ListView.builder(
              itemCount: doctorOnSearch.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () async {
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
                      speciality: widget.speciality,
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
            ),
          ) : widget.body,
        ),
      ],
    );
  }
}
