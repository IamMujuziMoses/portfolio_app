/*
* Created by Mujuzi Moses
*/

class User {
  String uid;
  String name;
  String email;
  String username;
  String status;
  String phone;
  int state;
  String profilePhoto;
  String regId;

  User({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.phone,
    this.state,
    this.profilePhoto,
    this.regId,
  });

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data["uid"] = user.uid;
    data["name"] = user.name;
    data["email"] = user.email;
    data["username"] = user.username;
    data["status"] = user.status;
    data["phone"] = user.phone;
    data["state"] = user.state;
    data["profile_photo"] = user.profilePhoto;
    data["regId"] = user.regId;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.phone = mapData['phone'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
    this.regId = mapData['regId'];
  }
}