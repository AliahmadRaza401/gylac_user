import 'dart:developer';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gyalcuser_project/models/driverModel.dart';
import 'package:gyalcuser_project/services/fcm_services.dart';
import 'package:gyalcuser_project/utils/app_route.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../constants/colors.dart';
import '../../providers/create_delivery_provider.dart';
import '../../widgets/custom_btn.dart';
import '../orderDetails/orderDetails.dart';
import 'package:get/get.dart';

class PayCard extends StatefulWidget {
  String orderId;
  PayCard({Key? key, required this.orderId}) : super(key: key);

  @override
  State<PayCard> createState() => _PayCardState();
}

class _PayCardState extends State<PayCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late CreateDeliveryProvider deliveryProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deliveryProvider =
        Provider.of<CreateDeliveryProvider>(context, listen: false);
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );

    log('deliveryProvider.pickPrice.text: ${deliveryProvider.pickPrice.text}');
    getDriverDataByID();
  }

  bool isLoading = false;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int updatedPrice = 0;

  Future getDriverDataByID() async {
    log("geting Driver....");
    try {
      await FirebaseFirestore.instance
          .collection('drivers')
          .where('id', isEqualTo: deliveryProvider.driverId)
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) {
                  print("User Col ${doc.data()}");
                  DriverModel driverModel =
                      DriverModel.fromMap(doc.data() as Map<String, dynamic>);
                  print(driverModel.wallet.toString());
                  print(
                      'deliveryProvider.pickPrice.text: ${deliveryProvider.pickPrice.text}');
                  setState(() {
                    updatedPrice = driverModel.wallet +
                        int.parse(deliveryProvider.pickPrice.text);

                    print('updatedPrice: $updatedPrice');
                  });
                }),
              });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateId() async {
    var rnd = math.Random();
    var next = rnd.nextDouble() * 10000000;
    while (next < 1000000) {
      next *= 100;
    }

    firebaseFirestore.collection("orders").doc(widget.orderId).update({
      "tracking": next.toInt().toString(),
    }).then((data) async {
      firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("notifications")
          .doc(widget.orderId)
          .set({
        "msg":
            "Order ${widget.orderId} payment done successfully. Your Tracking ID is ${next.toInt().toString()}",
        "status": "paymentDone",
        "timestamp": FieldValue.serverTimestamp(),
        "title": "Order Payment Done",
      }).then((data) async {
        firebaseFirestore
            .collection("drivers")
            .doc(deliveryProvider.driverId)
            .update({
          "wallet": updatedPrice,
        });

        firebaseFirestore
            .collection("orders")
            .doc(widget.orderId)
            .update({"trackStatus": "WaitForPickup"}).then((value) =>
                firebaseFirestore
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("orders")
                    .doc(widget.orderId)
                    .update({
                  "driverName": deliveryProvider.driverName,
                  "driverImage": deliveryProvider.driverImage,
                  "driverPhone": deliveryProvider.driverMobile,
                }));

        firebaseFirestore
            .collection("drivers")
            .doc(
              deliveryProvider.driverId,
            )
            .update({
          "wallet": deliveryProvider.pickPrice,
        });
        FCMServices.sendFCM("driver", deliveryProvider.driverId.toString(),
            "Payment Success!", "Delivery Payment Successfully");

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
                      Image.asset(
                        "assets/images/Correct_sign_1_freepik 4.png",
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Payment Complete".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            color: orange),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Your Tracking ID".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            color: orange),
                      ),
                      CustomBtn(
                        shadowColor: black,
                        size: 15,
                        bgColor: orange,
                        text: "#${next.toInt().toString()}",
                        onTap: () {},
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              );
            });
        Future.delayed(Duration(seconds: 3), () {
          Fluttertoast.showToast(
              msg: "Payment Successful".tr,
              textColor: Colors.white,
              backgroundColor: Colors.green);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OrderDetails()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            AppRoutes.pop(context);
          },
          child: Icon(
            FontAwesomeIcons.grip,
            color: white,
          ),
        ),
        backgroundColor: orange,
        elevation: 5,
        shadowColor: blackLight,
        title: Text('PAYMENT'.tr,
            style: TextStyle(
                color: white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily: 'Roboto')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreditCardWidget(
              glassmorphismConfig:
                  useGlassMorphism ? Glassmorphism.defaultConfig() : null,
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              cardBgColor: orangeDark,
              backgroundImage: useBackgroundImage ? 'assets/card_bg.png' : null,
              isSwipeGestureEnabled: true,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
              customCardTypeIcons: <CustomCardTypeIcon>[
                CustomCardTypeIcon(
                  cardType: CardType.mastercard,
                  cardImage: Image.asset(
                    'assets/images/master.png',
                    height: 48,
                    width: 48,
                  ),
                ),
              ],
            ),
            CreditCardForm(
              formKey: formKey,
              obscureCvv: true,
              obscureNumber: true,
              cardNumber: cardNumber,
              cvvCode: cvvCode,
              isHolderNameVisible: true,
              isCardNumberVisible: true,
              isExpiryDateVisible: true,
              cardHolderName: cardHolderName,
              expiryDate: expiryDate,
              themeColor: Colors.blue,
              textColor: orangeDark,
              cardNumberDecoration: InputDecoration(
                labelText: 'Number'.tr,
                hintText: 'XXXX XXXX XXXX XXXX',
                hintStyle: const TextStyle(color: orange),
                labelStyle: const TextStyle(color: orange),
                focusedBorder: border,
                enabledBorder: border,
              ),
              expiryDateDecoration: InputDecoration(
                hintStyle: const TextStyle(color: orange),
                labelStyle: const TextStyle(color: orange),
                focusedBorder: border,
                enabledBorder: border,
                labelText: 'Expiry Date'.tr,
                hintText: 'XX/XX',
              ),
              cvvCodeDecoration: InputDecoration(
                hintStyle: const TextStyle(color: orange),
                labelStyle: const TextStyle(color: orange),
                focusedBorder: border,
                enabledBorder: border,
                labelText: 'CVV'.tr,
                hintText: 'XXX',
              ),
              cardHolderDecoration: InputDecoration(
                hintStyle: const TextStyle(color: orange),
                labelStyle: const TextStyle(color: orange),
                focusedBorder: border,
                enabledBorder: border,
                labelText: 'Card Holder'.tr,
              ),
              onCreditCardModelChange: onCreditCardModelChange,
            ),
            isLoading == true
                ? Center(
                    child: CircularProgressIndicator(
                    color: orange,
                  ))
                : CustomBtn(
                    bgColor: orange,
                    shadowColor: black,
                    size: 15,
                    text: 'PAY'.tr,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        if (mounted) {
                          setState(() {
                            isLoading = true;
                          });
                        }
                        updateId();
                      } else {
                        Fluttertoast.showToast(msg: "Invalid Card Details".tr);
                      }
                    }),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
