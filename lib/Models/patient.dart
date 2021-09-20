/*
* Created by Mujuzi Moses
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class Patient{
  FieldValue time;
  String healthDep;
  String height;
  String weight;
  String bmi;
  String pressure;
  String pulse;
  String fileNo;
  String name;
  String pic;
  String dob;
  String recruited;
  String pt;
  String diagnosis;
  String residence;
  String street;
  String city;
  String phone;
  String email;
  String kin;
  String smoking;
  String famDiabetes;
  String famPressure;
  String famCancer;
  String alcoholic;
  String allergies;
  String sex;
  List medicine;
  List allergyMed;
  bool private;

  Patient({this.healthDep, this.height, this.weight, this.bmi, this.pressure, this.pulse, this.fileNo, this.time,
    this.name, this.dob, this.recruited, this.pt, this.diagnosis, this.residence, this.street, this.city,
    this.phone, this.email, this.kin, this.smoking, this.famDiabetes, this.famPressure, this.famCancer,
    this.alcoholic, this.allergies, this.sex, this.allergyMed, this.medicine, this.pic, this.private,
  });

  Map<String, dynamic> toMap(Patient patient) {
    Map<String, dynamic> patientMap = Map();
    patientMap["health_department"] = patient.healthDep;
    patientMap["height"] = patient.height;
    patientMap["weight"] = patient.weight;
    patientMap["bmi"] = patient.bmi;
    patientMap["pressure"] = patient.pressure;
    patientMap["pulse"] = patient.pulse;
    patientMap["file_number"] = patient.fileNo;
    patientMap["name"] = patient.name;
    patientMap["pic"] = patient.pic;
    patientMap["date_of_birth"] = patient.dob;
    patientMap["recruited"] = patient.recruited;
    patientMap["pt_no"] = patient.pt;
    patientMap["diagnosis"] = patient.diagnosis;
    patientMap["residence"] = patient.residence;
    patientMap["street"] = patient.street;
    patientMap["city"] = patient.city;
    patientMap["phone"] = patient.phone;
    patientMap["email"] = patient.email;
    patientMap["next_of_kin"] = patient.kin;
    patientMap["smoking"] = patient.smoking;
    patientMap["family_with_diabetes"] = patient.famDiabetes;
    patientMap["family_with_pressure"] = patient.famPressure;
    patientMap["family_with_cancer"] = patient.famCancer;
    patientMap["alcoholic"] = patient.alcoholic;
    patientMap["allergies"] = patient.allergies;
    patientMap["sex"] = patient.sex;
    patientMap["medicine"] = patient.medicine;
    patientMap["allergies_medication"] = patient.allergyMed;
    patientMap["private"] = patient.private;

    return patientMap;
  }

  Patient.fromMap(Map patientMap) {
    this.healthDep = patientMap["health_department"];
    this.height = patientMap["height"];
    this.weight = patientMap["weight"];
    this.bmi = patientMap["bmi"];
    this.pressure = patientMap["pressure"];
    this.pulse = patientMap["pulse"];
    this.fileNo = patientMap["file_number"];
    this.name = patientMap["name"];
    this.pic = patientMap["pic"];
    this.dob = patientMap["date_of_birth"];
    this.recruited = patientMap["recruited"];
    this.pt = patientMap["pt_no"];
    this.diagnosis = patientMap["diagnosis"];
    this.residence = patientMap["residence"];
    this.street = patientMap["street"];
    this.city = patientMap["city"];
    this.phone = patientMap["phone"];
    this.email = patientMap["email"] ;
    this.kin = patientMap["next_of_kin"];
    this.smoking = patientMap["smoking"];
    this.famDiabetes = patientMap["family_with_diabetes"];
    this.famPressure = patientMap["family_with_pressure"];
    this.famCancer = patientMap["family_with_cancer"];
    this.alcoholic = patientMap["alcoholic"];
    this.allergies = patientMap["allergies"];
    this.sex = patientMap["sex"];
    this.medicine = patientMap["medicine"];
    this.allergyMed = patientMap["allergies_medication"];
    this.private = patientMap["private"];
  }
}