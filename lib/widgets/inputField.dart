import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../constants/colors.dart';
import '../utils/app_colors.dart';

Widget inputField(BuildContext context, title, hint, controller,textInputType,suffix) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.04,
              )),
        ],
      ),
      Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: textFieldStroke, width: 1),
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 1),
                color: black.withOpacity(0.25),
                blurRadius: 3)
          ],
        ),
        height: MediaQuery.of(context).size.height * 0.05,
        child: TextFormField(
            keyboardType: textInputType,
            controller: controller,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.left,
            maxLines: 1,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Required';
              }
              return null;
            },
            style: const TextStyle(
              fontSize: 13,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height *
                    0.01, // HERE THE IMPORTANT PART
                left: 10,
              ),

              suffixIcon: suffix,
              labelStyle: const TextStyle(),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                ),
              ),
              hintText: hint,
              // labelText:"Your Name"
            )),
      ),
    ],
  );
}
