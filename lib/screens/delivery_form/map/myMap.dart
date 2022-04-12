// // ignore_for_file: unused_field
//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
//
// import '../../../providers/create_delivery_provider.dart';
// import '../../../utils/app_colors.dart';
//
// class MyMap extends StatefulWidget {
//   MyMap({Key? key}) : super(key: key);
//
//   @override
//   _MyMapState createState() => _MyMapState();
// }
//
// class _MyMapState extends State<MyMap> {
//   CreateDeliveryProvider? _createDeliveryProvider;
//   @override
//   void initState() {
//     super.initState();
//     _createDeliveryProvider =
//         Provider.of<CreateDeliveryProvider>(context, listen: false);
//   }
//
//   final Set<Marker> markers =  Set(); //markers for google map
//   var currentLaltg;
//   bool loading = true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryColor,
//         title: Text(
//           "Select Location",
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: Container(
//         child: Stack(
//           children: [
//             // loading == true
//             //     ? CircularProgressIndicator()
//             //     :
//             GoogleMap(
//               mapType: MapType.normal,
//               myLocationButtonEnabled: false,
//               myLocationEnabled: true,
//               zoomControlsEnabled: true,
//               zoomGesturesEnabled: true,
//               markers: markers,
//               onMapCreated: (GoogleMapController newMapController) async {
//                 print("Map Created");
//                 setState(() {
//                   loading = false;
//                   _createDeliveryProvider!.completerController
//                       .complete(newMapController);
//
//                   _createDeliveryProvider!.mapController = newMapController;
//                 });
//                 currentLaltg =
//                     await _createDeliveryProvider!.locatePosition(context);
//                 addmarkers(currentLaltg);
//               },
//               initialCameraPosition:
//                   _createDeliveryProvider!.initialCameraPosition,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Set<Marker> addmarkers(LatLng showLocation) {
//     print("Add Marker-------------------------------");
//     //markers to place on map
//     setState(() {
//       markers.add(Marker(
//         //add first marker
//         markerId: MarkerId(showLocation.toString()),
//         position: showLocation, //position of marker
//         infoWindow: InfoWindow(
//           //popup info
//           title: 'Marker Title First ',
//           snippet: 'My Custom Subtitle',
//         ),
//         icon: BitmapDescriptor.defaultMarker, //Icon for Marker
//       ));
//
//       //add more markers here
//     });
//
//     return markers;
//   }
// }
