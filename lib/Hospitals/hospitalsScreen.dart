import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/Hospitals/hospitalProfileScreen.dart';
import 'package:creativedata_app/Doctor/doctorAccount.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class HospitalsScreen extends StatefulWidget {
  static const String screenId = "hospitalsScreen";
  HospitalsScreen({Key key}) : super(key: key);

  @override
  _HospitalsScreenState createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {

  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream allStream;
  Stream topStream;

  @override
  void initState() {
    getHospitals();
    super.initState();
  }

  void getHospitals() async {
    String topReviews = "70";
    await databaseMethods.getHospitals().then((val) {
      setState(() {
        allStream = val;
      });
    });
    await databaseMethods.getTopHospitals(topReviews).then((val) {
      topStream = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        body: HospCustom(
          body: HospBody(
            allStream: allStream,
            topStream: topStream,
          ),
          title: "Hospitals",
        ),
      ),
    );
  }
}

Widget hospitalList({@required Stream hospitalStream}) {
  return StreamBuilder(
    stream: hospitalStream,
    builder: (context, snapshot) {
      return snapshot.hasData
          ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                String imageUrl = snapshot.data.docs[index].get("hospital_photo");
                String name = snapshot.data.docs[index].get("name");
                String phone = snapshot.data.docs[index].get("phone");
                Map ratingsMap = snapshot.data.docs[index].get("ratings");
                String ratings = ratingsMap["percentage"];
                String people = ratingsMap["people"];
                String uid = snapshot.data.docs[index].get("uid");
                return HospView(
                  hospitalName: name,
                  imageUrl: imageUrl,
                  phone: phone,
                  ratings: ratings,
                  people: people,
                  uid: uid,
                );
              },
            ) : Container();
    },
  );
}

class HospView extends StatefulWidget {
  final String hospitalName;
  final String imageUrl;
  final String phone;
  final String people;
  final String ratings;
  final String uid;
  const HospView({Key key, this.hospitalName, this.imageUrl, this.phone, this.ratings, this.uid, this.people}) : super(key: key);

  @override
  _HospViewState createState() => _HospViewState();
}

class _HospViewState extends State<HospView> {

  DatabaseMethods databaseMethods = DatabaseMethods();
  String email = "";
  String about = "";
  String location = "";
  List services = [];

  @override
  void initState() {
    super.initState();
    getHospitalInfo();
  }

  getHospitalInfo() async {
    QuerySnapshot snap;
    await databaseMethods.getHospitalByUid(widget.uid).then((val) {
      snap = val;
      email = snap.docs[0].get("email");
      about = snap.docs[0].get("about");
      location = snap.docs[0].get("address");
      services = snap.docs[0].get("services");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
        Container(
          width: 90 * SizeConfig.widthMultiplier,
          height: 15 * SizeConfig.heightMultiplier,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                spreadRadius: 0.5,
                blurRadius: 2,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              splashColor: Colors.red[200],
              highlightColor: Colors.grey.withOpacity(0.1),
              radius: 800,
              borderRadius: BorderRadius.circular(15),
              onTap: () => Navigator.push(
                context, MaterialPageRoute(
                builder: (context) => HospitalProfileScreen(
                  uid: widget.uid,
                  imageUrl: widget.imageUrl,
                  ratings: widget.ratings,
                  people: widget.people,
                  phone: widget.phone,
                  name: widget.hospitalName,
                  email: email,
                  about: about,
                  address: location,
                  services: services,
                ),
              ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    clipBehavior: Clip.hardEdge,
                    height: 15 * SizeConfig.heightMultiplier,
                    width: 30 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: CachedImage(
                      height: 10 * SizeConfig.heightMultiplier,
                      width: double.infinity,
                      imageUrl: widget.imageUrl,
                      radius: 20,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      right: 8,
                      left: 8,
                      bottom: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text(widget.hospitalName, style: TextStyle(
                              fontFamily: "Brand Bold",
                              fontSize: 3 * SizeConfig.textMultiplier,
                          ), overflow: TextOverflow.ellipsis,),
                        ),
                        Spacer(),
                        getReviews(widget.ratings, ""),
                        Text("(${widget.people} review(s))", style: TextStyle(fontFamily: "Brand-Regular"),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class HospBody extends StatefulWidget {
  final Stream allStream;
  final Stream topStream;
  const HospBody({Key key, this.allStream, this.topStream}) : super(key: key);

  @override
  _HospBodyState createState() => _HospBodyState();
}

class _HospBodyState extends State<HospBody> {

  bool allVisible = true;
  bool topVisible = false;

  Widget button(String category) {
    return Padding(
      padding: EdgeInsets.only(left: 1.8 * SizeConfig.widthMultiplier),
      child: RaisedButton(
        color: Colors.white,
        textColor: Colors.red[300],
        child: Container(
          height: 5 * SizeConfig.heightMultiplier,
          width: 35 * SizeConfig.widthMultiplier,
          child: Center(
            child: Text(category, style: TextStyle(
              fontFamily: "Brand Bold",
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
            });
          } else if (category == "Top Rated") {
            setState(() {
              allVisible = false;
              topVisible = true;
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
                      top: 5 * SizeConfig.heightMultiplier,
                      left: 3 * SizeConfig.widthMultiplier,
                      right: 3 * SizeConfig.widthMultiplier,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[100],
                      height: 82 * SizeConfig.heightMultiplier,
                      child: SingleChildScrollView(
                        child: hospitalList(hospitalStream: widget.allStream),
                      ),
                    ),
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
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[100],
                      height: 82 * SizeConfig.heightMultiplier,
                      child: SingleChildScrollView(
                          child: hospitalList(hospitalStream: widget.topStream),
                        ),
                    ),
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
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        button("All"),
                        button("Top Rated"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4 * SizeConfig.heightMultiplier,),
        ],
      ),
    );
  }
}


class HospCustom extends StatefulWidget {
  final Widget body;
  final String title;
  const HospCustom({Key key, this.body, this.title}) : super(key: key);

  @override
  _HospCustomState createState() => _HospCustomState();
}

class _HospCustomState extends State<HospCustom> {
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
            IconButton(
              onPressed: () {},
              color: Colors.red[300],
              splashColor: Colors.red[200],
              icon: Icon(CupertinoIcons.search,
              ),),
          ],
          flexibleSpace: FlexibleSpaceBar(
            title: Text(widget.title, style: TextStyle(
              color: Colors.red[300],
              fontFamily: "Brand Bold",
              fontSize: 3 * SizeConfig.textMultiplier,
            ),),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: widget.body,
        ),
      ],
    );
  }
}

