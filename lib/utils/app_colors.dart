import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFFBB03B);
  static const Color blackTextColor = Color(0xFF0C0829);
  static const Color orangeColor = Color(0xffFE6F1F);

  static LinearGradient background = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0XFFFFFFFF),
      Color(0XFFFFFFFE),
      Color(0XFFFFFEF1),
      Color(0XFFFFFEF2),
    ],
  );
  static LinearGradient timebackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.white,
      Colors.white,
      Color(0XFFE3E3E3).withOpacity(.7),
      Color(0XFFE3E3E3).withOpacity(.7),
      Color(0XFFE3E3E3).withOpacity(.7),
      Colors.white,
      Colors.white,
    ],
  );
  static LinearGradient appBar = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0XFFFDFDFD),
      Color(0XFFFCFCFC),
      Color(0XFFFBFBFB),
      Color(0XFFFAFAFA),
      Color(0XFFF5F5F5),
      Color(0XFFF5F5F5),
      Color(0XFFF4F4F3),
      Color(0XFFF6F6F6),
    ],
  );
}
