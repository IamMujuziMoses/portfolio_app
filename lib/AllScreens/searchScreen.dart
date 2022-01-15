import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:portfolio_app/Assistants/requestAssistant.dart';
import 'package:portfolio_app/Models/venueElement.dart';
import 'package:portfolio_app/Provider/appData.dart';
import 'package:portfolio_app/Models/address.dart';
import 'package:portfolio_app/Models/placePredictions.dart';
import 'package:portfolio_app/Widgets/divider.dart';
import 'package:portfolio_app/Widgets/progressDialog.dart';
import 'package:portfolio_app/configMaps.dart';
import 'package:portfolio_app/constants.dart';
import 'package:portfolio_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
/*
* Created by Mujuzi Moses
*/

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController pickUpTEC = TextEditingController();
  TextEditingController dropOffTEC = TextEditingController();
  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {

    String placeAddress = Provider.of<AppData>(context).pickUpLocation != null
        ? Provider.of<AppData>(context).pickUpLocation.placeName
        : "Please wait address loading...";
    pickUpTEC.text = placeAddress != null ? placeAddress : CircularProgressIndicator();

    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0,),
              child: Container(
                height: 215.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(18.0), bottomRight: Radius.circular(18.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFa81845),
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 25.0, right: 20.0, bottom: 15.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 5.0),
                      Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                              child: Icon(
                                  Icons.arrow_back,
                                color: Color(0xFFa81845),
                              ),
                          ),
                          Center(
                            child: Text("Search Hospital", style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Brand Bold",
                              color: Color(0xFFa81845)
                            ),),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0,),
                      Row(
                        children: <Widget>[
                          Image.asset("images/pickicon.png", height: 16.0, width: 16.0,),
                          SizedBox(height: 18.0),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 6.0,
                                    spreadRadius: 0.5,
                                    offset: Offset(0.7, 0.7),
                                  ),
                                ],
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(3.0),
                                child: TextField(
                                  controller: pickUpTEC,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintText: "...PickUp Location",
                                    fillColor: Colors.grey[100],
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10.0,),
                      Row(
                        children: [
                          Image.asset("images/desticon.png", height: 16.0, width: 16.0,),
                          SizedBox(height: 18.0),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: kPrimaryGradientColor,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(3.0),
                                child: TextField(
                                  onChanged: (val) {
                                    findPlace(val);
                                  },
                                  controller: dropOffTEC,
                                  decoration: InputDecoration(
                                    hintText: "...Hospital Name",
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            (placePredictionList.length > 0) ? Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListView.separated(
                padding: EdgeInsets.all(0.0),
                itemBuilder: (context, index) {
                return PredictionTile(
                  placePredictions: placePredictionList[index],
                );
              },
                separatorBuilder: (BuildContext context, int index) => DividerWidget(),
                itemCount: placePredictionList.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  void findPlace(String placeName) async{

    if (placeName.length > 1) {

      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:ug";
      var res = await RequestAssistant.getStringRequest(autoCompleteUrl);

      if (res == "Failed, No Response!") {
        return;
      }

      if (res["status"] == "OK") {
        var predictions = res["predictions"];
        var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();

        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget {

  final PlacePredictions placePredictions;
  const PredictionTile({Key key, this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        getPlaceAddressDetails(placePredictions.placeId, context);
      },
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(width: 10.0),
            Row(
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
                      Icons.add_location,
                      color: Colors.white,
                      size: 5 * SizeConfig.imageSizeMultiplier,
                    ),
                  ),
                ),
                SizedBox(width: 14.0),
                Expanded(
                  //flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 8.0,),
                      Text(placePredictions.mainText, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0),),
                      SizedBox(height: 2.0,),
                      Text(placePredictions.secondaryText,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0, color: Color(0xFFa81845)),),
                      SizedBox(height: 8.0,),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.0),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async{
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(message: "Setting Hospital, Please wait...",)
    );

    print("PlaceId ::: $placeId");
    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    var res = await RequestAssistant.getStringRequest(placeDetailsUrl);
    Navigator.pop(context);

    if (res == "Failed, No Response!") {
      return;
    }

    if (res["status"] == "OK") {
      Address address = Address();
      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(address);
      print("This is dropOff Location :: " + address.placeName);
      Navigator.pop(context, "obtainDirection");
    }
  }
}

Future<String> getPlaceAddressDetails2(VenueElement venueElement, context) async {
  showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(message: "Setting Hospital, Please wait...",)
  );
  Address address = Address();
  address.placeName = venueElement.name;
  address.placeId = venueElement.id;
  address.longitude = venueElement.location.lng;
  address.latitude = venueElement.location.lat;
  Navigator.pop(context);

  Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(address);
  return "obtainDirection";
}