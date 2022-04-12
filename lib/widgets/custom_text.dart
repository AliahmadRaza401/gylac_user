import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  
  // name constructor that has a positional parameters with the text required
  // and the other parameters optional
  CustomText({required this.text, this.size,this.color,this.weight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,style: TextStyle(fontFamily: 'Roboto',fontSize: size ?? 16, color: color ?? black, fontWeight: weight ?? FontWeight.normal),
    );
  }
}