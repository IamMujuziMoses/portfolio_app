import 'package:creativedata_app/Models/address.dart';
import 'package:flutter/cupertino.dart';
/*
* Created by Mujuzi Moses
*/

class AppData extends ChangeNotifier {

  Address pickUpLocation, dropOffLocation;

  void updatePickUpLocationAddress(Address pickUpAddress) {

    pickUpLocation = pickUpAddress;
    notifyListeners();
  }
  void updateDropOffLocationAddress(Address dropOffAddress) {

    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}