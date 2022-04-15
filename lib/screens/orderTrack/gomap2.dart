// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields

import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gyalcuser_project/chat/chat_handler.dart';
import 'package:provider/provider.dart';
import '../../chat/chat_room.dart';
import '../../chat/model/chat_room_model.dart';
import '../../chat/model/user_model.dart';
import '../../constants/colors.dart';
import '../../constants/keys.dart';
import '../../models/driverModel.dart';
import '../../providers/create_delivery_provider.dart';
import '../../providers/userProvider.dart';
import '../../utils/app_route.dart';
import '../../utils/image.dart';
import '../../utils/innerShahdow.dart';
import '../feeback/reviewScreen.dart';
import '../home/home_page.dart';
import 'distace_calculate.dart';
import 'map_services.dart';
import 'map_widget.dart';

class GoMap extends StatefulWidget {
  String driverId;
  GoMap({required this.driverId,});

  @override
  State<GoMap> createState() => _GoMapState();
}

class _GoMapState extends State<GoMap> {

  
  final Set<Marker> _markers = {};
  late LatLng currentLaltg;
  final Set<Marker> markers = new Set();
  Set<Polyline> _polyline = Set<Polyline>();
  List<LatLng> _polylineCoordinates = [];
  late PolylinePoints _polylinePoints;
  final Set<Circle> circle = Set<Circle>();
  var rideTime = 0.0;
  var ridedistance = 0.0;
  late LatLng destination;
 
  late LatLng liveLocation;
  DriverModel? driver;
  late Timer timer;
  late UserProvider _userProvider;
  late CreateDeliveryProvider deliveryProvider;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _polylinePoints = PolylinePoints();
    getLiveBarbar();
    deliveryProvider = Provider.of<CreateDeliveryProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  late GoogleMapController _mapController;
  late GoogleMapController _cntlr;

  void _onMapCreated(
      cntlr,
      ) {
    _mapController = cntlr;

    //locatePosition(context);
  }

