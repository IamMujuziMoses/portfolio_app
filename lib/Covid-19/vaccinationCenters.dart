import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:portfolio_app/AllScreens/regionalCenters.dart';
import 'package:portfolio_app/constants.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/
class VaccinationCenters extends StatefulWidget {
  final List<DocumentSnapshot> vacCentersSnap;
  const VaccinationCenters({Key key, this.vacCentersSnap}) : super(key: key);

  @override
  _VaccinationCentersState createState() => _VaccinationCentersState();
}

class _VaccinationCentersState extends State<VaccinationCenters> {

  Widget vacCenterList() {
    return widget.vacCentersSnap.length <= 0
        ? Container(
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Column(
                children: <Widget>[
                  Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFa81845)),),
                  ),
                ],
              ),
            ),
        ) : ListView.builder(
          itemCount: widget.vacCentersSnap.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            String region = widget.vacCentersSnap[index].id;
            return vacCenterTile(
              vacRegion: region,
            );
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          title: Text("Vaccination Centers", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Color(0xFFa81845)
          ),),
          backgroundColor: Colors.grey[100],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[100],
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: vacCenterList(),
          )
        ),
      ),
    );
  }

  Widget vacCenterTile({String vacRegion}) {
    return GestureDetector(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(
            builder: (context) => RegionalCenters(
              region: vacRegion,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.5 * SizeConfig.heightMultiplier),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  offset: Offset(2, 3),
                  spreadRadius: 0.5,
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 16 * SizeConfig.widthMultiplier,
                  height: 8 * SizeConfig.heightMultiplier,
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradientColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(FontAwesomeIcons.mapMarkedAlt, color: Colors.white,),
                  ),
                ),
                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                Container(
                  width: 68 * SizeConfig.widthMultiplier,
                  child: Text(vacRegion, overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Brand Bold",
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                    ),),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
