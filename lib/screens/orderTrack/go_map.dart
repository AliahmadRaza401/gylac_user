// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields

import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gyalcuser_project/constants/keys.dart';
import 'package:gyalcuser_project/screens/feeback/reviewScreen.dart';
import 'package:gyalcuser_project/screens/home/home_page.dart';
import 'package:gyalcuser_project/widgets/custom_btn.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../models/driverModel.dart';
import '../../providers/create_delivery_provider.dart';
import '../../utils/image.dart';
import '../../utils/innerShahdow.dart';
import 'distace_calculate.dart';
import 'map_services.dart';
import 'map_widget.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class TrackMap extends StatefulWidget {
  const TrackMap({Key? key}) : super(key: key);

  @override
  State<TrackMap> createState() => _TrackMapState();
}

class _TrackMapState extends State<TrackMap> {
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
  var barbarID;
  late LatLng liveLocation;
  late DriverModel driverModel;
  late Timer timer;
  late CreateDeliveryProvider deliveryProvider;




  /////////////////////////////////////////////////////////////////////////////////////////
  Uint8List? markerIcon;
  Uint8List? startMarkerIcon;
  Uint8List? endMarkerIcon;
  final Set<Marker> _marker = <Marker>{};

  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  GoogleMapController? mapController;
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deliveryProvider = Provider.of<CreateDeliveryProvider>(context, listen: false);
    //_polylinePoints = PolylinePoints();
    setCustomMarker();
    startCustomMarker();
    endCustomMarker();
    polylinePoints = PolylinePoints();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Uint8List> getBytesFromAssetStart(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Uint8List> getBytesFromAssetEnd(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void showLocationPins() {
    var sourceposition = LatLng(double.parse(deliveryProvider.pickupLat),double.parse(deliveryProvider.pickupLong));
    var destinationPosition = LatLng(double.parse(deliveryProvider.deliveryLat),double.parse(deliveryProvider.deliveryLong));

    _marker.add(Marker(
      markerId: const MarkerId('sourcePosition'),
      position: sourceposition,
      icon: BitmapDescriptor.fromBytes(startMarkerIcon!),
    ));

    _marker.add(
      Marker(
        markerId: const MarkerId('destinationPosition'),
        position: destinationPosition,
       icon: BitmapDescriptor.fromBytes(endMarkerIcon!),
      ),
    );


  }

  final Set<Polyline> _polylines = <Polyline>{};

  setPolylines() async {
    var result = await polylinePoints.getRouteBetweenCoordinates(
        mapKey,
        PointLatLng(double.parse(deliveryProvider.pickupLat),double.parse(deliveryProvider.pickupLong)),
        PointLatLng(double.parse(deliveryProvider.deliveryLat),double.parse(deliveryProvider.deliveryLong)));

    if (result.points.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    if(mounted) {
      setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: const PolylineId("ID"),
          width: 5,
          color: darkBlue,
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map

      _polylines.add(polyline);


    });
    }

    LatLngBounds bound;
    if(double.parse(deliveryProvider.pickupLat) > double.parse(deliveryProvider.deliveryLat) && double.parse(deliveryProvider.pickupLong) >  double.parse(deliveryProvider.deliveryLong)){
      bound= LatLngBounds(southwest: LatLng(double.parse(deliveryProvider.deliveryLat),double.parse(deliveryProvider.deliveryLong)), northeast: LatLng(double.parse(deliveryProvider.pickupLat),double.parse(deliveryProvider.pickupLong)));
    }
    else if(double.parse(deliveryProvider.pickupLong) > double.parse(deliveryProvider.deliveryLong)){
      bound= LatLngBounds(southwest: LatLng(double.parse(deliveryProvider.pickupLat),double.parse(deliveryProvider.deliveryLong)), northeast: LatLng( double.parse(deliveryProvider.deliveryLat),double.parse(deliveryProvider.pickupLong)));
    }
    else if(double.parse(deliveryProvider.pickupLat) >  double.parse(deliveryProvider.deliveryLat)){
      bound= LatLngBounds(southwest: LatLng( double.parse(deliveryProvider.deliveryLat),double.parse(deliveryProvider.pickupLong)), northeast: LatLng(double.parse(deliveryProvider.pickupLat),double.parse(deliveryProvider.deliveryLong)));
    }
    else{
      bound= LatLngBounds(southwest: LatLng(double.parse(deliveryProvider.pickupLat),double.parse(deliveryProvider.pickupLong)), northeast: LatLng( double.parse(deliveryProvider.deliveryLat),double.parse(deliveryProvider.deliveryLong)));
    }
    final GoogleMapController controller =
    await _controller.future;
    controller.animateCamera(
        CameraUpdate.newLatLngBounds(bound, 100));


  }

  void setCustomMarker() async {
    await getBytesFromAsset('assets/images/top_car.png', 40).then((value) {
      setState(() {
        markerIcon = value;
      });
    });
  }

  void startCustomMarker() async {
    await getBytesFromAssetStart('assets/images/top_car.png', 40)
        .then((value) {
      setState(() {
        startMarkerIcon = value;
      });
    });
  }

  void endCustomMarker() async {
    await getBytesFromAsset('assets/images/mapmarker.png', 60)
        .then((value) {
      setState(() {
        endMarkerIcon = value;
      });
    });
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////

//  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  late GoogleMapController _mapController;
  late GoogleMapController _cntlr;

  void _onMapCreated(
      _cntlr,
      ) {
    _mapController = _cntlr;
    setState(() {
      LatLngBounds bound;
      if(double.parse(deliveryProvider.pickupLat) > double.parse(deliveryProvider.deliveryLat) && double.parse(deliveryProvider.pickupLong) >  double.parse(deliveryProvider.deliveryLong)){
        bound= LatLngBounds(southwest: LatLng(double.parse(deliveryProvider.deliveryLat),double.parse(deliveryProvider.deliveryLong)), northeast: LatLng(double.parse(deliveryProvider.pickupLat),double.parse(deliveryProvider.pickupLong)));
      }
      else if(double.parse(deliveryProvider.pickupLong) > double.parse(deliveryProvider.deliveryLong)){
        bound= LatLngBounds(southwest: LatLng(double.parse(deliveryProvider.pickupLat),double.parse(deliveryProvider.deliveryLong)), northeast: LatLng( double.parse(deliveryProvider.deliveryLat),double.parse(deliveryProvider.pickupLong)));
      }
      else if(double.parse(deliveryProvider.pickupLat) >  double.parse(deliveryProvider.deliveryLat)){
        bound= LatLngBounds(southwest: LatLng( double.parse(deliveryProvider.deliveryLat),double.parse(deliveryProvider.pickupLong)), northeast: LatLng(double.parse(deliveryProvider.pickupLat),double.parse(deliveryProvider.deliveryLong)));
      }
      else{
        bound= LatLngBounds(southwest: LatLng(double.parse(deliveryProvider.pickupLat),double.parse(deliveryProvider.pickupLong)), northeast: LatLng( double.parse(deliveryProvider.deliveryLat),double.parse(deliveryProvider.deliveryLong)));
      }

      _mapController.animateCamera(
          CameraUpdate.newLatLngBounds(bound, 100));

    });

    showLocationPins();
    setPolylines();
   // locatePosition(context);
  }

  getLiveBarbar() {
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      getBarbarData();
    });
  }


