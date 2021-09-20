import 'package:creativedata_app/Models/nearbyAvailableDrivers.dart';
/*
* Created by Mujuzi Moses
*/

class GeoFireAssistant{

  static List<NearByAvailableDrivers> nearByAvailableDrivers = [];

  static void removeDriverFromList(String key) {
    int index = nearByAvailableDrivers.indexWhere((element) => element.key == key);
    nearByAvailableDrivers.removeAt(index);
  }

  static void updateDriverNearByLocation(NearByAvailableDrivers driver) {
    int index = nearByAvailableDrivers.indexWhere((element) => element.key == driver.key);
    nearByAvailableDrivers[index].latitude = driver.latitude;
    nearByAvailableDrivers[index].longitude = driver.longitude;
  }
}