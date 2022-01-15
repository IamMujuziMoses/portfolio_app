import 'package:portfolio_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.grey[100],
          title: Text("Medicine Cart", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Color(0xFFa81845),
          ),),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[100],
          child: Center(
            child: Text("Medicine Cart"),
          ),
        ),
      ),
    );
  }
}