 Future getBarbarData() async {
    try {
      await FirebaseFirestore.instance
          .collection('drivers')
          .where('id', isEqualTo: deliveryProvider.driverId)
          .get()
          .then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.forEach((doc) {

          if(mounted) {
            setState(() {
            liveLocation = LatLng(double.parse(doc["latitude"]), double.parse(doc["longitude"]));
          });
          }
        }),
        if (driverModel.lat != null)
          {
            setState(() {
              markers.removeWhere(
                      (marker) => marker.markerId.value == 'barbar');
              circle.removeWhere(
                      (circle) => circle.circleId.value == 'barbar');

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
        title:const Text('TRACK YOUR ORDER', style: TextStyle(
            color: white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Roboto')),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              // initialCameraPosition:
              // CameraPosition(target: _initialcameraposition),
              initialCameraPosition: CameraPosition(target: LatLng(double.parse(deliveryProvider.pickupLat),double.parse(deliveryProvider.pickupLong)),zoom: 14.5),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              // markers: markers,
              // circles: circle,
              // polylines: _polyline,
              markers: _marker,
              polylines: _polylines,
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
                      Text(deliveryProvider.duration,style: TextStyle(fontSize: 14,fontFamily: 'Poppins',fontWeight: FontWeight.bold,color: darkBlue))
                    ],
                  ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: orange.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text("Driver Current Location -  Old Town Street No.10",style: TextStyle(fontSize: 12,fontFamily: 'Poppins',fontWeight: FontWeight.w300,color: darkBlue),
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
           // bottomDistanceCancelBtn(context, rideTime, ridedistance,deliveryProvider.driverId),
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
      destination = LatLng(position.latitude, position.longitude);

      CameraPosition cameraPosition = CameraPosition(target: destination, zoom: 14);
      _mapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      getLiveBarbar();
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
          // infoWindow:
          //     InfoWindow(title: "${barber.firstName + " " + barber.lastName}"),
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(markerIcon)));

      //add more markers here

      circle.add(Circle(
          circleId: CircleId("barbar"),
          // radius: showLocation.accuracy,
          radius: 50,
          zIndex: 1,
          strokeColor: Colors.red,
          strokeWidth: 2,
          center: showLocation,
          fillColor: Colors.red.withAlpha(70)));
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
    //_disposeController();
    super.dispose();
    _polylines.clear();
    timer.cancel();
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _mapController;
    controller.dispose();

    print("Map is Dispose___________________________");
  }

}



