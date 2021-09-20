import 'package:creativedata_app/Covid-19/covid19Center.dart';
import 'package:creativedata_app/Covid-19/preventiveMeasures.dart';
import 'package:creativedata_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*
* Created by Mujuzi Moses
*/

class TreatmentAndManagement extends StatelessWidget {
  const TreatmentAndManagement({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.grey[100],
        title: Text("Treatment & Management", style: TextStyle(
          fontFamily: "Brand Bold",
          color: Colors.red[300],
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
                Text("Treatment", style: TextStyle(
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
                        message: "Scientists around the world are working to find and develop treatment for "
                            "COVID-19. Optimal supportive care includes OXYGEN for severely ill patients and "
                            "those who are at risk for severe disease and more advanced respiratory",
                        icon: FontAwesomeIcons.ban,
                      ),
                      Text("support such as ventilation for patients who are critically ill.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                      ),),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                      Text("DEXAMETHASONE is a corticosteroid that can help reduce the length of time on a "
                          "ventilator and save lives of patients with severe and critical illness. WHO does not "
                          "recommend self-medication with any medicines including antibiotics, as a prevention"
                          " or cure for COVID-19. Source(WHO)",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                      ),),
                    ],
                  ),
                ),
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Text("Why you should get vaccinated", style: TextStyle(
                  fontFamily: "Brand Bold",
                  fontSize: 3 * SizeConfig.textMultiplier,
                ),),
                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                Padding(
                  padding: EdgeInsets.only(
                    left: 2 * SizeConfig.widthMultiplier,
                    right: 2 * SizeConfig.widthMultiplier,
                  ),
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      prevCard(
                        message: "There are several safe and effective vaccines that prevent people from "
                            "getting seriously ill or dying from COVID-19. This is one pat of managing COVID-19, "
                            "in addition to the main preventive measures of staying at least 1 metre away from ",
                        icon: FontAwesomeIcons.ban,
                      ),
                      Text("others, covering a cough or sneeze in your elbow, frequently cleaning your hands, "
                          "wearing a mask and avoiding poorly ventilated rooms or opening a window. \nAs of 3 "
                          "June 2021, WHO has evaluated that the following vaccines against COVID-19 have met "
                          "the necessary criteria for safety and efficiency:\n\nAstraZeneca/Oxford vaccine.\n"
                          "Johnson and Johnson.\nModerna.\nPfizer/BionTech.\nSinopharm.\nSinovac.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),),
                    ],
                  ),
                ),
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Text("Who should get vaccinated?", style: TextStyle(
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
                      Text("The COVID-19 vaccines are safe for most people 18 years and older, including those"
                          " with pre-existing conditions of any kind, including auto-immune disorders. These "
                          "conditions include: hypertension, diabetes, asthma, pulmonary, liver and kidney "
                          "disease as well as chronic infections that are stable and controlled.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),),
                      SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
                      Text("If supplies are limited in your area, discuss your situation with your care provider "
                          "if you:\n\n"
                          "Have a compromised immune system.\nAre pregnant (if you are already breastfeeding, "
                          "you should continue after vaccination).\nHave a history of severe allergies, "
                          "particularly to a vaccine (or any of the ingredients in the vaccine).\nAre "
                          "severely frail.\n",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),),
                      SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
                      Text("Children and adolescents tend to have milder disease compared to adults, so unless "
                          "they ae a part of a group at higher risk of severe COVID-19, it is less urgent to "
                          "vaccinate then than older people, those with chronic health conditions and health workers.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),),
                      SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
                      Text("More evidence is needed on the use of the different COVID-19 vaccines in children "
                          "to be able to make general recommendations on vaccinating children against COVID-19.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),),
                      SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
                      Text("WHO's Strategic Advisory Group of Experts (SAGE) has concluded that the Pfizer/"
                          "BionTech vaccine is suitable for use for people aged 12 yeas and above. Children "
                          "aged between 12 years and 15 who are at high risk may be offered this vaccine alongside "
                          "other priority groups for vaccination. Vaccine trials for children are ongoing and "
                          "WHO will update its recommendations when the evidence or epidemiological situation "
                          "warrants a change in policy.\n\n"
                          "It's important for children to continue to have the recommended childhood vaccines.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),),
                      SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),

                    ],
                  ),
                ),
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Text("What should I do and expect after vaccination.", style: TextStyle(
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
                      Text("Stay at the place where you get vaccinated for at least 15 minutes afterwards, "
                          "just in case you have an unusual reaction, so health workers can help you.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),),
                      SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
                      Text("Check when you should come in for the second dose - if needed. Most of the vaccines "
                          "available are two-dose vaccines. Check with your care provider whether you need to "
                          "get a second dose and when you should get it. Second doses help boost the immune "
                          "response and strengthen immunity.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),),
                      SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
                      Text("In most cases, minor side effects are normal. Common side effects after vaccination, "
                          "which indicate that a person's body is building protection to COVID-19 infection "
                          "include:\n\nArm soreness.\nMild fever.\nTiredness.\nHeadaches.\nMuscle or joint aches.\n",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),),
                      SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
                      Text("Contact your care provider if there is redness or tenderness (pain) where you got "
                          "the shot that increases after 24 hours, or if side effects do not go away after a "
                          "few days.\n\nIf you experience an immediate severe allergic reaction to a first dose "
                          "of the COVID-19 vaccine, you should nt receive additional doses of the vaccine. "
                          "It's extremely rare for severe health reactions to be directly caused by vaccines.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),),
                      SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
                      Text("Taking painkillers such as paracetamol before receiving the COVID-19 vaccine to "
                          "prevent side effects is not recommended. This is because it is not known how "
                          "painkillers may affect how well the vaccine works. However, you may take paracetamol "
                          "or other painkillers if you do develop side effects such as pain, fever, headache or "
                          "muscle aches after vaccination.\n\nEven after you're vaccinated, keep taking precautions.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),),
                      SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
                      Text("While a COVID-19 vaccine wll prevent serious illness and death, we still don't "
                          "know the extent to which it keeps you from being infected and passing the virus on "
                          "to others. The more we allow the virus to spread, the more opportunity the virus "
                          "has to change.\n\nContinue to take actions to show and eventually stop the spread "
                          "of the virus.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),),
                      SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
                      Text("Keep at least 1 metre from others.\nWear a mask, especially in crowded, closed and "
                          "poorly ventilated settings.\nClean your hands frequently.\nCover any cough or sneeze "
                          "in your bent elbow.\nWhen indoors with others, ensure good ventilation, such as by "
                          "opening a window.\n\nDoing it all protects us all.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Brand-Regular",
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                        ),),
                      SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
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
