import 'package:flutter/widgets.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class MyMotionToast {
  static success(BuildContext context, title, desc) {
    return MotionToast.success(
      title: title,
      description: desc,
      width: 300,
      animationType: ANIMATION.fromLeft,
    ).show(context);
  }

  static error(BuildContext context, title, desc) {
    return MotionToast.error(
      title: title,
      description: desc,
      width: 300,
      animationType:  ANIMATION.fromLeft,
    ).show(context);
  }

  static warning(BuildContext context, title, desc) {
    return MotionToast.warning(
      title: title,
      description: desc,
      width: 300,
      animationType:  ANIMATION.fromLeft,
    ).show(context);
  }

  static delete(BuildContext context, title, desc) {
    return MotionToast.delete(
      title: title,
      description: desc,
      width: 300,
      animationType:  ANIMATION.fromLeft,
    ).show(context);
  }

  static info(BuildContext context, title, desc) {
    return MotionToast.info(
      title: title,
      description: desc,
      width: 300,
      animationType:  ANIMATION.fromLeft,
    ).show(context);
  }
}
