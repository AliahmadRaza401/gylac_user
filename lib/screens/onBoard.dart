import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gyalcuser_project/constants/colors.dart';
import 'package:gyalcuser_project/screens/authentication/Login/login.dart';
import 'package:gyalcuser_project/screens/authentication/SignUp/signUp.dart';

import 'package:gyalcuser_project/utils/app_route.dart';
import 'package:gyalcuser_project/widgets/custom_btn.dart';

import '../constants/text_style.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: orange,
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Change App Language',
              style: TextStyle(
                  color: white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            width: 10,
          ),
          Container(
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
