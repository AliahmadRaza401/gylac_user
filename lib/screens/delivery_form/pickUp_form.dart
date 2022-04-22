import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:gyalcuser_project/providers/create_delivery_provider.dart';
import 'package:gyalcuser_project/utils/app_colors.dart';
import 'package:gyalcuser_project/widgets/inputField.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/keys.dart';
import '../../constants/toast_utils.dart';
import 'package:get/get.dart';
import '../../widgets/custom_btn.dart';

class PickUpForm extends StatefulWidget {
  PickUpForm({Key? key}) : super(key: key);

  @override
  _PickUpFormState createState() => _PickUpFormState();
}

class _PickUpFormState extends State<PickUpForm> {
  PickResult? selectedPlace2;
  bool showGoogleMapInContainer = false;
  static const kInitialPosition2 = LatLng(-33.8567844, 151.213108);

  @override
  Widget build(BuildContext context) {
    final deliveryProvider = Provider.of<CreateDeliveryProvider>(context);
    // deliveryProvider.pickAddress.text =selectedPlace2 == null ? "Select Pickup Address" : selectedPlace2!.formattedAddress ?? "";
    var media = MediaQuery.of(context).size;
    return Positioned(
      top: media.height * 0.1,
      right: media.width * 0.04,
      child: Container(
        width: media.width * 0.93,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: AppColors.primaryColor, //
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
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          width: media.width * 0.88,
          // height: media.height * 0.88,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: deliveryProvider.pickFormkey,
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
                                    initialPosition: kInitialPosition2,
                                    useCurrentLocation: true,
                                    selectInitialPosition: true,
                                    usePinPointingSearch: true,
                                    usePlaceDetailSearch: true,
                                    onPlacePicked: (result) {
                                      selectedPlace2 = result;
                                      Navigator.of(context).pop();
                                      setState(() {
                                        deliveryProvider.pickAddress.text =
                                            selectedPlace2!.formattedAddress
                                                .toString();
                                        deliveryProvider.pickupLat =
                                            selectedPlace2!
                                                .geometry!.location.lat
                                                .toString();
                                        deliveryProvider.pickupLong =
                                            selectedPlace2!
                                                .geometry!.location.lng
                                                .toString();
                                      });
                                    })),
                          );
                        },
                        child: AbsorbPointer(
                          child: inputField(
                              context,
                              "Address".tr,
                              "Select Pickup Address".tr,
                              deliveryProvider.pickAddress,
                              TextInputType.text,
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child:
                                    Image.asset("assets/images/Pin 3 (1).png"),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      inputField(context, "Name".tr, "Enter Name".tr,
                          deliveryProvider.pickName, TextInputType.text, null),
                      const SizedBox(
                        height: 10,
                      ),
                      inputField(
                          context,
                          "Phone Number".tr,
                          "Enter Phone Number".tr,
                          deliveryProvider.pickPhone,
                          TextInputType.number,
                          null),
                      const SizedBox(
                        height: 10,
                      ),
                      inputField(
                          context,
                          "Email".tr,
                          "Enter Email".tr,
                          deliveryProvider.pickEmail,
                          TextInputType.emailAddress,
                          null),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: media.width * 0.37,
                            child: inputField(
                                context,
                                "Parcel Name".tr,
                                "",
                                deliveryProvider.pickParcelName,
                                TextInputType.text,
                                null),
                          ),
                          Container(
                            width: media.width * 0.37,
                            child: inputField(
                                context,
                                "Parcel Weight".tr,
                                "",
                                deliveryProvider.pickParcelWeight,
                                TextInputType.number,
                                null),
                          ),
                        ],
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
                              border:
                                  Border.all(color: textFieldStroke, width: 1),
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
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
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
                              border:
                                  Border.all(color: textFieldStroke, width: 1),
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
                                keyboardType: TextInputType.number,
                                controller: deliveryProvider.pickPrice,
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
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
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
                      CustomBtn(
                        onTap: () {
                          if (deliveryProvider.pickAddress.text.isEmpty) {
                            ToastUtils.showWarningToast(
                                context, "Required", "Address is required");
                          } else if (deliveryProvider.pickName.text.isEmpty) {
                            ToastUtils.showWarningToast(
                                context, "Required", "PickUp Name is required");
                          } else if (deliveryProvider.pickPhone.text.isEmpty) {
                            ToastUtils.showWarningToast(context, "Required",
                                "PickUp Phone is required");
                          } else if (deliveryProvider
                              .pickParcelName.text.isEmpty) {
                            ToastUtils.showWarningToast(
                                context, "Required", "Parcel Name is required");
                          } else if (deliveryProvider
                              .pickParcelWeight.text.isEmpty) {
                            ToastUtils.showWarningToast(context, "Required",
                                "Parcel weight is required");
                          } else if (deliveryProvider
                              .pickDescription.text.isEmpty) {
                            ToastUtils.showWarningToast(
                                context, "Required", "description is required");
                          } else if (deliveryProvider.pickPrice.text.isEmpty) {
                            ToastUtils.showWarningToast(context, "Required",
                                "PickUp price is required");
                          } else if (deliveryProvider.pickEmail.text.isEmpty) {
                            ToastUtils.showWarningToast(context, "Required",
                                "PickUp Email is required");
                          } else {
                            setState(() {
                              deliveryProvider.pickVisibleFalse();
                              //  widget.pick=!widget.pick;
                            });
                          }
                        },
                        bgColor: orange,
                        shadowColor: black,
                        text: 'Save'.tr,
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
