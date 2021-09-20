import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/userProfileScreen.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/main.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class SpecialityScreen extends StatefulWidget {
  static const String screenId = "specialityScreen";
  final String speciality;
  SpecialityScreen({Key key, this.speciality}) : super(key: key);

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
          ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
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
        textColor: Colors.red[300],
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
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[100],
                      height: 82 * SizeConfig.heightMultiplier,
                        child: SingleChildScrollView(
                          child: doctorsList(doctorStream: widget.allStream),
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
                          child: doctorsList(doctorStream: widget.topStream),
                        ),
                      ),
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
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[100],
                      height: 82 * SizeConfig.heightMultiplier,
                        child: SingleChildScrollView(
                          child: doctorsList(doctorStream: widget.seniorStream)
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
          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
        ],
      ),
    );
  }
}

class SpecCustom extends StatefulWidget {
  final Widget body;
  final String speciality;
  const SpecCustom({Key key, this.body, this.speciality}) : super(key: key);

  @override
  _SpecCustomState createState() => _SpecCustomState();
}

class _SpecCustomState extends State<SpecCustom> {
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
            title: Text(widget.speciality, textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red[300],
                fontFamily: "Brand Bold",
                //fontSize: 2.7 * SizeConfig.textMultiplier,
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
