import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_app/AllScreens/loginScreen.dart';
import 'package:portfolio_app/Provider/appData.dart';
import 'package:portfolio_app/Provider/eventProvider.dart';
import 'package:portfolio_app/Provider/imageUploadProvider.dart';
import 'package:portfolio_app/Provider/placesProvider.dart';
import 'package:portfolio_app/Provider/userProvider.dart';
import 'package:portfolio_app/Services/database.dart';
import 'package:portfolio_app/Services/helperFunctions.dart';
import 'package:portfolio_app/Widgets/customBottomNavBar.dart';
import 'package:portfolio_app/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
/*
* Created by Mujuzi Moses
*/

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize();
  
  var initSettingsAndroid = AndroidInitializationSettings("launch_image");
  var initSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (id, title, body, payload) async {});
  var initSettings = InitializationSettings(initSettingsAndroid, initSettingsIOS);
  await notificationsPlugin.initialize(initSettings,
    onSelectNotification: (payload) async {
    if (payload != null) {
      debugPrint("Notification Payload ::: $payload");
    }


    },
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}
FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
DatabaseMethods databaseMethods = DatabaseMethods();
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User currentUser = firebaseAuth.currentUser;

class _MyAppState extends State<MyApp> {

  bool userLoggedIn = false;
  bool isDoctor = false;
  String regId;
  QuerySnapshot snapshot;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPref().then((val) {
      setState(() {
        userLoggedIn = val;
      });
    });
    if (userLoggedIn == true) {
      User currentUser = firebaseAuth.currentUser;
      String uid = currentUser.uid;
     await databaseMethods.getUserByUid(uid).then((val) {
        setState(() {
          snapshot = val;
          regId = snapshot.docs[0].get("regId");
          regId == "Doctor" ? isDoctor = true : isDoctor = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey[100],
      //systemNavigationBarColor: Colors.red[300],
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return new MultiProvider(
      providers: [
        ChangeNotifierProvider<AppData>(create: (context) => AppData(),),
        ChangeNotifierProvider<PlacesNotifier>(create: (context) => PlacesNotifier(),),
        ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider(),),
        ChangeNotifierProvider<ImageUploadProvider>(create: (context) => ImageUploadProvider(),),
        ChangeNotifierProvider<EventProvider>(create: (context) => EventProvider(),),
      ],
      child: OverlaySupport.global(
        child: new MaterialApp(
          title: "Siro App",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(

            canvasColor: Colors.grey[100],
            primarySwatch: Colors.grey,
            primaryIconTheme: IconThemeData(color: Color(0xFFa81845)),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: firebaseAuth.currentUser  == null ? LoginScreen() : CustomBottomNavBar(isDoctor: isDoctor,),
          routes: routes,
        ),
      ),
    );
  }
}
