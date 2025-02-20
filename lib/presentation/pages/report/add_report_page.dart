import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/data/services/map_service.dart';
import 'package:dog_catcher/data/services/report_services.dart';
import 'package:dog_catcher/presentation/auth/widgets/widgets.dart';
import 'package:dog_catcher/presentation/pages/home/home.dart';
import 'package:dog_catcher/presentation/pages/report/widgets/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddReportPage extends ConsumerWidget {
  const AddReportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImage = ref.watch(imagePickerProvider);
    final latitude = ref.watch(latitudeProvider);
    final longitude = ref.watch(longitudeProvider);
    final locationController = TextEditingController();

    // Set text field when location updates
    if (latitude != null && longitude != null) {
      locationController.text =
          "Lat: ${latitude.toStringAsFixed(4)}, Lng: ${longitude.toStringAsFixed(4)}";
    }

    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Create a report"),
        actions: [
          TextButton(
            onPressed: () {
              if (latitude != null && longitude != null) {
                reportSave(
                  location: GeoPoint(latitude, longitude), // ✅ Save location
                  ref: ref,
                  title: titleController.text.trim(),
                  report: descriptionController.text.trim(),
                ).then((user) {
                  if (context.mounted) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                }).catchError((error) {
                  log("Error $error");
                });
              }
            },
            child: Text('Post'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            spacing: 20,
            children: [
              imagepickerWidget(context, ref, selectedImage),

              // Enter location manually
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: 'Enter your location',
                  border: OutlineInputBorder(),
                ),
              ),

              // Fetch Current Location Button
              TextButton.icon(
                label: Text('Use my current location'),
                icon: Icon(Icons.location_on_rounded),
                onPressed: () {
                  ref.read(fetchLocationProvider);
                },
              ),

              textfield(
                  controller: titleController, hint: "Enter your concern"),

              // Report description
              TextFormField(
                maxLines: 10,
                controller: descriptionController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: AppTheme.textSecondary),
                  hintText: 'Type here....',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppTheme.softPink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
