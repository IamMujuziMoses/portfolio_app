import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/main.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class RegionalCenters extends StatefulWidget {
  final String region;
  const RegionalCenters({Key key, this.region}) : super(key: key);

  @override
  _RegionalCentersState createState() => _RegionalCentersState();
}

class _RegionalCentersState extends State<RegionalCenters> {
  QuerySnapshot centerSnap;
  List centers = [];
  @override
  void initState() {
    getCenters();
    super.initState();
  }

  getCenters() async {
    await databaseMethods.getVaccinationCentersByRegion(widget.region).then((val) {
      setState(() {
        centerSnap = val;
      });
    });
    centers = centerSnap.docs[0].get("centers");
  }

  Widget centersList() {
    return centers.isNotEmpty ? ListView.builder(
      itemCount: centers.length,
      itemBuilder: (context, index) {
        return regionTile(
          region: centers[index],
          centerSnap: centerSnap,
        );
      },
    ) : Container(
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
          title: Text("${widget.region} Region", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Color(0xFFa81845)
          ),),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[100],
          child: centersList(),
        ),
      ),
    );
  }

  Widget regionTile({QuerySnapshot centerSnap, String region}) {
    List regionList = [];
    List regionList1 = [];
   for (int i = 0; i <= centerSnap.size - 1; i++) {
     regionList = centerSnap.docs[0].get(region);
   }
   for (int i = 0; i <= regionList.length - 1; i++) {
     regionList1.add(regionList[i]);
   }
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4 * SizeConfig.widthMultiplier,
        vertical: 0.5 * SizeConfig.heightMultiplier,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
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
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 1 * SizeConfig.heightMultiplier,
            horizontal: 1 * SizeConfig.widthMultiplier,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(region.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2.2 * SizeConfig.textMultiplier,
                        color: Colors.black,
                    ),),
                    SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                    Text("(${regionList1.length} Center(s))", maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Brand-Regular",
                        fontSize: 1.8 * SizeConfig.textMultiplier,
                        color: Colors.black,
                    ),),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: (regionList1.length * 2.6) * SizeConfig.heightMultiplier,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: regionList1.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Container(
                          width: double.infinity,
                          child: Text("${index + 1}:${regionList1[index].toString()}", maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "Brand Bold",
                              fontSize: 1.8 * SizeConfig.textMultiplier,
                              color: Colors.grey,
                            ),),
                        ),
                      );
                    },
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
