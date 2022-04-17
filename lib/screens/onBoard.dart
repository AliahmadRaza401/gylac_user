import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gyalcuser_project/constants/colors.dart';
import 'package:gyalcuser_project/screens/authentication/Login/login.dart';
import 'package:gyalcuser_project/screens/authentication/SignUp/signUp.dart';

import 'package:gyalcuser_project/utils/app_route.dart';
import 'package:gyalcuser_project/widgets/custom_btn.dart';

import '../constants/text_style.dart';
import '../widgets/custom_text.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {

  bool isSelected1 = true;
  bool isSelected2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: orange,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Change App Language',
              style: TextStyle(
                  color: white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: (){
              showDialog(
                  barrierColor: orange.withOpacity(0.2),
                  context: context,
                  builder: (BuildContext context) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 10,
                        insetPadding: const EdgeInsets.all(25),
                        backgroundColor: white,
                        child: StatefulBuilder(
                          builder: (BuildContext context,StateSetter setter){
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        if(mounted){
                                          setter(() {
                                            isSelected2 = false;
                                            isSelected1 = true;
                                          });
                                        }
                                      },
                                      child: Container(
                                        width:120,

                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color:orange,
                                            border: Border.all(color: stroke, width: 1),
                                            boxShadow: [
                                              BoxShadow(
                                                  color:black.withOpacity(0.5),
                                                  offset: Offset(1, 4),
                                                  blurRadius: 4)
                                            ]
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Center(
                                            child: CustomText(
                                              text: "ENGLISH",
                                              color:isSelected1 == false?white:black,
                                              size: 15,
                                              weight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        if(mounted){
                                          setter(() {
                                            isSelected2 = true;
                                            isSelected1 = false;
                                          });
                                        }
                                      },
                                      child: Container(
                                        width:120,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color:orange,
                                            border: Border.all(color: stroke, width: 1),
                                            boxShadow: [
                                              BoxShadow(
                                                  color:black.withOpacity(0.5),
                                                  offset: Offset(1, 4),
                                                  blurRadius: 4)
                                            ]
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Center(
                                            child: CustomText(
                                              text: "MONGOLIAN",
                                              color:isSelected2 == false?white:black,
                                              size: 15,
                                              weight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  });
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(1, 3), color: blackLight, blurRadius: 2)
                ],
                border: Border.all(color: stroke.withOpacity(0.3), width: 1),
                color: lightOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.language,
                color: white,
              ),
            ),
          ),
        ]),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/images/intro.png'),
                Column(
                  children: [
                    CustomBtn(
                      text: "SIGN IN",
                      onTap: () {
                        AppRoutes.push(context, Login());
                      },
                      bgColor: orange,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "OR",
                      style: MyTextStyle.poppins()
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomBtn(
                        text: "SIGN UP",
                        bgColor: orange,
                        onTap: () {
                          AppRoutes.push(context, SignUp());
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
