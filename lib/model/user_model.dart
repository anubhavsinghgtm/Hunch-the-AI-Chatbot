import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? uid;
  String? email;
  String? name;

  UserModel({this.uid, this.email, this.name});

  // to receive the data from the database
  factory UserModel.fromMap(map) {
    return UserModel(uid: map['uid'], email: map['email'], name: map['name']);
  }

  // to send the data to the database
  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'name': name};
  }
}
