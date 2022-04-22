import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../providers/userProvider.dart';
import '../utils/image.dart';
import '../widgets/App_Menu.dart';
import '../widgets/notificationTile.dart';

class Notifications extends StatefulWidget {
  Notifications({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  var scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        backgroundColor: Colors.grey[200],
          appBar: AppBar(
            leading: Builder(
              builder:(context)=>IconButton(
                icon: Image.asset(menuimage,width: 30,height: 30,),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            backgroundColor:orange,
            elevation: 5,
            shadowColor: blackLight,
            title: Text('Notifications'.tr, style: TextStyle(
                color: white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily: 'Roboto')),
          ),
          drawer: AppMenu(),
        body: Container(
          color: Colors.white,
          
          alignment: Alignment.center,
          child:StreamBuilder(
    stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("notifications").orderBy("timestamp", descending: true).snapshots(),
    builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
     if (!snapshot.hasData) {
        return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );           
      }else if(snapshot.hasData){
        List<dynamic> orders=snapshot.data!.docs;
        if(orders.isNotEmpty){
    return Scaffold(
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
           return NotificationTile(
         title:orders[index]["title"],
         msg:orders[index]["msg"].toString(),
         time:DateFormat.jm().format(orders[index]["timestamp"].toDate()).toString(),
        status: orders[index]["status"].toString(),
        );
        }));
        }
        else{
         return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 150,
                          width: 150,
                          decoration:const BoxDecoration(
                            color: Color.fromRGBO(251, 176, 59,1),
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                          ),
                          child: Icon(
                            Icons.notifications_active_rounded,
                            color: Colors.white.withOpacity(.6),
                            size: 40,
                          ),
                        ),
                         Align(
                          child: Padding(
                            padding:  EdgeInsets.all(15),
                            child: Text( "No Notifications Found".tr,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16,fontFamily: 'Poppins', color: Colors.black,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    );
        }
        
        }else{
            return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 150,
                          width: 150,
                          decoration:const BoxDecoration(
                            color: Color.fromRGBO(251, 176, 59,1),
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                          ),
                          child: Icon(
                            Icons.notifications_active_rounded,
                            color: Colors.white.withOpacity(.6),
                            size: 40,
                          ),
                        ),
                         Align(
                          child: Padding(
                            padding:  EdgeInsets.all(15),
                            child: Text( "No Notifications Found".tr,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    );
        }}),

          
          )
        
        
        )
    );
}

}







