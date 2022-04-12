//
// import 'package:flutter/material.dart';
// import 'package:gyalcproject/locators/service_locator.dart';
// import 'package:gyalcproject/providers/app_state.dart';
// import 'package:gyalcproject/services/call_sms.dart';
//
// import 'package:provider/provider.dart';
//
//
// import '../helpers/style.dart';
// import 'custom_text.dart';
//
// class RiderWidget extends StatelessWidget {
//   final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
//
//   @override
//   Widget build(BuildContext context) {
//     AppStateProvider appState = Provider.of<AppStateProvider>(context);
//
//     return DraggableScrollableSheet(
//         initialChildSize: 0.43,
//         minChildSize: 0.43,
//
//         builder: (BuildContext context, myscrollController) {
//           return Container(
//
//             decoration: BoxDecoration(color: white,
//
//                 boxShadow: [
//                   BoxShadow(
//                       color: grey.withOpacity(.8),
//                       offset: Offset(3, 2),
//                       blurRadius: 7)
//                 ]),
//             child: Column(children: [
//               Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: CustomText(
//                     text: "Order details",
//                     size: 18,
//                     weight: FontWeight.bold,
//                   ),
//                 ),
//                 Column(children: [
//                    Container(
//                     height: 40,
//                     width: 375,
//                     alignment: Alignment.centerLeft,
//                     child: Text("Parcel Details",style: TextStyle(fontWeight:FontWeight.bold),),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left:10.0),
//                   child: Row(children: [
//                     Container(
//                       height: 40,
//                       width: 175,
//                       alignment: Alignment.centerLeft,
//                       child: Text("Parcel Name",style: TextStyle(fontWeight:FontWeight.bold),),
//                   ),
//                   Container(
//                       height: 40,
//                       width: 175,
//                       alignment: Alignment.center,
//                       child: Text(appState.rideRequestModel.pickup["pickupParcelName"],style: TextStyle(fontWeight:FontWeight.bold),),
//                   ),
//               ],),
//                 ),
//               Padding(
//                 padding: const EdgeInsets.only(left:10.0),
//                 child: Row(children: [
//                     Container(
//                       height: 40,
//                       width: 175,
//                       alignment: Alignment.centerLeft,
//                       child: Text("Weight",style: TextStyle(fontWeight:FontWeight.bold),),
//                   ),
//                   Container(
//                       height: 40,
//                       width: 175,
//                       alignment: Alignment.center,
//                       child: Text(appState.rideRequestModel.pickup["pickupParcelWeight"]+" KG",style: TextStyle(fontWeight:FontWeight.bold),),
//                   ),
//                 ],),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left:10.0),
//                 child: Row(children: [
//                     Container(
//                       height: 40,
//                       width: 175,
//                       alignment: Alignment.centerLeft,
//                       child: Text("Description",style: TextStyle(fontWeight:FontWeight.bold),),
//                   ),Container(
//                       height: 40,
//                       width: 175,
//                       alignment: Alignment.center,
//                       child: Text(appState.rideRequestModel.pickup["pickupParcelDesc"],style: TextStyle(fontWeight:FontWeight.bold),),
//                   ),
//                 ],),
//               ),
//                 ],),
//               Padding(
//                 padding: const EdgeInsets.only(left:10.0),
//                 child: ListTile(leading: Image.asset("images/desticon.png",height: 30,width: 30,),
//                 title: Text("Pickup Location",style: TextStyle(fontWeight:FontWeight.bold),),
//                 subtitle: Text(appState.rideRequestModel.pickup["address"]),
//                 )
//               ),
//
//             ],),
//           );
//         });
//   }
// }
