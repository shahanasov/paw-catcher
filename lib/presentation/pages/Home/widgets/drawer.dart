import 'package:flutter/material.dart';

Widget drawer() {
  return Drawer(
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        children: [
          Container(
            width: 80, 
            height: 80, 
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/profiledog.jpg'),
                fit: BoxFit.contain, 
              ),
            ),
          ),
          ListTile(
            title: Text('Settings'),
          )
        ],
      ),
    ),
  );
}
