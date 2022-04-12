import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class DeliveryProvider{
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  DeliveryProvider({
    required this.firebaseFirestore,
    required this.firebaseStorage,
  });

  UploadTask uploadFile(File image, String fileName) {
    Reference reference = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> addDatatoFirestore(String collectionPath, String path, String gCollection,String groupId,Map<String, String> dataNeedUpdate) {
    return firebaseFirestore.collection(collectionPath).doc(path).collection(gCollection).doc(groupId).set(dataNeedUpdate);
  }

  Future<void> updateDatatoFirestore(String collectionPath, String path, String gCollection,String groupId,Map<String, String> dataNeedUpdate) {
    return firebaseFirestore.collection(collectionPath).doc(path).collection(gCollection).doc(groupId).update(dataNeedUpdate);
  }
}
