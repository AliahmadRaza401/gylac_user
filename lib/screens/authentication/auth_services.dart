import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gyalcuser_project/constants/toast_utils.dart';
import 'package:gyalcuser_project/providers/loading_provider.dart';
import 'package:gyalcuser_project/screens/home/home_page.dart';
import 'package:gyalcuser_project/screens/onBoard.dart';
import 'package:gyalcuser_project/utils/app_route.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/userProvider.dart';
import '../../services/firebase_services.dart';

class AuthServices {
  static var errorMessage;

  //SignIn
  static signIn(BuildContext context, String email, String password) async {
    final auth = FirebaseAuth.instance;
    UserProvider _userProvider = Provider.of<UserProvider>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    LoadingProvider _loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
    _loadingProvider.setLoading(true);
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
        pref.setString("userId", auth.currentUser!.uid),
                AppRoutes.replace(
                  context,
                  const HomePage(),
                ),
        ToastUtils.showSuccessToast(
            context, "Success", "Login Successful!!"),
                userLoggedIn(true),
                _loadingProvider.setLoading(false),
              });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":

          ToastUtils.showErrorToast(
              context, "Error", "Your email address is invalid");
          break;
        case "wrong-password":
          ToastUtils.showErrorToast(context, "Error", "Your password is wrong.");

          break;
        case "user-not-found":
          ToastUtils.showErrorToast(
              context, "Error", "User with this email doesn't exist.");

          break;
        case "user-disabled":
          ToastUtils.showErrorToast(
              context, "Error", "User with this email has been disabled.");

          break;
        case "too-many-requests":
          ToastUtils.showErrorToast(context, "Error", "Too many requests");

          break;
        case "operation-not-allowed":
          ToastUtils.showErrorToast(context, "Error",
              "Signing in with Email and Password is not enabled.");

          break;
        default:
          ToastUtils.showErrorToast(
              context, "Error", "An undefined Error happened");
      }
      _loadingProvider.setLoading(false);

      // GeneralDialogs.showOopsDialog(context, errorMessage);
      // MyMotionToast.error(
      //   context,
      //   "Error",
      //   errorMessage,
      // );
      return "false";
    }
  }

  // SignUp-----------------------------------------
  static void signUp(BuildContext context, String email, String password,
      fullName, mobilenumber, imageFile) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final _auth = FirebaseAuth.instance;
    LoadingProvider _loadingProvider =
        Provider.of<LoadingProvider>(context, listen: false);
    _loadingProvider.setLoading(true);
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
            pref.setString("userId", _auth.currentUser!.uid),
                postDetailsToFirestore(context, fullName, email, mobilenumber,
                    password, imageFile),
              })
          .catchError((e) {
        _loadingProvider.setLoading(false);
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":

          ToastUtils.showErrorToast(
              context, "Error", "Your email address is invalid");
          break;
        case "wrong-password":
          ToastUtils.showErrorToast(context, "Error", "Your password is wrong.");

          break;
        case "user-not-found":
          ToastUtils.showErrorToast(
              context, "Error", "User with this email doesn't exist.");

          break;
        case "user-disabled":
          ToastUtils.showErrorToast(
              context, "Error", "User with this email has been disabled.");

          break;
        case "too-many-requests":
          ToastUtils.showErrorToast(context, "Error", "Too many requests");

          break;
        case "operation-not-allowed":
          ToastUtils.showErrorToast(context, "Error",
              "Signing in with Email and Password is not enabled.");

          break;
        default:
          ToastUtils.showErrorToast(
              context, "Error", "An undefined Error happened");
      }
      _loadingProvider.setLoading(false);
      // MyMotionToast.error(
      //   context,
      //   "Error",
      //   errorMessage,
      // );
    }
  }

  static postDetailsToFirestore(BuildContext context, fullName, email,
      mobileNumber, password, imageFile) async {

    final _auth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    LoadingProvider _loadingProvider =
        Provider.of<LoadingProvider>(context, listen: false);

    var image = await FirebaseServices.imageUpload(imageFile, email);
    UserProvider _userProvider = Provider.of<UserProvider>(context, listen: false);

    await firebaseFirestore.collection("users").doc(user!.uid).set({
      'uid': user.uid,
      'email': email,
      'fullName': fullName,
      'password': password,
      'mobileNumber': '0$mobileNumber',
      'image': image,
    }).then((value) {

      _userProvider.uid = user.uid.toString();
      // _userProvider.email = email.toString();
      // _userProvider.password = password.toString();
      // _userProvider.fullName = fullName.toString();
      // _userProvider.phoneNumber = '0$mobileNumber';
      // _userProvider.image = image.toString();

      AppRoutes.push(context, HomePage());
      ToastUtils.showSuccessToast(
          context, "Success", "Account Created Successfully!!");
    }).catchError((e) {

    });
    _loadingProvider.setLoading(false);

    // AppRoutes.push(
    //     context,
    //     const LoginPage(
    //       name: "Trader",
    //     ));

    // MyMotionToast.success(
    //   context,
    //   "Success",
    //   'Account created successfully :) ',
    // );
  }

  // LogOut--------------------------------------

  static logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    userLoggedIn(false);
    AppRoutes.replace(context, Intro());
  }

  // user Logged
  static userLoggedIn(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('userLoggedIn', value);
  }

// get user LoggedIn value
  static getUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? boolValue = prefs.getBool('userLoggedIn');
    return boolValue;
  }

  // Farmer Logged
  static farmerLoggedIn(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('farmerLoggedIn', value);
  }

// get Farmer LoggedIn value
  static getFarmerLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? boolValue = prefs.getBool('farmerLoggedIn');
    return boolValue;
  }

// save FarmerId
  static saveFarmerID(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.setString('farmerID', value);
  }

  // get Farmer LoggedIn value
  static getFarmerID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('farmerID');
    return value;
  }

  static saveUniqueFarmerID(String farmerValue) async {
    SharedPreferences prefsValue = await SharedPreferences.getInstance();
    prefsValue.setString('uniqueFarmerID', farmerValue.toString());
  }

  static getUniqueFarmerID() async {
    SharedPreferences prefsValue = await SharedPreferences.getInstance();
    String? farmerValue = prefsValue.getString('uniqueFarmerID');
    return farmerValue;
  }

  static clearSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // save TraderId
  static saveTraderID(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('traderID', value);
  }

  // get Farmer LoggedIn value
  static getTraderID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('traderID');
    return value;
  }
}
