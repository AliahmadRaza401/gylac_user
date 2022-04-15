import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  String userId;
  double lat;
  String userName;
  double long;
  String phoneNumber;
  String image;
  String trackStatus;

  DriverModel({
    required this.trackStatus,
    required this.userName,required this.phoneNumber,required this.userId,required this.lat,required this.long,required this.image
  });

  Map<String, dynamic> toJson() => {
    'id': userId,
    'trackStatus': trackStatus,
    'latitude': lat,
    'longitude': long,
    'fullName': userName,
    'mobileNumber': phoneNumber,
    "dp":image
  };
  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      userId: map['id'] as String,
      trackStatus: map['trackStatus'] as String,
      lat: map['latitude'] as double,
      userName: map['fullName'] as String,
      long: map['longitude'] as double,
      phoneNumber: map['mobileNumber'] as String,
      image: map['dp'] as String,

    );
  }

  factory DriverModel.fromDocument(DocumentSnapshot doc) {
    String userId="";
    String phoneNumber="";
    double lat =0.0;
    double long =0.0;
    String userName ="";
    String image ="";
    String trackStatus = "";

    try {
      userId = doc.get("userId");
    } catch (e) {
      print(e);
    }

    try {
      lat = doc.get("latitude");
    }
    catch (e) {
      print(e);
    }
    try {
      long = doc.get("longitude");
    } catch (e) {
      print(e);
    }


    try {
      phoneNumber = doc.get("mobileNumber");
    } catch (e) {
      print(e);
    }

    try {
      userName = doc.get("fullName");
    } catch (e) {
      print(e);
    }

    try {
      userName = doc.get("dp");
    } catch (e) {
      print(e);
    }

    try {
      trackStatus = doc.get("trackStatus");
    } catch (e) {
      print(e);
    }


    return DriverModel(
      userId: userId,
      lat: lat,
      userName: userName,
      long: long,
      phoneNumber: phoneNumber,
      image:image,
      trackStatus:trackStatus
    );
  }
}
