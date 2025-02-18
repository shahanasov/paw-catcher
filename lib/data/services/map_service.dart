import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


final locationProvider = FutureProvider<LatLng?>((ref) async {
  Location locationController = Location();
  LatLng? currentPosition;
  bool serviceEnabled;
  PermissionStatus permissionGranted;
    // Step 1: Check if location services are enabled
  serviceEnabled = await locationController.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await locationController.requestService();
  } else {
    return null;
  }

   // Step 2: Check and request location permissions
  permissionGranted = await locationController.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await locationController.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  // Step 3: Fetch the current location
    LocationData currentLocation = await locationController.getLocation();
  if (currentLocation.latitude != null && currentLocation.longitude != null) {
    currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
  }
  return currentPosition;
});
