import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  String userId;
  String userToken;
  String userName;
  String userEmail;
  String userPassword;
  String phoneNumber;
  String imageUrl;


  UsersModel({
   required this.userName,required this.imageUrl,required this.phoneNumber,required this.userEmail,required this.userId,required this.userPassword,required this.userToken
});

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userToken': userToken,
        'userName': userName,
        'userEmail': userEmail,
        'phoneNumber': userId,
        'imageUrl': imageUrl,
      };

  factory UsersModel.fromDocument(DocumentSnapshot doc) {
    String userId="";
    String userToken="";
    String userName="";
    String userEmail="";
    String userPassword="";
    String phoneNumber="";
    String imageUrl="";



    try {
      userId = doc.get("userId");
    } catch (e) {
      print(e);
    }

    try {
      userToken = doc.get("userToken");
    }
    catch (e) {
      print(e);
    }
    try {
      userName = doc.get("userName");
    } catch (e) {
      print(e);
    }
    try {
      userEmail = doc.get("userEmail");
    } catch (e) {
      print(e);
    }
    try {
      userPassword = doc.get("userPassword");
    } catch (e) {
      print(e);
    }

    try {
      phoneNumber = doc.get("phoneNumber");
    } catch (e) {
      print(e);
    }

    try {
      imageUrl = doc.get("imageUrl");
    } catch (e) {
      print(e);
    }


    return UsersModel(
      userId: userId,
      userToken: userToken,
      userName: userName,
      userEmail: userEmail,
      userPassword: userPassword,
      phoneNumber: phoneNumber,
      imageUrl: imageUrl,
         );
  }
}
