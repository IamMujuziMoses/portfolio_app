import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/ratingScreen.dart';
import 'package:creativedata_app/AllScreens/searchScreen.dart';
import 'package:creativedata_app/Assistants/assistantMethods.dart';
import 'package:creativedata_app/Assistants/geoFireAssistant.dart';
import 'package:creativedata_app/Doctor/doctorAccount.dart';
import 'package:creativedata_app/Models/directionDetails.dart';
import 'package:creativedata_app/Models/nearbyAvailableDrivers.dart';
import 'package:creativedata_app/Models/rideRequest.dart';
import 'package:creativedata_app/Provider/appData.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Widgets/divider.dart';
import 'package:creativedata_app/Widgets/noDriverDialog.dart';
import 'package:creativedata_app/Widgets/progressDialog.dart';
import 'package:creativedata_app/Widgets/tripEndedDialog.dart';
import 'package:creativedata_app/configMaps.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
/*
* Created by Mujuzi Moses
*/

class MainScreen extends StatefulWidget {
  static const String screenId = "mainScreen";

  final bool fromNearest;
  final String name;
  final String phone;
  const MainScreen({Key key, this.name, this.phone, this.fromNearest,}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController newGoogleMapController;
  DatabaseMethods databaseMethods = DatabaseMethods();
  DirectionDetails tripDirectionDetails;
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};
  bool nearbyAvailableDriversKeyLoaded = false;
  BitmapDescriptor nearByIcon;
  String rideRequestId = "";
  List<NearByAvailableDrivers> availableDrivers;
  String state = "normal";
  Color color = Colors.transparent;
  StreamSubscription<QuerySnapshot> rideStreamSubscription;
  bool isRequestingPositionDetails = false;
  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  double rideDetailsContainerHeight = 0;
  double requestRideContainerHeight = 0;
  double driverDetailsContainerHeight = 0;
  double closeWidth = 0;
  double searchContainerHeight = 25 * SizeConfig.heightMultiplier;

