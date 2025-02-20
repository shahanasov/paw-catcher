import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/data/services/notification.dart';
import 'package:dog_catcher/presentation/on_boarding/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    FirebaseMessaging.instance.requestPermission();

  runApp(ProviderScope(child: const MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            theme:ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.softPink),),
      debugShowCheckedModeBanner: false,
      title: 'Paw Catcher',
      home: SplashScreen(),
    );
  }
}

void subscribeToTopic() async {
  await FirebaseMessaging.instance.subscribeToTopic('new_reports');
  print("Subscribed to new_reports topic");
}
