import 'dart:developer';

import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/data/services/auth_service.dart';
import 'package:dog_catcher/presentation/auth/widgets/widgets.dart';
import 'package:dog_catcher/presentation/on_boarding/widgets.dart';
import 'package:dog_catcher/presentation/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInScreen extends ConsumerWidget {
  SignInScreen({super.key});
  final signInFormKey = GlobalKey<FormState>();
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
      textfield(
        controller: controller,
        hint: 'Your email',
        validator: (value) => value!.isEmpty ? "Enter your Email" : null,
      ),
      Text('Password'),
      passwordfield(
        controller: passwordController,
        ref: ref,
      ),
      Text(
        'Forgot Password?',
        style: TextStyle(color: AppTheme.softPink),
      ),
      SizedBox(
        height: 3,
      ),
      Center(
        child: isLoading
            ? CircularProgressIndicator(
                color: AppTheme.softPink,
              )
            : buttonforAll(
                onPressed: () async {
                  if (signInFormKey.currentState!.validate()) {
                    ref.read(authLoadingProvider.notifier).state = true;

                    try {
                      String? errorMessage = await signInWithEmail(
                        ref: ref,
                        email: controller.text.trim(),
                        password: passwordController.text.trim(),
                      );

                      if (errorMessage == null) {
                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    } catch (error) {
                      log("Error: $error");
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Something went wrong. Please try again.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } finally {
                      ref.read(authLoadingProvider.notifier).state = false;
                    }
                  }
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
          child: Form(
            key: signInFormKey,
            child: Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgetsList),
          ),
        ),
      ),
    );
  }
}
