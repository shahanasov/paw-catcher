// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dog_catcher/data/models/report_model.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:math';
// import 'package:location/location.dart';

// const String serverKey = "YOUR_SERVER_KEY"; // Get from Firebase Console

// // 🔹 Haversine Formula to calculate distance in km
// double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//   const R = 6371; // Radius of Earth in km
//   double dLat = (lat2 - lat1) * pi / 180;
//   double dLon = (lon2 - lon1) * pi / 180;

//   double a = sin(dLat / 2) * sin(dLat / 2) +
//       cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
//           sin(dLon / 2) * sin(dLon / 2);

//   double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//   return R * c; // Distance in km
// }

// // 🔹 Function to get the current user's location using `location` package
// Future<LocationData?> getCurrentLocation() async {
//   Location location = Location();
//   bool serviceEnabled;
//   PermissionStatus permissionGranted;

//   // Check if location service is enabled
//   serviceEnabled = await location.serviceEnabled();
//   if (!serviceEnabled) {
//     serviceEnabled = await location.requestService();
//     if (!serviceEnabled) {
//       print("⚠️ Location services are disabled.");
//       return null;
//     }
//   }

//   // Check location permissions
//   permissionGranted = await location.hasPermission();
//   if (permissionGranted == PermissionStatus.denied) {
//     permissionGranted = await location.requestPermission();
//     if (permissionGranted != PermissionStatus.granted) {
//       print("⚠️ Location permission denied.");
//       return null;
//     }
//   }

//   return await location.getLocation();
// }

// // 🔹 Function to check users' real-time location and send notifications
// Future<void> sendNotificationToNearbyUsers(ReportModel report) async {
//   QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('Users').get();

//   List<String> tokens = [];

//   for (var userDoc in usersSnapshot.docs) {
//     var userData = userDoc.data() as Map<String, dynamic>;

//     if (userData.containsKey('fcmToken')) {
//       String? userFcmToken = userData['fcmToken'];

//       // Get user's real-time location
//       LocationData? userLocation = await getCurrentLocation();
//       if (userLocation == null) continue; // Skip if location retrieval fails

//       double distance = calculateDistance(
//         report.location.latitude, 
//         report.location.longitude, 
//         userLocation.latitude!, 
//         userLocation.longitude!
//       );

//       if (distance <= 5) { // ✅ Notify users within a 5km radius
//         tokens.add(userFcmToken!);
//       }
//     }
//   }

//   // Send notification if any nearby users are found
//   if (tokens.isNotEmpty) {
//     await sendPushNotification(tokens, report.title, report.report);
//   }
// }

// // 🔹 Function to send push notifications via Firebase Cloud Messaging (FCM)
// Future<void> sendPushNotification(List<String> tokens, String title, String body) async {
//   final url = Uri.parse("https://fcm.googleapis.com/fcm/send");

//   final payload = {
//     "registration_ids": tokens,
//     "notification": {
//       "title": title,
//       "body": body,
//       "click_action": "FLUTTER_NOTIFICATION_CLICK",
//     }
//   };

//   final headers = {
//     "Content-Type": "application/json",
//     "Authorization": "key=$serverKey",
//   };

//   final response = await http.post(url, headers: headers, body: jsonEncode(payload));

//   if (response.statusCode == 200) {
//     print("✅ Notification sent successfully!");
//   } else {
//     print("❌ Error sending notification: ${response.body}");
//   }
// }
