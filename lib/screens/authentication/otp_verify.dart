import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gyalcuser_project/constants/colors.dart';
import 'package:gyalcuser_project/constants/toast_utils.dart';
import 'package:gyalcuser_project/providers/loading_provider.dart';
import 'package:gyalcuser_project/screens/authentication/auth_services.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_btn.dart';

/// For more examples check out the demo directory
class OtpVerify extends StatefulWidget {
  String emailCtl;
  String passwordCtl;
  String nameCtl;

  String mobileNumber;
  var image;

  OtpVerify(
      {required this.mobileNumber,
      required this.passwordCtl,
      required this.image,
      required this.emailCtl,
      required this.nameCtl});

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool loading = Provider.of<LoadingProvider>(context).loading;

    const focusedBorderColor = orange;
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = orange;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    /// Optionally you can use form to validate the Pinput
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Form(
            key: formKey,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/images/Frame 32.png"),
                  Column(
                    children: [
                      Text("Verification",
                          style: TextStyle(
                              color: orange,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 25)),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.04),
                            child: Text('Enter the code send to the number',
                                style: TextStyle(
                                    color: orange,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Directionality(
                    // Specify direction if desired
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      length: 6,
                      controller: pinController,
                      focusNode: focusNode,
                      androidSmsAutofillMethod:
                          AndroidSmsAutofillMethod.smsUserConsentApi,
                      listenForMultipleSmsOnAndroid: true,
                      defaultPinTheme: defaultPinTheme,
                      // validator: (value) {
                      //   return value == '2222' ? null : 'Pin is incorrect';
                      // },
                      // onClipboardFound: (value) {
                      //   debugPrint('onClipboardFound: $value');
                      //   pinController.setText(value);
                      // },
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) {
                        debugPrint('onCompleted: $pin');
                        setState(() {
                          pinCode = pin;
                        });
                      },
                      onChanged: (value) {
                        debugPrint('onChanged: $value');
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 9),
                            width: 22,
                            height: 1,
                            color: focusedBorderColor,
                          ),
                        ],
                      ),
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: focusedBorderColor),
                        ),
                      ),
                      submittedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          color: fillColor,
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(color: focusedBorderColor),
                        ),
                      ),
                      errorPinTheme: defaultPinTheme.copyBorderWith(
                        border: Border.all(color: Colors.redAccent),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        loading
                            ? CircularProgressIndicator()
                            : CustomBtn(
                                text: "Verify",
                                onTap: () {
                                  FirebaseAuth auth = FirebaseAuth.instance;

                                  PhoneAuthCredential _credential =
                                      PhoneAuthProvider.credential(
                                    verificationId: verificationID,
                                    smsCode: pinCode,
                                  );
                                  auth
                                      .signInWithCredential(_credential)
                                      .then((result) {
                                    AuthServices.signUp(
                                        context,
                                        widget.emailCtl,
                                        widget.passwordCtl,
                                        widget.nameCtl,
                                        widget.mobileNumber,
                                        widget.image);
                                  }).catchError((e) {
                                    print(e);
                                  });
                                },
                                bgColor: orange,
                                shadowColor: black,
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    _signInWithMobileNumber();
  }

  String verificationID = '';
  String pinCode = '';
  _signInWithMobileNumber() async {
    UserCredential _credential;
    //var valid = _formKey.currentState.validate();
    User user;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    debugPrint('widget.mobileNumber_______________: ${widget.mobileNumber}');
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: widget.mobileNumber,
        verificationCompleted: (PhoneAuthCredential authCredential) async {},
        verificationFailed: ((error) {
          print(error);
          ToastUtils.showErrorToast(context, "Error".tr, error.toString());
        }),
        codeSent: (String verificationId, [int? forceResendingToken]) {
          setState(() {
            verificationID = verificationId;
          });
          //show dialog to take input from the user
          // showDialog(
          //   context: context,
          //   barrierDismissible: false,
          //   builder: (context) => AlertDialog(
          //     title: Text("Enter OTP"),
          //     content: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: <Widget>[
          //         TextField(
          //           controller: _codeController,
          //         ),
          //       ],
          //     ),
          //     actions: <Widget>[
          //       ElevatedButton(
          //         child: Text("Done"),
          //         onPressed: () {
          // FirebaseAuth auth = FirebaseAuth.instance;
          // smsCode = _codeController.text.trim();
          // PhoneAuthCredential _credential =
          //     PhoneAuthProvider.credential(
          //   verificationId: verificationId,
          //   smsCode: smsCode,
          // );
          // auth.signInWithCredential(_credential).then((result) {
          //   Navigator.of(context).pop();
          // }).catchError((e) {
          //   print(e);
          // });
          //         },
          //       ),
          //     ],
          //   ),
          // );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print('AUTORETRIVAL SECTION');
          print(verificationId);
          print("Timout");
          ToastUtils.showErrorToast(
              context, "Error".tr, "An undefined Error happened".tr);
        },
      );
    } catch (e) {}
  }
}
