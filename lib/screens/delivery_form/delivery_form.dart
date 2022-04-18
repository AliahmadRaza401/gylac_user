import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
 import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'dart:convert';
import 'package:gyalcuser_project/utils/app_colors.dart';
import 'package:gyalcuser_project/utils/app_route.dart';
import 'package:gyalcuser_project/widgets/inputField.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/keys.dart';
import '../../constants/toast_utils.dart';
import '../../providers/create_delivery_provider.dart';
import '../../widgets/custom_btn.dart';
import 'package:http/http.dart' as http;
import '../../constants/keys.dart';

class DeliveryForm extends StatefulWidget {

   DeliveryForm({Key? key}) : super(key: key);
  @override
  _DeliveryFormState createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryForm> {
   PickResult? selectedPlace;
  static const kInitialPosition = LatLng(-33.8567844, 151.213108);
  bool showGoogleMapInContainer = false;


   late CreateDeliveryProvider deliveryProvider;
   @override
   void initState() {
     // TODO: implement initState
     super.initState();
     deliveryProvider = Provider.of<CreateDeliveryProvider>(context, listen: false);
   }

   ////////////////////////Get Distance Places
   Future<void> getdistanceApi() async {

     try {
       final response = await http.get(Uri.parse(
           'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${deliveryProvider.pickupLat}, ${deliveryProvider.pickupLong}&destinations=${deliveryProvider.deliveryLat}, ${deliveryProvider.deliveryLong}&key=$mapKey'));
       if (response.statusCode == 200) {
         Map<String, dynamic> jsonResponse =
         Map<String, dynamic>.from(json.decode(response.body));

         if (jsonResponse["rows"][0]["elements"][0]["status"].toString() ==
             "ZERO_RESULTS") {
         } else {
           setState(() {
             deliveryProvider.distance = jsonResponse["rows"][0]["elements"][0]["distance"]["text"].toString();
             deliveryProvider.duration = jsonResponse["rows"][0]["elements"][0]["duration"]["text"].toString();
           });

         }
       } else {
         throw Exception('Unexpected error occurred!');
       }
     } catch (e) {
       ToastUtils.showWarningToast(context,"Failed","No Data Found");
     }
   }

  @override
  Widget build(BuildContext context) {
    final deliveryProvider = Provider.of<CreateDeliveryProvider>(context);

    var media = MediaQuery.of(context).size;

    return Positioned(
      top: media.height * 0.20,
      right: media.width * 0.04,
      child: Container(
        width: media.width * 0.93,
        decoration: BoxDecoration(
          color: Colors.white,

          border: Border.all(
            color:
                AppColors.primaryColor, //                   <--- border color
            width: 3.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.orangeColor.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Container(
          margin:const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          padding:const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          width: media.width * 0.9,
          // height: media.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: deliveryProvider.deliveryFormkey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlacePicker(
                                    apiKey: mapKey,
                                    hintText: "Find a place ...",
                                    searchingText: "Please wait ...",
                                    selectText: "Select place",
                                    outsideOfPickAreaText: "Place not in area",
                                    initialPosition: kInitialPosition,
                                    useCurrentLocation: true,
                                    selectInitialPosition: true,
                                    usePinPointingSearch: true,
                                    usePlaceDetailSearch: true,
                                    onPlacePicked: (result) {
                                      selectedPlace = result;
                                      Navigator.of(context).pop();
                                      setState(() {
                                        deliveryProvider.deliveryAddress.text =  selectedPlace!.formattedAddress.toString();
                                        deliveryProvider.deliveryLat = selectedPlace!.geometry!.location.lat.toString();
                                        deliveryProvider.deliveryLong = selectedPlace!.geometry!.location.lng.toString();
                                      });
                                    }
                                )
                            ),
                          );
                        },
                        child: AbsorbPointer(
                          child: inputField(context, "Address", "Select Delivery Address",
                              deliveryProvider.deliveryAddress,TextInputType.text,Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Image.asset("assets/images/Pin 3 (1).png"),
                              )),
                        ),
                      ),
                      const  SizedBox(
                        height: 10,
                      ),
                      inputField(
                        context,
                        "Name",
                        "Enter Name",
                        deliveryProvider.deliveryName,
                          TextInputType.text, null
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      inputField(
                        context,
                        "Phone Number",
                        "Enter Phone Number",
                        deliveryProvider.deliveryPhone,
                          TextInputType.number, null
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      inputField(context, "Email", "Enter Email",
                          deliveryProvider.deliveryEmail,TextInputType.emailAddress, null),
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
                                // minLines: 12,
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

                      CustomBtn(
                        onTap: () {
                           if (deliveryProvider
                              .deliveryAddress.text.isEmpty) {
                          ToastUtils.showWarningToast(
                          context,
                          "Required",
                          "Delivery Address is required");
                          } else if (deliveryProvider
                              .deliveryName.text.isEmpty) {
                          ToastUtils.showWarningToast(
                          context,
                          "Required",
                          "Delivery Name is required");
                          } else if (deliveryProvider
                              .deliveryPhone.text.isEmpty) {
                          ToastUtils.showWarningToast(
                          context,
                          "Required",
                          "Delivery Phone is required");
                          } else if (deliveryProvider
                              .deliveryEmail.text.isEmpty) {
                          ToastUtils.showWarningToast(
                          context,
                          "Required",
                          "Delivery Email is required");
                          } else if (RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(deliveryProvider
                              .deliveryEmail.text) ==
                          false) {
                          ToastUtils.showWarningToast(context,
                          "Error", "Enter a valid email!");
                          } else if (deliveryProvider
                              .deliveryDescription.text.isEmpty) {
                          ToastUtils.showWarningToast(
                          context,
                          "Required",
                          "Delivery Description is required");
                          }
                          else{
                            getdistanceApi();
                            Fluttertoast.showToast(msg: "Details Added");
                            setState(() {

                            });
                          }

                        },
                        bgColor: orange,
                        shadowColor: black,
                        text: 'Save',
                      ),

                    ],
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

