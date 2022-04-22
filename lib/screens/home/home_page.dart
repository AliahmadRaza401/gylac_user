// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gyalcuser_project/screens/delivery_form/create_delivery_form.dart';
import 'package:gyalcuser_project/utils/app_route.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../providers/create_delivery_provider.dart';
import '../../providers/userProvider.dart';
import '../../utils/image.dart';
import '../../widgets/App_Menu.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/gradient_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late UserProvider _userProvider;
  late CreateDeliveryProvider deliveryProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    deliveryProvider =
        Provider.of<CreateDeliveryProvider>(context, listen: false);
    getData();
  }

  getData() async {
    String uid = _auth.currentUser!.uid;
    await _firestore.collection('users').doc(uid).get().then((value) {
      setState(() {
        _userProvider.email = value.data()!["email"].toString();
        _userProvider.fullName = value.data()!["fullName"].toString();
        _userProvider.phoneNumber = '0${value.data()!["mobileNumber"]}';
        _userProvider.image = value.data()!["image"].toString();
        _userProvider.address = value.data()!["address"].toString();
      });
    });
    getCount();
  }

  getCount() async {
    int count = await FirebaseFirestore.instance
        .collection('drivers')
        .get()
        .then((value) => value.size);
    setState(() {
      deliveryProvider.driverLength = count;
    });
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 210,
        backgroundColor: Colors.transparent,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            width: media.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: Image.asset(
                          menuimage,
                          width: 30,
                          height: 30,
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        AppRoutes.push(context, const CreateDeliveryForm());
                      },
                      child: Container(
                        width: media.width * 0.55,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: orange, width: 1),
                          boxShadow: const [
                            BoxShadow(
                                color: stroke,
                                offset: Offset(2, 6),
                                blurRadius: 8)
                          ],
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child:  SizedBox(
                                width: 150,
                                child: GradientText(
                                  'SCHEDULE A NEW \n DELIVERY'.tr,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold),
                                  gradient: LinearGradient(
                                    colors: [
                                      orangeDark,
                                      redOrange,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/images/clock.png',
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      drawer: AppMenu(),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: media.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: media.height * 0.68,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                "assets/images/food.png",
                                height: media.height * 0.12,
                              ),
                              Image.asset(
                                "assets/images/bags.png",
                                height: media.height * 0.12,
                              ),
                              Image.asset(
                                "assets/images/people.png",
                                height: media.height * 0.12,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: media.width * 0.5,
                                child: CustomBtn(
                                  text: "POPULAR DELIVERIES".tr,
                                  onTap: () {
                                
                                    
                                  },
                                  bgColor: orange,
                                  size: 15,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance.collection("topRated").limit(15).snapshots(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.data == null) {
                              return const Center(child: CircularProgressIndicator(color: orange));
                            }

                            else {
                              final List<QueryDocumentSnapshot<Map<String, dynamic>>> orders = snapshot.data!.docs;

                              return orders.isNotEmpty? GridView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      childAspectRatio: 2 / 2,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 10),
                                  itemCount: orders.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: stroke, width: 1),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: const Offset(2, 3),
                                                blurRadius: 5,
                                                color: black.withOpacity(0.25))
                                          ],
                                          borderRadius: BorderRadius.circular(10),
                                          color: white,
                                        ),
                                        child:Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Column(
                                            children: [

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("${orders[index]["pickupParcelName"]} PACKAGE",style:  const TextStyle(fontFamily: 'Roboto',fontSize: 8,fontWeight: FontWeight.bold)),
                                                  Row(
                                                    children: [
                                                      orders[index]["driverImage"].isNotEmpty
                                                          ? SizedBox(
                                                        width:20,
                                                        height:20,
                                                        child: Image.network(
                                                          orders[index]["driverImage"],
                                                          fit: BoxFit.fitHeight,
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
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(orders[index]["driverName"],style:  const TextStyle(fontFamily: 'Roboto',fontSize: 10,fontWeight: FontWeight.bold)),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                color: white,
                                                                boxShadow:const [
                                                                  BoxShadow(
                                                                    color: dimOrange,
                                                                    blurRadius: 5,
                                                                    offset: Offset(0, 0), // changes position of shadow
                                                                  ),
                                                                ],
                                                                borderRadius: BorderRadius.circular(4)
                                                            ),
                                                            padding: const EdgeInsets.all(2),
                                                            child: Row(

                                                              children: [
                                                                Image.asset("assets/images/badge.png",width: 10,height: 10,),
                                                                const Text("Top High Rated",style:  TextStyle(color: redColor,fontFamily: 'Poppins',fontSize: 6,fontWeight: FontWeight.bold))
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(orders[index]["parcel"],style:  const TextStyle(fontFamily: 'Roboto',fontSize: 7,fontWeight: FontWeight.bold)),
                                                  SizedBox(
                                                    width: 80,
                                                    height: 20,
                                                    child: RatingBar.builder(
                                                      initialRating: double.parse(orders[index]["rating"]),
                                                      itemSize: 10,
                                                      minRating: 1,
                                                      direction: Axis.horizontal,
                                                      itemCount: 5,
                                                      itemPadding:const EdgeInsets.symmetric(horizontal: 2.0),
                                                      itemBuilder: (context, _) => const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate: (rating) {

                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    width:100,
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: black, width: 1),
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: white,
                                                    ),
                                                    child: Image.asset("assets/images/bike.png"),
                                                  ),
                                                  Column(
                                                    children: [
                                                      GradientText(
                                                       "\$ " +orders[index]["pickupDeliveryPrice"],
                                                        style: TextStyle(
                                                            decoration: TextDecoration.underline,
                                                            fontSize: 10,
                                                            fontFamily: 'Poppins',
                                                            fontWeight: FontWeight.bold),
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            Color(0xFF7C6414),
                                                            Color(0xFFFFC961),
                                                          ],
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                        ),
                                                      ),
                                                      Column(
                                                        children: [
                                                          orders[index]["vehicle"] == "VAN"?Image.asset(vanimage,width: 50,height: 50,):
                                                          orders[index]["vehicle"] == "CAR"?Image.asset(carimage,width: 50,height: 50,):
                                                          orders[index]["vehicle"] == "SCOOTER"?Image.asset(scooterimage,width: 50,height: 50,):
                                                          orders[index]["vehicle"] == "TRUCK"?Image.asset(truckimage,width: 50,height: 50,):
                                                          orders[index]["vehicle"] == "BIKE"?Image.asset(cycleimage,width: 50,height: 50,):
                                                          orders[index]["vehicle"] == "MINI TRUCK"?Image.asset(miniTruckimage,width: 50,height: 50,):
                                                          Image.asset("assets/images/Group 8504.png",width: 50,height: 50,),
                                                          GradientText(
                                                            orders[index]["vehicle"],
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                fontFamily: 'Poppins',
                                                                fontWeight: FontWeight.bold),
                                                            gradient: LinearGradient(
                                                              colors: [
                                                                Color(0xFF7C6414),
                                                                Color(0xFFFFC961),
                                                              ],
                                                              begin: Alignment.topCenter,
                                                              end: Alignment.bottomCenter,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                    );
                                  }):  Column(
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
                                      Icons.message,
                                      color: Colors.white.withOpacity(.6),
                                      size: 40,
                                    ),
                                  ),
                                  const Align(
                                    child: Padding(
                                      padding:  EdgeInsets.all(15),
                                      child: Text("No Popular Deliveries Found",
                                        textAlign: TextAlign.center,
                                        style:
                                        TextStyle(fontSize: 16,fontFamily: 'Poppins', color: Colors.black,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),

                        const SizedBox(
                          height: 20,
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
    );
  }
}
