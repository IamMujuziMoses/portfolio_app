import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/drugDetails.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class MedicalStore extends StatelessWidget {
  final Stream drugStream;
  const MedicalStore({Key key, this.drugStream}) : super(key: key);

  Widget drugList() {
    return StreamBuilder(
      stream: drugStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? GridView.builder(
                itemCount: snapshot.data.docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2 * SizeConfig.widthMultiplier
                ),
                itemBuilder: (context, index) {
                  String description = snapshot.data.docs[index].get("description");
                  String boxCapacity = snapshot.data.docs[index].get("dosage");
                  String imageUrl = snapshot.data.docs[index].get("drug_img");
                  String drugName = snapshot.data.docs[index].get("name");
                  String price = snapshot.data.docs[index].get("price");
                  String dosage = snapshot.data.docs[index].get("dosage");
                  return drugTile(
                    context: context,
                    description: description,
                    boxCapacity: boxCapacity,
                    imageUrl: imageUrl,
                    dosage: dosage,
                    drugName: drugName,
                    price: price,
                  );
                },
              ) : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.grey[100],
          title: Stack(
            children: <Widget>[
              Visibility(
                visible: true,
                child: Text("Medical Store", style: TextStyle(
                  fontFamily: "Brand Bold",
                  color: Colors.red[300],
            ),),
              ),
              Visibility(
                visible: true,
                child: Text("Medical Store", style: TextStyle(
                  fontFamily: "Brand Bold",
                  color: Colors.red[300],
            ),),
              ),

            ]
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              color: Colors.red[300],
              splashColor: Colors.red[200],
              icon: Icon(CupertinoIcons.search,
              ),),
          ],
        ),
        body: Container(
          color: Colors.grey[100],
          height: MediaQuery.of(context).size.height,
          width:  MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: drugList(),
          ),
        ),
      ),
    );
  }

  Widget drugTile({BuildContext context, description, boxCapacity, dosage, imageUrl, drugName, price}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => DrugDetails(
            imageUrl: imageUrl,
            description: description,
            drugName: drugName,
            price: price,
            dosage: dosage,
          ),
        ),
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          width: 20 * SizeConfig.widthMultiplier,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                offset: Offset(2, 3),
                spreadRadius: 0.5,
                blurRadius: 2,
                color: Colors.black.withOpacity(0.3),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              CachedImage(
                width: double.infinity,
                height: 16 * SizeConfig.heightMultiplier,
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                radius: 10,
              ),
              Container(
                width: double.infinity,
                height: 9 * SizeConfig.heightMultiplier,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Text("$drugName $dosage", maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text("Dosage: $dosage", maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                          fontFamily: "Brand-Regular",
                          color: Colors.grey,
                          fontSize: 1.8 * SizeConfig.textMultiplier,
                        ),),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text("Price: UGX $price", maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                          fontFamily: "Brand-Regular",
                          color: Colors.grey[600],
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                        ),),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
}
}
