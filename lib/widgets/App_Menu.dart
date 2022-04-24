import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gyalcuser_project/screens/authentication/Login/login.dart';
import 'package:gyalcuser_project/screens/orderHistory/orderHistory_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/colors.dart';
import '../providers/userProvider.dart';
import '../screens/HelpAndSupport.dart';
import '../screens/home/home_page.dart';
import '../screens/myOrders.dart';
import '../screens/notifications.dart';
import '../screens/profile/profileScreen.dart';
import 'custom_text.dart';
import 'package:get/get.dart';

class AppMenu extends StatefulWidget{

  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
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
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width*0.75,
      child: ListView(
            children: [
              Container(
                  color: orange,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0, left: 10,bottom: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap:(){
                            Navigator.of(context).pop();
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>ProfileScreen()),);},
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child:Container(
                                height:
                                MediaQuery.of(context).size.height * 0.12,
                                width:
                                MediaQuery.of(context).size.width * 0.27,

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: orangeDark,width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.9),
                                      blurRadius: 7,
                                      offset: const Offset(0, 6),
                                    ),
                                  ]
                              ),
                              child: userProvider.image.isNotEmpty
                                  ? ClipOval(
                                    child: Image.network(
                                      userProvider.image,
                                      fit: BoxFit.fill,
                                      errorBuilder: (context, object, stackTrace) {
                                        return const Icon(
                                          Icons.account_circle,
                                          size: 90,
                                          color: white,
                                        );
                                      },
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return SizedBox(
                                          width: 90,
                                          height: 90,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: white,
                                              value: loadingProgress.expectedTotalBytes != null &&
                                                  loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                  :const Icon(
                                Icons.account_circle,
                                size: 90,
                                color: white,
                              )

                            ),


                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userProvider.fullName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle( fontSize: 15, fontFamily: 'Poppins',fontWeight: FontWeight.bold),
                              ),
                              Text(
                                userProvider.email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),

              ListTile(
                leading: Icon(
                  Icons.home,
                  color: Color.fromRGBO(251, 176, 59, 1),
                ),
                title: CustomText(text: "Home".tr),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
              ListTile(
                leading: Icon(
                  FontAwesomeIcons.clipboardList,
                  color: Color.fromRGBO(251, 176, 59, 1),
                ),
                title: CustomText(text:  "My Orders".tr),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => MyOrders()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.history,
                  color: Color.fromRGBO(251, 176, 59, 1),
                ),
                title: CustomText(text: "Order History".tr),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => orderHistory()));
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.notifications,
                  color: Color.fromRGBO(251, 176, 59, 1),
                ),
                title: CustomText(text: "Notifications".tr),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Notifications()));
                },
              ),
              ListTile(
                leading: Icon(
                  FontAwesomeIcons.gear,
                  color: Color.fromRGBO(251, 176, 59, 1),
                ),
                title: CustomText(text:"Help & Support".tr),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => HelpAndSupport()));
                },
              ),
              Container(
                // height: MediaQuery.of(context).size.height * 0.07,
                // color: Colors.green,
                width: MediaQuery.of(context).size.width,
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.globe,
                        color: Color.fromRGBO(251, 176, 59, 1),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.08,
                      ),
                      CustomText(text:"Language".tr)
                    ],
                  ),
                  children: <Widget>[
                    ListTile(
                      onTap: () async {
                        Get.updateLocale(Locale('en', 'US'));
                        Navigator.of(context).pop();
                      },
                      title:  Text(
                        'English'.tr,
                        style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w700),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Get.updateLocale(Locale('mn', 'MN'));
                        Navigator.of(context).pop();
                      },
                      title:  Text(
                        'Mongolian'.tr,
                        style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),

              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Color.fromRGBO(251, 176, 59, 1),
                ),
                title: CustomText(text: "Logout".tr),
                onTap: () {
                  showAlertDialog(context);

                },
              )
            ],
          ),
    );
  }

  showAlertDialog(BuildContext context) {

    Widget okButton = FlatButton(
      child: Text("Ok".tr),
      onPressed: () {
        handleSignOut();
      },
    );

    Widget noButton = FlatButton(
      child: Text("Cancel".tr),
      onPressed: () {
        Navigator.of(context).pop();

      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      //title: Text("Simple Alert"),
      content: Text("Do you want to Logout?".tr),
      actions: [okButton, noButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}