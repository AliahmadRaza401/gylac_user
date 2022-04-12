import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class ToastUtils{

  static showErrorToast(
      BuildContext context, String title, String description) {
    MotionToast.error(
        title: Text(title,style: const TextStyle(fontWeight: FontWeight.bold),),
        description: Text(description))
        .show(context);
  }

  static showSuccessToast(
      BuildContext context, String title, String description) {
    MotionToast.success(
        title: Text(title,style: const TextStyle(fontWeight: FontWeight.bold),),
        description: Text(description))
        .show(context);
  }

  static showWarningToast(
      BuildContext context, String title, String description) {
    MotionToast.warning(
        title: Text(title,style: const TextStyle(fontWeight: FontWeight.bold),),
        description: Text(description))
        .show(context);
  }

}