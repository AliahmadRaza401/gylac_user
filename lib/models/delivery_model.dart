import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryModel {
  String pickupAddress;
  String pickupName;
  String pickupEmail;
  String pickupPhone;
  String pickupParcelName;
  String pickupParcelWeight;
  String pickupParcelDesc;
  String pickupDeliveryPrice;
  String pickupLat;
  String pickupLong;

  String deliveryAddress;
  String deliveryName;
  String deliveryEmail;
  String deliveryPhone;
  String deliveryParcelDesc;
  String deliveryLat;
  String deliveryLong;

  String parcel;

  String checkIllegal;

  String vehicle;

  String tracking;
  String userid;
  String userName;
  String orderType;
  String orderTime;
  String orderStatus;
  String orderDate;
  String driverId;
  String distance;
  String time;
  String orderID;
  int rejectCount;
  List rejections;
  String trackStatus;
  DateTime createdAt;

  DeliveryModel({
    required this.trackStatus,
    required this.time,
    required this.pickupAddress,
    required this.pickupName,
    required this.pickupEmail,
    required this.pickupPhone,
    required this.pickupParcelName,
    required this.pickupParcelWeight,
    required this.pickupParcelDesc,
    required this.pickupDeliveryPrice,
    required this.deliveryEmail,
    required this.deliveryPhone,
    required this.deliveryAddress,
    required this.deliveryName,
    required this.deliveryParcelDesc,
    required this.parcel,
    required this.checkIllegal,
    required this.vehicle,
    required this.orderDate,
    required this.orderStatus,
    required this.userid,
    required this.distance,
    required this.userName,
    required this.deliveryLat,
    required this.deliveryLong,
    required this.driverId,
    required this.orderTime,
    required this.orderID,
    required this.orderType,
    required this.pickupLat,
    required this.pickupLong,
    required this.tracking,
    required this.rejectCount,
    required this.rejections,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "pickupAddress": pickupAddress,
      "pickupName": pickupName,
      "pickupEmail": pickupEmail,
      "pickupPhone": pickupPhone,
      "pickupParcelName": pickupParcelName,
      "pickupParcelWeight": pickupParcelWeight,
      "pickupParcelDesc": pickupParcelDesc,
      "pickupDeliveryPrice": pickupDeliveryPrice,
      "deliveryAddress": deliveryAddress,
      "deliveryName": deliveryName,
      "deliveryEmail": deliveryEmail,
      "deliveryPhone": deliveryPhone,
      "deliveryParcelDesc": deliveryParcelDesc,
      "parcel": parcel,
      "checkIllegal": checkIllegal,
      "vehicle": vehicle,
      "orderDate": orderDate,
      "orderStatus": orderStatus,
      "tracking": tracking,
      "distance": distance,
      "orderTime": orderTime,
      "orderType": orderType,
      "driverId": driverId,
      "userId": userid,
      "orderId": orderID,
      "pickupLat": pickupLat,
      "pickupLong": pickupLong,
      "userName": userName,
      "deliveryLat": deliveryLat,
      "deliveryLong": deliveryLong,
      "rejectCount": rejectCount,
      "rejections": rejections,
      "duration": time,
      "trackStatus": trackStatus,
      'createdAt': createdAt,
    };
  }

  factory DeliveryModel.fromDocument(DocumentSnapshot doc) {
    String pickupAddress = "";
    String pickupName = "";
    String pickupEmail = "";
    String pickupPhone = "";
    String pickupParcelName = "";
    String pickupParcelWeight = "";
    String pickupParcelDesc = "";
    String pickupDeliveryPrice = "";
    String deliveryAddress = "";
    String deliveryName = "";
    String deliveryEmail = "";
    String deliveryPhone = "";
    String deliveryParcelDesc = "";
    String parcel = "";
    String checkIllegal = "";
    String vehicle = "";
    String tracking = "";
    String userid = "";
    String userName = "";
    String orderType = "";
    String orderTime = "";
    String orderStatus = "";
    String orderDate = "";
    String driverId = "";
    String distance = "";
    String deliveryLat = "";
    String deliveryLong = "";
    String pickupLat = "";
    String pickupLong = "";
    String orderId = "";
    int rejectCount = 0;
    List rejections = [];
    String time = "";
    String trackStatus = "";
    DateTime createdAt = DateTime.now();

    try {
      pickupAddress = doc.get("pickupAddress");
    } catch (e) {
      print(e);
    }

    try {
      pickupName = doc.get("pickupName");
    } catch (e) {
      print(e);
    }
    try {
      pickupEmail = doc.get("pickupEmail");
    } catch (e) {
      print(e);
    }
    try {
      pickupPhone = doc.get("pickupPhone");
    } catch (e) {
      print(e);
    }
    try {
      pickupParcelName = doc.get("pickupParcelName");
    } catch (e) {
      print(e);
    }

    try {
      pickupParcelWeight = doc.get("pickupParcelWeight");
    } catch (e) {
      print(e);
    }

    try {
      pickupParcelDesc = doc.get("pickupParcelDesc");
    } catch (e) {
      print(e);
    }

    try {
      pickupDeliveryPrice = doc.get("pickupDeliveryPrice");
    } catch (e) {
      print(e);
    }
    try {
      deliveryAddress = doc.get("deliveryAddress");
    } catch (e) {
      print(e);
    }
    try {
      deliveryName = doc.get("deliveryName");
    } catch (e) {
      print(e);
    }
    try {
      deliveryEmail = doc.get("deliveryEmail");
    } catch (e) {
      print(e);
    }
    try {
      deliveryPhone = doc.get("deliveryPhone");
    } catch (e) {
      print(e);
    }
    try {
      deliveryParcelDesc = doc.get("deliveryParcelDesc");
    } catch (e) {
      print(e);
    }
    try {
      parcel = doc.get("parcel");
    } catch (e) {
      print(e);
    }
    try {
      checkIllegal = doc.get("checkIllegal");
    } catch (e) {
      print(e);
    }
    try {
      vehicle = doc.get("vehicle");
    } catch (e) {
      print(e);
    }
    try {
      tracking = doc.get("tracking");
    } catch (e) {
      print(e);
    }
    try {
      userid = doc.get("userid");
    } catch (e) {
      print(e);
    }
    try {
      userName = doc.get("userName");
    } catch (e) {
      print(e);
    }
    try {
      orderStatus = doc.get("orderStatus");
    } catch (e) {
      print(e);
    }
    try {
      orderTime = doc.get("orderTime");
    } catch (e) {
      print(e);
    }
    try {
      orderType = doc.get("orderType");
    } catch (e) {
      print(e);
    }
    try {
      orderDate = doc.get("orderDate");
    } catch (e) {
      print(e);
    }
    try {
      driverId = doc.get("driverId");
    } catch (e) {
      print(e);
    }
    try {
      distance = doc.get("distance");
    } catch (e) {
      print(e);
    }
    try {
      deliveryLat = doc.get("deliveryLat");
    } catch (e) {
      print(e);
    }
    try {
      deliveryLong = doc.get("deliveryLong");
    } catch (e) {
      print(e);
    }
    try {
      pickupLat = doc.get("pickupLat");
    } catch (e) {
      print(e);
    }
    try {
      pickupLong = doc.get("pickupLong");
    } catch (e) {
      print(e);
    }
    try {
      time = doc.get("duration");
    } catch (e) {
      print(e);
    }
    try {
      trackStatus = doc.get("trackStatus");
    } catch (e) {
      print(e);
    }

    try {
      createdAt = doc.get("createdAt");
    } catch (e) {
      print(e);
    }

    return DeliveryModel(
      pickupAddress: pickupAddress,
      pickupName: pickupName,
      pickupEmail: pickupEmail,
      pickupPhone: pickupPhone,
      pickupParcelName: pickupParcelName,
      pickupParcelWeight: pickupParcelWeight,
      pickupParcelDesc: pickupParcelDesc,
      pickupDeliveryPrice: pickupDeliveryPrice,
      deliveryAddress: deliveryAddress,
      deliveryName: deliveryName,
      deliveryEmail: deliveryEmail,
      deliveryPhone: deliveryPhone,
      deliveryParcelDesc: deliveryParcelDesc,
      parcel: parcel,
      checkIllegal: checkIllegal,
      vehicle: vehicle,
      orderDate: orderDate,
      orderTime: orderTime,
      pickupLat: pickupLat,
      pickupLong: pickupLong,
      distance: distance,
      driverId: driverId,
      userName: userName,
      userid: userid,
      orderStatus: orderStatus,
      orderType: orderType,
      deliveryLong: deliveryLong,
      deliveryLat: deliveryLat,
      tracking: tracking,
      orderID: orderId,
      rejectCount: rejectCount,
      rejections: rejections,
      time: time,
      trackStatus: trackStatus,
      createdAt: createdAt,
    );
  }
}
