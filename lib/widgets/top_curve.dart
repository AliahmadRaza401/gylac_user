import 'package:flutter/cupertino.dart';

Widget curveTop(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.4,
    width: MediaQuery.of(context).size.width,
    alignment: Alignment.bottomLeft,
    decoration:const BoxDecoration(
        // border: Border.all(),
        image: DecorationImage(
            image: AssetImage('assets/images/Frame 32.png'), fit: BoxFit.cover)),
  );
}
