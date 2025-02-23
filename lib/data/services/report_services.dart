import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dog_catcher/data/models/report_model.dart';
import 'package:dog_catcher/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

// class ReportServices {couse can't be in a class

// upload image to firestore function
Future<String> uploadImageToFirebase(File imageFile) async {
  // final String? userId = FirebaseAuth.instance.currentUser?.uid;
  final storageRef =
      FirebaseStorage.instance.ref().child('${imageFile.path}.jpg');
  // final uploadTask =
  await storageRef.putFile(imageFile);
  return await storageRef.getDownloadURL(); // Return the image download URL
}

final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity().onConnectivityChanged.map((results) => results
      .first); // Convert List<ConnectivityResult> to a single ConnectivityResult
});

final userDetailsProvider = FutureProvider.autoDispose<UserModel?>((ref) async {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    throw Exception('User ID is null');
  }

  try {
    final userDetailDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    if (userDetailDoc.exists) {
      return UserModel.fromSnapshot(userDetailDoc);
    } else {
      return null;
    }
  } on FirebaseException catch (e) {
    log(e.code);
    return null;
  }
});

Future<void> reportSave({
  // required File image,
  required String report,
  required String title,
  // required String name,
  required WidgetRef ref,
  required GeoPoint location,
}) async {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  // final geoPoint = GeoPoint(latitude, longitude);

  // ref.read(authLoadingProvider.notifier).state = true;
  try {
    // final imagePath = await uploadImageToFirebase(image);
    final userdetail = FirebaseFirestore.instance.collection("Reports");
    String reportId = userdetail.doc().id;
    final newReport = ReportModel(
      volunteer: false,
      reportId: reportId,
      location: location,
      title: title,
      report: report,
      auther: userId!,
      time: DateTime.now(),
    );

    // Save to Firestore
    userdetail.doc(reportId).set(newReport.toJson());
    // userdetail.doc().set(newReport);
    // await sendNotificationToNearbyUsers(newReport);
  } catch (e) {
    log("Error $e");
  } finally {
    // ref.read(authLoadingProvider.notifier).state = false;
  }
}

final reportsProvider = StreamProvider.autoDispose<List<ReportModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('Reports')
      .snapshots() // Listen for real-time updates
      .map((snapshot) => snapshot.docs
          .map((doc) => ReportModel.fromSnapshot(doc))
          .toList()); // Convert to List<ReportModel>
});

String getFormattedTimestamp(DateTime timestamp) {
  return timeago.format(timestamp, locale: 'en');
}

class ImagePickerNotifier extends StateNotifier<File?> {
  ImagePickerNotifier() : super(null);

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      state = File(image.path); // Update state with selected image
    }
  }
}

// Provider for ImagePickerNotifier
final imagePickerProvider =
    StateNotifierProvider<ImagePickerNotifier, File?>((ref) {
  return ImagePickerNotifier();
});

Future<List<String>> getAllAdminIds() async {
  try {
    // Query the 'Admins' collection to get all admin documents
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Admins').get();

    if (querySnapshot.docs.isNotEmpty) {
      List<String> adminIds =
          querySnapshot.docs.map((doc) => doc['authId'] as String).toList();

      return adminIds;
    } else {
      return [];
    }
  } catch (e) {
    log("Error retrieving admin IDs: $e");
    return [];
  }
}

//  to fetch only nearby reports
// Fetch user location using new locationSettings approach
// Fetch user location
final locationProvider = FutureProvider<Position>((ref) async {
  LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // Min distance before an update
  );

  return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings);
});

// Fetch and filter nearby reports **without modifying ReportModel**
final nearbyReportsProvider =
    StreamProvider.autoDispose<List<ReportModel>>((ref) async* {
  final position = await ref.watch(locationProvider.future);
  const double maxDistance = 5.0; // Max distance in km

  yield* FirebaseFirestore.instance
      .collection('Reports')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => ReportModel.fromSnapshot(doc))
        .where((report) {
      // Calculate distance dynamically
      final distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            report.location.latitude,
            report.location.longitude,
          ) /
          1000; // Convert meters to km

      return distance <= maxDistance; // Keep only nearby reports
    }).toList();
  });
});


 // Fetch volunteer details
  Future<Map<String, dynamic>?> getVolunteerDetails(String adminId) async {
    try {
      final document = await FirebaseFirestore.instance.collection('Admin').doc(adminId).get();
      if (document.exists) {
        return document.data();
      } else {
        return null;
      }
    } catch (e) {
      log('Error fetching volunteer details: $e');
      rethrow;
    }
  }
final volunteerDetailsProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>?, String>((ref, adminId) async {
  return getVolunteerDetails(adminId); // Call the function to fetch details
});


Future<String> fetchPlaceName(GeoPoint location) async {
  final apiKey = "AIzaSyBzyHjj4QgqqdYjFmX3pcnfpgZ1Uc_NqYo";
  final url =
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$apiKey";
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["status"] == "OK") {
        return data["results"][0]["formatted_address"];
      }
    }
    return "Unknown Location";
  } catch (e) {
    log("Error fetching location: $e");
    return "Error fetching location";
  }
}

// Create a Riverpod FutureProvider
final placeNameProvider =
    FutureProvider.family<String, GeoPoint>((ref, location) async {
  return await fetchPlaceName(location);
});
// final nearbyReportsProvider =
//     StreamProvider.autoDispose<List<ReportModel>>((ref) async* {
//   final position = await ref.watch(locationProvider.future);
//   final notificationService = ref.read(notificationServiceProvider);
//   const double maxDistance = 5.0;

//   // Initialize notifications once
//   await notificationService.initNotification();

//   yield* FirebaseFirestore.instance
//       .collection('Reports')
//       .snapshots()
//       .asyncMap((snapshot) async {
//     // Check each document change for new reports within range
//     for (var change in snapshot.docChanges) {
//       if (change.type == DocumentChangeType.added) {
//         final report = ReportModel.fromSnapshot(change.doc);
//         final distance = Geolocator.distanceBetween(
//               position.latitude,
//               position.longitude,
//               report.location.latitude,
//               report.location.longitude,
//             ) /
//             1000;

//         if (distance <= maxDistance) {
//           await notificationService.showNotification(
//             title: report.title,
//             body: 'A new report is nearby!',
//           );
//         }
//       }
//     }

//     // Return current list of nearby reports
//     return snapshot.docs
//         .map((doc) => ReportModel.fromSnapshot(doc))
//         .where((report) {
//           final distance = Geolocator.distanceBetween(
//                 position.latitude,
//                 position.longitude,
//                 report.location.latitude,
//                 report.location.longitude,
//               ) /
//               1000;
//           return distance <= maxDistance;
//         })
//         .toList();
//   });
// });