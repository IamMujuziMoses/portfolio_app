import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/Chat/cachedImage.dart';
import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:portfolio_app/Doctor/eventDetails.dart';
import 'package:portfolio_app/Utilities/utils.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class EventsScreen extends StatelessWidget {
  final Stream eventsStream;
  final bool isDoctor;
  const EventsScreen({Key key, this.eventsStream, this.isDoctor}) : super(key: key);

  Widget eventList() {
    return StreamBuilder(
      stream: eventsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  Timestamp dateStr = snapshot.data.docs[index].get("event_date");
                  DateTime dateTime = dateStr.toDate();
                  String date = Utils.formatDate(dateStr.toDate());
                  String description = snapshot.data.docs[index].get("event_desc");
                  String title = snapshot.data.docs[index].get("event_title");
                  String imageUrl = snapshot.data.docs[index].get("url");
                  String status = snapshot.data.docs[index].get("status");
                  String time = Utils.formatTime(dateStr.toDate());
                  return eventTile(
                    context: context,
                    dateTime: dateTime,
                    date: date,
                    description: description,
                    title: title,
                    imageUrl: imageUrl,
                    status: status,
                    time: time,
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
          title: Text("Events", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Color(0xFFa81845),
          ),),
        ),
        body: Container(
          color: Colors.grey[100],
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: eventList(),
          ),
        ),
      ),
    );
  }

  Widget eventTile({title, description, imageUrl, time, date, status, DateTime dateTime, BuildContext context}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => EventDetails(
            isDoctor: isDoctor,
            imageUrl: imageUrl,
            eventTitle: title,
            status: status,
            eventDesc: description,
            eventDate: date,
            eventDateTime: dateTime,
          ),
        ),
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 40 * SizeConfig.heightMultiplier,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(2, 3),
                spreadRadius: 0.5,
                blurRadius: 2,
                color: Colors.black.withOpacity(0.3),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
                CachedImage(
                  width: double.infinity,
                  height: double.infinity,
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  radius: 10,
                ),
              Positioned(
                top: 2 * SizeConfig.heightMultiplier,
                right: 2 * SizeConfig.widthMultiplier,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(editDateDay(date), style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 4 * SizeConfig.textMultiplier,
                        ),),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Text(editDateMY(date), style: TextStyle(
                          fontFamily: "Brand Bold",
                          color: Colors.grey,
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),)
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 2 * SizeConfig.heightMultiplier,
                left: 2 * SizeConfig.widthMultiplier,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 85 * SizeConfig.widthMultiplier,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Status: $status", maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: "Brand-Regular",
                                  color: Colors.white,
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                              ),),
                              Text("Time: $time", maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: "Brand-Regular",
                                  color: Colors.white,
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                              ),),
                            ],
                          ),
                        ),
                        Container(
                          width: 85 * SizeConfig.widthMultiplier,
                          child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "Brand Bold",
                              color: Color(0xFFa81845),
                              fontSize: 4 * SizeConfig.textMultiplier,
                          ),),
                        ),
                        Container(
                          width: 85 * SizeConfig.widthMultiplier,
                          child: Text(description, maxLines: 3, overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "Brand-Regular",
                              color: Colors.white,
                              fontSize: 2 * SizeConfig.textMultiplier,
                          ),),
                        ),
                      ],
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

  String editDateDay(String date) {
    int index = date.indexOf(",");
    String day = date.substring(index - 2, index);

    return day;
  }

  String editDateMY(String date) {
    int index = date.indexOf(",");
    String day = date.substring(index - 2, index);
    String monthYear = date.replaceAll(day, "").trim();
    return monthYear;
  }
}
