import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String name;
  String email;
  UserModel({required this.email,required this.name});

  //  Convert Firestore document snapshot to UserModel
  static UserModel fromSnapshot(
   DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
      email:snapshot.get('email')as String,
     name: snapshot.get('name') as String,
    );
  }

  // Convert UserModel to JSON for storing in Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }

}