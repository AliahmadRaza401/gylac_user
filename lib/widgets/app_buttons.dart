import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gyalcuser_project/constants/colors.dart';

import '../constants/text_style.dart';
import '../utils/app_colors.dart';


Widget customButton(BuildContext context, title, Function onPress) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.5,
    child: RaisedButton(
      color: Colors.black,
      textColor: Colors.white,
      child: SizedBox(
        height: 60.0,
        child: Center(
            child: Text(
          title,
          style: MyTextStyle.poppinsBold().copyWith(
            fontSize: 18.0,
            color: Colors.white
          ),
        )),
      ),
      shape:  RoundedRectangleBorder(
        borderRadius:  BorderRadius.circular(10.0),
      ),
      onPressed: onPress(),
    ),
  );
}

class NormalButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;

  const NormalButton({
     Key? key,
    required this.buttonText,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10)),
        height: 45,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Text(buttonText),
      ),
    );
  }
}
