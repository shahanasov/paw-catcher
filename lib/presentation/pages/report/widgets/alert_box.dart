import 'package:dog_catcher/data/services/report_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

void showImageSourceDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Select Image from"),
        actions: [
          Container(),
          TextButton.icon(
            onPressed: () {
              ref
                  .read(imagePickerProvider.notifier)
                  .pickImage(ImageSource.camera);
              Navigator.pop(context);
            },
            icon: Icon(Icons.camera_alt),
            label: Text("Camera"),
          ),
          TextButton.icon(
            onPressed: () {
              ref
                  .read(imagePickerProvider.notifier)
                  .pickImage(ImageSource.gallery);
              Navigator.pop(context);
            },
            icon: Icon(Icons.photo_library),
            label: Text("Gallery"),
          ),
        ],
      );
    },
  );
}

void showImageSourceSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Photo'),
              onTap: () {
                ref
                    .read(imagePickerProvider.notifier)
                    .pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Pick from Gallery'),
              onTap: () {
                ref
                    .read(imagePickerProvider.notifier)
                    .pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
