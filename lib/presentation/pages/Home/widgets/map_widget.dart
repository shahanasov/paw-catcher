import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/data/services/map_service.dart';
import 'package:dog_catcher/data/services/report_services.dart' as reportservices;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyGoogleMap extends ConsumerWidget {
  final GeoPoint? selectedLocation;
  const MyGoogleMap({this.selectedLocation, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsyncValue = ref.watch(locationProvider);
     final nearbyReportsAsyncValue = ref.watch(reportservices.nearbyReportsProvider);
    LatLng kerala = LatLng(10.850516, 76.271080);
    return locationAsyncValue.when(
      data: (currentPosition) {
        Set<Marker> markers = {};

        // Add nearby reports markers
        nearbyReportsAsyncValue.whenData((reports) {
          for (var report in reports) {
            markers.add(
              Marker(
                markerId: MarkerId(report.title),
                position: LatLng(report.location.latitude, report.location.longitude),
                infoWindow: InfoWindow(
                  title: "Report ${report.title}",
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
              ),
            );
          }
        });

        // Add current location marker
        if (currentPosition != null) {
          markers.add(
            Marker(
              markerId: MarkerId("currentLocation"),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              position: currentPosition,
              infoWindow: InfoWindow(title: "You are here"),
            ),
          );
        }

        // Add selected location marker
        if (selectedLocation != null) {
          LatLng reportedPlace =
              LatLng(selectedLocation!.latitude, selectedLocation!.longitude);
          markers.add(
            Marker(
              markerId: MarkerId("Reported Area"),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              position: reportedPlace,
              infoWindow: InfoWindow(title: "Reported Area"),
            ),
          );
        }
        return GoogleMap(
            initialCameraPosition:
                CameraPosition(target: currentPosition ?? kerala, zoom: 13),
            zoomGesturesEnabled: true,
            markers: markers,
            circles: {
              if (currentPosition != null)
                Circle(
                    circleId: CircleId("nearby_radius"),
                    center: currentPosition,
                    radius: 500,
                    fillColor: AppTheme.yellow,
                    strokeColor: AppTheme.yellow,
                    strokeWidth: 1)
            });
      },
      loading: () {
        return Container(
          color: AppTheme.softPink,
          child: Center(
            child: CircularProgressIndicator(
              color: AppTheme.softPink,
            ),
          ),
        );
      },
      error: (error, stack) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $error'),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(locationProvider); // Retry permission request
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
