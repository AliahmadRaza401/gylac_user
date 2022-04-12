import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  String userId;
  String lat;
  String userName;
  String long;
  String phoneNumber;


  DriverModel({
    required this.userName,required this.phoneNumber,required this.userId,required this.lat,required this.long
  });

  Map<String, dynamic> toJson() => {
    'id': userId,
    'latitude': lat,
    'longitude': long,
    'fullName': userName,
    'mobileNumber': phoneNumber,
  };

  factory DriverModel.fromDocument(DocumentSnapshot doc) {
    String userId="";
    String phoneNumber="";
    String lat ="";
    String long ="";
    String userName ="";

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


    return DriverModel(
      userId: userId,
      lat: lat,
      userName: userName,
      long: long,
      phoneNumber: phoneNumber,
    );
  }
}
