
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gyalcuser_project/constants/colors.dart';
import 'package:gyalcuser_project/screens/authentication/Login/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/userProvider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/custom_textfield.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController address = TextEditingController();

  File? avatarImageFile;

  Future<void> handleSignOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("userId", "null");
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Login()),
          (Route<dynamic> route) => false,
    );
    Fluttertoast.showToast(msg: "Logged Out Successfully");
  }



  @override
  Widget build(BuildContext context) {
  //  AppStateProvider appState = Provider.of<AppStateProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    fullName.text = userProvider.fullName;
    email.text = userProvider.email;
    phoneNo.text = userProvider.phoneNumber;
    address.text =  userProvider.address.toString() =="null"?"Add Address":userProvider.address;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon:const Icon(
            FontAwesomeIcons.reply,
            color: white,
          ),
        ),
        elevation: 5,
        shadowColor: blackLight,
        title:const Text('Profile', style: TextStyle(
            color: white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Roboto')),
        backgroundColor:orange,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top:10.0,bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    bottom: 16.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: orange,width: 2),
                  ),
                  child: avatarImageFile == null
                      ? userProvider.image.isNotEmpty
                      ? Image.network(
                        userProvider.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, object, stackTrace) {
                          return Icon(
                            Icons.account_circle,
                            size: 90,
                            color: orange,
                          );
                        },
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            width: 90,
                            height: 90,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: orange,
                                value: loadingProgress.expectedTotalBytes != null &&
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      )
                      : Icon(
                    Icons.account_circle,
                    size: 90,
                    color: orange,
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(45),
                    child: Image.file(
                      avatarImageFile!,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/Pencil Drawing.png",
                    width: 25,height: 25,
                    ),
                    const Text("EDIT PROFILE",style: TextStyle(decoration: TextDecoration.underline,
                        fontFamily: "Roboto",fontWeight: FontWeight.bold,color: orange,fontSize: 15),)
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0,right: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),

                boxShadow: [
                  BoxShadow(
                    color: AppColors.orangeColor.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 4,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child:Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:const [
                        Text("Full Name",
                            style: TextStyle(
                                color: orangeDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: 'Poppins')),
                      ],
                    ),
                    CustomTextField(
                      hint: "Full Name",
                      prefixIcon:const Icon(
                        FontAwesomeIcons.user,
                        color: lightGrey,
                      ),
                      controller: fullName,
                    ),
                    const  SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:const [
                        Text("Email",
                            style: TextStyle(
                                color: orangeDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: 'Poppins')),
                      ],
                    ),
                    CustomTextField(
                      hint: "Email",
                      prefixIcon:const Icon(
                        FontAwesomeIcons.envelope,
                        color: lightGrey,
                      ),
                      controller: email,
                    ),
                    const  SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:const [
                        Text("Phone Number",
                            style: TextStyle(
                                color: orangeDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: 'Poppins')),
                      ],
                    ),
                    CustomTextField(
                      hint: "Phone Number",
                      prefixIcon:const Icon(
                        FontAwesomeIcons.phone,
                        color: lightGrey,
                      ),
                      controller: phoneNo,
                    ),
                    const  SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:const [
                            Text("Address",
                                style: TextStyle(
                                    color: orangeDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    fontFamily: 'Poppins')),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: textFieldStroke, width: 1),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(2, 2),
                                  color: black.withOpacity(0.25),
                                  blurRadius: 5)
                            ],
                          ),
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: TextFormField(
                            // minLines: 2,
                              maxLines: 10,
                              keyboardType: TextInputType.multiline,
                              controller: address,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.left,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'required';
                                }
                                return null;
                              },
                              style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.05,
                                  // HERE THE IMPORTANT PART
                                  left: 10,
                                ),

                                labelStyle: const TextStyle(),
                                border:const OutlineInputBorder(
                                  borderSide: BorderSide(color: white),
                                ),
                                focusedBorder:const OutlineInputBorder(
                                  borderSide: BorderSide(color: white),
                                ),
                                enabledBorder:const OutlineInputBorder(
                                  borderSide: BorderSide(color: white),
                                ),
                                // labelText:"Your Name"
                              )),
                        ),
                      ],
                    ),
                    const  SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.0, left: 80.0, right: 80.0),
            child: CustomBtn(
                text: "LOGOUT",
                bgColor: orange,
                onTap: () {
                  handleSignOut();
                }),
          ),
        ],
      ),
    );
  }
}

