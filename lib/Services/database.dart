import 'dart:io';
import 'dart:typed_data';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/Enum/userState.dart';
import 'package:creativedata_app/Models/activity.dart';
import 'package:creativedata_app/Models/call.dart';
import 'package:creativedata_app/Models/message.dart';
import 'package:creativedata_app/Models/notification.dart';
import 'package:creativedata_app/Models/rideRequest.dart';
import 'package:creativedata_app/Models/user.dart' as myUser;
import 'package:creativedata_app/Models/doctor.dart';
import 'package:creativedata_app/Provider/imageUploadProvider.dart';
import 'package:creativedata_app/Utilities/utils.dart';
import 'package:creativedata_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
/*
* Created by Mujuzi Moses
*/

class DatabaseMethods{

  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Reference _storageReference;
  final CollectionReference callCollection = fireStore.collection("Call");
  final CollectionReference chatRoomCollection = fireStore.collection("ChatRoom");
  final CollectionReference recordsCollection = fireStore.collection("Call_Records");
  final CollectionReference appointmentCollection = fireStore.collection("Appointments");
  final CollectionReference rideRequestCollection = fireStore.collection("Ride_Requests");
  final CollectionReference vacCentersCollection = fireStore.collection("Vaccination_Centers");
  final CollectionReference doctorsCollection = fireStore.collection("doctors");
  final CollectionReference driversCollection = fireStore.collection("Drivers");
  final CollectionReference hospitalsCollection = fireStore.collection("Hospitals");
  final CollectionReference notificationsCollection = fireStore.collection("Notifications");
  final CollectionReference postsCollection = fireStore.collection("Posts");
  final CollectionReference usersCollection = fireStore.collection("users");
  final CollectionReference eventsCollection = fireStore.collection("Events");
  final CollectionReference drugsCollection = fireStore.collection("Drugs");
  final CollectionReference alertsCollection = fireStore.collection("Alerts");
  final CollectionReference adsCollection = fireStore.collection("Ads");

  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.doc(uid).snapshots();

  Future<myUser.User> getUserDetails() async {
    User currentUser = firebaseAuth.currentUser;
    String uid = currentUser.uid;
    String name;
    QuerySnapshot querySnapshot;
    await getUserByUid(uid).then((val) {
      querySnapshot = val;
      name = querySnapshot.docs[0].get("name");
    });
    Map<String, dynamic> documentSnapshot;
    QuerySnapshot fromSnap;
    documentSnapshot = await userSnapToMap(name, fromSnap);
   return myUser.User.fromMap(documentSnapshot);
  }

  Stream<QuerySnapshot> fetchLastMessageBetween({@required String chatRoomId}) => chatRoomCollection
      .doc(chatRoomId)
      .collection("chats")
      .orderBy("time")
      .snapshots();

  void setUserState({@required String uid, @required UserState userState, @required bool isDoctor}) {
    int stateNum = Utils.stateToNum(userState);

    if (isDoctor == true) {
      updateDoctorDocField({"state": stateNum}, uid);
    } else {
      updateUserDocField({"state": stateNum}, uid);
    }
  }

  Future<Stream<DocumentSnapshot>> getUserStream({@required String uid, @required bool isDoctor}) async{
    if (isDoctor == true) {
      String docId = await getDoctorDocId(uid);
      return doctorsCollection.doc(docId).snapshots();
    } else {
      String docId = await getUserDocId(uid);
      return usersCollection.doc(docId).snapshots();
    }
  }
  
  Future<Doctor> getDoctorDetails() async {
    User currentUser = firebaseAuth.currentUser;
    String uid = currentUser.uid;
    String name;
    QuerySnapshot querySnapshot;
    await getUserByUid(uid).then((val) {
      querySnapshot = val;
      name = querySnapshot.docs[0].get("name");
    });
    Map<String, dynamic> documentSnapshot;
    QuerySnapshot fromSnap;
    documentSnapshot = await doctorSnapToMap(name, fromSnap);
   return Doctor.fromMap(documentSnapshot);
  }

  Future<String> getName() async {
    User currentUser = firebaseAuth.currentUser;
    String uid = currentUser.uid;
    String name;
    QuerySnapshot querySnapshot;
    await getUserByUid(uid).then((val) {
      querySnapshot = val;
      name = querySnapshot.docs[0].get("name");
    });
   return name;
  }

  Future<String> getReviews() async {
    User currentUser = firebaseAuth.currentUser;
    String uid = currentUser.uid;
    String name;
    QuerySnapshot querySnapshot;
    await getUserByUid(uid).then((val) {
      querySnapshot = val;
      name = querySnapshot.docs[0].get("reviews");
    });
   return name;
  }

  Future<dynamic> getDays() async {
    User currentUser = firebaseAuth.currentUser;
    String uid = currentUser.uid;
    List<dynamic> days;
    QuerySnapshot querySnapshot;
    await getUserByUid(uid).then((val) {
      querySnapshot = val;
      days = querySnapshot.docs[0].get("days");
    });
   return days;
  }
  Future<dynamic> getFees() async {
    User currentUser = firebaseAuth.currentUser;
    String uid = currentUser.uid;
    Map fees;
    QuerySnapshot querySnapshot;
    await getUserByUid(uid).then((val) {
      querySnapshot = val;
      fees = querySnapshot.docs[0].get("fee");
    });
   return fees;
  }

