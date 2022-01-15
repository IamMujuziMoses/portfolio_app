import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/mainScreen.dart';
import 'package:creativedata_app/Assistants/assistantMethods.dart';
import 'package:creativedata_app/Models/address.dart';
import 'package:creativedata_app/Models/venue.dart';
import 'package:creativedata_app/Models/venueElement.dart';
import 'package:creativedata_app/Provider/appData.dart';
import 'package:creativedata_app/Widgets/divider.dart';
import 'package:creativedata_app/Widgets/progressDialog.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
/*
* Created by Mujuzi Moses
*/

class NearestHospitalScreen extends StatefulWidget {
  final String name;
  final String phone;
  final Venue venue;
  final Position currentPosition;
  const NearestHospitalScreen({Key key, this.venue, this.currentPosition, this.name, this.phone}) : super(key: key);
  @override
  _NearestHospitalScreenState createState() => _NearestHospitalScreenState();
}

class _NearestHospitalScreenState extends State<NearestHospitalScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.grey[100],
          title: Text("Nearest Health Centers", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Color(0xFFa81845),
          ),),
        ),
        body: Container(
          color: Colors.grey[100],
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                (widget.venue != null && widget.venue.response.venues.length > 0)
                    ? ListView.separated(
                    itemBuilder: (context, index) {
                      VenueElement venueElement = widget.venue.response.venues[index];
                      return HospitalsTile(
                        venueElement: venueElement,
                        currentPosition: widget.currentPosition,
                        name: widget.name,
                        phone: widget.phone,
                        venue: widget.venue,
                      );
                    },
                    separatorBuilder: (context, int index) => DividerWidget(),
                    itemCount: widget.venue.response.venues.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                  ) : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.grey[100],
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.solidHospital,
                          size: 20 * SizeConfig.imageSizeMultiplier,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                        Text("No Health Center(s) Available", style: TextStyle(
                          fontFamily: "Brand Bold",
                          color: Colors.grey,
                          fontSize: 3 * SizeConfig.textMultiplier,
                        ),),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Text("please check your internet connection", style: TextStyle(
                          fontFamily: "Brand-Regular",
                          color: Colors.grey,
                          fontSize: 1.8 * SizeConfig.textMultiplier,
                        ),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HospitalsTile extends StatefulWidget {
  final String name;
  final String phone;
  final VenueElement venueElement;
  final Position currentPosition;
  final Venue venue;
  const HospitalsTile({Key key, this.venueElement, this.currentPosition, this.name, this.phone, this.venue}) : super(key: key);

  @override
  _HospitalsTileState createState() => _HospitalsTileState();
}

class _HospitalsTileState extends State<HospitalsTile> {
  
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      splashColor: Color(0xFFa81845).withOpacity(0.6),
      highlightColor: Colors.grey.withOpacity(0.1),
      onPressed: () {
        getPlaceAddressDetails(context);
      },
      child: Container(
        height: 8 * SizeConfig.heightMultiplier,
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
                      FontAwesomeIcons.hospital,
                      color: Colors.white,
                      size: 5 * SizeConfig.imageSizeMultiplier,
                    ),
                  ),
                ),
                SizedBox(width: 1.4 * SizeConfig.widthMultiplier,),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Container(
                              width: 70 * SizeConfig.widthMultiplier,
                              child: Text(widget.venueElement.name, overflow: TextOverflow.ellipsis, style: TextStyle(
                                  fontSize: 16.0, fontFamily: "Brand Bold",
                              ),),
                            ),
                      ),
                      Container(
                        child: Text("${double.parse(((widget.venueElement.location.distance / 1000) + 2).toStringAsFixed(1))} Km", style: TextStyle(
                          fontSize: 1.8 * SizeConfig.textMultiplier,
                          fontFamily: "Brand Bold",
                          color: Colors.grey,
                        ),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      ),
    );
  }

  void getPlaceAddressDetails(context) async {

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(message: "Setting Hospital, Please wait...",)
    );

    Address address = Address();
    address.placeName = widget.venueElement.name;
    address.placeId = widget.venueElement.id;
    address.longitude = widget.venueElement.location.lng;
    address.latitude = widget.venueElement.location.lat;

    await AssistantMethods.searchCoordinateAddress(widget.currentPosition, context);
    Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(address);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
      context, MaterialPageRoute(
      builder: (context) => MainScreen(
        venue: widget.venue,
        fromNearest: true,
        name: widget.name,
        phone: widget.phone,
      ),
    ),
    );
  }
}
