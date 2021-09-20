/*
* Created by Mujuzi Moses
*/

class Doctor {
  String uid;
  String name;
  String email;
  String username;
  String status;
  String phone;
  int state;
  String profilePhoto;
  String about;
  String age;
  String hospital;
  String hours;
  String patients;
  String speciality;
  String years;
  String regId;
  String reviews;

  Doctor({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.phone,
    this.state,
    this.profilePhoto,
    this.about,
    this.age,
    this.hospital,
    this.hours,
    this.patients,
    this.speciality,
    this.years,
    this.regId,
    this.reviews,
  });

  Map toMap(Doctor doctor) {
    var data = Map<String, dynamic>();
    data["uid"] = doctor.uid;
    data["name"] = doctor.name;
    data["email"] = doctor.email;
    data["username"] = doctor.username;
    data["status"] = doctor.status;
    data["phone"] = doctor.phone;
    data["state"] = doctor.state;
    data["profile_photo"] = doctor.profilePhoto;
    data["about"] = doctor.about;
    data["age"] = doctor.age;
    data["hospital"] = doctor.hospital;
    data["hours"] = doctor.hours;
    data["patient"] = doctor.patients;
    data["speciality"] = doctor.speciality;
    data["years"] = doctor.years;
    data["regId"] = doctor.regId;
    data["reviews"] = doctor.reviews;
  }

  Doctor.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.phone = mapData['phone'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
    this.about = mapData['about'];
    this.age = mapData['age'];
    this.hospital = mapData['hospital'];
    this.hours = mapData['hours'];
    this.patients = mapData['patients'];
    this.speciality = mapData['speciality'];
    this.years = mapData['years'];
    this.regId = mapData['regId'];
    this.reviews = mapData['reviews'];
  }
}