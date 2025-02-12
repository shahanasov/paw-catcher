import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/presentation/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget boardingpagebutton({
  required BuildContext context,
}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          fixedSize: Size(327, 56),
          backgroundColor: AppTheme().softPink),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SignInScreen()));
      },
      child: Text("Let's Go!",
          style: TextStyle(
            color: AppTheme().textPrimary,
          )));
}

final passwordVisibilityProvider = StateProvider<bool>((ref) => false);
Widget passwordfield({
  required TextEditingController controller,
  required WidgetRef ref,
}) {
  return Consumer(builder: (context, ref, child) {
    final isObscure = ref.watch(passwordVisibilityProvider);
    return TextFormField(
      obscureText: !isObscure,
      controller: controller,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: AppTheme().textSecondary),
        suffixIcon: IconButton(
            onPressed: () {
              ref.read(passwordVisibilityProvider.notifier).state = !isObscure;
            },
            icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off)),
        hintText: 'Your Password',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: AppTheme().softPink,
      ),
    );
  });
}

Widget buttonforAll({
  required BuildContext context,
  required VoidCallback onPressed,
  String? hint,
  Color? color,
}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          fixedSize: Size(327, 48),
          backgroundColor: color ?? AppTheme().softPink),
      onPressed: () {
        onPressed();
      },
      child: Text(hint ?? 'Button',
          style: TextStyle(
            color: AppTheme().textPrimary,
          )));
}

Widget signinWithButton(String text) {
  return OutlinedButton(
      style: OutlinedButton.styleFrom(
          fixedSize: Size(327, 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(35))),
      onPressed: () {},
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            text == 'Google'
                ? 'assets/images/googlelogo.png'
                : 'assets/images/appleLogo.png',
            height: 25,
            width: 25,
          ),
          Text(
            "Sign in with $text",
            style: TextStyle(color: Colors.black),
          )
        ],
      ));
}
