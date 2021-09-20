import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_app/AllScreens/VideoChat/pickUpLayout.dart';
import 'package:creativedata_app/AllScreens/loginScreen.dart';
import 'package:creativedata_app/AllScreens/registerScreen.dart';
import 'package:creativedata_app/Models/patient.dart';
import 'package:creativedata_app/Services/database.dart';
import 'package:creativedata_app/Utilities/utils.dart';
import 'package:creativedata_app/Widgets/progressDialog.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class AddPatientScreen extends StatefulWidget {
  AddPatientScreen({Key key}) : super(key: key);

  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {

  DatabaseMethods databaseMethods = DatabaseMethods();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController healthDepTEC = TextEditingController();
  TextEditingController prescriptionTEC = TextEditingController();
  TextEditingController allergyPresTEC = TextEditingController();
  TextEditingController heightTEC = TextEditingController();
  TextEditingController weightTEC = TextEditingController();
  TextEditingController bmiTEC = TextEditingController();
  TextEditingController pressureTEC = TextEditingController();
  TextEditingController pulseTEC = TextEditingController();
  TextEditingController fileNoTEC = TextEditingController();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController dobTEC = TextEditingController();
  TextEditingController recTEC = TextEditingController();
  TextEditingController ptTEC = TextEditingController();
  TextEditingController diagTEC = TextEditingController();
  TextEditingController residenceTEC = TextEditingController();
  TextEditingController streetTEC = TextEditingController();
  TextEditingController cityTEC = TextEditingController();
  TextEditingController telTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController kinTEC = TextEditingController();
  TextEditingController smokingTEC = TextEditingController();
  TextEditingController famDiabetesTEC = TextEditingController();
  TextEditingController famPressureTEC = TextEditingController();
  TextEditingController famCancerTEC = TextEditingController();
  TextEditingController alcoholTEC = TextEditingController();
  TextEditingController allergiesTEC = TextEditingController();
  DropDownList sexList = DropDownList(
    listItems: ["Male", "Female"],
    placeholder: "Sex",
  );
  List medList = [];
  List allergyMedList = [];

  @override
  Widget build(BuildContext context) {
    return PickUpLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.grey[100],
          title: Text("Add Patient", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Colors.red[300],
          ),),
        ),
        body: Container(
          color: Colors.grey[100],
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text("Please Fill in all the Fields", style: TextStyle(
                      fontFamily: "Brand Bold",
                      fontSize: 2 * SizeConfig.textMultiplier,
                      color: Colors.grey,
                    ),),
                  ),
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      leftTile(title: "Health Dpt:", controller: healthDepTEC),
                      rightTile(title: "File No.:", controller: fileNoTEC,),
                    ],
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      leftTile(title: "Name:", controller: nameTEC,),
                      dateTile(title: "D.O.B:", controller: dobTEC, context: context,),
                    ],
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      leftTile(title: "Pt. No.:", controller: ptTEC,),
                      dateTile(title: "Recr. on:", controller: recTEC,
                        context: context,
                        dateTime: DateTime.now(),
                      ),
                    ],
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      leftTile(title: "Diagnosis:", controller: diagTEC),
                      dropDownTile(title: "Sex:", downList: sexList),
                    ],
                  ),
                  SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                  radioTile(title: "Smoking:", controller: smokingTEC),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  radioTile(title: "Alcoholic:", controller: alcoholTEC),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  radioTile(title: "Allergies:", controller: allergiesTEC),
                  SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      measureTile(title: "Height:", controller: heightTEC, trailing: "ft"),
                      measureTile(title: "Weight:", controller: weightTEC, trailing: "Kg"),
                    ],
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      measureTile(title: "Pressure:", controller: pressureTEC, trailing: "mmHg"),
                      measureTile(title: "Pulse:", controller: pulseTEC, trailing: "bpm"),
                    ],
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  measureTile(title: "BMI.:", controller: bmiTEC, trailing: "Kg"),
                  SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                  Text("Medication", style: TextStyle(
                    fontFamily: "Brand Bold",
                    color: Colors.black54,
                    fontSize: 2.5 * SizeConfig.textMultiplier,
                  ),),
                  medList.isNotEmpty && medList.length > 0
                      ? SizedBox(height: 2 * SizeConfig.heightMultiplier,)
                      : Container(),
                  medList.isNotEmpty && medList.length > 0
                      ? presCard(list: medList)
                      : Container(),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  presInputTile(controller: prescriptionTEC, list: medList, hintText: "Prescription"),
                  SizedBox(height: 6 * SizeConfig.heightMultiplier,),
                  Text("Medication for Allergies", style: TextStyle(
                    fontFamily: "Brand Bold",
                    color: Colors.black54,
                    fontSize: 2.5 * SizeConfig.textMultiplier,
                  ),),
                  allergyMedList.isNotEmpty && allergyMedList.length > 0
                      ? SizedBox(height: 2 * SizeConfig.heightMultiplier,)
                      : Container(),
                  allergyMedList.isNotEmpty && allergyMedList.length > 0
                      ? presCard(list: allergyMedList)
                      : Container(),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  presInputTile(controller: allergyPresTEC, list: allergyMedList, hintText: "Prescription for Allergies"),
                  SizedBox(height: 6 * SizeConfig.heightMultiplier,),
                  Text("Other Records", style: TextStyle(
                    fontFamily: "Brand Bold",
                    color: Colors.black,
                    fontSize: 3 * SizeConfig.textMultiplier,
                  ),),
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  Text("Family Health History", style: TextStyle(
                    fontFamily: "Brand Bold",
                    color: Colors.black45,
                    fontSize: 2.5 * SizeConfig.textMultiplier,
                  ),),
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  radioTile(title: "Anyone With Pressure:",
                    width: 75 * SizeConfig.widthMultiplier,
                    controller: famPressureTEC,
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  radioTile(title: "Anyone With Diabetes:",
                    width: 75 * SizeConfig.widthMultiplier,
                    controller: famDiabetesTEC,
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  radioTile(title: "Anyone With Cancer:",
                    width: 75 * SizeConfig.widthMultiplier,
                    controller: famCancerTEC
                  ),
                  SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                  Text("Patient's Contacts", style: TextStyle(
                    fontFamily: "Brand Bold",
                    color: Colors.black45,
                    fontSize: 2.5 * SizeConfig.textMultiplier,
                  ),),
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  leftTile(
                    title: "Residence:",
                    controller: residenceTEC,
                    width: double.infinity,
                    containerWidth: 60 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  leftTile(
                    title: "Street:",
                    controller: streetTEC,
                    width: double.infinity,
                    containerWidth: 60 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  leftTile(
                    title: "City:",
                    controller: cityTEC,
                    width: double.infinity,
                    containerWidth: 60 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  leftTile(
                    title: "Tel:",
                    controller: telTEC,
                    type: TextInputType.phone,
                    width: double.infinity,
                    containerWidth: 60 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  leftTile(
                    title: "E-mail:",
                    controller: emailTEC,
                    type: TextInputType.emailAddress,
                    width: double.infinity,
                    containerWidth: 60 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  leftTile(
                    title: "Next of Kin Tel:",
                    type: TextInputType.phone,
                    controller: kinTEC,
                    width: double.infinity,
                    containerWidth: 60 * SizeConfig.widthMultiplier,
                  ),
                  SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                  Center(
                    child: Container(
                      width: 60 * SizeConfig.widthMultiplier,
                      child: RaisedButton(
                        onPressed: () async{
                          if (healthDepTEC.text.isEmpty) {
                            displayToastMessage("Health Department is required", context);
                          } else if (fileNoTEC.text.isEmpty) {
                            displayToastMessage("File Number is required", context);
                          } else if (nameTEC.text.isEmpty) {
                            displayToastMessage("Patient's Name is required", context);
                          } else if (dobTEC.text.isEmpty) {
                            displayToastMessage("Date of Birth is required", context);
                          } else if (recTEC.text.isEmpty) {
                            displayToastMessage("Recruited date is required", context);
                          } else if (diagTEC.text.isEmpty) {
                            displayToastMessage("Diagnosis is required", context);
                          } else if (sexList.selectedValue.isEmpty) {
                            displayToastMessage("Sex is required", context);
                          } else if (smokingTEC.text.isEmpty) {
                            displayToastMessage("Smoking Option is required", context);
                          } else if (alcoholTEC.text.isEmpty) {
                            displayToastMessage("Alcoholic Option is required", context);
                          } else if (allergiesTEC.text.isEmpty) {
                            displayToastMessage("Allergies Option is required", context);
                          } else if (heightTEC.text.isEmpty) {
                            displayToastMessage("Height is required", context);
                          } else if (weightTEC.text.isEmpty) {
                            displayToastMessage("Weight is required", context);
                          } else if (pressureTEC.text.isEmpty) {
                            displayToastMessage("Blood Pressure is required", context);
                          } else if (pulseTEC.text.isEmpty) {
                            displayToastMessage("Pulse is required", context);
                          } else if (medList.isEmpty) {
                            displayToastMessage("Please provide the prescription", context);
                          } else if (allergiesTEC.text == "Yes" && allergyMedList.isEmpty) {
                            displayToastMessage("Please provide allergies prescription", context);
                          } else if (famPressureTEC.text.isEmpty) {
                            displayToastMessage("Anyone with Pressure option is required", context);
                          } else if (famDiabetesTEC.text.isEmpty) {
                            displayToastMessage("Anyone with Diabetes is required", context);
                          } else if (famCancerTEC.text.isEmpty) {
                            displayToastMessage("Anyone with Cancer is required", context);
                          } else if (residenceTEC.text.isEmpty) {
                            displayToastMessage("Residence is required", context);
                          } else if (streetTEC.text.isEmpty) {
                            displayToastMessage("Street is required", context);
                          } else if (cityTEC.text.isEmpty) {
                            displayToastMessage("City is required", context);
                          } else if (telTEC.text.isEmpty) {
                            displayToastMessage("Telephone is required", context);
                          } else if (emailTEC.text.isEmpty) {
                            displayToastMessage("Email is required", context);
                          } else if (kinTEC.text.isEmpty) {
                            displayToastMessage("Next of Kin is required", context);
                          } else {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return ProgressDialog(message: "Please wait...",);
                                });
                            Patient patient = Patient(
                              time: FieldValue.serverTimestamp(),
                              healthDep: healthDepTEC.text,
                              height: heightTEC.text + " ft",
                              weight: weightTEC.text + " Kg",
                              bmi: bmiTEC.text.isNotEmpty ? bmiTEC.text + " Kg" : null,
                              pressure: pressureTEC.text + " mmHg",
                              pulse: pulseTEC.text + " bpm",
                              fileNo: fileNoTEC.text,
                              name: nameTEC.text,
                              pic: null,
                              dob: dobTEC.text,
                              recruited: recTEC.text,
                              pt: ptTEC.text.isNotEmpty ? ptTEC.text : null,
                              diagnosis: diagTEC.text,
                              residence: residenceTEC.text,
                              street: streetTEC.text,
                              city: cityTEC.text,
                              phone: telTEC.text,
                              email: emailTEC.text,
                              kin: kinTEC.text,
                              smoking: smokingTEC.text,
                              famDiabetes: famDiabetesTEC.text,
                              famPressure: famPressureTEC.text,
                              famCancer: famCancerTEC.text,
                              alcoholic: alcoholTEC.text,
                              allergies: allergiesTEC.text,
                              sex: sexList.selectedValue,
                              medicine: medList,
                              allergyMed: allergyMedList,
                              private: false,
                            );
                            var patientMap = patient.toMap(patient);
                            await databaseMethods.savePatient(patientMap, firebaseAuth.currentUser.uid);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        },
                        color: Colors.red[300],
                        splashColor: Colors.white,
                        highlightColor: Colors.grey.withOpacity(0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text("Submit", style: TextStyle(
                            fontFamily: "Brand Bold",
                            color: Colors.white,
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                          ),),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget presCard({List list}) {
    return Container(
      width: double.infinity,
      child: list.isNotEmpty && list.length > 0
          ? ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                height: 1 * SizeConfig.heightMultiplier,
              ),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  height: 5 * SizeConfig.heightMultiplier,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        spreadRadius: 0.5,
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          list[index],
                          style: TextStyle(
                            fontFamily: "Brand Bold",
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              list.removeAt(index);
                            });
                          },
                          padding: EdgeInsets.all(2),
                          icon: Icon(
                            CupertinoIcons.clear_thick,
                            color: Colors.red[300],
                            size: 4 * SizeConfig.imageSizeMultiplier,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Container(),
    );
  }

  Widget presInputTile({TextEditingController controller, List list, hintText, TextInputType type}) {
    return Container(
      width: double.infinity,
      height: 4 * SizeConfig.heightMultiplier,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 60 * SizeConfig.widthMultiplier,
            child: TextField(
              controller: controller,
              maxLines: 1,
              keyboardType: type,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: "Brand-Regular",
                  color: Colors.grey,
                  fontSize: 2 * SizeConfig.textMultiplier,
                ),
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(5, 10, 10, 5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              style: TextStyle(
                fontSize: 2 * SizeConfig.textMultiplier,
                fontFamily: "Brand-Regular",
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  list.add(controller.text);
                  controller.text = "";
                });
              }
            },
            color: Colors.white,
            splashColor: Colors.red[200],
            highlightColor: Colors.grey.withOpacity(0.1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Text("Add", style: TextStyle(
                fontFamily: "Brand Bold",
                color: Colors.red[300],
                fontSize: 2.5 * SizeConfig.textMultiplier,
              ),),
            ),
          ),
        ],
      ),
    );
  }

  Widget rightTile({String title, TextEditingController controller, TextInputType type}) {
    return Container(
      width: 35 * SizeConfig.widthMultiplier,
      height: 4 * SizeConfig.heightMultiplier,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(
              fontFamily: "Brand Bold",
              fontSize: 2.3 * SizeConfig.textMultiplier,
            ),),
          Container(
            width: 20 * SizeConfig.widthMultiplier,
            child: TextField(
              controller: controller,
              maxLines: 1,
              keyboardType: type,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(5, 10, 10, 5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              style: TextStyle(
                fontSize: 2 * SizeConfig.textMultiplier,
                fontFamily: "Brand-Regular",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dropDownTile({String title, DropDownList downList}) {
    return Container(
      width: 35 * SizeConfig.widthMultiplier,
      height: 4 * SizeConfig.heightMultiplier,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(
              fontFamily: "Brand Bold",
              fontSize: 2.3 * SizeConfig.textMultiplier,
            ),),
          Container(
            width: 20 * SizeConfig.widthMultiplier,
            child: downList,
          ),
        ],
      ),
    );
  }

  Widget measureTile({String title, TextEditingController controller, trailing,}) {
    return Container(
      width: 45 * SizeConfig.widthMultiplier,
      height: 4 * SizeConfig.heightMultiplier,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(
            fontFamily: "Brand Bold",
            fontSize: 2.3 * SizeConfig.textMultiplier,
          ),),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 16 * SizeConfig.widthMultiplier,
                child: TextField(
                  controller: controller,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(5, 10, 10, 5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 2 * SizeConfig.textMultiplier,
                    fontFamily: "Brand-Regular",
                  ),
                ),
              ),
              Text(trailing, style: TextStyle(
                fontFamily: "Brand-Regular",
                fontSize: 2 * SizeConfig.textMultiplier,
              ),),
            ],
          ),
        ],
      ),
    );
  }

   Widget dateTile({String title, TextEditingController controller, BuildContext context, DateTime dateTime,}) {
    FocusNode focusNode = FocusNode();

    textFieldFocusDidChange() async {
      if (focusNode.hasFocus) {
        var date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: dateTime == null ? DateTime(1950) : dateTime,
          lastDate: DateTime(2089),
        );
        controller.text = date == null ? "" : Utils.formatDate(date);
        focusNode.removeListener(textFieldFocusDidChange);
        //focusNode.dispose();
      }
    }

    focusNode.addListener(textFieldFocusDidChange);
    return Container(
      width: 35 * SizeConfig.widthMultiplier,
      height: 4 * SizeConfig.heightMultiplier,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(
              fontFamily: "Brand Bold",
              fontSize: 2.3 * SizeConfig.textMultiplier,
            ),),
          Container(
              width: 20 * SizeConfig.widthMultiplier,
              child: TextField(
                    controller: controller,
                    maxLines: 1,
                    focusNode: focusNode,
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(5, 10, 10, 5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 2 * SizeConfig.textMultiplier,
                      fontFamily: "Brand-Regular",
                    ),
                  ),
            ),
        ],
      ),
    );
  }

  Widget leftTile({String title, TextEditingController controller, width, containerWidth, TextInputType type}) {
    return Container(
      width: width == null ? 50 * SizeConfig.widthMultiplier : width,
      height: 4 * SizeConfig.heightMultiplier,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(
              fontFamily: "Brand Bold",
              fontSize: 2.3 * SizeConfig.textMultiplier,
            ),),
          Container(
            width: containerWidth == null ? 30 * SizeConfig.widthMultiplier : containerWidth,
            child: TextField(
              controller: controller,
              maxLines: 1,
              keyboardType: type,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(5, 10, 10, 5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              style: TextStyle(
                fontSize: 2 * SizeConfig.textMultiplier,
                fontFamily: "Brand-Regular",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget radioTile({String title, width, TextEditingController controller}) {
    String group = "";
    return Container(
          width: width == null ? 50 * SizeConfig.widthMultiplier : width,
          height: 4 * SizeConfig.heightMultiplier,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title, style: TextStyle(
                fontFamily: "Brand Bold",
                fontSize: 2.3 * SizeConfig.textMultiplier,
              ),),
              Container(
                width: 30 * SizeConfig.widthMultiplier,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Row(
                      children: <Widget>[
                        Container(
                          width: 7 * SizeConfig.widthMultiplier,
                          child: Radio(
                            value: "Yes",
                            activeColor: Colors.red[300],
                            groupValue: group,
                            onChanged: (T) {
                              setState(() {
                                group = T;
                                controller.text = T;
                              });
                            },
                          ),
                        ),
                        Text("Yes", style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),),
                        Spacer(),
                        Container(
                          width: 7 * SizeConfig.widthMultiplier,
                          child: Radio(
                            value: "No",
                            activeColor: Colors.red[300],
                            groupValue: group,
                            onChanged: (T) {
                              setState(() {
                                group = T;
                                controller.text = T;
                              });
                            },
                          ),
                        ),
                        Text("No", style: TextStyle(
                          fontFamily: "Brand Bold",
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
  }
}
