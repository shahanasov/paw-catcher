import 'package:dog_catcher/core/fonts.dart';
import 'package:dog_catcher/presentation/pages/notifcation/notification_page.dart';
import 'package:dog_catcher/presentation/pages/report/add_report_page.dart';
import 'package:flutter/material.dart';

AppBar customAppBar(
    GlobalKey<ScaffoldState> scaffoldKey, BuildContext context) {
  return AppBar(
    leading: Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          scaffoldKey.currentState?.openDrawer();
        },
        child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/profiledog.jpg')),
      ),
    ),
    title: Text('Paw Catcher', style: Fonts.poppins),
    actions: [
      IconButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NotificationPage()));
          },
          icon: Icon(Icons.notification_important)),
      IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddReportPage()));
          },
          icon: Icon(Icons.report_problem)),
      SizedBox(
        width: 15,
      )
    ],
  );
}
