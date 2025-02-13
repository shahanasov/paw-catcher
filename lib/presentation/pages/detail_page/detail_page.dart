import 'package:dog_catcher/core/fonts.dart';
import 'package:dog_catcher/core/theme.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Paw Catcher',style: Fonts.poppins,),),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text('Title'),
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                  color: AppTheme().softPink,
                  borderRadius: BorderRadius.circular(10)),
              height: 180,
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('place'), Text('time ago')],
            ),
            SizedBox(height: 10,),
            Text('report......'),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {}, child: Text('progress'))
          ],
        ),
      ),
    );
  }
}
