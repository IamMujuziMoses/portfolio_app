import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class PreventiveMeasures extends StatelessWidget {
  const PreventiveMeasures({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.grey[100],
        title: Text("Preventive Measures", style: TextStyle(
          fontFamily: "Brand Bold",
          color: Color(0xFFa81845),
        ),),
      ),
      body: Container(
        color: Colors.grey[100],
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: EdgeInsets.only(
              left: 2 * SizeConfig.widthMultiplier,
              right: 2 * SizeConfig.widthMultiplier,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("How to prevent COVID-19", style: TextStyle(
                    fontFamily: "Brand Bold",
                    fontSize: 3 * SizeConfig.textMultiplier,
                  ),),
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  Padding(
                     padding: EdgeInsets.only(
                       left: 2 * SizeConfig.widthMultiplier,
                       right: 2 * SizeConfig.widthMultiplier,
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                         prevCard(
                           icon: FontAwesomeIcons.headSideMask,
                           title: "Always Wear Mask",
                           message: "Make Wearing a mask a normal part of being around other people. The "
                               "appropriate use, storage and cleaning or disposal are essential to make masks"
                               " as effective as possible.",
                         ),
                         SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                         prevCard(
                           icon: FontAwesomeIcons.peopleArrows,
                           title: "Keep recommended distance",
                           message: "Maintain at least 1 metre distance between yourself and others to reduce "
                               "your risk of infection when they cough, sneeze or speak. Maintain an even "
                               "greater distance between yourself and others when indoors.",
                         ),
                         SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                         prevCard(
                           icon: FontAwesomeIcons.handshakeSlash,
                           title: "Avoid handshakes",
                           message: "Avoid shaking hands with people you don't know, or have just met, avoid "
                               "hugging because the coronavirus is air-bone and can remain on surfaces like "
                               "hands and clothes for a long period of time.",
                         ),
                         SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                         prevCard(
                           icon: FontAwesomeIcons.handsWash,
                           title: "Wash hands with soap or Sanitize",
                           message: "Clean hands frequently with clean water and soap or sanitize with an "
                               "alcohol based sanitizer.",
                         ),
                         SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                         prevCard(
                           icon: FontAwesomeIcons.ban,
                           title: "Avoid touching nose, eyes & mouth",
                           message: "Avoid touching your eyes, nose and mouth. Hands touch many surfaces and "
                               "can pick up viruses.",
                         ),
                         SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                         prevCard(
                           icon: FontAwesomeIcons.ban,
                           title: "Avoid Crowds",
                           message: "Avoid spaces that are closed, crowded or involve close contact. Meet "
                               "people outside.",
                         ),
                         SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                         prevCard(
                           icon: FontAwesomeIcons.ban,
                           title: "Sanitize and Clean touched surfaces",
                           message: "Clean and Disinfect frequently touched surfaces such as door handles, "
                               "faucets and phone screens, car locks, money, et.c",
                         ),
                         SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                         prevCard(
                           icon: FontAwesomeIcons.ban,
                           title: "Sneeze or Cough in bent elbow",
                           message: "Cover your mouth and nose with your bent elbow or tissue when you cough "
                               "or sneeze. Then dispose of the used tissue immediately into a closed bin and "
                               "wash your hands.",
                         ),
                         SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                       ],
                     ),
                   ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}

Widget prevCard({IconData icon, message, String title}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        height: 12 * SizeConfig.heightMultiplier,
        width: 24 * SizeConfig.widthMultiplier,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: Offset(1, 2),
              spreadRadius: 0.5,
              blurRadius: 2,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.black54,
            size: 14 * SizeConfig.imageSizeMultiplier,
          ),
        ),
      ),
      SizedBox(width: 2 * SizeConfig.widthMultiplier,),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          title == null ? Container() : Container(
            width: 65 * SizeConfig.widthMultiplier,
            child: Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: "Brand Bold",
                fontSize: 2.5 * SizeConfig.textMultiplier,
              ),
            ),
          ),
          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
          Container(
            width: 65 * SizeConfig.widthMultiplier,
            child: Text(message,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: "Brand-Regular",
                fontSize: 2.5 * SizeConfig.textMultiplier,
              ),
            ),
          ),

        ],
      )
    ],
  );
}
