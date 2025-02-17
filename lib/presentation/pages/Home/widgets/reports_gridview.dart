import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/data/models/report_model.dart';
import 'package:dog_catcher/data/services/report_services.dart';
import 'package:dog_catcher/presentation/pages/detail_page/detail_page.dart';
import 'package:flutter/material.dart';

class CustomGrid extends StatelessWidget {
  final List<ReportModel> reportsList;
  final ScrollController scrollController;
  const CustomGrid(
      {super.key, required this.reportsList, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        controller: scrollController,
        itemCount: reportsList.length,
        itemBuilder: (context, index) {
          final report = reportsList[index];
          // final time = getFormattedTimestamp(report.time);
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailPage(
                        reportModel: report,
                      )));
            },
            child: SizedBox(
                height: 450,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    spacing: 3,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: AppTheme().softPink,
                            borderRadius: BorderRadius.circular(10)),
                        height: 150,
                      ),
                      Text(
                        maxLines: 1,
                        report.title,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: Container(
                      //       height: 25,
                      //       width: 90,
                      //       decoration: BoxDecoration(
                      //         color: AppTheme().safeGreen,
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       child: Center(
                      //         child: Text('progress'),
                      //       )),
                      // )
                    ],
                  ),
                )),
          );
        });
  }
}
