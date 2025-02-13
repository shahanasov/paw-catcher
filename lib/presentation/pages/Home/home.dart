import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/presentation/pages/home/widgets/appbar.dart';
import 'package:dog_catcher/presentation/pages/home/widgets/draggable_scrollable_sheet.dart';
import 'package:dog_catcher/presentation/pages/home/widgets/drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: scaffoldKey,
        appBar: customAppBar(scaffoldKey,context),
        drawer: drawer(context),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: AppTheme().softPink,
            ),
            CostumDraggableScrollableSheet()
          ],
        ));
  }
}
