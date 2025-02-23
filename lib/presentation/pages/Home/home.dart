import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_catcher/presentation/pages/home/widgets/appbar.dart';
import 'package:dog_catcher/presentation/pages/home/widgets/draggable_scrollable_sheet.dart';
import 'package:dog_catcher/presentation/pages/home/widgets/drawer.dart';
import 'package:dog_catcher/presentation/pages/home/widgets/map_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final GeoPoint? location;
  const HomePage({super.key, this.location});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: scaffoldKey,
        appBar: customAppBar(scaffoldKey, context),
        drawer: CustomDrawer(),
        body: Stack(
          fit: StackFit.expand,
          children: [MyGoogleMap(), CostumDraggableScrollableSheet()],
        ));
  }
}
