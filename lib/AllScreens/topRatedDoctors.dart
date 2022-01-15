import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:portfolio_app/AllScreens/userProfileScreen.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class TopRatedDoctors extends StatelessWidget {
  final Stream docStream;
  TopRatedDoctors({Key key, this.docStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.grey[100],
          title: Text("Top Rated Doctors", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Colors.red[300],
          ),),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[100],
          child: Padding(
            padding: EdgeInsets.only(
              top: 2 * SizeConfig.heightMultiplier,
              left: 3 * SizeConfig.widthMultiplier,
              right: 3 * SizeConfig.widthMultiplier,
            ),
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: docStream,
                builder: (context, snapshot) {
                  return snapshot.hasData ? ListView.builder(
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
                    },
                  ) : Container(
                    child: Center(
                      child: Text("No Doctors at the moment"),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
