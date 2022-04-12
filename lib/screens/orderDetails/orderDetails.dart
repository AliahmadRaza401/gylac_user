import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gyalcuser_project/screens/feeback/reviewScreen.dart';
import 'package:gyalcuser_project/screens/orderTrack/go_map.dart';
import 'package:gyalcuser_project/utils/app_route.dart';
import 'package:gyalcuser_project/utils/innerShahdow.dart';
import 'package:gyalcuser_project/widgets/custom_btn.dart';
import 'package:provider/provider.dart';
import 'package:status_change/status_change.dart';
import '../../constants/colors.dart';
import '../../providers/create_delivery_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/image.dart';
import '../../widgets/App_Menu.dart';
import '../../widgets/inputField.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  late CreateDeliveryProvider deliveryProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deliveryProvider = Provider.of<CreateDeliveryProvider>(context, listen: false);
  }
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var scaffoldState = GlobalKey<ScaffoldState>();

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
                      decoration:const BoxDecoration(
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
                                SizedBox(
                                  width: media.width * 0.37,
                                  child: AbsorbPointer(
                                    child: inputField(context, "Parcel Name", "",
                                        deliveryProvider.pickParcelName,TextInputType.text,null),
                                  ),
                                ),
                                SizedBox(
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
                                          offset:const Offset(1, 1),
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
                offset:Offset(0,3),
                child: Container(
                  padding: EdgeInsets.all(10),
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
                                Image.asset("assets/images/Avatar.png",width: 60,height: 60,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("TEST",style:  TextStyle(fontFamily: 'Roboto',fontSize: 18,fontWeight: FontWeight.bold)),
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
                                      padding: EdgeInsets.all(2),
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
                                Container(
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
                                SizedBox(width: 20,),
                                Container(
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
                Text(deliveryProvider.pickParcelName.text.toString(),style:  TextStyle(color: black,fontFamily: 'Poppins',fontSize: 15,fontWeight: FontWeight.w300)),
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
            SizedBox(height: 30,),
            CustomBtn( bgColor: orange,
                shadowColor: black,
                size: 15,
                text: 'TRACK ORDER',
                onTap: (){
              AppRoutes.push(context, TrackMap());
                }),
            SizedBox(height: 20,),
          ],
        ),
      ),

    );

  }
}




