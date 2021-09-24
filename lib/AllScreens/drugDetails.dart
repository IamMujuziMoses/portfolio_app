import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/Doctor/doctorAccount.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class DrugDetails extends StatelessWidget {
  final String imageUrl;
  final String drugName;
  final String price;
  final String description;
  final String dosage;
  DrugDetails({Key key, this.imageUrl, this.drugName, this.description, this.price, this.dosage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PickUpLayout(
      scaffold: Scaffold(
        body: customMed(
          body: _drugDetailsBody(context),
          imageUrl: imageUrl,
          drugName: "$drugName $dosage",
        ),
      ),
    );
  }

  Widget _drugDetailsBody(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 10 * SizeConfig.heightMultiplier,
      color: Colors.grey[100],
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 4 * SizeConfig.widthMultiplier,
            vertical: 2 * SizeConfig.heightMultiplier,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.red[400],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("UGX $price", style: TextStyle(
                        fontFamily: "Brand Bold",
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                        color: Colors.white,
                      ),),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5 * SizeConfig.heightMultiplier,),
              Text("Drug description", style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontFamily: "Brand Bold",
                fontSize: 3 * SizeConfig.textMultiplier,
              ),),
              SizedBox(height: 1 * SizeConfig.heightMultiplier,),
              getAbout(description),
              SizedBox(height: 5 * SizeConfig.heightMultiplier,),
              Text("General usage", style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontFamily: "Brand Bold",
                fontSize: 3 * SizeConfig.textMultiplier,
              ),),
              SizedBox(height: 1 * SizeConfig.heightMultiplier,),
              getAbout(description),
              SizedBox(height: 5 * SizeConfig.heightMultiplier,),
              Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red[300], width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Icon(Icons.shopping_cart,
                          color: Colors.red[300],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5 * SizeConfig.widthMultiplier,),
                  RaisedButton(
                    splashColor: Colors.white,
                    highlightColor: Colors.grey.withOpacity(0.1),
                    color: Colors.red[300],
                    textColor: Colors.white,
                    child: Container(
                       width: 60 * SizeConfig.widthMultiplier,
                      child: Center(
                        child: Text("Buy", style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "Brand Bold",
                        ),),
                      ),
                    ),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 5 * SizeConfig.heightMultiplier,),
            ],
          ),
        ),
      ),
    );
  }
}

Widget customMed({@required Widget body, imageUrl, drugName}) {
  return CustomScrollView(
    slivers: <Widget>[
      SliverAppBar(
        backgroundColor: Colors.grey[100],
        expandedHeight: 300,
        floating: false,
        pinned: true,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15)
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(drugName, style: TextStyle(
                color: Colors.black,
                fontFamily: "Brand Bold",
              ),),
            ),
          ),
          background: CachedImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            isRound: false,
            radius: 0,
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Center(
          child: body,
        ),
      ),
    ],
  );
}