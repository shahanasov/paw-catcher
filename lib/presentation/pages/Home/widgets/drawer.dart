import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/presentation/pages/chat/chat_rooms.dart';
import 'package:flutter/material.dart';

Widget drawer(BuildContext context) {
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
          SizedBox(
            height: 10,
          ),
          Card(
              color: AppTheme().softPink,
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChatRooms()));
                },
                leading: Icon(Icons.chat),
                title: Text('Chat with Rescue Team'),
              )),
          Card(
            color: AppTheme().softPink,
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          )
        ],
      ),
    ),
  );
}
