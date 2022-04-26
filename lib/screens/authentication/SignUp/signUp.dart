// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gyalcuser_project/constants/colors.dart';
import 'package:gyalcuser_project/providers/loading_provider.dart';
import 'package:gyalcuser_project/screens/authentication/Login/login.dart';
import 'package:gyalcuser_project/screens/authentication/auth_services.dart';
import 'package:gyalcuser_project/services/image_piker.dart';
import 'package:gyalcuser_project/widgets/custom_btn.dart';
import 'package:gyalcuser_project/widgets/custom_textfield.dart';
import 'package:gyalcuser_project/widgets/top_curve.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

import '../../../constants/text_style.dart';
import '../../../constants/toast_utils.dart';
import '../../../utils/app_route.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  TextEditingController nameCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();

  File? _image;
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    bool loading = Provider.of<LoadingProvider>(context).loading;
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/Frame 32.png"),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Signup".tr,
                                style: TextStyle(
                                    color: orange,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25)),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.04),
                              child: Text("Please signup to continue".tr,
                                  style: TextStyle(
                                      color: orange,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            openFilePicker();
                          },
                          child: Row(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.12,
                                    width: MediaQuery.of(context).size.width *
                                        0.27,
                                    decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(25),
                                        color: orange,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.9),
                                            blurRadius: 7,
                                            offset: const Offset(0, 6),
                                          ),
                                        ]),
                                  ),
                                  _image != null
                                      ? Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.12,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.27,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            image: DecorationImage(
                                              image: FileImage(_image!),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          child:
                                              null /* add child content here */,
                                        )
                                      // ClipOval(
                                      //     child: Image.file(
                                      //       _image!,
                                      //       fit: BoxFit.fill,
                                      //       height: MediaQuery.of(context)
                                      //               .size
                                      //               .height *
                                      //           0.12,
                                      //       width: MediaQuery.of(context)
                                      //               .size
                                      //               .width *
                                      //           0.25,
                                      //     ),
                                      //   )
                                      : Image.asset(
                                          "assets/images/Camera.png",
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.12,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.17,
                                        )
                                ],
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.035,
                              ),
                              Text("Add Profile Picture".tr,
                                  style: TextStyle(
                                      color: orange,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Full Name".tr,
                                style: TextStyle(
                                    color: orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: 'Poppins')),
                          ],
                        ),
                        CustomTextField(
                          hint: "Your name".tr,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset("assets/images/Profile.png"),
                          ),
                          controller: nameCtl,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Email".tr,
                                style: TextStyle(
                                    color: orange,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ],
                        ),
                        CustomTextField(
                          hint: "Your email".tr,
                          prefixIcon: Icon(
                            Icons.email,
                            color: lightGrey,
                          ),
                          controller: emailCtl,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Create Password".tr,
                                style: TextStyle(
                                    color: orange,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ],
                        ),
                        CustomTextField(
                          hint: "Type a strong password".tr,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: lightGrey,
                          ),
                          controller: passwordCtl,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Phone Number".tr,
                                style: TextStyle(
                                    color: orange,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ],
                        ),
                        CustomTextField(
                          hint: "XXX-XXX-XXXX",
                          text: TextInputType.number,
                          prefixIcon: Icon(
                            Icons.phone,
                            color: lightGrey,
                          ),
                          controller: phoneCtl,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20.0,
                              ),
                              loading
                                  ? CircularProgressIndicator()
                                  : CustomBtn(
                                      text: "SIGN UP".tr,
                                      onTap: () {
                                        if (_image == null) {
                                          ToastUtils.showWarningToast(
                                              context,
                                              "Required",
                                              "Profile Picture is required");
                                        } else if (nameCtl.text.isEmpty) {
                                          ToastUtils.showWarningToast(
                                              context,
                                              "Required",
                                              "Full Name is required");
                                        } else if (emailCtl.text.isEmpty) {
                                          ToastUtils.showWarningToast(context,
                                              "Required", "Email is required");
                                        } else if (RegExp(
                                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(emailCtl.text) ==
                                            false) {
                                          ToastUtils.showWarningToast(context,
                                              "Error", "Enter a valid email!");
                                        } else if (passwordCtl.text.isEmpty) {
                                          ToastUtils.showWarningToast(
                                              context,
                                              "Required",
                                              "Password is required");
                                        } else if (passwordCtl.text.length <
                                            6) {
                                          ToastUtils.showWarningToast(
                                              context,
                                              "Error",
                                              "Password should be at least six digits.");
                                        } else if (phoneCtl.text.isEmpty) {
                                          ToastUtils.showWarningToast(
                                              context,
                                              "Error",
                                              "Phone number is required");
                                        } else {
                                          AuthServices.signUp(
                                              context,
                                              emailCtl.text,
                                              passwordCtl.text,
                                              nameCtl.text,
                                              phoneCtl.text,
                                              _image);
                                        }
                                      },
                                      bgColor: orange,
                                      shadowColor: black,
                                    ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  AppRoutes.replace(context, const Login());
                                },
                                child: SizedBox(
                                  // color: Colors.green,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already Have an Account? ".tr,
                                        style: MyTextStyle.poppins(),
                                      ),
                                      Text(
                                        " LOGIN".tr,
                                        style: TextStyle(
                                          color: orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openFilePicker() async {
    print("File Picker");
    var image = await pickImageFromGalleryOrCamera(context);
    if (image == null) return;

    // setState(() => _image = image);
    cropImage(image);
  }

  /// Crop Image
  cropImage(filePath) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      setState(() {
        _image = croppedFile;
      });
    }
  }
}
