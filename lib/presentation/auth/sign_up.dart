import 'dart:developer';

import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/data/services/auth_service.dart';
import 'package:dog_catcher/presentation/auth/widgets/widgets.dart';
import 'package:dog_catcher/presentation/on_boarding/widgets.dart';
import 'package:dog_catcher/presentation/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authLoadingProvider);
    TextEditingController controller = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    List<Widget> widgetsList = [
      Text(
        'Sign Up',
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        'Create account and choose favorite menu',
        style: TextStyle(
          color: AppTheme().softPink,
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        'Name',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      textfield(controller: nameController, hint: 'Your Name'),
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
      textfield(controller: controller, hint: 'Your Email'),
      Text(
        'Password',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      passwordfield(controller: passwordController, ref: ref),
      SizedBox(
        height: 10,
      ),
      Center(
          child: isLoading
              ? CircularProgressIndicator(
                  color: AppTheme().softPink,
                )
              : buttonforAll(
                  onPressed: () {
                    signUp(
                            ref: ref,
                            name: nameController.text.trim(),
                            email: controller.text.trim(),
                            password: passwordController.text.trim())
                        .then((user) {
                      if (context.mounted) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePage()));
                      }
                    }).catchError((error) {
                      log("Error $error");
                    });
                  },
                  context: context,
                  hint: 'Register')),
      optsign(context, false),
    ];
    return Scaffold(
      backgroundColor: AppTheme().backgroundColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgetsList),
        ),
      ),
      bottomSheet: IgnorePointer(
        child: Container(
          color: AppTheme().backgroundColor,
          height: 80,
          child: Column(
            spacing: 6,
            children: [
              Text('By clicking Register, you agree to our '),
              Text(
                'Terms and Data Policy.',
                style: TextStyle(color: AppTheme().softPink),
              )
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
