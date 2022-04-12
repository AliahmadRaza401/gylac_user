import 'package:flutter/material.dart';
import 'package:gyalcuser_project/constants/toast_utils.dart';
import 'package:gyalcuser_project/screens/authentication/auth_services.dart';
import 'package:gyalcuser_project/utils/app_route.dart';
import 'package:gyalcuser_project/widgets/custom_btn.dart';
import 'package:gyalcuser_project/widgets/custom_textfield.dart';
import 'package:gyalcuser_project/widgets/top_curve.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_style.dart';
import '../../../providers/loading_provider.dart';
import '../SignUp/signUp.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool loading = Provider.of<LoadingProvider>(context).loading;

    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              curveTop(context),
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                ),
                // color: Colors.black,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.05,
                              ),
                              child: const Text("Customer Login",
                                  style: TextStyle(
                                      color: orange,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.width * 0.04),
                              child: const Text("Please Login to continue",
                                  style: TextStyle(
                                      color: orange,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:const [
                            Text("Email",
                                style: TextStyle(
                                    color: orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: 'Poppins')),
                          ],
                        ),
                        CustomTextField(
                          hint: "Your email",
                          prefixIcon:const Icon(
                            Icons.email,
                            color: lightGrey,
                          ),
                          controller: emailCtl,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:const [
                              Text("Password",
                                style: TextStyle(
                                    color: orange,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ],
                        ),
                        CustomTextField(
                          hint: "Type a password",
                          prefixIcon:const Icon(
                            Icons.lock_outline,
                            color: lightGrey,
                          ),
                          controller: passwordCtl,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: Text(
                                'Forgot Password?',
                                style: MyTextStyle.poppins().copyWith(
                                  color: orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: ()  {
                              if (emailCtl.text.isEmpty) {
                                ToastUtils.showWarningToast(context, "Required", "Email is required");
                                  }
                              else if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailCtl.text) == false){
                                ToastUtils.showWarningToast(context, "Error", "Enter a valid email!");
                              }
                              else if (passwordCtl.text.isEmpty) {
                                ToastUtils.showWarningToast(context, "Required", "Password is required");
                              }
                              else if (passwordCtl.text.length < 6) {
                                ToastUtils.showWarningToast(context, "Error", "Password should be at least six digits.");
                              }
                              else{
                                AuthServices.signIn(context, emailCtl.text, passwordCtl.text);
                              }

                              },
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              loading
                                  ?const CircularProgressIndicator()
                                  : CustomBtn(
                                      text: "LOGIN",
                                      onTap: () {
                                        if (emailCtl.text.isEmpty) {
                                          ToastUtils.showWarningToast(context, "Required", "Email is required");
                                        }
                                        else if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailCtl.text) == false){
                                          ToastUtils.showWarningToast(context, "Error", "Enter a valid email!");
                                        }
                                        else if (passwordCtl.text.isEmpty) {
                                          ToastUtils.showWarningToast(context, "Required", "Password is required");
                                        }
                                        else if (passwordCtl.text.length < 6) {
                                          ToastUtils.showWarningToast(context, "Error", "Password should be at least six digits.");
                                        }
                                        else{
                                          AuthServices.signIn(context, emailCtl.text, passwordCtl.text);
                                        }

                                      },
                                      bgColor: orange,
                                      shadowColor: black,
                                    ),
                              const SizedBox(
                                height: 15.0,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            AppRoutes.push(context, const SignUp());
                          },
                          child: SizedBox(
                            // color: Colors.green,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Do not Have an Account? ",
                                  style: MyTextStyle.poppins(),
                                ),
                                const Text(
                                  " SIGNUP",
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
