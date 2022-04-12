// import 'package:flutter/cupertino.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
//
// class LocationProvider with ChangeNotifier {
//   // Address pickUpLocation, dropOffLocation;
//
//   bool isLoadingPickLocation = true;
//    Position? currentPosition;
//   var geolocator = Geolocator();
//
//   //////////////////////////////////////////////////
//   TextEditingController pickUpTextEditingController = TextEditingController();
//   TextEditingController dropOffTextEditingController = TextEditingController();
//   bool pickUp = false;
//   // List<Placepredictions> dropOFPredictionList = [];
//   // List<Placepredictions> pickUpPredictionList = [];
//   ///////////////////////////////////////////////////////
//   List<LatLng> pLineCoordinate = [];
//   Set<Polyline> polylineSet = {};
//
//   Set<Marker> markersSet = {};
//   Set<Circle> circlesSet = {};
//
//   double rideDetailContainerHeight = 0;
//   double searchContainerHeight = 300.0;
//   // late DirectionDetails tripdirectionDetails;
//   double bottomPaddingOfMap = 0;
// /*
//   void updatePickUpLocationAddress(Address pickUpAddress) {
//     pickUpLocation = pickUpAddress;
//     isLoadingPickLocation = false;
//     notifyListeners();
//   }
//
//   void updateDropOffLocationAddress(Address dropOffAddress) {
//     dropOffLocation = dropOffAddress;
//     notifyListeners();
//   }
// */
//
//   void waiting(value) {
//     pickUp = true;
//     isLoadingPickLocation = value;
//
//     notifyListeners();
//   }
// }
