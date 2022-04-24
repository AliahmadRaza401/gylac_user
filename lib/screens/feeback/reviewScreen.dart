import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gyalcuser_project/chat/chat_handler.dart';
import 'package:get/get.dart';
import 'package:gyalcuser_project/services/fcm_services.dart';
import 'package:gyalcuser_project/widgets/custom_btn.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../../chat/chat_room.dart';
import '../../chat/model/chat_room_model.dart';
import '../../chat/model/user_model.dart';
import '../../constants/colors.dart';
import '../../constants/toast_utils.dart';
import '../../providers/create_delivery_provider.dart';
import '../../providers/userProvider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_route.dart';
import '../../utils/image.dart';
import '../../utils/innerShahdow.dart';
import '../home/home_page.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late UserProvider _userProvider;
  late CreateDeliveryProvider deliveryProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deliveryProvider = Provider.of<CreateDeliveryProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  TextEditingController feedText = TextEditingController();


  bool isLoading = false;
  String rate = "";
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uniqueId = const Uuid().v1();

  //ADDING SUPPORT TO  DB
  addDataToUserDB() async{
    try{
      firebaseFirestore
          .collection("feedback")
          .doc(uniqueId)
          .set({
        "uid":_auth.currentUser!.uid,
        "feedback":feedText.text.toString(),
        "driverId":deliveryProvider.driverId,
        "orderId":deliveryProvider.orderId.toString(),
        "reviewDate":DateTime.now(),
        "driverName":deliveryProvider.driverName,
        "rating":rate

      })
          .then((data) async {
      /* if(rate == "4.0" || rate == "5.0"){
         firebaseFirestore
             .collection("topRated")
             .doc(uniqueId)
             .set({
           "pickupAddress": deliveryProvider.pickAddress.text.toString(),
           "pickupName": deliveryProvider.pickName.text.toString(),
           "pickupEmail": deliveryProvider.pickEmail.text.toString(),
           "pickupPhone": deliveryProvider.pickPhone.text.toString(),
           "pickupParcelName": deliveryProvider.pickParcelName.text.toString(),
           "pickupParcelWeight": deliveryProvider.pickParcelWeight.text,
           "pickupParcelDesc": deliveryProvider.pickDescription.text.toString(),
           "pickupDeliveryPrice": deliveryProvider.pickPrice.text,
           "deliveryAddress": deliveryProvider.deliveryAddress.text.toString(),
           "deliveryName": deliveryProvider.deliveryName.text.toString(),
           "deliveryEmail": deliveryProvider.deliveryEmail.text.toString(),
           "deliveryPhone": deliveryProvider.deliveryPhone.text.toString(),
           "deliveryParcelDesc": deliveryProvider.deliveryDescription.text.toString(),
           "vehicle": deliveryProvider.vehicle.toString(),
           "pickupLat": deliveryProvider.pickupLat,
           "pickupLong": deliveryProvider.pickupLong,
           "distance": deliveryProvider.distance,
           "driverId": deliveryProvider.driverId,
           "driverName": deliveryProvider.deliveryName,
           "userName": _userProvider.fullName,
           "userid": _auth.currentUser!.uid,
           "rating": rate,
           "parcel": deliveryProvider.parcel,
           "driverImage": deliveryProvider.driverImage,
           "driverMobile":deliveryProvider.driverMobile,
           "orderType": deliveryProvider.scheduleOrder,
           "deliveryLong": deliveryProvider.deliveryLong,
           "deliveryLat": deliveryProvider.deliveryLat,
           "orderID": deliveryProvider.orderId.toString(),
           "time": deliveryProvider.duration,
         }).then((value) => {
         setState(() {
         isLoading = false;
         feedText.text ="";
         }),
         FCMServices.sendFCM("driver", deliveryProvider.driverId.toString(),
             "Rating received", "User give $rate star rating"),
         ToastUtils.showSuccessToast(
             context, "Success".tr, "Feedback Sent Successfully!".tr),
         Future.delayed(Duration(seconds: 3), () {
           Navigator.of(context).pushAndRemoveUntil(
             MaterialPageRoute(builder: (context) => HomePage()),
                 (Route<dynamic> route) => false,
           );
         }),
         });

       }*/
     //  else{
        if(mounted)
         setState(() {
           isLoading = false;
           feedText.text ="";
         });
         FCMServices.sendFCM("driver", deliveryProvider.driverId.toString(),
             "Rating received", "User give $rate star rating");
         ToastUtils.showSuccessToast(
             context, "Success".tr, "Feedback Sent Successfully!".tr);
         Future.delayed(Duration(seconds: 2), () {
           Navigator.of(context).pushAndRemoveUntil(
             MaterialPageRoute(builder: (context) => HomePage()),
                 (Route<dynamic> route) => false,
           );
         });
     //  }

      }).catchError((err) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });

    }
    on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:
        IconButton(
          onPressed: () => Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
            );
          }),
          icon:const Icon(
            FontAwesomeIcons.reply,
            color: white,
          ),
        ),
        backgroundColor: orange,
        title: Text("TRACK YOUR ORDER".tr,style: TextStyle(fontFamily: 'Poppins',fontSize: 18,fontWeight: FontWeight.bold,color: white),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomBtn(shadowColor: black,size: 20,text: "ORDER COMPLETE".tr, onTap: (){},bgColor: greenColor,w: 300,txtColor: white,),
              const SizedBox(height: 10,),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),

                  ),
                  child: Image.asset("assets/images/Group 8511.png",height: 150,)),
              const SizedBox(height: 10,),
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
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(deliveryProvider.driverName,style:  TextStyle(fontFamily: 'Roboto',fontSize: 18,fontWeight: FontWeight.bold)),
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
              const SizedBox(height: 10,),
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
                margin: EdgeInsets.all(15),
                height: MediaQuery.of(context).size.height * 0.1,
                child: TextFormField(
                    maxLines: 10,
                    controller: feedText,
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.left,
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
                      hintText: "How’s Your Order?  Feedback Please".tr,
                      hintStyle:const TextStyle(fontSize: 15,fontFamily: 'Poppins')
                      // labelText:"Your Name"
                    )),
              ),
          const SizedBox(height: 10,),
            RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            itemCount: 5,
            itemPadding:const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                rate = rating.toString();
              });


            },
          ),

              const SizedBox(height: 20,),
              isLoading == true? Center(child: CircularProgressIndicator(color: orange,)): CustomBtn(size: 18,text: "SEND FEEDBACK".tr,
                onTap: (){
                  if(feedText.text.isEmpty){
                    Fluttertoast.showToast(msg: "Please enter orderId".tr);
                  }
                  else if(rate == ""){
                    Fluttertoast.showToast(msg: "Please add rating".tr);
                  }
                  else{
                    setState(() {
                      isLoading =true;
                    });
                    addDataToUserDB();
                  }

              },bgColor: orange,w: 200,txtColor: white,shadowColor: black,),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
