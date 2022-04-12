import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';
import 'custom_text.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final Color? txtColor;
  final Color? bgColor;
  final Color? shadowColor;
  final Function() onTap;
  final double? size;
  final double? w;

  const CustomBtn(
      {Key? key,
      this.size,
        this.w,
      required this.text,
      this.txtColor,
      this.bgColor,
      this.shadowColor,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width:w?? 180,
        height: 55,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: bgColor ?? black,
            border: Border.all(color: stroke.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                  color: shadowColor == null
                      ? Colors.grey.withOpacity(0.5)
                      : shadowColor!.withOpacity(0.5),
                  offset: Offset(1, 4),
                  blurRadius: 4)
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: CustomText(
              text: text,
              color: txtColor ?? white,
              size: size ?? 22,
              weight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
