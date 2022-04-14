class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;

  UserModel({required this.uid,required this.fullname,required this.email,required this.profilepic});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullname = map["fullname"];
    email = map["email"];
    profilepic = map["profilepic"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "profilepic": profilepic,
    };
  }
}