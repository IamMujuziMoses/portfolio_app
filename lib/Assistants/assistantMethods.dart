import 'dart:convert';

import 'package:creativedata_app/Assistants/requestAssistant.dart';
import 'package:creativedata_app/Models/directionDetails.dart';
import 'package:creativedata_app/Provider/appData.dart';
import 'package:creativedata_app/Models/address.dart';
import 'package:creativedata_app/configMaps.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
/*
* Created by Mujuzi Moses
*/

class AssistantMethods {

  static Future<String> searchCoordinateAddress(Position position, context) async {

    String placeAddress = "";
    String st1, st2, st3, st4;
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    var response = await RequestAssistant.getStringRequest(url);

    if (response != "Failed, No Response!") {
      st1 = response["results"][0]["address_components"][0]["long_name"];
      st2 = response["results"][0]["address_components"][1]["long_name"];
      st3 = response["results"][0]["address_components"][3]["long_name"];
      //st4 = response["results"][0]["address_components"][5]["short_name"];
      placeAddress = st1 + ", " + st2 + ", " + st3;// + " " + st4;
      print("PlaceHolder ::: $placeAddress");

      Address userPickupAddress = new Address();
      userPickupAddress.longitude = position.longitude;
      userPickupAddress.latitude = position.latitude;
      userPickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickupAddress);
    }
    return placeAddress;
  }

  Future<DirectionDetails> obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async {

    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getStringRequest(directionUrl);

    if (res == "Failed, No Response!") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.encodePoints = res["routes"][0]["overview_polyline"]["points"];
    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];
    directionDetails.distanceText= res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];

    return directionDetails;

  }

  static alertNewMessage(String token, context, fromUserName, fromUid, fromPhoto, bool sendToDoc, chatroomId) async {
    Map<String, String> headerMap = {
      "Content-Type": "application/json",
      "Authorization": serverToken,
    };

    Map notificationMap = {
      "body": "You have a new message from ${sendToDoc == true ? fromUserName : "Dr. $fromUserName"}",
      "title": "Siro Message",
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "sender_name": "$fromUserName",
      "sender_uid": "$fromUid",
      "sender_photo": "$fromPhoto",
      "send_to_doctor": "$sendToDoc",
      "chatroomId": chatroomId,
      "type": "message",
    };

    Map sendNotificationMap = {
      "notification": notificationMap,
      "priority": "high",
      "data": dataMap,
      "to": token,
    };

    var res = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );
  }

  static sendNotification(String token, context, String rideRequestId) async {
    var destination = Provider.of<AppData>(context, listen: false).dropOffLocation;

    Map<String, String> headerMap = {
      "Content-Type": "application/json",
      "Authorization": serverToken,
      //"Access-Control-Allow-Origin": "*",
    };

    Map notificationMap = {
      "body": "DropOff Address, ${destination.placeName}",
      "title": "You have a new Ambulance Request",
    };
    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "ride_request_id": rideRequestId,
    };

    Map sendNotificationMap = {
      "notification": notificationMap,
      "priority": "high",
      "data": dataMap,
      "to": token,
    };

    var res = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );
  }
}
