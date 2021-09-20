/*
* Created by Mujuzi Moses
*/

class RideRequest{
  String createdAt;
  String driverId;
  String dropOffAddress;
  String pickUpAddress;
  String riderName;
  String riderPhone;
  String status;
  String uid;
  Map dropOff;
  Map pickUp;

  RideRequest({
    this.createdAt, this.driverId, this.dropOffAddress, this.pickUpAddress, this.status,
    this.riderName, this.riderPhone, this.dropOff, this.pickUp, this.uid,
  });

  Map<String, dynamic> toMap(RideRequest rideRequest) {
    Map<String, dynamic> rideRequestMap = Map();
    rideRequestMap["created_at"] = rideRequest.createdAt;
    rideRequestMap["driver_id"] = rideRequest.driverId;
    rideRequestMap["dropOff_address"] = rideRequest.dropOffAddress;
    rideRequestMap["pickUp_address"] = rideRequest.pickUpAddress;
    rideRequestMap["rider_name"] = rideRequest.riderName;
    rideRequestMap["rider_phone"] = rideRequest.riderPhone;
    rideRequestMap["dropOff"] = rideRequest.dropOff;
    rideRequestMap["pickUp"] = rideRequest.pickUp;
    rideRequestMap["uid"] = rideRequest.uid;
    rideRequestMap["status"] = rideRequest.status;

    return rideRequestMap;
  }

  RideRequest.fromMap(Map rideRequestMap) {
    this.createdAt = rideRequestMap["created_at"];
    this.driverId = rideRequestMap["driver_id"];
    this.dropOffAddress = rideRequestMap["dropOff_address"];
    this.pickUpAddress = rideRequestMap["pickUp_address"];
    this.riderName = rideRequestMap["rider_name"];
    this.riderPhone = rideRequestMap["rider_phone"];
    this.dropOff = rideRequestMap["dropOff"];
    this.pickUp = rideRequestMap["pickUp"];
    this.uid = rideRequestMap["uid"];
    this.status = rideRequestMap["status"];
  }

}