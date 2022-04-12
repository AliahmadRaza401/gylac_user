import 'package:flutter/material.dart';
import 'package:gyalcuser_project/constants/colors.dart';

import '../utils/app_colors.dart';
class CustomRadioWidget<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final double width;
  final double height;

  CustomRadioWidget({required this.value, required this.groupValue,required this.onChanged, this.width = 28, this.height = 28});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          onChanged(value);
        },
        child: Container(

          height: height,
          width: width,
          decoration: ShapeDecoration(
            shape: CircleBorder(),
          ),

          child: Center(
            child: Container(
              height: this.height - 8,
              width: this.width - 8,
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                gradient: LinearGradient(
                  colors: value == groupValue ? [
                   orangeDark, redOrange,
                  ] : [
                    lightGrey,
                    lightGrey,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}