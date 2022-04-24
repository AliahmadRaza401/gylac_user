import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  String userId;
  double lat;
  String userName;
  double long;
  String phoneNumber;
  String image;
  String trackStatus;
  int wallet;
  int level;
  DriverModel({
    required this.trackStatus,
    required this.userName,
    required this.phoneNumber,
    required this.userId,
    required this.lat,
    required this.long,
    required this.image,
    required this.wallet,
    required this.level,
  });

  Map<String, dynamic> toJson() => {
        'id': userId,
        'trackStatus': trackStatus,
        'latitude': lat,
        'longitude': long,
        'fullName': userName,
        'mobileNumber': phoneNumber,
        "dp": image,
        "level": level,
        "wallet": wallet,
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
      level: map['level'] as int,
      wallet: map['wallet'] as int,
    );
  }

  factory DriverModel.fromDocument(DocumentSnapshot doc) {
    String userId = "";
    String phoneNumber = "";
    double lat = 0.0;
    double long = 0.0;
    String userName = "";
    String image = "";
    String trackStatus = "";
    int level = 0;
    int wallet = 0;

    try {
      userId = doc.get("userId");
    } catch (e) {
      print(e);
    }

    try {
      lat = doc.get("latitude");
    } catch (e) {
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

    try {
      level = doc.get("level");
    } catch (e) {
      print(e);
    }

    try {
      wallet = doc.get("wallet");
    } catch (e) {
      print(e);
    }

    return DriverModel(
      userId: userId,
      lat: lat,
      userName: userName,
      long: long,
      phoneNumber: phoneNumber,
      image: image,
      trackStatus: trackStatus,
      level: level,
      wallet: wallet,
    );
  }
}
