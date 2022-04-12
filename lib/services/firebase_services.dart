import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class FirebaseServices {
  static final _auth = FirebaseAuth.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static deleteRecord(BuildContext context, docsName, id) {
    var collection = FirebaseFirestore.instance.collection(docsName);
    collection
        .doc(id) // <-- Doc ID to be deleted.
        .delete()
        .then((e) {
      // MyMotionToast.delete(
      //   context,
      //   "Success",
      //   "Delete successfully :) ",
      // );
    });
  }

  static deleteBalance(BuildContext context, farmerId, balanceId) {
    try {
      FirebaseFirestore.instance
          .collection("farmers")
          .doc(farmerId)
          .collection("balance")
          .doc(balanceId)
          .delete();
      // FCMServices.sendFCM(
      //   'trader',
      //   farmerId,
      //   "Balance Delete",
      //   "Trader delete item in your account",
      // );
      // MyMotionToast.delete(
      //   context,
      //   "Success",
      //   "Delete successfully :) ",
      // );
    } catch (e) {
      print(e);
    }
  }

  static Future<String> imageUpload(imageFile, name) async {
    var image;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(name);
    UploadTask uploadTask = ref.putFile(imageFile);
    await uploadTask.then((res) {
      image = res.ref.getDownloadURL();
    });
    return image;
  }
}
