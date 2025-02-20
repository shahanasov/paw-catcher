import 'dart:developer';

import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/data/services/auth_service.dart';
import 'package:dog_catcher/presentation/auth/widgets/widgets.dart';
import 'package:dog_catcher/presentation/on_boarding/widgets.dart';
import 'package:dog_catcher/presentation/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final isLoading = ref.watch(authLoadingProvider);
    TextEditingController controller = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    List<Widget> widgetsList = [
      Text(
        'Welcome Back 👋',
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        'Sign to your account',
        style: TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        'Email',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      textfield(controller: controller, hint: 'Your email'),
      Text('Password'),
      passwordfield(controller: passwordController, ref: ref),
      Text(
        'Forgot Password?',
        style: TextStyle(color: AppTheme.softPink),
      ),
      SizedBox(
        height: 3,
      ),
      Center(
        child: isLoading? CircularProgressIndicator(color: AppTheme.softPink,):
        buttonforAll(
            onPressed: () {
              
                  signInWithEmail(ref: ref,
                      email: controller.text.trim(),
                      password: passwordController.text.trim())
                  .then((user) {
                if (context.mounted) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage()));
                }
              }).catchError((error) {
                log("Error $error");
              });
            },
            hint: 'Login',
            context: context,
            color: AppTheme.softPink),
      ),
      optsign(context, true),
      Row(
        children: [
          Expanded(
              child: Divider(
            thickness: 1,
            color: Colors.black,
          )),
          Text('Or with'),
          Expanded(
              child: Divider(
            thickness: 1,
            color: Colors.black,
          )),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      signinWithButton('Google'),
      signinWithButton('Apple')
    ];

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgetsList),
        ),
      ),
    );
  }
}
