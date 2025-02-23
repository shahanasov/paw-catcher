import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/presentation/auth/sign_in.dart';
import 'package:dog_catcher/presentation/auth/sign_up.dart';
import 'package:flutter/material.dart';

Widget textfield(
    {required TextEditingController controller, String? hint, String? label,String? Function(String?)? validator, }) {
  return TextFormField(
    validator: validator, 
    controller: controller,
    decoration: InputDecoration(
      hintStyle: TextStyle(color: AppTheme.textSecondary),
      hintText: hint ?? 'Type here',
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      filled: true,
      fillColor: AppTheme.softPink,
    ),
  );
}

Widget optsign(BuildContext context, bool have) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(have ? "Don't have an account?" : "Have an account?"),
      GestureDetector(
        onTap: () {
          have
              ? Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignUpScreen()))
              : Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignInScreen()));
        },
        child: Text(
          have ? '  Sign Up' : "  Sign In",
          style: TextStyle(color: AppTheme.softPink),
        ),
      )
    ],
  );
}


Future<void> showErrorDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Error", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