  Future<String> getPhone() async {
    User currentUser = firebaseAuth.currentUser;
    String uid = currentUser.uid;
    String name;
    QuerySnapshot querySnapshot;
    await getUserByUid(uid).then((val) {
      querySnapshot = val;
      name = querySnapshot.docs[0].get("phone");
    });
   return name;
  }

  Future<String> getAbout() async {
    User currentUser = firebaseAuth.currentUser;
    String uid = currentUser.uid;
    String about;
    QuerySnapshot querySnapshot;
    await getUserByUid(uid).then((val) {
      querySnapshot = val;
      about = querySnapshot.docs[0].get("about");
    });
   return about;
  }

  Future<String> getAge() async {
    User currentUser = firebaseAuth.currentUser;
    String uid = currentUser.uid;
    String age;
    QuerySnapshot querySnapshot;
    await getUserByUid(uid).then((val) {
      querySnapshot = val;
      age = querySnapshot.docs[0].get("age");
    });
   return age;
  }

  Future<String> getPatients() async {
    User currentUser = firebaseAuth.currentUser;
    String uid = currentUser.uid;
    String patients;
    QuerySnapshot querySnapshot;
    await getUserByUid(uid).then((val) {
      querySnapshot = val;
      patients = querySnapshot.docs[0].get("patients");
    });
   return patients;
  }

  Future<String> getExperience() async {
    User currentUser = firebaseAuth.currentUser;
    String uid = currentUser.uid;
    String experience;
    QuerySnapshot querySnapshot;
    await getUserByUid(uid).then((val) {
      querySnapshot = val;
      experience = querySnapshot.docs[0].get("years");
    });
   return experience;
  }

  Future<String> getSpeciality() async {
    User currentUser = firebaseAuth.currentUser;
    String uid = currentUser.uid;
    String speciality;
    QuerySnapshot querySnapshot;
    await getUserByUid(uid).then((val) {
      querySnapshot = val;
      speciality = querySnapshot.docs[0].get("speciality");
    });
   return speciality;
  }

  Future<String> getDoctorsHospital() async {
    User currentUser = firebaseAuth.currentUser;
    String uid = currentUser.uid;
    String hospital;
    QuerySnapshot querySnapshot;
    await getUserByUid(uid).then((val) {
      querySnapshot = val;
      hospital = querySnapshot.docs[0].get("hospital");
    });
   return hospital;
  }

  Future<String> getHours() async {
    User currentUser = firebaseAuth.currentUser;
    String uid = currentUser.uid;
    String hours;
    QuerySnapshot querySnapshot;
    await getUserByUid(uid).then((val) {
      querySnapshot = val;
      hours = querySnapshot.docs[0].get("hours");
    });
   return hours;
  }

  Future<String> getRegId() async {
    User currentUser = firebaseAuth.currentUser;
    String uid = currentUser.uid;
    String regId;
    QuerySnapshot querySnapshot;
    await getUserByUid(uid).then((val) {
      querySnapshot = val;
      regId = querySnapshot.docs[0].get("regId");
    });
   return regId;
  }

   Future<String> getEmail() async {
    User currentUser = firebaseAuth.currentUser;
    String uid = currentUser.uid;
    String email;
    QuerySnapshot querySnapshot;
    await getUserByUid(uid).then((val) {
      querySnapshot = val;
      email = querySnapshot.docs[0].get("email");
    });
   return email;
  }

  Future<String> getProfilePhoto() async {
    User currentUser = firebaseAuth.currentUser;
    String uid = currentUser.uid;
    String profilePhoto;
    QuerySnapshot querySnapshot;
    await getUserByUid(uid).then((val) {
      querySnapshot = val;
      profilePhoto = querySnapshot.docs[0].get("profile_photo");
    });
   return profilePhoto;
  }

  getUserByUsername(String username) async{

    QuerySnapshot userSnap;
    QuerySnapshot docSnap;

    userSnap = await usersCollection.where("name", isEqualTo: username.trim()).get();
    docSnap = await doctorsCollection.where("name", isEqualTo: username.trim()).get();

    try {
      userSnap.docs[0].get("regId");
    } catch (e) {
      userSnap = null;
    }
    try {
      docSnap.docs[0].get("regId");
    } catch (e) {
      docSnap = null;
    }

    return docSnap != null ? docSnap : userSnap;

  }
  
  getHospitalByUid(String uid) async {
    return await hospitalsCollection.where("uid", isEqualTo: uid.trim()).get();
  }

  getUserByUid(String uid) async{

    QuerySnapshot userSnap;
    QuerySnapshot docSnap;

    userSnap = await usersCollection.where("uid", isEqualTo: uid.trim()).get();
    docSnap = await doctorsCollection.where("uid", isEqualTo: uid.trim()).get();

    try {
      userSnap.docs[0].get("regId");
    } catch (e) {
      userSnap = null;
    }
    try {
      docSnap.docs[0].get("regId");
    } catch (e) {
      docSnap = null;
    }

    return docSnap != null ? docSnap : userSnap;

  }

  getDriverByUid(String uid) async {
    QuerySnapshot driverSnap;
    driverSnap = await driversCollection.where("uid", isEqualTo: uid.trim()).get();
    return driverSnap;
  }

  getHospitalByName(String name) async {
    QuerySnapshot hospitalSnap;
    hospitalSnap = await hospitalsCollection.where("name", isEqualTo: name.trim()).get();
    return hospitalSnap;
  }

