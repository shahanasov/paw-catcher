import 'package:dog_catcher/core/fonts.dart';
import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/data/models/report_model.dart';
import 'package:dog_catcher/data/services/report_services.dart';
import 'package:dog_catcher/presentation/pages/detail_page/widgets/volunteer_button.dart';
import 'package:dog_catcher/presentation/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailPage extends ConsumerWidget {
  final ReportModel reportModel;
  const DetailPage({super.key, required this.reportModel});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final time = getFormattedTimestamp(reportModel.time);
    final placeAsync = ref.watch(placeNameProvider(reportModel.location));
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
                  color: AppTheme.softPink,
                  borderRadius: BorderRadius.circular(10)),
              height: 180,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                placeAsync.when(
                  data: (place) => SizedBox(
                      width: 200,
                      child: GestureDetector(
                          onTap: () {
                            // Navigate to HomePage with location data
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  location: reportModel.location,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            place,
                            overflow: TextOverflow.ellipsis,
                          ))),
                  loading: () => Text(
                    "Loading...",
                    style: Fonts.poppins,
                  ),
                  error: (err, stack) => Text(
                    "Location error",
                    style: Fonts.poppins,
                  ),
                ),
                Text(time)
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(reportModel.report),
            SizedBox(
              height: 10,
            ),
           
            volunteerButton(context: context, adminId: reportModel.volunteerId)
            
          ],
        ),
      ),
    );
  }
}
