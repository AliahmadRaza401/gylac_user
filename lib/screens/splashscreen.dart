import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gyalcuser_project/constants/colors.dart';
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
      checkSignedIn();
    });
  }

  void checkSignedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("userId");
    var viewed = prefs.getInt("onBoard");
    if (id.toString() == "null") {
      if (viewed != 0) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => OnBoardingScreen()),
              (Route<dynamic> route) => false,
        );
      }
      else{
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Intro()),
              (Route<dynamic> route) => false,
        );
      }
    } else if (id.toString() != "null") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Intro()),
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
