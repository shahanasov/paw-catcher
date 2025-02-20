import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/presentation/pages/report/widgets/alert_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget imagepickerWidget(BuildContext context, WidgetRef ref, selectedImage) {
  return // Image Picker UI
      Container(
    decoration: BoxDecoration(
      color: AppTheme.softPink,
      borderRadius: BorderRadius.circular(10),
    ),
    height: 180,
    width: double.infinity,
    child: selectedImage != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              selectedImage,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          )
        : Center(
            child: IconButton(
              onPressed: () {
                showImageSourceSheet(context, ref);
              },
              icon: Icon(Icons.add_photo_alternate, size: 50),
            ),
          ),
  );
}
