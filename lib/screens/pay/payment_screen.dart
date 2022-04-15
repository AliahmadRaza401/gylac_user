import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math'as math;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gyalcuser_project/utils/innerShahdow.dart';
import 'package:gyalcuser_project/widgets/custom_btn.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../providers/create_delivery_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/image.dart';
import '../../widgets/inputField.dart';
import '../orderDetails/orderDetails.dart';

class PaymentScreen extends StatefulWidget {
  String orderId;
   PaymentScreen({Key? key,required this.orderId}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  late CreateDeliveryProvider deliveryProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deliveryProvider = Provider.of<CreateDeliveryProvider>(context, listen: false);
    getDriverData();
  }

  getDriverData() async{
    firebaseFirestore
        .collection("drivers")
        .doc(deliveryProvider.driverId).get().then((value){
      if(mounted) {
        setState(() {
          deliveryProvider.driverName = value.data()!["fullName"].toString();
          deliveryProvider.driverImage = value.data()!["dp"].toString();
          deliveryProvider.driverLat = value.data()!["latitude"];
          deliveryProvider.driverLong = value.data()!["longitude"];
          deliveryProvider.driverMobile = value.data()!["mobileNumber"].toString();
        });
      }
    });
  }

  bool isLoading = false;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future updateId() async{
    var rnd =  math.Random();
    var next = rnd.nextDouble() * 10000000;
    while (next < 1000000) {
      next *= 100;
    }

    firebaseFirestore
        .collection("orders")
        .doc(widget.orderId)
        .update({
        "tracking":next.toInt().toString(),
        }).then((data) async {
      firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("notifications")
          .doc(widget.orderId)
          .set({
        "msg": "Order ${widget.orderId} payment done successfully. Your Tracking ID is ${next.toInt().toString()}",
        "status": "paymentDone",
        "timestamp": FieldValue.serverTimestamp(),
        "title": "Order Payment Done",
      }).then((data) async {
        firebaseFirestore
            .collection("orders")
            .doc(widget.orderId).update({"trackStatus":"WaitForPickup"});
        firebaseFirestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("orders")
            .doc(widget.orderId)
            .update({
          "driverName": deliveryProvider.driverName,
          "driverImage": deliveryProvider.driverImage,
          "driverPhone": deliveryProvider.driverMobile,
        });
        setState(() {
          isLoading = false;
        });

        showDialog(
            barrierColor: orange.withOpacity(0.2),
            context: context,
            builder: (BuildContext context) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 10,
                  insetPadding: const EdgeInsets.all(25),
                  backgroundColor: white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/Component 17.png"),
                      Image.asset("assets/images/Correct_sign_1_freepik 4.png",width: 100,height: 100,),
                      SizedBox(height: 20,),
                      Text("Order Complete",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,fontFamily: 'Poppins',color: orange),),
                      SizedBox(height: 50,),
                      Text("Your Tracking ID",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,fontFamily: 'Poppins',color: orange),),
                      CustomBtn(
                        shadowColor: black,
                        size: 15,
                        bgColor: orange,
                        text: "#${next.toInt().toString()}",
                        onTap: (){},
                      ),
                      SizedBox(height: 30,),
                    ],
                  ),
                ),
              );
            });
        Future.delayed(Duration(seconds: 2), () {

          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderDetails())
          );
        });

      }).catchError((err) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });


    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });

  }

  var scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldState,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: Icon(FontAwesomeIcons.grip,color: white,),
        backgroundColor:orange,
        elevation: 5,
        shadowColor: blackLight,
        title:const Text('ORDER SUMMARY', style: TextStyle(
            color: white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Roboto')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 2,
                      offset: const Offset(
                          0, 5), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.all(
                       Radius.circular(20.0)),
                  border: Border.all(
                      color: const Color(0xfff1d5a9))),
              padding: const EdgeInsets.only(left: 10,right: 10,),
              child: ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      pickPhoneimage,
                      height: 50,
                      width: 50,
                    ),
                    const Text(
                      'PICK-UP DETAILS',
                      style:  TextStyle(
                        fontFamily: 'Roboto',
                          color: black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                trailing:const Icon(
                 FontAwesomeIcons.chevronDown,
                  color: AppColors.primaryColor,
                ),
                children: <Widget>[
                  Container(
                      width:MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(28),bottomLeft: Radius.circular(28)),
                        color: white,
                      ),
                      child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            AbsorbPointer(
                              child: inputField(context, "Address", "Select Pickup Address",
                                  deliveryProvider.pickAddress,TextInputType.text,Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image.asset("assets/images/Pin 3 (1).png"),
                                  )),
                            ),
                            const  SizedBox(
                              height: 10,
                            ),

                            AbsorbPointer(
                              child: inputField(
                                  context,
                                  "Name",
                                  "Enter Name",
                                  deliveryProvider.pickName,
                                  TextInputType.text,null
                              ),
                            ),
                            const  SizedBox(
                              height: 10,
                            ),
                            AbsorbPointer(
                              child: inputField(
                                  context,
                                  "Phone Number",
                                  "Enter Phone Number",
                                  deliveryProvider.pickPhone,
                                  TextInputType.number,null
                              ),
                            ),
                            const  SizedBox(
                              height: 10,
                            ),
                            AbsorbPointer(
                              child: inputField(context, "Email", "Enter Email",
                                  deliveryProvider.pickEmail,
                                  TextInputType.emailAddress,null),
                            ),
                            const  SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: media.width * 0.37,
                                  child: AbsorbPointer(
                                    child: inputField(context, "Parcel Name", "",
                                        deliveryProvider.pickParcelName,TextInputType.text,null),
                                  ),
                                ),
                                Container(
                                  width: media.width * 0.37,
                                  child: AbsorbPointer(
                                    child: inputField(
                                        context,
                                        "Parcel Weight",
                                        "",
                                        deliveryProvider.pickParcelWeight,
                                        TextInputType.number,null
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const  SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Parcel Description",
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                        )),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: textFieldStroke, width: 1),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(1, 1),
                                          color: black.withOpacity(0.25),
                                          blurRadius: 3)
                                    ],
                                  ),
                                  height: MediaQuery.of(context).size.height * 0.1,
                                  child: TextFormField(
                                    // minLines: 2,
                                      readOnly: true,
                                      maxLines: 10,
                                      keyboardType: TextInputType.multiline,
                                      controller: deliveryProvider.pickDescription,
                                      textAlignVertical: TextAlignVertical.center,
                                      textAlign: TextAlign.left,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'required';
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                          top: MediaQuery.of(context).size.height *
                                              0.05,
                                          // HERE THE IMPORTANT PART
                                          left: 10,
                                        ),

                                        labelStyle: const TextStyle(),
                                        border:const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        focusedBorder:const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        enabledBorder:const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        hintText: "",
                                        // labelText:"Your Name"
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Delivery Price Offer",
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                        )),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: textFieldStroke, width: 1),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(1, 1),
                                          color: black.withOpacity(0.25),
                                          blurRadius: 3)
                                    ],
                                  ),
                                  width: media.width * 0.35,
                                  height: MediaQuery.of(context).size.height * 0.05,
                                  child: TextFormField(
                                      keyboardType:  TextInputType.number,
                                      controller: deliveryProvider.pickPrice,
                                      readOnly:  true,
                                      textAlignVertical: TextAlignVertical.center,
                                      textAlign: TextAlign.left,

                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'required';
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                          top: MediaQuery.of(context).size.height *
                                              0.05,
                                          // HERE THE IMPORTANT PART
                                          left: 10,
                                        ),

                                        labelStyle: const TextStyle(),
                                        border:const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        focusedBorder:const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        enabledBorder:const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        hintText: "",
                                        // labelText:"Your Name"
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      )
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 2,
                      offset: const Offset(
                          0, 5), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.all(
                      Radius.circular(20.0)),
                  border: Border.all(
                      color: const Color(0xfff1d5a9))),
              padding: const EdgeInsets.only(left: 10,right: 10,),
              child: ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      yvanimage,
                      height: 50,
                      width: 50,
                    ),
                    const Text(
                      'DELIVERY DETAILS',
                      style: TextStyle(
                          color: black,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                trailing:const Icon(
                  FontAwesomeIcons.chevronDown,
                  color: AppColors.primaryColor,
                ),
                children: <Widget>[
                  Container(
                      width:MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(28),bottomLeft: Radius.circular(28)),
                        color: white,

                      ),
                      child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Column(
                          children: [
                            AbsorbPointer(
                              child: inputField(context, "Address", "Select Delivery Address",
                                  deliveryProvider.deliveryAddress,TextInputType.text,Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image.asset("assets/images/Pin 3 (1).png"),
                                  )),
                            ),
                            const  SizedBox(
                              height: 10,
                            ),
                            AbsorbPointer(
                              child: inputField(
                                  context,
                                  "Name",
                                  "Enter Name",
                                  deliveryProvider.deliveryName,
                                  TextInputType.text,null
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AbsorbPointer(
                              child: inputField(
                                  context,
                                  "Phone Number",
                                  "Enter Phone Number",
                                  deliveryProvider.deliveryPhone,
                                  TextInputType.number,null
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AbsorbPointer(
                              child: inputField(context, "Email", "Enter Email",
                                  deliveryProvider.deliveryEmail,TextInputType.emailAddress,null),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Parcel Description",
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                        )),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: textFieldStroke, width: 1),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(1, 1),
                                          color: black.withOpacity(0.25),
                                          blurRadius: 3)
                                    ],
                                  ),
                                  height: MediaQuery.of(context).size.height * 0.15,
                                  child: TextFormField(
                                      readOnly: true,
                                      maxLines: 10,
                                      keyboardType: TextInputType.multiline,
                                      controller:
                                      deliveryProvider.deliveryDescription,
                                      textAlignVertical: TextAlignVertical.center,
                                      textAlign: TextAlign.left,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'required';
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                          top: MediaQuery.of(context).size.height *
                                              0.05,
                                          // HERE THE IMPORTANT PART
                                          left: 10,
                                        ),

                                        labelStyle: const TextStyle(),
                                        border:const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        focusedBorder:const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        enabledBorder:const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        hintText: "",
                                        // labelText:"Your Name"
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),


                          ],
                        ),
                      )
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left:10.0,right: 10),
              child: InnerShadow(
                blur: 5,
                color: brownDark,
                offset:Offset(0,2),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: white,
                            border: Border.all(color: orange,width: 2),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset("assets/images/Rider.png",width: 20,height: 20,),
                              SizedBox(width: 2,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                          width:150,
                                          child: Text(deliveryProvider.pickAddress.text.toString(),style:  TextStyle(fontFamily: 'Poppins',fontSize: 10,fontWeight: FontWeight.w500))),
                                      SizedBox(width: 10,),
                                      Text(deliveryProvider.duration,style:  TextStyle(fontFamily: 'Poppins',fontSize: 10,fontWeight: FontWeight.bold,color: orange)),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox( width:150,child: Text(deliveryProvider.deliveryAddress.text.toString(),style:  TextStyle(fontFamily: 'Poppins',fontSize: 8,fontWeight: FontWeight.w300))),
                                      SizedBox(width: 10,),
                                      Text(deliveryProvider.distance,style:  TextStyle(fontFamily: 'Poppins',fontSize: 10,fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          deliveryProvider.vehicle == "VAN"?Image.asset(vanimage,width: 60,height: 60,):
                          deliveryProvider.vehicle == "CAR"?Image.asset(carimage,width: 60,height: 60,):
                           deliveryProvider.vehicle == "SCOOTER"?Image.asset(scooterimage,width: 60,height: 60,):
                           deliveryProvider.vehicle == "TRUCK"?Image.asset(truckimage,width: 60,height: 60,):
                           deliveryProvider.vehicle == "BIKE"?Image.asset(cycleimage,width: 60,height: 60,):
                           deliveryProvider.vehicle == "MINI TRUCK"?Image.asset(miniTruckimage,width: 60,height: 60,):
                          Image.asset("assets/images/Group 8504.png",width: 60,height: 60,),
                          Text( deliveryProvider.vehicle,style:  TextStyle(color: black,fontFamily: 'Poppins',fontSize: 8,fontWeight: FontWeight.w600))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("Parcel Name",style:  TextStyle(color: black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.w400)),
                Text(deliveryProvider.pickParcelName.text.toString()+" (Order)",style:  TextStyle(color: black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.w300)),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("Weight",style:  TextStyle(color: black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.w400)),
                Text(deliveryProvider.pickParcelWeight.text.toString()+" KG",style:  TextStyle(color: black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.w300)),
              ],
            ),
            SizedBox(height: 10,),
            Container(
              width: media.width,
              color: orange,
              padding: EdgeInsets.only(left:10,right: 10,top: 5,bottom: 5),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text("Price Order",style:  TextStyle(color: white,fontFamily: 'Poppins',fontSize: 20,fontWeight: FontWeight.bold)),
                      Text(deliveryProvider.pickPrice.text.toString()+" MNT",style:  TextStyle(color: white,fontFamily: 'Poppins',fontSize: 18,fontWeight: FontWeight.bold)),

                    ],
                  ),
                  Container(
                      width: 3,
                      height: 50,
                      color: black),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Distance",style:  TextStyle(color: black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.w300)),
                          SizedBox(width: 10,),
                          Text(deliveryProvider.distance,style:  TextStyle(color: black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.w300)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Time",style:  TextStyle(color: black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.w300)),
                          SizedBox(width: 10,),
                          Text(deliveryProvider.duration,style:  TextStyle(color: black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.w300)),
                        ],
                      ),


                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left:20.0,right: 20),
              child: InnerShadow(
                blur: 2,
                color: brownDark,
                offset:Offset(0,2),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Image.asset("assets/images/qpay.png",width: 100,height: 100,),
                     const Text("Q PAY",style: TextStyle(color: orange,fontWeight: FontWeight.bold,fontSize: 30),),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                         gradient:const LinearGradient(
                           colors: [Color(0xFFFBB03B), Color(0xFFFF5922)],
                           begin: Alignment.topCenter,
                           end: Alignment.bottomCenter,
                         ),
                          shape: BoxShape.circle,
                          border: Border.all(color: black)
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left:20.0,right: 20),
              child: Container(
                padding:  const EdgeInsets.only(left:10),
                decoration: BoxDecoration(
                    color: Colors.white,

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 2,
                        offset: const Offset(
                            0, 5), // changes position of shadow
                      ),
                    ],
                    borderRadius: const BorderRadius.all(
                        Radius.circular(20.0)),
                    border: Border.all(
                        color: const Color(0xfff1d5a9))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   const Text("ADD PROMO / GIFT CODE",style: TextStyle(fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.bold),),
                    Container(
                      decoration: BoxDecoration(
                        color: orange.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),

                      ),

                      width: 100,
                      child: TextFormField(
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical.top,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                          decoration:const InputDecoration(
                            contentPadding: EdgeInsets.only(

                              // HERE THE IMPORTANT PART
                              left: 10,
                            ),

                            labelStyle: const TextStyle(),
                            border:InputBorder.none,
                            focusedBorder:InputBorder.none,
                            enabledBorder:InputBorder.none,
                            hintText: "",
                            // labelText:"Your Name"
                          )),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30,),
            isLoading == true? Center(child: CircularProgressIndicator(color: orange,)): CustomBtn( bgColor: orange,
                shadowColor: black,
                size: 15,
                text: 'PROCEED TO PAY',
                onTap: (){
                 setState(() {
                   isLoading = true;
                 });
                 updateId();

                }),
            SizedBox(height: 20,),
          ],
        ),
      ),

    );
  }

}
