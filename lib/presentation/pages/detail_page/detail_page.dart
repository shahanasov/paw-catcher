import 'package:dog_catcher/core/fonts.dart';
import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/data/models/report_model.dart';
import 'package:dog_catcher/data/services/report_services.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final ReportModel reportModel;
  const DetailPage({super.key, required this.reportModel});

  @override
  Widget build(BuildContext context) {
    final time = getFormattedTimestamp(reportModel.time);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Paw Catcher',
          style: Fonts.poppins,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(reportModel.title),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: AppTheme().softPink,
                  borderRadius: BorderRadius.circular(10)),
              height: 180,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('place'), Text(time)],
            ),
            SizedBox(
              height: 10,
            ),
            Text(reportModel.report),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: () {}, child: Text('progress'))
          ],
        ),
      ),
    );
  }
}
