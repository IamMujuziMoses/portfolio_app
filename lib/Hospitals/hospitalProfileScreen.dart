import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/bookAppointmentScreen.dart';
import 'package:creativedata_app/AllScreens/doctorProfileScreen.dart';
import 'package:creativedata_app/AllScreens/hospReviewsScreen.dart';
import 'package:creativedata_app/Doctor/doctorAccount.dart';
import 'package:creativedata_app/Hospitals/hospDoctors.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Widgets/progressDialog.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/main.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
/*
* Created by Mujuzi Moses
*/

class HospitalProfileScreen extends StatefulWidget {
  static const String screenId = "hospitalProfileScreen";

  final String docId;
  final String uid;
  final List services;
  final String imageUrl;
  final String ratings;
  final String people;
  final String phone;
  final String name;
  final String address;
  final String email;
  final String about;
  const HospitalProfileScreen({Key key,
    this.uid, this.imageUrl, this.ratings, this.people, this.phone,
    this.name, this.email, this.about, this.address, this.services, this.docId}) : super(key: key);

  @override
  _HospitalProfileScreenState createState() => _HospitalProfileScreenState();
}

class _HospitalProfileScreenState extends State<HospitalProfileScreen> {

  String myProfilePic;
  QuerySnapshot snap;

  void getUserInfo() async {
    myProfilePic = await databaseMethods.getProfilePhoto();
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        body: hospCustom(
          body: _hospBody(context),
          imageUrl: widget.imageUrl,
          hospName: widget.name,
          context: context
        ),
      ),
    );

  }

  Widget _hospBody(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 10 * SizeConfig.heightMultiplier,
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          right: 2 * SizeConfig.widthMultiplier,
          left: 2 * SizeConfig.widthMultiplier,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 2 * SizeConfig.heightMultiplier,
              ),
              child: Container(
                    height: 10 * SizeConfig.heightMultiplier,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            left: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Location: ", style: TextStyle(
                                    fontFamily: "Brand Bold",
                                    fontSize: 2 * SizeConfig.textMultiplier,
                                  ),),
                                  Container(
                                    width: 33 * SizeConfig.widthMultiplier,
                                    child: Text(widget.address, style: TextStyle(
                                      fontFamily: "Brand-Regular",
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                    ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Email: ", style: TextStyle(
                                    fontFamily: "Brand Bold",
                                    fontSize: 2 * SizeConfig.textMultiplier,
                                  ),),
                                  Container(
                                    width: 38 * SizeConfig.widthMultiplier,
                                    child: Text(widget.email, style: TextStyle(
                                      fontFamily: "Brand-Regular",
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                    ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Center(
                            child: GestureDetector(
                              onTap: () async{
                                showDialog(
                                  context: context,
                                  builder: (context) => ProgressDialog(message: "Please wait..."),
                                );
                                Stream reviewStream;
                                await databaseMethods.getHospitalsReviews(widget.docId).then((val) {
                                  setState(() {
                                    reviewStream = val;
                                  });
                                });
                                snap = await reviewStream.first;
                                int size = snap.size;
                                Navigator.pop(context);
                                Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => HospReviewsScreen(
                                  reviewStream: reviewStream,
                                  hospName: widget.name,
                                  size: size,
                                  hospDocId: widget.docId,
                                  myPhoto: myProfilePic,
                                  hospRating: widget.ratings,
                                ),
                                ),);
                              },
                              child: getReviews(widget.ratings, ""),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 2 * SizeConfig.widthMultiplier,
                top: 1 * SizeConfig.heightMultiplier,
              ),
              child: Text("About", style: TextStyle(
                fontFamily: "Brand Bold",
                fontSize: 2.8 * SizeConfig.textMultiplier,
              ),),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 1 * SizeConfig.heightMultiplier,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    child: Text(widget.about, style: TextStyle(
                      fontFamily: "Brand-Regular",
                      fontSize: 2 * SizeConfig.textMultiplier,
                    ),),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 2 * SizeConfig.widthMultiplier,
                top: 1 * SizeConfig.heightMultiplier,
              ),
              child: Text("Services", style: TextStyle(
                fontFamily: "Brand Bold",
                fontSize: 2.8 * SizeConfig.textMultiplier,
              ),),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 1 * SizeConfig.heightMultiplier,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: widget.services != null && widget.services.length > 0 ?
                  ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      return ServicesTile(
                        service: widget.services[index],
                        name: widget.name,
                        uid: widget.uid,
                      );
                    },
                    separatorBuilder: (context, index) => Divider(thickness: 2,),
                    itemCount: widget.services.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                  ) : Container(
                    height: 10 * SizeConfig.heightMultiplier,
                    child: Center(
                      child: Text("No Services at the moment"),
                    ),
                  ),
            ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 2 * SizeConfig.heightMultiplier,
              ),
              child: Center(
                child: actionButton(
                  color: Color(0xFFa81845),
                  icon: Icons.call_rounded,
                  action: "Voice Call",
                  onTap: () => launch(('tel:${widget.phone}')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServicesTile extends StatefulWidget {
  final String service;
  final String name;
  final String uid;
  const ServicesTile({Key key, this.service, this.name, this.uid}) : super(key: key);

  @override
  _ServicesTileState createState() => _ServicesTileState();
}

class _ServicesTileState extends State<ServicesTile> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  IconData icon = FontAwesomeIcons.redoAlt;

  @override
  initState() {
    getInfo();
    super.initState();
  }

 getInfo() async {
   switch (widget.service) {
      case "Cardiologists":
        setState(() {
          icon = FontAwesomeIcons.heartbeat;
        });
        break;
      case "Dentists":
        setState(() {
          icon = FontAwesomeIcons.tooth;
        });
        break;
      case "General Doctors":
        setState(() {
          icon = FontAwesomeIcons.stethoscope;
        });
        break;
      case "Neurologists":
        setState(() {
          icon = FontAwesomeIcons.brain;
        });
        break;
      case "Ophthalmologists":
        setState(() {
          icon = FontAwesomeIcons.eye;
        });
        break;
      case "Pneumologists":
        setState(() {
          icon = FontAwesomeIcons.lungs;
        });
        break;
     default:
       setState(() {
         icon = FontAwesomeIcons.stethoscope;
       });
    }
 }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      splashColor: Color(0xFFa81845).withOpacity(0.6),
      highlightColor: Colors.grey.withOpacity(0.1),
      onPressed: () async {
        displaySnackBar( label: "OK", message: "Getting doctors...", context: context, duration: Duration(seconds: 2));
        List doctorsList = await databaseMethods.getHospitalServiceDoctor(widget.uid, widget.service);

        Navigator.push(context, MaterialPageRoute(
          builder: (context) => HospDoctors(
            service: widget.service,
            icon: icon,
            hospitalName: widget.name,
            doctorsList: doctorsList,
          ),),);
      },
      child: Container(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 4 * SizeConfig.heightMultiplier,
              width:  8 * SizeConfig.widthMultiplier,
              decoration: BoxDecoration(
                gradient: kPrimaryGradientColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 4 * SizeConfig.imageSizeMultiplier,
                ),
              ),
            ),
            SizedBox(width: 1.4 * SizeConfig.widthMultiplier,),
            Container(
              width: 60 * SizeConfig.widthMultiplier,
              child: Text(
                  widget.service,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Brand Bold",
                  ),),
            ),
          ],
        ),
      ),
    );
  }
}


Widget hospCustom({Widget body, String hospName, imageUrl, BuildContext context}) {
 return CustomScrollView(
   slivers: <Widget>[
     SliverAppBar(
       backgroundColor: Colors.grey[100],
       expandedHeight: 350,
       floating: false,
       pinned: true,
       elevation: 0,
       flexibleSpace: FlexibleSpaceBar(
         centerTitle: true,
         title: Container(
           decoration: BoxDecoration(
               color: Colors.grey[100],
               borderRadius: BorderRadius.circular(15),
           ),
           child: Padding(
             padding: EdgeInsets.all(8.0),
             child: Text(hospName, style: TextStyle(
               color: Color(0xFFa81845),
               fontFamily: "Brand Bold",
               fontSize: 2.5 * SizeConfig.textMultiplier,
             ),),
           ),
         ),
         background: CachedImage(
           imageUrl: imageUrl,
           fit: BoxFit.cover,
           isRound: false,
           radius: 0,
         ),
       ),
     ),
     SliverToBoxAdapter(
       child: Center(
         child: body,
       ),
     ),
   ],
 );
}
