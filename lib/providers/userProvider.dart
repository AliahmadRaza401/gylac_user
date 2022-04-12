import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  String email = "";
  String password = "";
  String uid = "";
  String fullName = '';
  String phoneNumber = '';
  String image = '';
  String address = '';
}
