import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/Enum/userState.dart';
import 'package:creativedata_app/Models/user.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Utilities/utils.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class OnlineIndicator extends StatefulWidget {
  final String uid;
  final bool isDoctor;
  OnlineIndicator({Key key, @required this.uid, @required this.isDoctor}) : super(key: key);

  @override
  _OnlineIndicatorState createState() => _OnlineIndicatorState();
}

class _OnlineIndicatorState extends State<OnlineIndicator> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream stream;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  void getInfo() async {
    await databaseMethods.getUserStream(uid: widget.uid, isDoctor: widget.isDoctor).then((val) {
      setState(() {
        stream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: stream,
        builder: (context, snapshot) {
      User user;
      if (snapshot.hasData && snapshot.data.data() != null) {
        user = User.fromMap(snapshot.data.data());
      }
      return Container(
        height: 12, width: 12,
        margin: EdgeInsets.only(right: 8, top: 8),
        decoration: BoxDecoration(
          border: Border.all(color: getBColor(user != null ? user.state != null ? user.state : 0 : null), width: 2),
          shape: BoxShape.circle,
          color: getColor(user != null ? user.state != null ? user.state : 0 : null),
        ),
      );

    },
    );
  }

  getColor(int state) {
    switch (Utils.numToState(state)) {
      case UserState.Offline:
        return Colors.transparent;
      case UserState.Online:
        return Colors.green;
      default:
        return Colors.orange[300];
    }
  }
  getBColor(int state) {
    switch (Utils.numToState(state)) {
      case UserState.Offline:
        return Colors.transparent;
      case UserState.Online:
        return Colors.white;
      default:
        return Colors.white;
    }
  }
}
