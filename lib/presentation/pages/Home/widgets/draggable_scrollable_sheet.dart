import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/presentation/pages/detail_page/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod provider to control the sheet height
final sheetHeightProvider = StateProvider<double>((ref) => 0.3);

class CostumDraggableScrollableSheet extends ConsumerWidget {
  const CostumDraggableScrollableSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheetHeight = ref.watch(sheetHeightProvider);
    return DraggableScrollableSheet(
        expand: true,
        initialChildSize: sheetHeight, // 30% of screen height initially
        minChildSize: 0.2, // Minimum 20% when dragged down
        maxChildSize: 0.95, // Expandable to 90% when dragged up
        builder: (BuildContext context, ScrollController scrollController) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
            ),
            child: Column(
              children: [
                // Drag Indicator (like Instagram)
                GestureDetector(
                  behavior: HitTestBehavior.opaque, // Ensures touch is detected
                  onVerticalDragUpdate: (details) {
                    final newSize = sheetHeight - details.primaryDelta! / 400;
                    ref.read(sheetHeightProvider.notifier).state =
                        newSize.clamp(0.2, 0.9);
                  },
                  onVerticalDragEnd: (details) {
                    // Snap to nearest state (collapsed or expanded)
                    ref.read(sheetHeightProvider.notifier).state =
                        sheetHeight > 0.5 ? 0.9 : 0.3;
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.8, crossAxisCount: 2),
                      controller: scrollController,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DetailPage()));
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height: 80,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('place'),
                                        Text('time ago')
                                      ],
                                    ),
                                    Text(
                                      'report..............................',
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5,),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                         height: 25,
                                         width: 90,
                                          decoration: BoxDecoration(
                                            color: AppTheme().safeGreen,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                                
                                          ),
                                          child: Center(
                                            child: Text('progress'),
                                          )),
                                    )
                                  ],
                                ),
                              )),
                        );
                      }),
                )
              ],
            ),
          );
        });
  }
}
