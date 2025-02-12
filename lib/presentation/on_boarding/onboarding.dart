import 'package:dog_catcher/presentation/on_boarding/widgets.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
       
        Positioned.fill(
            child: Image.asset(
          'assets/images/dogsonboarding.jpg',
          height: double.infinity,
          fit: BoxFit.cover,
        )),
        Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: boardingpagebutton(context: context))
      ]),
    );
  }
}
