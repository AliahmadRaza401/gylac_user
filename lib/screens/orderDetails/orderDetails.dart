import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gyalcuser_project/chat/chat_handler.dart';
import 'package:get/get.dart';
import 'package:gyalcuser_project/utils/app_route.dart';
import 'package:gyalcuser_project/utils/innerShahdow.dart';
import 'package:gyalcuser_project/widgets/custom_btn.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../chat/chat_room.dart';
import '../../chat/model/chat_room_model.dart';
import '../../chat/model/user_model.dart';
import '../../constants/colors.dart';
import '../../providers/create_delivery_provider.dart';
import '../../providers/userProvider.dart';
import '../../utils/app_colors.dart';
import '../../utils/image.dart';
import '../../widgets/inputField.dart';
import '../orderTrack/gomap2.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  late UserProvider _userProvider;
  late CreateDeliveryProvider deliveryProvider;

  int seconds = 1200;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deliveryProvider = Provider.of<CreateDeliveryProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _countTimer();
  }
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var scaffoldState = GlobalKey<ScaffoldState>();
  Timer? _timer;
  bool  setLoading = false;

  void _countTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getUpdate();
    });
  }

  String trackStatus = "";
  String driverId = "";
  bool step4 = false;
  bool step5 = false;

  getUpdate() async{
    firebaseFirestore
        .collection("orders")
        .doc(deliveryProvider.orderId).get().then((value){
      if(mounted) {
        setState(() {
          trackStatus = value.data()!["trackStatus"].toString();
          driverId = value.data()!["driverId"].toString();
        });
      }
    });

    if(trackStatus =="WaitForPickup"){
      if(mounted){
        setState(() {
          step4 = false;
          step5 = false;
        });
      }
    }

    else if(trackStatus =="Picked"){
      if(mounted){
        setState(() {
          step4 = true;
        });
      }
    }
    else if(trackStatus =="Delivered"){
      if(mounted){
        setState(() {
          step5 = true;
          _timer!.cancel();
        });
      }
      Fluttertoast.showToast(msg: "Order Delivered Successfully".tr,textColor: Colors.white,backgroundColor: Colors.green);
    }

    else{

    }

  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldState,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading:const Icon(FontAwesomeIcons.grip,color: white,),
        backgroundColor:orange,
        elevation: 5,
        shadowColor: blackLight,
        title: Text('ORDER SUMMARY'.tr, style: TextStyle(
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
                    Text(
                      'PICK-UP DETAILS'.tr,
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
                              child: inputField(context, "Address".tr, "Select Pickup Address".tr,
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
                                  "Name".tr,
                                  "Enter Name".tr,
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
                                  "Phone Number".tr,
                                  "Enter Phone Number".tr,
                                  deliveryProvider.pickPhone,
                                  TextInputType.number,null
                              ),
                            ),
                            const  SizedBox(
                              height: 10,
                            ),
                            AbsorbPointer(
                              child: inputField(context, "Email".tr, "Enter Email".tr,
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
                                    child: inputField(context, "Parcel Name".tr, "",
                                        deliveryProvider.pickParcelName,TextInputType.text,null),
                                  ),
                                ),
                                Container(
                                  width: media.width * 0.37,
                                  child: AbsorbPointer(
                                    child: inputField(
                                        context,
                                        "Parcel Weight".tr,
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
                                    Text("Parcel Description".tr,
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
                                    Text("Delivery Price Offer".tr,
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
                    Text(
                      'DELIVERY DETAILS'.tr,
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
                              child: inputField(context, "Address".tr, "Select Delivery Address".tr,
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
                                  "Name".tr,
                                  "Enter Name".tr,
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
                                  "Phone Number".tr,
                                  "Enter Phone Number".tr,
                                  deliveryProvider.deliveryPhone,
                                  TextInputType.number,null
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AbsorbPointer(
                              child: inputField(context, "Email".tr, "Enter Email".tr,
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
                                    Text("Parcel Description".tr,
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
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left:10.0,right: 10),
              child: InnerShadow(
                blur: 5,
                color: brownDark,
                offset:const Offset(0,3),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,right: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                deliveryProvider.driverImage.isNotEmpty
                                    ? SizedBox(
                                      width:50,
                                      height:50,
                                      child: Image.network(
                                  deliveryProvider.driverImage,
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
                                SizedBox(width: 20.w,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(deliveryProvider.driverName,style:  const TextStyle(fontFamily: 'Roboto',fontSize: 18,fontWeight: FontWeight.bold)),
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
                                          Image.asset("assets/images/badge.png",width: 20,height: 20,),
                                          const SizedBox(width: 5,),
                                          const Text("Top High Rated",style:  TextStyle(color: redColor,fontFamily: 'Poppins',fontSize: 10,fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap:() async{
                                    var url = "tel:${deliveryProvider.driverMobile}";
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Container(
                                    padding:const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow:const [
                                        BoxShadow(
                                            color: dimOrange,
                                            blurRadius: 5)
                                      ],
                                    ),
                                    child: Image.asset("assets/images/bx_bxs-phone-call.png",width: 30,height: 30,),
                                  ),
                                ),
                                const SizedBox(width: 20,),
                                GestureDetector(
                                  onTap: () async {
                                    log(deliveryProvider.driverId.toString());
                                    ChatRoomModel? chatRoomModel =
                                    await chatHandler.getChatRoom(
                                        deliveryProvider.driverId,
                                        FirebaseAuth
                                            .instance.currentUser!.uid);

                                    if (chatRoomModel != null) {
                                      AppRoutes.push(
                                          context,
                                          ChatRoom(
                                            targetUser: UserModel(
                                              uid: deliveryProvider.driverId.toString(),
                                              fullname: deliveryProvider.driverName.toString(),
                                              email: 'test@gmail.com',
                                              profilepic:deliveryProvider.driverImage.toString(),
                                            ),
                                            userModel: UserModel(
                                              uid: _userProvider.uid,
                                              fullname: _userProvider.fullName,
                                              email: _userProvider.email,
                                              profilepic: _userProvider.image,
                                            ),
                                            chatRoom: chatRoomModel,
                                          ));
                                    }
                                  },
                                  child: Container(
                                    padding:const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow:const [
                                        BoxShadow(
                                            color: dimOrange,
                                            blurRadius: 5)
                                      ],
                                    ),
                                    child: Image.asset("assets/images/bpmn_end-event-message.png",width: 30,height: 30,),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const Divider(color: orange,height: 10,thickness: 3,),
                      Row(
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
                                  const SizedBox(width: 2,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                              width:150,
                                              child: Text(deliveryProvider.pickAddress.text.toString(),style:  const TextStyle(fontFamily: 'Poppins',fontSize: 10,fontWeight: FontWeight.w500))),
                                          const SizedBox(width: 10,),
                                          Text(deliveryProvider.duration,style:  const TextStyle(fontFamily: 'Poppins',fontSize: 10,fontWeight: FontWeight.bold,color: orange)),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox( width:150,child: Text(deliveryProvider.deliveryAddress.text.toString(),style:  const TextStyle(fontFamily: 'Poppins',fontSize: 8,fontWeight: FontWeight.w300))),
                                          const SizedBox(width: 10,),
                                          Text(deliveryProvider.distance,style:  const TextStyle(fontFamily: 'Poppins',fontSize: 10,fontWeight: FontWeight.w500)),
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
                              Text( deliveryProvider.vehicle,style:  const TextStyle(color: black,fontFamily: 'Poppins',fontSize: 8,fontWeight: FontWeight.w600))
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green
                          ),
                          margin: const EdgeInsets.all(5),
                          child: const Icon(Icons.check,color: white,),
                        ),
                        Container(
                          width: 5,
                          height: 50,
                          decoration: const BoxDecoration(
                              color: Colors.green
                          ),

                        ),
                      ],
                    ),
                     Text("Waiting For Acceptance".tr,style:  TextStyle(fontSize: 15,fontFamily: 'Poppins',fontWeight: FontWeight.bold),)
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green
                          ),
                          margin: const EdgeInsets.all(5),
                          child: const Icon(Icons.check,color: white,),
                        ),
                        Container(
                          width: 5,
                          height: 50,
                          decoration: const BoxDecoration(
                              color: Colors.green
                          ),

                        ),
                      ],
                    ),
                    Text("${deliveryProvider.driverName} accept your Request".tr,style:const TextStyle(fontSize: 15,fontFamily: 'Poppins',fontWeight: FontWeight.bold),)
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration:  BoxDecoration(
                              shape: BoxShape.circle,
                              color:step4 ==false? Colors.green.withOpacity(0.45): Colors.green,
                            border:step4 == false? Border.all(color: Colors.green,width: 2):null
                          ),
                          margin: const EdgeInsets.all(5),
                          child: const Icon(Icons.check,color: white,),
                        ),
                        Container(
                          width: 5,
                          height: 50,
                          decoration:  BoxDecoration(
                              color: step4 ==false? Colors.grey:Colors.green
                          ),

                        ),
                      ],
                    ),
                     Text("Waiting for Pickup".tr,style:  TextStyle(fontSize: 15,fontFamily: 'Poppins',fontWeight: FontWeight.bold, color: Colors.black),)
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration:  BoxDecoration(
                              shape: BoxShape.circle,
                              color:step4 ==false? Colors.grey:Colors.green
                          ),
                          margin: const EdgeInsets.all(5),
                          child: const Icon(Icons.check,color: white,),
                        ),
                        Container(
                          width: 5,
                          height: 50,
                          decoration:  BoxDecoration(
                              color: step4 ==false? Colors.grey:Colors.green
                          ),

                        ),
                      ],
                    ),
                     Text("Parcel Picked up".tr,style: TextStyle(fontSize: 15,fontFamily: 'Poppins',fontWeight: FontWeight.bold, color:step4 ==false? Colors.grey:Colors.black),)
                  ],
                ),
                Row(
                  children: [
                    Container(
                      decoration:  BoxDecoration(
                          shape: BoxShape.circle,
                          color: step5 ==false? Colors.grey:Colors.green
                      ),
                      margin: const EdgeInsets.all(5),
                      child: const Icon(Icons.check,color: white,),
                    ),
                     Text("Delivered Location".tr,style:  TextStyle(fontSize: 15,fontFamily: 'Poppins',fontWeight: FontWeight.bold, color: step5 ==false? Colors.grey:Colors.black),)
                  ],
                ),
              ],

            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 Text("Parcel Name".tr,style:  TextStyle(color: black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.w400)),
                Text(deliveryProvider.pickParcelName.text.toString(),style:  const TextStyle(color: black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.w300)),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 Text("Weight".tr,style:  TextStyle(color: black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.w400)),
                Text(deliveryProvider.pickParcelWeight.text.toString()+" KG",style:  const TextStyle(color: black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.w300)),
              ],
            ),
            const SizedBox(height: 10,),
            Container(
              width: media.width,
              color: orange,
              padding: const EdgeInsets.only(left:10,right: 10,top: 5,bottom: 5),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                       Text("Price Order".tr,style:  const TextStyle(color: white,fontFamily: 'Poppins',fontSize: 20,fontWeight: FontWeight.bold)),
                      Text(deliveryProvider.pickPrice.text.toString()+" MNT",style:  const TextStyle(color: white,fontFamily: 'Poppins',fontSize: 18,fontWeight: FontWeight.bold)),

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
                           Text("Distance".tr,style:  TextStyle(color: black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.w300)),
                          const SizedBox(width: 10,),
                          Text(deliveryProvider.distance,style:  const TextStyle(color: black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.w300)),
                        ],
                      ),
                      Row(
                        children: [
                           Text("Time".tr,style:  TextStyle(color: black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.w300)),
                          const SizedBox(width: 10,),
                          Text(deliveryProvider.duration,style:  const TextStyle(color: black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.w300)),
                        ],
                      ),


                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            CustomBtn( bgColor: orange,
                shadowColor: black,
                size: 15,
                text: 'TRACK ORDER'.tr,
                onTap: (){
              AppRoutes.push(context,  GoMap(driverId:driverId));
                }),
            const SizedBox(height: 20,),
          ],
        ),
      ),

    );

  }
}




