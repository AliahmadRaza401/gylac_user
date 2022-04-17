import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MapServices {
  static Future<Uint8List> getMarkerImage(BuildContext context) async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/images/mapmarker.png");
    return byteData.buffer.asUint8List();
  }

  static Future<Uint8List> getMarkerWithSize(int width) async {
    ByteData data = await rootBundle.load("assets/images/mapmarker.png");
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
  static Future<Uint8List> getMarkerWithSize2(int width) async {
    ByteData data = await rootBundle.load("assets/images/package.png");
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static Future<Uint8List> getMarkerWithSize3(int width) async {
    ByteData data = await rootBundle.load("assets/images/Rider.png");
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static updateLocationInDB(latitude, longitude) {
    var collection = FirebaseFirestore.instance.collection('drivers');
    collection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
          {
            'latitude': latitude,
            'longitude': longitude,
          },
        ) // <-- Updated data
        .then((_) => print(' update Location InDB Success'))
        .catchError((error) => print(' update Location InDB Failed: $error'));
  }
}
