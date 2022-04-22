import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import '../constants/colors.dart';
import '../constants/toast_utils.dart';
import '../utils/image.dart';
import '../widgets/App_Menu.dart';
import '../widgets/custom_btn.dart';
import '../widgets/custom_textfield.dart';

class HelpAndSupport extends StatefulWidget{

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  TextEditingController orderText = TextEditingController();
  TextEditingController issueText = TextEditingController();
  // Initial Selected Value
  String dropdownvalue = 'Select your Issue'.tr;

  // List of items in our dropdown menu
  var items = [
    'Select your Issue'.tr,
    'Issue Regarding Product Damage'.tr,
    'Product Misplace'.tr,
    'Late Delivery'.tr,
    'Bad user experience'.tr,
  ];

  bool isLoading = false;

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uniqueId = const Uuid().v1();
  //ADDING SUPPORT TO  DB
  addDataToUserDB() async{
    try{
      firebaseFirestore
          .collection("support")
          .doc(uniqueId)
          .set({
        "uid":_auth.currentUser!.uid,
        "orderId":orderText.text.toString(),
        "issue":dropdownvalue.toString(),
        "message":issueText.text.toString(),

      })
          .then((data) async {
        setState(() {
          isLoading = false;
          orderText.text ="";
          issueText.text ="";
          dropdownvalue ="Select your Issue".tr;
        });
        ToastUtils.showSuccessToast(
            context, "Success".tr, "Report Sent Successfully!".tr);
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
        leading: Builder(
          builder:(context)=>IconButton(
            icon: Image.asset(menuimage,width: 30,height: 30,),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor:orange,
        elevation: 5,
        shadowColor: blackLight,
        title: Text('Help And Support'.tr, style: TextStyle(
            color: white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Roboto')),
      ),
      drawer: AppMenu(),
      body:Container(
        margin:const EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0,right: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text('Please How we can help you?'.tr, style: TextStyle(
                    color: orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Poppins')),
                const  SizedBox(
                  height: 10,
                ),
                  Text('Order ID'.tr, style: TextStyle(
                    color: orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Poppins')),
                CustomTextField(
                  hint: "Enter your Order Id here".tr,
                  controller: orderText,
                ),
                const  SizedBox(
                  height: 20,
                ),
                Container(
                  width: 350,
                  height: 54,
                  decoration: BoxDecoration(
                    color: orange,
                    border: Border.all(color: const Color(0xFFA8A8A8)),
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: const [
                       BoxShadow(
                          offset:  Offset(2, 3),
                          color: stroke,
                          blurRadius: 5)
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left:5.0,right: 5.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        // Initial Value
                        value: dropdownvalue,
                        dropdownColor: orange,
                        // Down Arrow Icon
                        icon: const Icon(FontAwesomeIcons.circleChevronDown,color: black,size: 20,),
                        style:  const TextStyle(color: white, fontWeight: FontWeight.bold,fontSize: 15,fontFamily: 'Poppins'),
                        // Array list of items
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: SizedBox(
                                width: 200,
                                child: Text(items.tr)),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const  SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Report an issue".tr,
                            style: TextStyle(
                                color: orangeDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Poppins')),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: textFieldStroke, width: 1),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(2, 2),
                              color: black.withOpacity(0.25),
                              blurRadius: 5)
                        ],
                      ),
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: TextFormField(
                        // minLines: 2,
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          controller: issueText,

                          textAlignVertical: TextAlignVertical.center,
                          textAlign: TextAlign.left,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'required';
                            }
                            return null;
                          },
                          style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                          decoration: InputDecoration(
                            hintText: "Describe your Issue here".tr,
                            contentPadding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height *
                                  0.05,
                              // HERE THE IMPORTANT PART
                              left: 10,
                            ),

                            labelStyle: const TextStyle(),
                            border:const OutlineInputBorder(
                              borderSide: BorderSide(color: white),
                            ),
                            focusedBorder:const OutlineInputBorder(
                              borderSide: BorderSide(color: white),
                            ),
                            enabledBorder:const OutlineInputBorder(
                              borderSide: BorderSide(color: white),
                            ),
                            // labelText:"Your Name"
                          )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 80.0, right: 80.0),
                  child:isLoading == true? Center(child: CircularProgressIndicator(color: orange,)):CustomBtn(
                      text: "SUBMIT".tr,
                      bgColor: orange,
                      onTap: () {

                        if(orderText.text.isEmpty){
                          Fluttertoast.showToast(msg: "Please enter orderId");
                        }
                        else if(dropdownvalue == "Select your issue"){
                          Fluttertoast.showToast(msg: "Please select issue");
                        }
                        else if(issueText.text.isEmpty){
                          Fluttertoast.showToast(msg: "Please enter some remarks");
                        }

                        else{
                          setState(() {
                            isLoading =true;
                          });
                          addDataToUserDB();
                        }


                      }),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}