  Future<void> saveRideRequest() async {
    var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;

    Map pickUpLocMap = {
      "latitude": pickUp.latitude.toString(),
      "longitude": pickUp.longitude.toString(),
    };

    Map dropOffLocMap = {
      "latitude": dropOff.latitude.toString(),
      "longitude": dropOff.longitude.toString(),
    };

    RideRequest rideRequest = RideRequest(
      driverId: "waiting",
      pickUp: pickUpLocMap,
      dropOff: dropOffLocMap,
      createdAt: DateTime.now().toString(),
      riderName: widget.name,
      riderPhone: widget.phone,
      pickUpAddress: pickUp.placeName,
      dropOffAddress: dropOff.placeName,
      uid: "",
    );

    String returnId = await databaseMethods.saveRideRequest(rideRequest);
    setState(() {
      rideRequestId = returnId;
    });

    rideStreamSubscription = databaseMethods.rideRequestCollection.snapshots().listen((event) async {
      if (event.docs == null) {
        return;
      }
      int index = event.docs.indexWhere((element) => element.id == rideRequestId);
      if (event.docs[index].get("status") != null) {
        statusRide = event.docs[index].get("status");
      }
      if (event.docs[index].get("driver_name") != null) {
        driverName = event.docs[index].get("driver_name");
      }
      if (event.docs[index].get("driver_phone") != null) {
        driverPhone = event.docs[index].get("driver_phone");
      }
      if (event.docs[index].get("car_details") != null) {
        ambLicencePlate = event.docs[index].get("car_details");
      }
      if (event.docs[index].get("driver_pic") != null) {
        driverPic = event.docs[index].get("driver_pic");
      }
      if (event.docs[index].get("hospital") != null) {
        hospital = event.docs[index].get("hospital");
      }
      if (event.docs[index].get("driver_id") != null) {
        driverId = event.docs[index].get("driver_id");
        QuerySnapshot snapshot;
        databaseMethods.getDriverByUid(driverId).then((val) {
          snapshot = val;
          if (snapshot.docs[index].get("ratings") != null) {
            Map ratings = snapshot.docs[index].get("ratings");
            driverRatings = int.parse(ratings['percentage']);
            people = int.parse(ratings['people']);
          }
        });
      }

      if (event.docs[index].get("driver_location") != null) {
        Map location = event.docs[index].get("driver_location");
        driverLat = double.parse(location["latitude"]);
        driverLng = double.parse(location["longitude"]);
        LatLng driverCurrentLatLng = LatLng(driverLat, driverLng);
        if (statusRide == "accepted") {
          updateRideTimeToPickUpLoc(driverCurrentLatLng);
        } else if (statusRide == "enRoute") {
          updateRideTimeToDropOffLoc(driverCurrentLatLng);
        } else if (statusRide == "arrived") {
          setState(() {
            rideStatus = "Ambulance has Arrived";
          });
        }
      }
      if (statusRide == "accepted"){
        displayDriverDetailsContainer();
        Geofire.stopListener();
        // deleteGeoFireMarkers();
      }
      if (statusRide == "ended"){
        resetApp();
        var res = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TripEndedDialog(),
        );
        String driverPic = event.docs[index].get("driver_pic");
        if (res == "close") {
          double res = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RatingScreen(driverPic: driverPic, driverName: driverName,),
            ),
          );
          QuerySnapshot snap;
          databaseMethods.getDriverByUid(driverId).then((val) async {
            snap = val;
            if (snap.docs[0].get("ratings") != null) {
              Map ratingsMap = snap.docs[0].get("ratings");
              int oldRatings = int.parse(ratingsMap['percentage']);
              int oldPeople = int.parse(ratingsMap['people']);
              int people = oldPeople + 1;
              int ratings = (res + oldRatings).round();
              double percentageD = ratings / people;
              int percentage = percentageD.round();
              Map<String, dynamic> update = {
                "people": "$people",
                "percentage": "$percentage",
              };
              await databaseMethods.updateDriverDocField({"ratings": update}, driverId);
            } else {
              Map<String, dynamic> ratingsMap = {
                "people": "1",
                "percentage": "$res",
              };
              await databaseMethods.updateDriverDocField({"ratings": ratingsMap}, driverId);
            }
          });
          rideStreamSubscription.cancel();
          rideStreamSubscription = null;
          cancelRideRequest();
        }
      }

    });
  }

  void cancelRideRequest() async {
    await databaseMethods.cancelRideRequest(uid: rideRequestId);
    resetApp();
    setState(() {
      state = "normal";
      rideRequestId = "";
    });
  }

  void updateRideTimeToPickUpLoc(LatLng driverCurrentLatLng) async {
    if (isRequestingPositionDetails == false) {
      isRequestingPositionDetails = true;

      var positionUserLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
      var details = await AssistantMethods().obtainPlaceDirectionDetails(driverCurrentLatLng, positionUserLatLng);
      if (details == null) {
        return;
      }
      setState(() {
        rideStatus = "Ambulance is Coming - ${details.durationText}";
      });

      isRequestingPositionDetails = false;
    }
  }

  void updateRideTimeToDropOffLoc(LatLng driverCurrentLatLng) async {
    if (isRequestingPositionDetails == false) {
      isRequestingPositionDetails = true;

      var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;
      var dropOffUserLatLng = LatLng(dropOff.latitude, dropOff.longitude);
      var details = await AssistantMethods().obtainPlaceDirectionDetails(driverCurrentLatLng, dropOffUserLatLng);
      if (details == null) {
        return;
      }
      setState(() {
        rideStatus = "Going to Hospital - ${details.durationText}";
        color = Colors.grey[200];
      });

      isRequestingPositionDetails = false;
    }
  }

  void displayRideDetailsContainer() async {
    await getPlaceDirections();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 30 * SizeConfig.heightMultiplier;
      bottomPaddingOfMap = 30 * SizeConfig.heightMultiplier;
      closeWidth = 15 * SizeConfig.widthMultiplier;
    });
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 15);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethods.searchCoordinateAddress(position, context);
    print("This is your Address ::: " + address);

    initGeoFireListener();
  }

  Future<void> displayRequestRideContainer() async{
    setState(() {
      requestRideContainerHeight = 24 * SizeConfig.heightMultiplier;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 24 * SizeConfig.heightMultiplier;
      closeWidth = 0;
    });
    await saveRideRequest();
  }

  void displayDriverDetailsContainer() {
    setState(() {
      driverDetailsContainerHeight = 39 * SizeConfig.heightMultiplier;
      requestRideContainerHeight = 0;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 39 * SizeConfig.heightMultiplier;
    });
  }

  resetApp() {
    setState(() {
      searchContainerHeight = 25 * SizeConfig.heightMultiplier;
      rideDetailsContainerHeight = 0;
      requestRideContainerHeight = 0;
      driverDetailsContainerHeight = 0;
      bottomPaddingOfMap = 25 * SizeConfig.heightMultiplier;
      closeWidth = 0;
      polylineSet.clear();
      markerSet.clear();
      circleSet.clear();
      pLineCoordinates.clear();

      statusRide = "";
      rideRequestId = "";
      rideStatus = "Ambulance is Coming";
      driverName = "";
      hospital = "";
      driverPic = "";
      driverPhone = "";
      ambLicencePlate = "";
      hospital = "";
      driverLat = 0;
      driverLng = 0;
      driverRatings = 0;
      people = 0;
    });
    locatePosition();
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0.369719, 32.659309),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    createIconMarker();
    SizeConfig().init(context);
    return PickUpLayout(
        scaffold: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            backgroundColor: Colors.grey[100],
            title: Text("Find Hospital", style: TextStyle(
              fontFamily: "Brand Bold",
              color: Colors.red[300],
            ),),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => resetApp(),
                    child: AnimatedSize(
                      vsync: this,
                      curve: Curves.bounceOut,
                      duration: new Duration(milliseconds: 800),
                      child: Container(
                        width: closeWidth,
                        decoration: BoxDecoration(
                          color: Colors.red[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Center(
                            child: Text("Cancel", style: TextStyle(
                                  fontSize:  2.3 * SizeConfig.textMultiplier,
                                  color: Colors.grey[100],
                                  fontFamily: "Brand-Regular",
                                  fontWeight: FontWeight.bold,
                                ),),
                          ),
                        ),
                      ),
                    ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: <Widget>[
              GoogleMap(
                padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                initialCameraPosition: _kGooglePlex,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                polylines: polylineSet,
                markers: markerSet,
                circles: circleSet,
                onMapCreated: (GoogleMapController controller) {
                  _googleMapController.complete(controller);
                  newGoogleMapController = controller;

                  setState(() {
                    bottomPaddingOfMap = 25 * SizeConfig.heightMultiplier;
                  });

                  if (widget.fromNearest == true) {
                    displayRideDetailsContainer();
                  } else {
                    locatePosition();
                  }
                },
              ),
              //searchHospitalWidget
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSize(
                  vsync: this,
                  curve: Curves.bounceOut,
                  duration: new Duration(milliseconds: 800),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 10, right: 10,),
                              child: Container(
                                height: searchContainerHeight,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red[300],
                                      blurRadius: 16.0,
                                      spreadRadius: 0.5,
                                      offset: Offset(0.7, 0.7),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 6.0),
                                      Text("Hello,", style: TextStyle(fontSize: 1.5 * SizeConfig.textMultiplier, fontFamily: "Brand-Regular"),),
                                      Text("Having an Emergency?!",
                                        style: TextStyle(fontSize: 2.6 * SizeConfig.textMultiplier, fontFamily: "Brand Bold"),
                                      ),
                                      SizedBox(height: 20.0,),
                                      GestureDetector(
                                        onTap: () async {
                                          var res = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                                          if (res == "obtainDirection") {
                                            displayRideDetailsContainer();
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red[300],
                                            borderRadius: BorderRadius.circular(5.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black54,
                                                blurRadius: 6.0,
                                                spreadRadius: 0.5,
                                                offset: Offset(0.7, 0.7),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons.search, color: Colors.white,),
                                                SizedBox(width: 18.0,),
                                                Text("Search Hospital", style: TextStyle(
                                                  fontSize: 2 * SizeConfig.textMultiplier,
                                                  fontFamily: "Brand Bold",
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2 * SizeConfig.heightMultiplier),
                                      Container(
                                        height: 5 * SizeConfig.heightMultiplier,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {},
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Colors.red[300],
                                                    ),
                                                    SizedBox(width: 12.0,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(Provider.of<AppData>(context).pickUpLocation != null
                                                              ? Provider.of<AppData>(context).pickUpLocation.placeName
                                                              : "Add Home", style: TextStyle(fontFamily: "Brand Bold"),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                        SizedBox(height: 4.0,),
                                                        Text("Your current Location",
                                                          style: TextStyle(color: Colors.black54, fontSize: 12.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10.0,),
                                              DividerWidget(),
                                            ],
                                          ),
                                        ),
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
                  ),
              //requestAmbulanceWidget
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSize(
                  vsync: this,
                  curve: Curves.bounceOut,
                  duration: new Duration(milliseconds: 800),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 10, right: 10,),
                          child: Container(
                            height: rideDetailsContainerHeight,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red[300],
                                  blurRadius: 16.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7, 0.7),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.red[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10, right: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              FontAwesomeIcons.route,
                                              color: Colors.white,
                                              size: 6 * SizeConfig.imageSizeMultiplier,
                                            ),
                                            SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text("Distance", style: TextStyle(
                                                    fontSize: 2.5 * SizeConfig.textMultiplier,
                                                    fontFamily: "Brand-Bold",
                                                    color: Colors.white
                                                  ),),
                                                  Text(tripDirectionDetails != null ? tripDirectionDetails.distanceText : "", style: TextStyle(
                                                    fontSize: 1.9 * SizeConfig.textMultiplier,
                                                    color: Colors.white60,
                                                  ),),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                    ),
                                  ),
                                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                                  RaisedButton(
                                      onPressed: () async{
                                        setState(() {
                                          state = "requesting";
                                        });
                                        await displayRequestRideContainer();
                                        availableDrivers = GeoFireAssistant.nearByAvailableDrivers;
                                        searchNearestDriver(rideRequestId);
                                      },
                                      color: Colors.red[300],
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        child: Container(
                                          child: Center(
                                            child: Text("Request Ambulance", style: TextStyle(
                                                  fontSize: 2.5 * SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),),
                                          ),
                                        ),
                                      ),
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
              ),
              //waitingAmbulanceWidget
              Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                vsync: this,
                curve: Curves.bounceOut,
                duration: new Duration(milliseconds: 800),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          top: 10,
                          right: 10,
                        ),
                        child: Container(
                          height: requestRideContainerHeight,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red[300],
                                blurRadius: 16.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                                SizedBox(height: 3 * SizeConfig.heightMultiplier,
                                  width: double.infinity,
                                  child: Center(
                                    child: SizedBox(
                                      width: 250.0,
                                      child: ColorizeAnimatedTextKit(
                                          speed: Duration(milliseconds: 400),
                                          repeatForever: true,
                                          pause: Duration(milliseconds: 100),
                                          onTap: () => print("Tap Event"),
                                          text: [
                                            "Requesting Ambulance...",
                                            "Please wait...",
                                            "Finding Ambulance...",
                                          ],
                                          textStyle: TextStyle(
                                              fontSize: 25,
                                              fontFamily: "Horizon"
                                          ),
                                          colors: [
                                            Colors.red, Colors.grey, Colors.blue, Colors.red,
                                            Colors.grey, Colors.blue, Colors.red, Colors.grey,
                                            Colors.blue, Colors.red, Colors.grey, Colors.blue,
                                          ],
                                          textAlign: TextAlign.center,
                                          alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                                GestureDetector(
                                  onTap: () => cancelRideRequest(),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 8 * SizeConfig.heightMultiplier,
                                        width: 16 * SizeConfig.widthMultiplier,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(color: Colors.red[300], width: 2,),
                                        ),
                                        child: Icon(Icons.close_rounded,
                                          size: 6 * SizeConfig.imageSizeMultiplier,
                                          color: Colors.red[300],
                                        ),
                                      ),
                                      SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                                      Container(
                                        width: 20 * SizeConfig.widthMultiplier,
                                        decoration: BoxDecoration(
                                          color: Colors.red[300],
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Cancel",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 3 * SizeConfig.textMultiplier,
                                              color: Colors.white,
                                            ),),
                                        ),
                                      ),
                                    ],
                                  ),
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
            ),
              //assignedAmbulanceWidget
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSize(
                  vsync: this,
                  curve: Curves.bounceOut,
                  duration: new Duration(milliseconds: 800),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                            top: 10,
                            right: 10,
                          ),
                          child: Container(
                            height: driverDetailsContainerHeight,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red[300],
                                  blurRadius: 16.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7, 0.7),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 6,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Text(rideStatus,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.red[300],
                                            fontSize: 2.8 * SizeConfig.textMultiplier,
                                            fontFamily: "Brand-Bold",
                                            fontWeight: FontWeight.bold,
                                        ),overflow:  TextOverflow.ellipsis,),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                                  Divider(thickness: 2,),
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            height: 8 * SizeConfig.heightMultiplier,
                                            width: 16 * SizeConfig.widthMultiplier,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: Colors.white,
                                              border: Border.all(color: Colors.red[300], style: BorderStyle.solid, width: 2),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              child: CachedImage(
                                                imageUrl: driverPic,
                                                isRound: true,
                                                radius: 10,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Hospital: $hospital", style: TextStyle(
                                                color: Colors.black54,
                                              ),),
                                              Text("Licence Plate: $ambLicencePlate", style: TextStyle(
                                                color: Colors.black54,
                                              ),),
                                              Text("Driver: $driverName", style: TextStyle(
                                                fontSize: 2.3 * SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.bold,
                                              ),),
                                              SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,

                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          getReviews(driverRatings != 0 ? "$driverRatings" : "5", ""),
                                          Text(driverRatings != 0 ? "($people review(s))": "(0 reviews(s))"),
                                        ],
                                      )
                                    ],
                                  ),
                                  Divider(thickness: 2,),
                                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () => launch(('tel:$driverPhone')),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 7 * SizeConfig.heightMultiplier,
                                              width: 14 * SizeConfig.widthMultiplier,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                border: Border.all(color: Colors.red[300], width: 2),
                                              ),
                                              child: Icon(Icons.call_rounded,),
                                            ),
                                            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                            Text("Call", style: TextStyle(
                                              fontSize: 2.3 * SizeConfig.textMultiplier,
                                            ),),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 7 * SizeConfig.heightMultiplier,
                                              width: 14 * SizeConfig.widthMultiplier,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                border: Border.all(color: Colors.red[300], width: 2),
                                              ),
                                              child: Icon(CupertinoIcons.square_list),
                                            ),
                                            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                            Text("Details", style: TextStyle(
                                              fontSize: 2.3 * SizeConfig.textMultiplier,
                                            ),),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: rideStatus == "Going to Hospital" ? () {} : () => cancelRideRequest(),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 7 * SizeConfig.heightMultiplier,
                                              width: 14 * SizeConfig.widthMultiplier,
                                              decoration: BoxDecoration(
                                                color: color,
                                                borderRadius: BorderRadius.circular(50),
                                                border: Border.all(color: Colors.red[300], width: 2),
                                              ),
                                              child: Icon(CupertinoIcons.clear,),
                                            ),
                                            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                            Text("Cancel", style: TextStyle(
                                              fontSize: 2.3 * SizeConfig.textMultiplier,
                                            ),),
                                          ],
                                        ),
                                      ),
                                    ],
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
              ),
          ],
          ),
        ),
      );
  }

  Future<void> getPlaceDirections() async {

   var initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
   var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

   var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
   var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

   showDialog(
     context: context,
     builder: (BuildContext context) => ProgressDialog(message: "Please wait..."),
   );
   
   var details = await AssistantMethods().obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);
   setState(() {
     tripDirectionDetails = details;
   });
   Navigator.pop(context);

   print("This is Encoded points ::: " + details.encodePoints);
   
   PolylinePoints polylinePoints = PolylinePoints();
   List<PointLatLng> decodePolylinePointResults = polylinePoints.decodePolyline(details.encodePoints);

   pLineCoordinates.clear();

    if (decodePolylinePointResults.isNotEmpty) {
      decodePolylinePointResults.forEach((PointLatLng pointLatLng) {
        pLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.red[300],
        polylineId: PolylineId("PolylineId"),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude && pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    }
    else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
        northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude,),
      );
    }
    else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
        northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude,),
      );
    }
    else {
      latLngBounds = LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }
    newGoogleMapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        latLngBounds,
        70,
      ),);

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: initialPos.placeName, snippet: "Your Location"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: finalPos.placeName, snippet: "Destination"),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markerSet.add(pickUpLocMarker);
      markerSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: Colors.red,
      center: pickUpLatLng,
      radius: 14,
      strokeWidth: 8,
      strokeColor: Colors.red[300],
      circleId: CircleId("pickUpId"),
    );

    Circle dropOffLocCircle = Circle(
      fillColor: Colors.green[900],
      center: dropOffLatLng,
      radius: 14,
      strokeWidth: 8,
      strokeColor: Colors.green[400],
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      circleSet.add(pickUpLocCircle);
      circleSet.add(dropOffLocCircle);
    });
  }

  void initGeoFireListener() {
    Geofire.initialize("availableDrivers");
    Geofire.queryAtLocation(
      currentPosition.latitude,
      currentPosition.longitude,
      15,).listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearByAvailableDrivers nearByAvailableDrivers = NearByAvailableDrivers();
            nearByAvailableDrivers.key = map["key"];
            nearByAvailableDrivers.latitude = map["latitude"];
            nearByAvailableDrivers.longitude = map["longitude"];
            GeoFireAssistant.nearByAvailableDrivers.add(nearByAvailableDrivers);
            if (nearbyAvailableDriversKeyLoaded = true) {
              updateAvailableDriversOnMap();
            }
            break;

          case Geofire.onKeyExited:
            GeoFireAssistant.removeDriverFromList(map["key"]);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            NearByAvailableDrivers nearByAvailableDrivers = NearByAvailableDrivers();
            nearByAvailableDrivers.key = map["key"];
            nearByAvailableDrivers.latitude = map["latitude"];
            nearByAvailableDrivers.longitude = map["longitude"];
            GeoFireAssistant.updateDriverNearByLocation(nearByAvailableDrivers);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
            updateAvailableDriversOnMap();
            break;
        }
      }

      setState(() {});
    });
  }

  void updateAvailableDriversOnMap() {
    setState(() {
      markerSet.clear();
    });

    Set<Marker> tMakers = Set<Marker>();
    for(NearByAvailableDrivers drivers in GeoFireAssistant.nearByAvailableDrivers) {
     LatLng driverPosition = LatLng(drivers.latitude, drivers.longitude);

     Marker marker = Marker(
       markerId: MarkerId("driver${drivers.key}"),
       position: driverPosition,
       icon: nearByIcon,
       rotation: createRandomNumber(360),
     );

     tMakers.add(marker);
    }
    setState(() {
      markerSet = tMakers;
    });
  }

  void createIconMarker() {
    if (nearByIcon == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2,2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/ambulance_icon.png").then((val) {
        nearByIcon = val;
      });
    }
  }

  void noDriverFound() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => NoDriverDialog(),
    );
  }

  void searchNearestDriver(String rideRequestID) {
    if (availableDrivers.length == 0) {
      cancelRideRequest();
      resetApp();
      noDriverFound();
      return;
    }
    var driver = availableDrivers[0];
    notifyDriver(driver, rideRequestID);
    //availableDrivers.removeAt(0);
  }

  void notifyDriver(NearByAvailableDrivers driver, String rideRequestId) async {
    QuerySnapshot snapshot;
    String token = "";
    await databaseMethods.updateDriverDocField({"newRide": rideRequestId}, driver.key);
    await databaseMethods.getDriverByUid(driver.key).then((val) {
      if (val != null) {
        snapshot = val;
        token = snapshot.docs[0].get("token");
        AssistantMethods.sendNotification(token, context, rideRequestId);
      } else {
        return;
      }

      const oneSecondPassed = Duration(seconds: 1);
      var timer = Timer.periodic(oneSecondPassed, (timer) async {

        if(state != "requesting") {
          await databaseMethods.updateDriverDocField({"newRide": "cancelled"}, driver.key);
          driverRequestTimeOut = 40;
          timer.cancel();
        }

        driverRequestTimeOut = driverRequestTimeOut - 1;
        QuerySnapshot snap;
        await databaseMethods.getDriverByUid(driver.key).then((val) {
          snap = val;
          if (snap.docs[0].get("newRide") == "accepted") {
            driverRequestTimeOut = 40;
            timer.cancel();
          }
        });

        if (driverRequestTimeOut == 0) {
          await databaseMethods.updateDriverDocField({"newRide": "timeout"}, driver.key);
          driverRequestTimeOut = 40;
          timer.cancel();
          resetApp();
          noDriverFound();
          //searchNearestDriver();
        }
      });
    });

  }
}

double createRandomNumber(int num) {
  int randomNumber = Random().nextInt(num);
  return randomNumber.toDouble();
}
