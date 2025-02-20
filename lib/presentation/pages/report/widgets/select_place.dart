import 'package:dog_catcher/data/services/map_service.dart';
import 'package:flutter/material.dart';
import 'package:place_picker_google/place_picker_google.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class LocationPickerWidget extends ConsumerWidget {
  final TextEditingController locationController;
  final String googleApiKey;

  const LocationPickerWidget({
    super.key,
    required this.locationController,
    required this.googleApiKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Location Search Field
        TextField(
          controller: locationController,
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Search for a location',
            border: OutlineInputBorder(),
          ),
          onTap: () async {
            // Use Navigator to push the PlacePicker screen
            LocationResult? result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PlacePicker(
                  apiKey: googleApiKey,
                ),
              ),
            );

            if (result != null) {
              // Update state providers
              ref.read(latitudeProvider.notifier).state = result.latLng!.latitude;
              ref.read(longitudeProvider.notifier).state = result.latLng!.longitude;
              locationController.text = result.formattedAddress ?? '';
            }
          },
        ),

        // Current Location Button
        TextButton.icon(
          label: Text('Use my current location'),
          icon: Icon(Icons.location_on_rounded),
          onPressed: () => ref.read(fetchLocationProvider),
        ),
      ],
    );
  }
}