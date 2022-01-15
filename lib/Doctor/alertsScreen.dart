import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/Utilities/utils.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class AlertsScreen extends StatelessWidget {
  final Stream alertStream;
  const AlertsScreen({Key key, this.alertStream}) : super(key: key);

  Widget alertList() {
    return StreamBuilder(
      stream: alertStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  Timestamp dateStr = snapshot.data.docs[index].get("time");
                  String date = Utils.formatDate(dateStr.toDate());
                  String time = Utils.formatTime(dateStr.toDate());
                  String heading = snapshot.data.docs[index].get("heading");
                  String issuedBy = snapshot.data.docs[index].get("issued_by");
                  return AlertTile(
                    date: date,
                    time: time,
                    heading: heading,
                    issuedBy: issuedBy,
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
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.grey[100],
          title: Text("Alerts", style: TextStyle(fontFamily: "Brand Bold", color: Color(0xFFa81845)),),
        ),
        body: Container(
          color: Colors.grey[100],
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.only(
              left: 4, right: 4,
            ),
            child: alertList(),
          ),
        ),
      ),
    );
  }
}

class AlertTile extends StatelessWidget {
  final String time;
  final String heading;
  final String date;
  final String issuedBy;

  const AlertTile({Key key, this.time, this.heading, this.date, this.issuedBy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 1 * SizeConfig.heightMultiplier,
        horizontal: 3 * SizeConfig.widthMultiplier,
      ),
      child: Container(
        height: 15 * SizeConfig.heightMultiplier,
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
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 8 * SizeConfig.heightMultiplier,
                width: 12 * SizeConfig.widthMultiplier,
                child: Center(
                  child: Icon(
                    CupertinoIcons.exclamationmark_triangle,
                    size: 8 * SizeConfig.imageSizeMultiplier,
                    color: Color(0xFFa81845),
                  ),
                ),
              ),
              Container(
                width: 79 * SizeConfig.widthMultiplier,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 25 * SizeConfig.widthMultiplier,
                            child: Text(date, overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Brand-Regular",
                                fontSize: 1.8 * SizeConfig.textMultiplier,
                              ),),
                          ),
                          Container(
                            width: 18 * SizeConfig.widthMultiplier,
                            child: Text(time, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Brand-Regular",
                                fontSize: 1.8 * SizeConfig.textMultiplier,
                              ),),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 85 * SizeConfig.widthMultiplier,
                      child: Text("Alert! $heading", overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: <Widget>[
                          Spacer(),
                          Container(
                            //width: 40 * SizeConfig.widthMultiplier,
                            child: Text("Issued by: $issuedBy", overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Brand-Regular",
                                fontSize: 2 * SizeConfig.textMultiplier,
                              ),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
