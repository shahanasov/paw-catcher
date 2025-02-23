import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;
  String? fcmToken; // 🔹 Optional FCM token
  String userId;
  UserModel({
    required this.email,
    required this.name,
    required this.userId,
    this.fcmToken,
  });

  // 🔹 Convert Firestore document snapshot to UserModel
  static UserModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
      email: snapshot.get('email') as String,
      name: snapshot.get('name') as String,
      fcmToken: snapshot.data()?['fcmToken'] as String?, // 🔹 Nullable
      userId: snapshot.get('userId') as String
    );
  }

  // 🔹 Convert UserModel to JSON for storing in Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'fcmToken': fcmToken, // 🔹 Include FCM token in Firestore
    };
  }
}
