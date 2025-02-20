import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;
  String? fcmToken; // 🔹 Optional FCM token

  UserModel({
    required this.email,
    required this.name,
    this.fcmToken,
  });

  // 🔹 Convert Firestore document snapshot to UserModel
  static UserModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
      email: snapshot.get('email') as String,
      name: snapshot.get('name') as String,
      fcmToken: snapshot.data()?['fcmToken'] as String?, // 🔹 Nullable
    );
  }

  // 🔹 Convert UserModel to JSON for storing in Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'fcmToken': fcmToken, // 🔹 Include FCM token in Firestore
    };
  }
}
