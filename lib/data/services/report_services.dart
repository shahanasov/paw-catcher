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
}) async {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  // ref.read(authLoadingProvider.notifier).state = true;
  try {
    // final imagePath = await uploadImageToFirebase(image);
    final userdetail = FirebaseFirestore.instance.collection("Reports");
    final newReport = ReportModel(
            // imagePath: imagePath,
            title: title,
            report: report,
            auther: userId!,
            time: DateTime.now())
        .toJson();
    userdetail.doc().set(newReport);
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