  getLiveBarbar() {
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      getBarbarData();
    });
  }

  Future getBarbarData() async {
    try {
      await FirebaseFirestore.instance
          .collection('drivers')
          .where('id', isEqualTo: widget.driverId)
          .get()
          .then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.forEach((doc) {
          print('barber....');
          print(doc.data());
          driver = DriverModel.fromMap(doc.data() as Map<String, dynamic>);
          print(driver!.lat);

          setState(() {
            liveLocation = LatLng(driver!.lat, driver!.long);
          });
        }),
        if (driver!.lat !=null)
          {
            setState(() {
              markers.removeWhere(
                      (marker) => marker.markerId.value == 'barbar');

              barbarMarkers(liveLocation);
              // distance time
              ridedistance = calculateHarvesineDistanceInKM(
                  liveLocation, destination);
              rideTime = calculateETAInMinutes(ridedistance, 30);
            }),
            if (ridedistance == 0 || ridedistance < 0.10)
              {
                print("barber Reached____________________________"),
                timer.cancel(),

              },
            if (_polylineCoordinates == null ||
                _polylineCoordinates.isEmpty)
              {
                setPolylineOnMap(
                  liveLocation.latitude,
                  liveLocation.longitude,
                  destination.latitude,
                  destination.longitude,
                )
              }
          }
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          onPressed: () => Navigator.pop(context),
          icon:const Icon(
            FontAwesomeIcons.reply,
            color: white,
          ),
        ),
        backgroundColor:orange,
        elevation: 5,
        shadowColor: blackLight,
        title: Text('TRACK YOUR ORDER ', style: TextStyle(
            color: white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Roboto')),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition:
              CameraPosition(target: _initialcameraposition),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: false,
              markers: markers,
              circles: circle,
              polylines: _polyline,
            ),
            Container(
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(20)
              ),
              height: 80,
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("YOUR DRIVER WILL ARRIVE IN",style: TextStyle(fontSize: 12,fontFamily: 'Poppins',fontWeight: FontWeight.bold,color: darkBlue),),
                        Text(rideTime.toStringAsFixed(2)+ " mins",style: TextStyle(fontSize: 14,fontFamily: 'Poppins',fontWeight: FontWeight.bold,color: darkBlue))
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: orange.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text("Driver Distance -  ${ridedistance.toStringAsFixed(2)} km",style: TextStyle(fontSize: 12,fontFamily: 'Poppins',fontWeight: FontWeight.w300,color: darkBlue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:2.0,right: 2.0),
                    child: InnerShadow(
                      blur: 5,
                      color: brownDark,
                      offset:Offset(0,3),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10)
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
                                      GestureDetector(
                                        onTap: () async {
                                          log(widget.driverId.toString());
                                          ChatRoomModel? chatRoomModel =
                                          await chatHandler.getChatRoom(
                                              widget.driverId,
                                              FirebaseAuth
                                                  .instance.currentUser!.uid);

                                          if (chatRoomModel != null) {
                                            AppRoutes.push(
                                                context,
                                                ChatRoom(
                                                  targetUser: UserModel(
                                                    uid: driver!.userId.toString(),
                                                    fullname: driver!.userName.toString(),
                                                    email: 'test@gmail.com',
                                                    profilepic: driver!.image.toString(),
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
                  Container(
                    decoration: BoxDecoration(
                      color: white,
                    ),

                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(onPressed: (){
                          openDialog();
                        }, child: Text("Order Cancel"),
                          style: TextButton.styleFrom(
                              primary: black,
                              backgroundColor: white,
                              textStyle: const TextStyle(fontFamily: "Poppins",fontSize: 12,decoration: TextDecoration.underline,)),
                        ),
                        TextButton(onPressed: (){
                          completeOrder();

                        }, child: Text("COMPLETE"),
                          style: TextButton.styleFrom(
                              primary: white,
                              backgroundColor: greenColor,
                              textStyle: const TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold,fontSize: 15,)),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            // bottomDistanceCancelBtn(context, rideTime, ridedistance),
          ],
        ),
      ),
    );
  }

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                color: orange,
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Image.asset("assets/images/orderFailed.png",width: 50,height: 50,),
                      margin: const EdgeInsets.only(bottom: 10),
                    ),
                    const Text(
                      'Cancel Order',
                      style: TextStyle(color: Colors.white,fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Are you sure you want to cancel order?',
                      style: TextStyle(color: Colors.white70, fontFamily: 'Poppins',fontSize: 13),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: const Icon(
                        Icons.cancel,
                        color: orange,
                      ),
                      margin: const EdgeInsets.only(right: 10),
                    ),
                    const Text(
                      'Cancel',
                      style: TextStyle(color: orange, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: const Icon(
                        Icons.check_circle,
                        color: orange,
                      ),
                      margin: const EdgeInsets.only(right: 10),
                    ),
                    const Text(
                      'Yes',
                      style: TextStyle(color: orange,fontFamily: 'Poppins', fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        setState(() {
          isLoading = true;
        });
        cancelOrder();

    }
  }

  Future cancelOrder() async{
    firebaseFirestore
        .collection("orders")
        .doc(deliveryProvider.orderId)
        .update({
      "orderStatus": "cancelled",
    });
    firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("orders")
        .doc(deliveryProvider.orderId)
        .update({
      "OrderStatus": "cancelled",
    }).then((data) async {
      firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("notifications")
          .doc(deliveryProvider.orderId)
          .set({
        "msg": "Order ${deliveryProvider.orderId} has been cancelled.",
        "status": "cancelled",
        "timestamp": FieldValue.serverTimestamp(),
        "title": "Order Cancelled",
      });
      setState(() {
        isLoading = false;
      });
      Future.delayed(Duration(seconds: 2), () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage())
        );
      });

    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });

  }

  Future completeOrder() async{
    firebaseFirestore
        .collection("orders")
        .doc(deliveryProvider.orderId)
        .update({
      "orderStatus": "completed",
    });
    firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("orders")
        .doc(deliveryProvider.orderId)
        .update({
      "OrderStatus": "completed",
    }).then((data) async {
      firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("notifications")
          .doc(deliveryProvider.orderId)
          .set({
        "msg": "Order ${deliveryProvider.orderId} has been successfully completed",
        "status": "completed",
        "timestamp": FieldValue.serverTimestamp(),
        "title": "Order Completed",
      });
      Fluttertoast.showToast(msg: "Order Completed",backgroundColor: greenColor);
      setState(() {
        isLoading = false;
      });
      Future.delayed(Duration(seconds: 2), () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReviewScreen())
        );
      });

    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });

  }

  locatePosition(
      BuildContext context,
      ) async {
    print('i am in the location function');

    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    LocationPermission status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      print("Location is Off =======================>>");
    } else {
      print("Location is ON =======================>>");
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      var currentPosition = position;
      destination = LatLng(double.parse(deliveryProvider.deliveryLat),double.parse(deliveryProvider.deliveryLong));

      // barberMarkers(latLatPosition);

      CameraPosition cameraPosition = CameraPosition(target: destination, zoom: 14);
      _mapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    }
  }

  void setPolylineOnMap(double startLat, double startLong, double destiLat,
      double destiLong) async {
    print("String Polyline..............................");

    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        mapKey,
        PointLatLng(startLat, startLong),
        PointLatLng(destiLat, destiLong));
    if (result.status == "OK") {
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      userMarkers(LatLng(destiLat, destiLong));
      setState(() {
        _polyline.add(Polyline(
            width: 5,
            polylineId: PolylineId('polyline'),
            color: Colors.red,
            points: _polylineCoordinates));
      });
    } else {
      print("Polyline Not Generated!!!!!!!!!!!!!!!!");
    }
  }

  Future<Set<Marker>> barbarMarkers(showLocation) async {
    final Uint8List markerIcon = await MapServices.getMarkerWithSize(100);
    //markers to place on map
    setState(() {
      markers.add(Marker(
          markerId: MarkerId('barbar'),
          position: showLocation,
          infoWindow:
          InfoWindow(title: driver!.userName),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(markerIcon)));


    });
    return markers;
  }

  Future<Set<Marker>> userMarkers(showLocation) async {
    setState(() {
      markers.add(Marker(
        markerId: MarkerId("user"),
        position: showLocation,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    });
    return markers;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _mapController;
    controller.dispose();
    timer.cancel();

    print("Map is Dispose___________________________");
  }
}