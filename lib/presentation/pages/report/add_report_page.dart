import 'dart:developer';
import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/data/services/report_services.dart';
import 'package:dog_catcher/presentation/auth/widgets/widgets.dart';
import 'package:dog_catcher/presentation/pages/home/home.dart';
import 'package:dog_catcher/presentation/pages/report/widgets/alert_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddReportPage extends ConsumerWidget {
  const AddReportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImage = ref.watch(imagePickerProvider);
    TextEditingController controller = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a report"),
        actions: [
          TextButton(
              onPressed: () {
                // if (selectedImage != null) {
                  reportSave(
                    // image: selectedImage,
                    ref: ref,
                    title: controller.text.trim(),
                    report: descriptionController.text.trim(),
                  ).then((user) {
                    if (context.mounted) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  }).catchError((error) {
                    log("Error $error");
                  });
                // }
              },
              child: Text('Post'))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            spacing: 20,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme().softPink,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 180,
                width: double.infinity, // Ensure it takes full width if needed
                child: selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Ensures rounded corners
                        child: Image.file(
                          selectedImage,
                          width:
                              double.infinity, // Forces it to take full width
                          height: 180, // Forces it to take full height
                          fit: BoxFit
                              .cover, // Ensures it covers the entire container
                        ),
                      )
                    : Center(
                        child: IconButton(
                          onPressed: () {
                            showImageSourceSheet(context, ref);
                          },
                          icon: Icon(
                            Icons.add_photo_alternate,
                            size: 50,
                          ),
                        ),
                      ),
              ),
              Text('Enter Your location'),
              textfield(
                  controller: controller, hint: "Please Enter you concern"),
              TextFormField(
                maxLines: 10,
                controller: descriptionController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: AppTheme().textSecondary),
                  hintText: 'Type here....',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: AppTheme().softPink,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
