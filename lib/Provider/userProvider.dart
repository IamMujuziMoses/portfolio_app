import 'package:portfolio_app/Models/doctor.dart';
import 'package:portfolio_app/Models/user.dart';
import 'package:portfolio_app/Services/database.dart';
import 'package:flutter/cupertino.dart';
/*
* Created by Mujuzi Moses
*/

class UserProvider with ChangeNotifier {
  User _user;
  Doctor _doctor;

  DatabaseMethods _databaseMethods = new DatabaseMethods();

  User get getUser => _user;
  Doctor get getDoctor => _doctor;

  void refreshUser() async {
    User user = await _databaseMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

  void refreshDoctor() async {
    Doctor doctor = await _databaseMethods.getDoctorDetails();
    _doctor = doctor;
    notifyListeners();
  }
}