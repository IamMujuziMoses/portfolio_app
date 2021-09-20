/*
* Created by Mujuzi Moses
*/

import 'package:creativedata_app/Constants/errorMessages.dart';
import 'package:creativedata_app/CustomErrors/fault.dart';
import 'package:creativedata_app/Models/venue.dart';
import 'package:creativedata_app/Services/placesServices.dart';
import 'package:flutter/cupertino.dart';

class PlacesNotifier extends ChangeNotifier {
  static String _clientId = "QOD2QBXLCI10PHPUYJ05XTG3FHSGUBEDPO31OUN5SG3C5XIJ";

  static String _clientSecret = "VABZCTCQ32I5PJGDBV4JKLEBDYVQLND2VIGFFKQFBSORM4NH";
  static String _apiVersion = "20190425";
  static String _radius = "4000";

  var _placeService = PlacesService();

  Fault _placesNotifierFault;

  Venue _venue;

  bool _isLoadingVenues = true;

  setFault(Fault fault) => _placesNotifierFault = fault;

  Fault get getFault => _placesNotifierFault;

  setVenue(Venue venue) => _venue = venue;

  Venue get getVenue => _venue;

  setIsLoadingVenues(bool isLoading) {
    _isLoadingVenues = isLoading;
    notifyListeners();
  }

  bool get isLoadingVenues => _isLoadingVenues;

  getPlaces(String latitude, String longitude) async {
    setIsLoadingVenues(true);
    try {
      Venue venue = await _placeService.getNearestPlaces(
          _clientId, _clientSecret, _apiVersion, latitude, longitude, _radius);
      setVenue(venue);
    } on Fault catch (e) {
      setFault(e);
    } catch (e) {
      setFault(Fault(message: UNKNOWN_ERROR));
      print("Error occurred: ${e.toString()}");
    }
    setIsLoadingVenues(false);
  }
}