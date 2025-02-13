import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_catcher/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ReportServices {couse can't be in a class

  // upload image to firestore function
  // Future<String> uploadProfilePhotoToFirebase(File imageFile) async {
  //   final storageRef =
  //       FirebaseStorage.instance.ref().child('profilephoto/$userId.jpg');
  //   // final uploadTask =
  //   await storageRef.putFile(imageFile);
  //   return await storageRef.getDownloadURL(); // Return the image download URL
  // }

  final userDetailsProvider =
      FutureProvider.autoDispose<UserModel?>((ref) async {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User ID is null');
    }

    try {
      final userDetailDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

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

