import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;


double calculateHarvesineDistanceInKM(
  LatLng start,
  LatLng destination,
) {
  double lat1 = start.latitude;
  double lon1 = start.longitude;
  double lat2 = destination.latitude;
  double lon2 = destination.longitude;

  double dLat = lat2 * (math.pi / 180) - lat1 * (math.pi / 180);
  double dLon = lon2 * (math.pi / 180) - lon1 * (math.pi / 180);

  double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1 * (math.pi / 180)) *
          math.cos(lat2 * (math.pi / 180)) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);

  double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  double d = 6371 * c;

  return d;
}

double calculateETAInMinutes(double distanceInKM, double speedInKMH) {
  return (distanceInKM / speedInKMH) * 60;
}

double calculateRouteLengthInKM(List<LatLng> polylineCoordinates) {
  double totalDistance = 0.0;

// Calculating the total distance by adding the distance
// between small segments

  for (int i = 0; i < polylineCoordinates.length - 1; i++) {
    totalDistance += Geolocator.distanceBetween(
      polylineCoordinates[i].latitude,
      polylineCoordinates[i].longitude,
      polylineCoordinates[i + 1].latitude,
      polylineCoordinates[i + 1].longitude,
    );
  }
  return totalDistance / 1000;
}

// Future<List<LatLng>> getPolyLineCoordinates(
//   LatLng start,
//   LatLng destination,
// ) async {
//   // Initializing PolylinePoints
//   var polylinePoints = PolylinePoints();
//   List<LatLng> polylineCoordinates = [];

//   // Generating the list of coordinates to be used for
//   // drawing the polylines
//   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//   googlMapKey, // Google Maps API Key
//     PointLatLng(start.latitude, start.longitude),
//     PointLatLng(destination.latitude, destination.longitude),
//     travelMode: TravelMode.driving,
//   );

//   // Adding the coordinates to the list
//   if (result.points.isNotEmpty) {
//     result.points.forEach((PointLatLng point) {
//       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//     });
//   }

//   return polylineCoordinates;
// }
