import 'dart:async';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateDeliveryProvider extends ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  final pickFormkey = GlobalKey<FormState>();
  final deliveryFormkey = GlobalKey<FormState>();

  bool pickUpVisible = false;
  bool deliveryVisible = false;

  TextEditingController pickEmail = TextEditingController();
  TextEditingController pickAddress = TextEditingController();
  TextEditingController pickName = TextEditingController();
  TextEditingController pickPhone = TextEditingController();
  TextEditingController pickParcelName = TextEditingController();
  TextEditingController pickParcelWeight = TextEditingController();
  TextEditingController pickDescription = TextEditingController();
  TextEditingController pickPrice = TextEditingController();

  TextEditingController deliveryEmail = TextEditingController();
  TextEditingController deliveryAddress = TextEditingController();
  TextEditingController deliveryName = TextEditingController();
  TextEditingController deliveryPhone = TextEditingController();
  TextEditingController deliveryDescription = TextEditingController();

  String scheduleOrder = "";
  String parcel = "";
  String date = "";
  String time = "";
  String vehicle = "";
  String pickupLat = "";
  String pickupLong = "";
  String deliveryLat = "";
  String deliveryLong = "";
  String distance = "";
  String duration = "";
  int driverLength = 0;
  int rejectionCount = 0;
  String orderId = "";

  String driverId = "";
  double driverLat = 0.0;
  double driverLong = 0.0;
  String driverName = "";
  String driverMobile = "";
  String driverImage = "";

  final requiredValidator = RequiredValidator(errorText: 'Required');
  final emailValidator =
      EmailValidator(errorText: 'Enter a valid email address');

  deliveryVisibleFalse() {
    deliveryVisible = false;
    notifyListeners();
  }

  pickVisibleFalse() {
    pickUpVisible = false;
    notifyListeners();
  }

  //Map
  late Position currentPosition;
  var geolocator = Geolocator();
  Completer<GoogleMapController> completerController = Completer();
// late GoogleMapController mapController;
  late LatLng currentlatLatPosition;
  CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.77483, -122.41942),
    zoom: 12,
  );
  late CameraPosition currentCameraPosition;
  String address = '';

  Future locatePosition(BuildContext context) async {
    print('i am in the location function');
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPosition = position;
    print('currentPosition: $currentPosition');

    currentlatLatPosition = LatLng(position.latitude, position.longitude);
    currentCameraPosition =
        CameraPosition(target: currentlatLatPosition, zoom: 14);
    // address = await AssistantMethods.searchCoordinateAddress(position, context);
    // print('This is your address ::' + address);
    //  mapController.animateCamera(CameraUpdate.newCameraPosition(currentCameraPosition));
    notifyListeners();
    return currentlatLatPosition;
  }
}
