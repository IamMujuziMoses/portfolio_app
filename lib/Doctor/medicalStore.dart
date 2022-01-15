import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/Chat/cachedImage.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/cartScreen.dart';
import 'package:creativedata_app/AllScreens/drugDetails.dart';
import 'package:creativedata_app/constants.dart';
import 'package:creativedata_app/main.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class MedicalStore extends StatefulWidget {
  final Stream drugStream;
  final int items;
  const MedicalStore({Key key, this.drugStream, this.items}) : super(key: key);

  @override
  _MedicalStoreState createState() => _MedicalStoreState();
}

class _MedicalStoreState extends State<MedicalStore> {

  TextEditingController searchTEC = TextEditingController();
  bool searchVisible = false;
  bool titleVisible = true;

  int _cartItems = 0;
  List drugOnSearch = [];
  List drugs = [];
  QuerySnapshot drugSnap;

  @override
  void initState() {
    if (widget.items == null) {
      _cartItems = 0;
    } else {
      _cartItems = widget.items;
    }
    getDrugList();
    super.initState();
  }

  getDrugList() async {
    drugSnap = await widget.drugStream.first;
     for (int i = 0; i <= drugSnap.size - 1; i++) {
       drugs.add(drugSnap.docs[i].get("name"));
     }
  }

  showHideSearchBar() {
    if (searchVisible == false && titleVisible == true) {
     setState(() {
       searchVisible = true;
       titleVisible = false;
     });
    } else if (searchVisible == true && titleVisible == false) {
      setState(() {
        searchVisible = false;
        titleVisible = true;
      });
    }
  }

  Widget drugList() {
    return StreamBuilder(
      stream: widget.drugStream,
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
                  String imageUrl = snapshot.data.docs[index].get("drug_img");
                  String drugName = snapshot.data.docs[index].get("name");
                  String price = snapshot.data.docs[index].get("price");
                  String dosage = snapshot.data.docs[index].get("dosage");
                  return drugTile(
                    context: context,
                    description: description,
                    boxCapacity: dosage,
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
                visible: titleVisible,
                child: Text("Medical Store", style: TextStyle(
                  fontFamily: "Brand Bold",
                  color: Color(0xFFa81845),
            ),),
              ),
              Visibility(
                visible: searchVisible,
                child: Container(
                  height: 5 * SizeConfig.heightMultiplier,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        drugOnSearch = drugs.where((element) => element.toLowerCase()
                            .contains(value.toLowerCase())).toList();
                      });
                    },
                    controller: searchTEC,
                    maxLines: 1,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "Search for drug...",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Brand-Regular",
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                      fontFamily: "Brand-Regular",
                    ),
                  ),
                ),
              ),
            ]
          ),
          actions: <Widget>[
            Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(4),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                    ),
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Center(
                          child: Icon(Icons.shopping_cart_outlined,
                            color: Color(0xFFa81845),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0, top: 5,
                  child: Visibility(
                    visible: _cartItems == 0 ? false : true,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradientColor,
                        border: Border.all(color: Colors.grey[100], width: 2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        child: Center(
                          child: Text(_cartItems.toString(), style: TextStyle(
                            fontFamily: "Brand Bold",
                            color: Colors.white,
                          ),),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: <Widget>[
                Visibility(
                  visible: titleVisible,
                  child: IconButton(
                    onPressed: () => showHideSearchBar(),
                    splashColor: Color(0xFFa81845).withOpacity(0.6),
                    icon: Icon(CupertinoIcons.search, color: Color(0xFFa81845),
                  ),),
                ),
                Visibility(
                  visible: searchVisible,
                  child: IconButton(
                    onPressed: () {
                      searchTEC.text = "";
                      drugOnSearch.clear();
                      showHideSearchBar();
                    },
                    color: Color(0xFFa81845),
                    splashColor: Color(0xFFa81845).withOpacity(0.6),
                    icon: Icon(CupertinoIcons.clear,
                  ),),
                ),
              ],
            ),
          ],
        ),
        body: Container(
          color: Colors.grey[100],
          height: MediaQuery.of(context).size.height,
          width:  MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: searchTEC.text.isNotEmpty && drugOnSearch.length > 0
                ? ListView.builder(
              itemCount: drugOnSearch.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(4),
                  child: GestureDetector(
                    onTap: () async {
                      // showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
                      // );
                      QuerySnapshot drugSnap2;
                      await databaseMethods.getDrugByName(drugOnSearch[index]).then((val) {
                        setState(() {
                          drugSnap2 = val;
                        });
                      });
                      // Navigator.pop(context);
                      Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context) => DrugDetails(
                          items: _cartItems,
                          imageUrl: drugSnap2.docs[0].get("drug_img"),
                          description: drugSnap2.docs[0].get("description"),
                          drugName: drugOnSearch[index],
                          price: drugSnap2.docs[0].get("price"),
                          dosage: drugSnap2.docs[0].get("dosage"),
                        ),
                      ),
                      );
                      Future.delayed(Duration(seconds: 1), () {
                        setState(() {
                          searchTEC.text = "";
                          drugOnSearch.clear();
                          searchVisible = false;
                          titleVisible = true;
                        });
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 5 * SizeConfig.heightMultiplier,
                          width: 10 * SizeConfig.widthMultiplier,
                          decoration: BoxDecoration(
                            gradient: kPrimaryGradientColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Icon(FontAwesomeIcons.pills, color: Colors.white,),
                          ),
                        ),
                        SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                        Text(drugOnSearch[index], style: TextStyle(
                          fontFamily: "Brand Bold",
                        ),),
                      ],
                    ),
                  ),
                );
              },
            ) : drugList(),
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
            items: _cartItems,
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
                          fontSize: 2.4 * SizeConfig.textMultiplier,
                        ),),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text("Dosage: $dosage", maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                          fontFamily: "Brand-Regular",
                          color: Colors.grey,
                          fontSize: 1.6 * SizeConfig.textMultiplier,
                        ),),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text("Price: UGX $price", maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                          fontFamily: "Brand-Regular",
                          color: Colors.grey[600],
                          fontSize: 2 * SizeConfig.textMultiplier,
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