  getRideRequestByUid(String uid) async {
    QuerySnapshot rideRequestSnap;
    rideRequestSnap = await rideRequestCollection.where("uid", isEqualTo: uid.trim()).get();
    return rideRequestSnap;
  }

  getUserByUserEmail(String userEmail) async{

    QuerySnapshot userSnap;
    QuerySnapshot docSnap;

    userSnap = await usersCollection.where("email",isEqualTo: userEmail).get();
    docSnap = await doctorsCollection.where("email",isEqualTo: userEmail).get();

    try {
      userSnap.docs[0].get("regId");
    } catch (e) {
      userSnap = null;
    }
    try {
      docSnap.docs[0].get("regId");
    } catch (e) {
      docSnap = null;
    }

    return docSnap != null ? docSnap : userSnap;
  }

  uploadUserInfo(userMap) {

    usersCollection.add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  uploadDoctorInfo(userMap) {

    doctorsCollection.add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    chatRoomCollection.doc(chatRoomId).set(chatRoomMap).catchError((e) {
      print(e.toString());
    });
  }

  updateChatRoomDocField(updateMap, docId) {
    chatRoomCollection.doc(docId).update(updateMap).catchError((e) {
      print(e.toString());
    });
  }

  updateCallRecordDocField(updateMap, docId) {
    recordsCollection.doc(docId).update(updateMap).catchError((e) {
      print(e.toString());
    });
  }

  createAppointment(String chatRoomId, appMap) {
    appointmentCollection.doc(chatRoomId).set(appMap).catchError((e) {
      print(e.toString());
    });
  }
  
  addConversationMessages(String chatRoomId, messageMap, CustomNotification notification, Activity activity, isDoctor) {
    chatRoomCollection.doc(chatRoomId).collection("chats").add(messageMap).catchError((e) {
          print(e.toString());
    });
    chatRoomCollection.doc(chatRoomId).update({"last_time": FieldValue.serverTimestamp()});
    var notificationMap =  notification.toMessageNotification(notification);
    createNotification(notificationMap);
    var activityMap = activity.toMessageActivity(activity);
    if (isDoctor == true) {
      createDoctorActivity(activityMap, currentUser.uid);
    } else {
      createUserActivity(activityMap, currentUser.uid);
    }
  }

  updateConversationMessage(chatRoomId, Map<String, dynamic> update, docId) async {
    chatRoomCollection.doc(chatRoomId).collection("chats").doc(docId).update(update).catchError((e) {
      print("Update Message Field Error ::: ${e.toString()}");
    });
  }

  getConversationMessages(String chatRoomId) async{
    return await chatRoomCollection.doc(chatRoomId).collection("chats")
        .orderBy("time", descending: true).snapshots();
  }

  Future<String> createPost(postMap) async {
    try {
      String postId = "";
      await postsCollection.add(postMap).then((ref) async{
        postId = ref.id;
      });
      return postId;
    } catch (e) {
      print("Create Post Error ::: ${e.toString()}");
      return null;
    }
  }

  getPosts() async {
    return await postsCollection.orderBy("time", descending: true).snapshots();
  }

  getPostByDoctorName(String name) async {
    return await postsCollection.where("sender_name", isEqualTo: name.trim())
        .orderBy("time", descending: true).snapshots();
  }

  getPostByDoctorNameSnap(String name) async {
    return await postsCollection.where("sender_name", isEqualTo: name.trim()).get();
  }

  getAlerts() async {
    return await alertsCollection.orderBy("time", descending: true).snapshots();
  }

  createSharedPost(postMap ,sharedPostMap) async {
    String docId = await createPost(postMap);
    postsCollection.doc(docId).collection("sharedPost").add(sharedPostMap).catchError((e) {
      print(e.toString());
    });
  }

  createLike(likeMap, docId) async {
    postsCollection.doc(docId).collection("likes").add(likeMap).catchError((e) {
      print(e.toString());
    });
  }

  getLikes(docId) async {
    return await postsCollection.doc(docId).collection("likes").get();
  }

  createShare(shareMap, docId) async {
    postsCollection.doc(docId).collection("shares").add(shareMap).catchError((e) {
      print(e.toString());
    });
  }

  getShares(docId) async {
    return await postsCollection.doc(docId).collection("shares").get();
  }

  savePatient(patientMap, uid) async {
    String docId = await getDoctorDocId(uid);
    doctorsCollection.doc(docId).collection("Patients").add(patientMap).catchError((e) {
      print(e.toString());
    });
  }

  addDoctorReview(reviewMap, uid) async {
    String docId = await getDoctorDocId(uid);
    doctorsCollection.doc(docId).collection("Reviews").add(reviewMap).catchError((e) {
      print(e.toString());
    });
  }

  addHospitalReview(reviewMap, hospDocId) async {
    hospitalsCollection.doc(hospDocId).collection("Reviews").add(reviewMap).catchError((e) {
      print(e.toString());
    });
  }

  createUserReminder(reminderMap, uid) async {
    String docId = await getUserDocId(uid);
    usersCollection.doc(docId).collection("Reminders").add(reminderMap).catchError((e) {
      print("Create Reminder Error ::: ${e.toString()}");
    });
  }

  createUserActivity(activityMap, uid) async {
    String docId = await getUserDocId(uid);
    usersCollection.doc(docId).collection("Activities").add(activityMap).catchError((e) {
      print("Create Activity Error ::: ${e.toString()}");
    });
  }

  updateUserReminder(Map<String, dynamic> update, String uid, String remName) async {
    String docId = await getUserDocId(uid);
    QuerySnapshot snap = await usersCollection.doc(docId).collection("Reminders").where("name", isEqualTo: remName).get();
    String remDocId = snap.docs[0].id.trim();
    usersCollection.doc(docId).collection("Reminders").doc(remDocId).update(update).catchError((e) {
      print("Update User Reminder Field Error ::: ${e.toString()}");
    });
  }
  
  createDoctorReminder(reminderMap, uid) async {
    String docId = await getDoctorDocId(uid);
    doctorsCollection.doc(docId).collection("Reminders").add(reminderMap).catchError((e) {
      print("Create Reminder Error ::: ${e.toString()}");
    });
  }

  createDoctorActivity(activityMap, uid) async {
    String docId = await getDoctorDocId(uid);
    doctorsCollection.doc(docId).collection("Activities").add(activityMap).catchError((e) {
      print("Create Activiy Error ::: ${e.toString()}");
    });
  }

  updateDoctorReminder(Map<String, dynamic> update, String uid, String remName) async {
    String docId = await getDoctorDocId(uid);
    QuerySnapshot snap = await doctorsCollection.doc(docId).collection("Reminders").where("name", isEqualTo: remName).get();
    String remDocId = snap.docs[0].id.trim();
    doctorsCollection.doc(docId).collection("Reminders").doc(remDocId).update(update).catchError((e) {
      print("Update Doctor Reminder Field Error ::: ${e.toString()}");
    });
  }

  deleteUserReminder(name, uid) async {
    String docId = await getUserDocId(uid);
    QuerySnapshot snap = await usersCollection.doc(docId).collection("Reminders").where("name", isEqualTo: name).get();
    String reminderDoc = snap.docs[0].id.trim();
    await usersCollection.doc(docId).collection("Reminders").doc(reminderDoc).delete();
  }

  deleteDoctorReminder(name, uid) async {
    String docId = await getDoctorDocId(uid);
    QuerySnapshot snap = await doctorsCollection.doc(docId).collection("Reminders").where("name", isEqualTo: name).get();
    String reminderDoc = snap.docs[0].id.trim();
    await doctorsCollection.doc(docId).collection("Reminders").doc(reminderDoc).delete();
  }

  deleteSavedPatient(name, uid) async {
    String docId = await getDoctorDocId(uid);
    QuerySnapshot snap = await doctorsCollection.doc(docId).collection("Patients").where("name", isEqualTo: name).get();
    String patientDocId = snap.docs[0].id.trim();
    await doctorsCollection.doc(docId).collection("Patients").doc(patientDocId).delete();
  }

  deleteLike(name, docId) async {
    QuerySnapshot snap = await postsCollection.doc(docId).collection("likes").where("name", isEqualTo: name).get();
    String likeDocId = snap.docs[0].id.trim();
    await postsCollection.doc(docId).collection("likes").doc(likeDocId).delete();
  }

  deletePost(type) async {
    String docId = await getPostDocId(type);
    await postsCollection.doc(docId).delete();
  }

  deleteNotification(type, heading) async {
    if (type == "event") {
      QuerySnapshot snap = await notificationsCollection.where("event_title", isEqualTo: heading).get();
      String docId = snap.docs[0].id.trim();
      await notificationsCollection.doc(docId).delete();
    } else if (type == "alert") {
      QuerySnapshot snap = await notificationsCollection.where("heading", isEqualTo: heading).get();
      String docId = snap.docs[0].id.trim();
      await notificationsCollection.doc(docId).delete();
    } else if (type == "medicine reminder") {
      QuerySnapshot snap = await notificationsCollection.where("drug_name", isEqualTo: heading).get();
      String docId = snap.docs[0].id.trim();
      await notificationsCollection.doc(docId).delete();
    } else if (type == "appointment reminder") {
      QuerySnapshot snap = await notificationsCollection.where("app_type", isEqualTo: heading).get();
      String docId = snap.docs[0].id.trim();
      await notificationsCollection.doc(docId).delete();
    } else if (type == "post") {
      QuerySnapshot snap = await notificationsCollection.where("post_heading", isEqualTo: heading).get();
      String docId = snap.docs[0].id.trim();
      await notificationsCollection.doc(docId).delete();
    }
  }

  deleteMessageNotification(senderName, receiverName) async {
    QuerySnapshot snap = await notificationsCollection
        .where("sender_name", isEqualTo: senderName)
        .where("receiver_name", isEqualTo: receiverName).get();
    String docId = snap.docs[0].id.trim();
    await notificationsCollection.doc(docId).delete();
  }

  getSharedPosts(String docId) async {
    CollectionReference sharedPostCollection = postsCollection.doc(docId).collection("sharedPost");
    QuerySnapshot snap = await sharedPostCollection.get();
    return snap;
  }

  getCallRecords(String userName) async {
    return await recordsCollection.where("users", arrayContains: userName)
        .orderBy("call_time", descending: true).snapshots();
  }

  getCallRecordsSnap(String userName) async {
    return await recordsCollection.where("users", arrayContains: userName).get();
  }

  getSavedPatient(name, uid) async {
    String docId = await getDoctorDocId(uid);
    return await doctorsCollection.doc(docId).collection("Patients").where("name", isEqualTo: name).get();
  }

  getUserReminder(name, uid) async {
    String docId = await getUserDocId(uid);
    return await usersCollection.doc(docId).collection("Reminders").where("name", isEqualTo: name).get();
  }

  getDoctorReminder(name, uid) async {
    String docId = await getDoctorDocId(uid);
    return await doctorsCollection.doc(docId).collection("Reminders").where("name", isEqualTo: name).get();
  }

  getLikesByName(name, docId) async {
    return await postsCollection.doc(docId).collection("likes").where("name", isEqualTo: name).get();
  }

  getAllDoctorsBySpeciality(String speciality) async {
    return await doctorsCollection
        .where("speciality", isEqualTo: speciality).snapshots();
  }

  getAllDoctorsBySpecialitySnap(String speciality) async {
    return await doctorsCollection
        .where("speciality", isEqualTo: speciality).get();
  }

  getVaccinationCentersByRegionSnap(String region) async {
    return await vacCentersCollection.doc(region).get();
  }

  getVaccinationCenters() async {
    return await vacCentersCollection.snapshots();
  }

  getVaccinationCentersByRegion(String region) async {
    return await vacCentersCollection.where("region", isEqualTo: region).get();
  }

  getTopDoctorsBySpeciality(String speciality, String reviews) async {
    return await doctorsCollection
        .where("speciality", isEqualTo: speciality)
        .where("reviews", isGreaterThanOrEqualTo: reviews)
        .orderBy("reviews", descending: true).snapshots();
  }

  getTopDoctors(String reviews) async {
    return await doctorsCollection
        .where("reviews", isGreaterThanOrEqualTo: reviews)
        .orderBy("reviews", descending: true).snapshots();
  }

  getTopHospitals(String reviews) async {
    return await hospitalsCollection
        .where("percentage", isGreaterThanOrEqualTo: reviews)
        .orderBy("percentage", descending: true).snapshots();
  }

  getSeniorDoctorsBySpeciality(String speciality, String age) async {
    return await doctorsCollection
        .where("speciality", isEqualTo: speciality)
        .where("age", isGreaterThanOrEqualTo: age)
        .orderBy("age", descending: true).snapshots();
  }
  
  getChatRooms(String userName) async{
    return await chatRoomCollection
        .where("users", arrayContains: userName)
        .orderBy("last_time", descending: true).snapshots();
  }

  getChatRoomsSnap(String userName) async {
    return await chatRoomCollection.where("users", arrayContains: userName).get();
  }

  getAppointments(String username) async {
    return await appointmentCollection
        .where("users", arrayContains: username)
        .orderBy("time", descending: true).snapshots();
  }

  getDoctorsSavedPatients(String uid) async {
    String docId = await getDoctorDocId(uid);
    return await doctorsCollection.doc(docId).collection("Patients")
        .orderBy("time", descending: true).snapshots();
  }

  getDoctorsReviews(String uid) async {
    String docId = await getDoctorDocId(uid);
    return await doctorsCollection.doc(docId).collection("Reviews")
        .orderBy("created_at", descending: true).snapshots();
  }

  getHospitalsReviews(hospDocId) async {
    return await hospitalsCollection.doc(hospDocId).collection("Reviews")
        .orderBy("created_at", descending: true).snapshots();
  }

  getUsersReminders(uid) async {
    String docId = await getUserDocId(uid);
    return await usersCollection.doc(docId).collection("Reminders")
        .orderBy("created_at", descending: true).snapshots();
  }

  getUserActivities(uid) async {
    String docId = await getUserDocId(uid);
    return await usersCollection.doc(docId).collection("Activities")
        .orderBy("created_at", descending: true).snapshots();
  }

  getDoctorActivities(uid) async {
    String docId = await getDoctorDocId(uid);
    return await doctorsCollection.doc(docId).collection("Activities")
        .orderBy("created_at", descending: true).snapshots();
  }

  getDoctorsReminders(uid) async {
    String docId = await getDoctorDocId(uid);
    return await doctorsCollection.doc(docId).collection("Reminders")
        .orderBy("created_at", descending: true).snapshots();
  }

  getImageAd() async {
    return await adsCollection.where("adType", isEqualTo: "Image").get();
  }

  getVideoAd() async {
    return await adsCollection.where("adType", isEqualTo: "Video").get();
  }

  createAd(imageMap) {
    adsCollection.add(imageMap).catchError((e) {
      print(e.toString());
    });
  }

  getUsers() async {
    return await usersCollection.snapshots();
  }

  getEvents() async {
    return await eventsCollection.orderBy("created_at", descending: true).snapshots();
  }

  createNotification(notificationMap) async {
    await notificationsCollection.add(notificationMap).catchError((e) {
      print("Create Notification Error ::: ${e.toString()}");
    });
  }

  getNotifications() async {
    return await notificationsCollection.orderBy("created_at", descending: true).snapshots();
  }

  getDrugs() async {
    return await drugsCollection.snapshots();
  }

  getDrugByName(name) async {
    return await drugsCollection.where("name", isEqualTo: name).get();
  }

  getDoctors() async {
    return await doctorsCollection.snapshots();
  }

  getDoctorsSnap() async {
    return await doctorsCollection.get();
  }

  getDrivers() async {
    return await driversCollection.snapshots();
  }

  getHospitals() async {
    return await hospitalsCollection.snapshots();
  }

  updateUserDocField(Map<String, dynamic> update, String uid) async {
    String docId = await getUserDocId(uid);
    usersCollection.doc(docId).update(update).catchError((e) {
      print("Update User Field Error ::: ${e.toString()}");
    });
  }

  updateDoctorDocField(Map<String, dynamic> update, String uid) async {
    String docId = await getDoctorDocId(uid);
    doctorsCollection.doc(docId).update(update).catchError((e) {
      print("Update Doctor Field Error ::: ${e.toString()}");
    });
  }

  updateHospitalDocField(Map<String, dynamic> update, String hospDocId) async {
    hospitalsCollection.doc(hospDocId).update(update).catchError((e) {
      print("Update Hospital Field Error ::: ${e.toString()}");
    });
  }

  updatePostDocField(Map<String, dynamic> update, String docId) async {
    postsCollection.doc(docId).update(update).catchError((e) {
      print("Update Post Field Error ::: ${e.toString()}");
    });
  }

  updateDriverDocField(Map<String, dynamic> update, String uid) async {
    String docId = await getDriverDocId(uid);
    driversCollection.doc(docId).update(update).catchError((e) {
      print("Update Driver Field Error ::: ${e.toString()}");
    });
  }

  deleteUserDocField(String token, String uid) async {
    String docId = await getUserDocId(uid);
    usersCollection.doc(docId).update({
      token: FieldValue.delete(),
    }).catchError((e) {
      print("Delete User Field Error ::: ${e.toString()}");
    });
  }

  updateSavedPatientDocField(Map<String, dynamic> update, name, String uid) async {
    String docId = await getDoctorDocId(uid);
    QuerySnapshot snap = await doctorsCollection.doc(docId).collection("Patients").where("name", isEqualTo: name).get();
    String patientDocId = snap.docs[0].id.trim();
    doctorsCollection.doc(docId).collection("Patients").doc(patientDocId).update(update).catchError((e) {
      print("Update Saved Patient Field Error ::: ${e.toString()}");
    });
  }

  deleteSavedPatientDocField(Map<String, dynamic> update, name, String uid, String token) async {
    String docId = await getDoctorDocId(uid);
    QuerySnapshot snap = await doctorsCollection.doc(docId).collection("Patients").where("name", isEqualTo: name).get();
    String patientDocId = snap.docs[0].id.trim();
    doctorsCollection.doc(docId).collection("Patients").doc(patientDocId).update({
      token: FieldValue.delete(),
    }).catchError((e) {
      print("Delete Saved Patient Field Error ::: ${e.toString()}");
    });
  }

   deleteDriverDocField(String token, String uid) async {
    String docId = await getDriverDocId(uid);
    driversCollection.doc(docId).update({
      token: FieldValue.delete(),
    }).catchError((e) {
      print("Delete Driver Field Error ::: ${e.toString()}");
    });
  }

  createDocRequest(requestMap, hospUid) async {
    String docId = await getHospitalDocId(hospUid);
    hospitalsCollection.doc(docId).collection("DocRequests").add(requestMap).catchError((e) {
      print("Create Doc Request Error ::: ${e.toString()}");
    });
  }

  getHospitalServiceDoctor(String uid, String service) async {
    String docId = await getHospitalDocId(uid);
    CollectionReference hospDoctorsReference = hospitalsCollection.doc(docId).collection("doctors");
    QuerySnapshot snap = await hospDoctorsReference.get();
    List serviceDoctors = snap.docs[0].get(service);
    return serviceDoctors;
  }

  Future<String> getUserDocId(String uid) async {
    QuerySnapshot userSnap;
    userSnap = await usersCollection.where("uid", isEqualTo: uid.trim()).get();
    String id = userSnap.docs[0].id.trim();
    return id;
  }

  Future<String> getHospitalDocId(String uid) async {
    QuerySnapshot userSnap;
    userSnap = await hospitalsCollection.where("uid", isEqualTo: uid.trim()).get();
    String id = userSnap.docs[0].id.trim();
    return id;
  }

  Future<String> getPostDocId(String type) async {
    QuerySnapshot snapshot;
    snapshot = await postsCollection.where("type", isEqualTo: type.trim()).get();
    String id = snapshot.docs[0].id.trim();
    return id;
  }

  Future<String> getDoctorDocId(String uid) async {
    QuerySnapshot docSnap;
    docSnap = await doctorsCollection.where("uid", isEqualTo: uid.trim()).get();
    String id = docSnap.docs[0].id.trim();
    return id;
  }
  
  Future<String> getDrugsDocId(drugName) async {
    QuerySnapshot drugSnap;
    drugSnap = await drugsCollection.where("name", isEqualTo: drugName).get();
    String id = drugSnap.docs[0].id.trim();
    return id;
  }

  Future<String> getDriverDocId(String uid) async {
    QuerySnapshot driverSnap;
    driverSnap = await driversCollection.where("uid", isEqualTo: uid.trim()).get();
    String id = driverSnap.docs[0].id.trim();
    return id;
  }

  void uploadImage(String chatRoomId, File image, String senderId, ImageUploadProvider imageUploadProvider,
      CustomNotification notification, Activity activity, bool isDoctor) async {
    imageUploadProvider.setToLoading();
    int size = await Utils.getFileSize(image);
    final kb = size / 1024;
    final mb = kb / 1024;
    final sizeStr = mb >= 1 ? '${mb.toStringAsFixed(2)} MBs' : '${kb.toStringAsFixed(2)} KBs';
    String url = await uploadFileToStorage(image);
    imageUploadProvider.setToIdle();
    assetsAudioPlayer = new AssetsAudioPlayer();
    assetsAudioPlayer.open(Audio("sounds/msg_sent.mp3"));
    assetsAudioPlayer.play();
    setImageMsg(chatRoomId, url, senderId, sizeStr, notification, activity, isDoctor);
  }

  void uploadAudio(chatRoomId, File audio, senderId, ImageUploadProvider provider,
      CustomNotification notification, Activity activity, bool isDoctor) async {
    provider.setToLoading();
    int size = await Utils.getFileSize(audio);
    final kb = size / 1024;
    final mb = kb / 1024;
    final sizeStr = mb >= 1 ? '${mb.toStringAsFixed(2)} MBs' : '${kb.toStringAsFixed(2)} KBs';
    String url = await uploadFileToStorage(audio);
    provider.setToIdle();
    assetsAudioPlayer = new AssetsAudioPlayer();
    assetsAudioPlayer.open(Audio("sounds/msg_sent.mp3"));
    assetsAudioPlayer.play();
    setAudioMsg(chatRoomId, url, senderId, sizeStr, notification, activity, isDoctor);
  }

  void uploadDocument(chatRoomId, File document,senderId, ImageUploadProvider provider,
      CustomNotification notification, Activity activity, bool isDoctor) async {
    provider.setToLoading();
    int size = await Utils.getFileSize(document);
    final kb = size / 1024;
    final mb = kb / 1024;
    final sizeStr = mb >= 1 ? '${mb.toStringAsFixed(2)} MBs' : '${kb.toStringAsFixed(2)} KBs';
    String url = await uploadFileToStorage(document);
    provider.setToIdle();
    assetsAudioPlayer = new AssetsAudioPlayer();
    assetsAudioPlayer.open(Audio("sounds/msg_sent.mp3"));
    assetsAudioPlayer.play();
    setDocumentMsg(chatRoomId, url, senderId, sizeStr, notification, activity, isDoctor);
  }

  void uploadVideo(String chatRoomId, File video, String senderId, ImageUploadProvider imageUploadProvider,
      CustomNotification notification, Activity activity, bool isDoctor) async {
    imageUploadProvider.setToLoading();
    int size = await Utils.getFileSize(video);
    final kb = size / 1024;
    final mb = kb / 1024;
    final sizeStr = mb >= 1 ? '${mb.toStringAsFixed(2)} MBs' : '${kb.toStringAsFixed(2)} KBs';
    Uint8List thumbnail = await Utils.generateThumbnail(video);
    String url = await uploadFileToStorage(video);
    imageUploadProvider.setToIdle();
    assetsAudioPlayer = new AssetsAudioPlayer();
    assetsAudioPlayer.open(Audio("sounds/msg_sent.mp3"));
    assetsAudioPlayer.play();
    setVideoMsg(chatRoomId, url, senderId, sizeStr, thumbnail, notification, activity, isDoctor);
  }

  Future<String> uploadFileToStorage(File file) async {

    try {
      _storageReference = FirebaseStorage.instance.ref()
          .child('${DateTime.now().microsecondsSinceEpoch}');

      UploadTask _storageUploadTask = _storageReference.putFile(file);

      var url;
      await _storageUploadTask.then((val) async {
        url = await val.ref.getDownloadURL();
      });
      return await url;
    } catch (e) {
      print("upload File Error :: " + e.toString());
      return null;
    }
  }

  Future<String> saveRideRequest(RideRequest rideRequest) async {
    try {
      String rideRequestDocId = "";
      Map<String, dynamic> rideRequestMap = rideRequest.toMap(rideRequest);
      await rideRequestCollection.add(rideRequestMap).then((ref) async{
        rideRequestDocId = ref.id;
        await updateRideRequestDocField({"uid": rideRequestDocId}, rideRequestDocId);
      });
      return rideRequestDocId;
    } catch (e) {
      print("save ride request error ::: " + e.toString());
      return null;
    }
  }

  updateRideRequestDocField(Map<String, dynamic> update, String docId) async {
    rideRequestCollection.doc(docId).update(update).catchError((e) {
      print("Update Ride Request Error ::: ${e.toString()}");
    });
  }

  cancelRideRequest({String uid}) async {
    try {
      await rideRequestCollection.doc(uid).delete();
    } catch (e) {
      print("cancel ride request error ::: " + e.toString());
    }
  }

  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);
      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print("make call Error :: " + e.toString());
      return false;
    }
  }

  Future<bool> endCall({Call call, Records records, String chatRoomId}) async {
    try {
      records.chatRoomId = chatRoomId;
      Map<String, dynamic> recordsMap = records.toMap(records);
      await recordsCollection.doc(chatRoomId).set(recordsMap);
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print("end Call Error :: " + e.toString());
      return false;
    }
  }

  void setDocumentMsg(chatRoomId, url, senderId, sizeStr, notification, activity, isDoctor) async {
    Message _message;
    _message = Message.documentMessage(
      message: "DOCUMENT",
      sendBy: senderId,
      size: sizeStr,
      status: "waiting",
      docUrl: url,
      time: FieldValue.serverTimestamp(),
      type: "document",
    );

    var messageMap = _message.toDocumentMap();
    chatRoomCollection.doc(chatRoomId).collection("chats").add(messageMap).catchError((e) {
      print( e.toString());
    });
    chatRoomCollection.doc(chatRoomId).update({"last_time": FieldValue.serverTimestamp()});
    var notificationMap =  notification.toMessageNotification(notification);
    createNotification(notificationMap);
    var activityMap = activity.toMessageActivity(activity);
    if (isDoctor == true) {
      createDoctorActivity(activityMap, currentUser.uid);
    } else {
      createUserActivity(activityMap, currentUser.uid);
    }
  }

  void setAudioMsg(chatRoomId, url, senderId, sizeStr, notification, activity, isDoctor) async {
    Message _message;
    _message = Message.audioMessage(
      message: "AUDIO",
      sendBy: senderId,
      status: "waiting",
      size: sizeStr,
      audioUrl: url,
      time: FieldValue.serverTimestamp(),
      type: "audio",
    );

    var messageMap = _message.toAudioMap();
    chatRoomCollection.doc(chatRoomId).collection("chats").add(messageMap).catchError((e) {
      print( e.toString());
    });
    chatRoomCollection.doc(chatRoomId).update({"last_time": FieldValue.serverTimestamp()});
    var notificationMap =  notification.toMessageNotification(notification);
    createNotification(notificationMap);
    var activityMap = activity.toMessageActivity(activity);
    if (isDoctor == true) {
      createDoctorActivity(activityMap, currentUser.uid);
    } else {
      createUserActivity(activityMap, currentUser.uid);
    }
  }

  void setVideoMsg(String chatRoomId, String url, String senderId, String size, Uint8List thumbnail,
      CustomNotification notification, Activity activity, isDoctor) async {
    Message _message;
    _message = Message.videoMessage(
      message: "VIDEO",
      sendBy: senderId,
      videoUrl: url,
      status: "waiting",
      time: FieldValue.serverTimestamp(),
      type: "video",
      thumbnail: thumbnail,
      size: size,
    );

    var messageMap = _message.toVideoMap();
    chatRoomCollection.doc(chatRoomId).collection("chats").add(messageMap).catchError((e) {
      print( e.toString());
    });
    chatRoomCollection.doc(chatRoomId).update({"last_time": FieldValue.serverTimestamp()});
    var notificationMap =  notification.toMessageNotification(notification);
    createNotification(notificationMap);
    var activityMap = activity.toMessageActivity(activity);
    if (isDoctor == true) {
      createDoctorActivity(activityMap, currentUser.uid);
    } else {
      createUserActivity(activityMap, currentUser.uid);
    }
  }

  void setImageMsg(String chatRoomId, String url, String senderId, String size,
      CustomNotification notification, Activity activity, isDoctor
      ) async {
    Message _message;

    _message = Message.imageMessage(
      message: "IMAGE",
      sendBy: senderId,
      photoUrl: url,
      status: "waiting",
      size: size,
      time: FieldValue.serverTimestamp(),
      type: "image",
    );

    var messageMap = _message.toImageMap();

    chatRoomCollection.doc(chatRoomId).collection("chats").add(messageMap).catchError((e) {
      print( e.toString());
    });
    chatRoomCollection.doc(chatRoomId).update({"last_time": FieldValue.serverTimestamp()});
    var notificationMap =  notification.toMessageNotification(notification);
    var activityMap = activity.toMessageActivity(activity);
    createNotification(notificationMap);
    if (isDoctor == true) {
      createDoctorActivity(activityMap, currentUser.uid);
    } else {
      createUserActivity(activityMap, currentUser.uid);
    }
  }

  Future<Map<String, dynamic>> userSnapToMap(String name, QuerySnapshot snap) async {
    Map<String, dynamic> map;

    await getUserByUsername(name).then((val) {
      snap = val;
      if (snap.docs[0].get("regId") == "Doctor") {}
      map = {
        "uid" : snap.docs[0].get("uid"),
        "email" : snap.docs[0].get("email"),
        "name" : snap.docs[0].get("name"),
        "phone" : snap.docs[0].get("phone"),
        "username" : snap.docs[0].get("username"),
        "profile_photo" : snap.docs[0].get("profile_photo"),
        "state" : snap.docs[0].get("state"),
        "status" : snap.docs[0].get("status"),
        "regId" : snap.docs[0].get("regId"),
      };
    });

    return map;
  }

  Future<Map<String, dynamic>> doctorSnapToMap(String name, QuerySnapshot snap) async {
    Map<String, dynamic> map;

    await getUserByUsername(name).then((val) {
      snap = val;
      if (snap.docs[0].get("regId") == "User") {}
      map = {
        "uid" : snap.docs[0].get("uid"),
        "email" : snap.docs[0].get("email"),
        "name" : snap.docs[0].get("name"),
        "phone" : snap.docs[0].get("phone"),
        "username" : snap.docs[0].get("username"),
        "profile_photo" : snap.docs[0].get("profile_photo"),
        "state" : snap.docs[0].get("state"),
        "status" : snap.docs[0].get("status"),
        "about" : snap.docs[0].get("about"),
        "age" : snap.docs[0].get("age"),
        "hospital" : snap.docs[0].get("hospital"),
        "hours" : snap.docs[0].get("hours"),
        "patients" : snap.docs[0].get("patients"),
        "speciality" : snap.docs[0].get("speciality"),
        "years" : snap.docs[0].get("years"),
        "regId" : snap.docs[0].get("regId"),
      };
    });

    return map;
  }
}