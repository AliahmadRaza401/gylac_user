import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/colors.dart';
import '../utils/image.dart';
import '../utils/innerShahdow.dart';
import '../widgets/App_Menu.dart';
import '../widgets/orderTile.dart';
class MyOrders extends StatefulWidget {
  MyOrders({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  var scaffoldState = GlobalKey<ScaffoldState>();

bool pickup_pressed = false;
bool del_pressed = false;

  @override
  Widget build(BuildContext context) {
   // UserProvider userProvider = Provider.of<UserProvider>(context);

    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        backgroundColor: Colors.grey[200],
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
            title:const Text('My Orders', style: TextStyle(
                color: white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily: 'Roboto')),
          ),
        drawer: AppMenu(),
     body:  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
       stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("orders").snapshots(),
       builder: (BuildContext context, snapshot) {
         if (snapshot.data == null) {
           return const Center(child: CircularProgressIndicator(color: orange));
         }

         else {
           final List<QueryDocumentSnapshot<Map<String, dynamic>>> orders = snapshot.data!.docs;

           return orders.isNotEmpty?ListView.builder(
             itemCount: orders.length,
             itemBuilder: (context, index) {
               return Padding(
                 padding: const EdgeInsets.all(10.0),
                 child: InnerShadow(
                   blur: 5,
                   color: brownDark,
                   offset:const Offset(0,3),
                   child: Container(

                     decoration: BoxDecoration(
                         color: white,
                         border: Border.all(color: orange,width: 2),
                         borderRadius: BorderRadius.circular(30)
                     ),
                     child: Padding(
                       padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 20),
                       child: Column(
                         children: [
                           const SizedBox(height: 10,),
                           Row(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Row(
                                 children: [
                                   orders[index]["driverImage"].isNotEmpty
                                       ? Image.network(
                                     orders[index]["driverImage"],
                                     fit: BoxFit.cover,
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
                                       Text(orders[index]["driverName"],style:  const TextStyle(fontFamily: 'Roboto',fontSize: 18,fontWeight: FontWeight.bold)),
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
                               Text(orders[index]["orderPrice"].toString()+" MNT",style:  const TextStyle(fontFamily: 'Roboto',fontSize: 18,fontWeight: FontWeight.bold),)
                             ],
                           ),
                           const Divider(color: orange,height: 10,thickness: 3,),
                           const SizedBox(height: 10,),
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
                                                   child: Text(orders[index]["pickupAddress"],style:  const TextStyle(fontFamily: 'Poppins',fontSize: 10,fontWeight: FontWeight.w500))),
                                               const SizedBox(width: 10,),
                                               Text(orders[index]["duration"].toString(),style:  const TextStyle(fontFamily: 'Poppins',fontSize: 10,fontWeight: FontWeight.bold,color: orange)),
                                             ],
                                           ),
                                           Row(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               SizedBox( width:150,child: Text(orders[index]["destinationAddress"],style:  const TextStyle(fontFamily: 'Poppins',fontSize: 8,fontWeight: FontWeight.w300))),
                                               const SizedBox(width: 10,),
                                               Text(orders[index]["distance"].toString(),style:  const TextStyle(fontFamily: 'Poppins',fontSize: 10,fontWeight: FontWeight.w500)),
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
                                   orders[index]["vehicleType"] == "VAN"?Image.asset(vanimage,width: 60,height: 60,):
                                   orders[index]["vehicleType"] == "CAR"?Image.asset(carimage,width: 60,height: 60,):
                                   orders[index]["vehicleType"] == "SCOOTER"?Image.asset(scooterimage,width: 60,height: 60,):
                                   orders[index]["vehicleType"] == "TRUCK"?Image.asset(truckimage,width: 60,height: 60,):
                                   orders[index]["vehicleType"] == "BIKE"?Image.asset(cycleimage,width: 60,height: 60,):
                                   orders[index]["vehicleType"] == "MINI TRUCK"?Image.asset(miniTruckimage,width: 60,height: 60,):
                                   Image.asset("assets/images/Group 8504.png",width: 60,height: 60,),
                                   Text(orders[index]["vehicleType"],style:  const TextStyle(fontFamily: 'Poppins',fontSize: 8,fontWeight: FontWeight.w600))
                                 ],
                               )
                             ],
                           ),
                           const SizedBox(height: 10,),
                           const Divider(color: orange,height: 10,thickness: 3,),
                           const SizedBox(height: 10,),
                         ],
                       ),
                     ),
                   ),
                 ),
               );

             },
           ):
           Column(
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
                   child: Text("No Orders",
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

        )
        
        
        );
          
}

}







