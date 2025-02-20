import 'dart:developer';

import 'package:dog_catcher/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authLoadingProvider = StateProvider<bool>((ref) => false);

// class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signInWithEmail({
    required String email,
    required String password,
    required WidgetRef ref,
  }) async {
    ref.read(authLoadingProvider.notifier).state = true;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      log("error $e");
    } finally {
      ref.read(authLoadingProvider.notifier).state = false;
    }
  }

  signOut() async {
    await auth.signOut();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required WidgetRef ref,
  }) async {
    ref.read(authLoadingProvider.notifier).state = true;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String? userId = userCredential.user?.uid;
      if (userId != null) {
         String? fcmToken = await FirebaseMessaging.instance.getToken();
        final userdetail = FirebaseFirestore.instance.collection("Users");
        final newUser = UserModel(email: email, name: name,fcmToken: fcmToken).toJson();
        userdetail.doc(userId).set(newUser);
      }
    } catch (e) {
      log("Error $e");
    } finally {
      ref.read(authLoadingProvider.notifier).state = false;
    }
  }
// }
