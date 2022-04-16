import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gyalcuser_project/constants/colors.dart';
import 'package:gyalcuser_project/screens/authentication/Login/login.dart';
import 'package:gyalcuser_project/screens/home/home_page.dart';
import 'package:gyalcuser_project/screens/onBoard.dart';
import 'package:gyalcuser_project/screens/onBoarding/on_boarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      // just delay for showing this slash page clearer because it too fast
      checkSignedIn();
    });
  }

  void checkSignedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("userId");
    if (id.toString() == "null") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Intro()),
        (Route<dynamic> route) => false,
      );
    } else if (id.toString() != "null") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => OnBoardingScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: null,
      body: Center(
        child: Image.asset("assets/images/logo.jpeg"),
      ),
    );
  }
}
