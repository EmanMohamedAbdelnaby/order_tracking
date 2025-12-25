import 'package:flutter/material.dart';
import 'package:map_location_picker/map_location_picker.dart';

class PlacePickerScreen extends StatelessWidget {
  const PlacePickerScreen({super.key});

  static const String apiKey = "AIzaSyADiHO0nJF98ANCOaCVQZ6Weia-mfMK3Os";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick Location")),
      body: MapLocationPicker(
        apiKey: apiKey,
        currentLatLng: const LatLng(30.030803, 31.2565769),

        onNext: (result) {
          Navigator.pop(context);
          if (result != null) {
            final latLng = LatLng(
              result.geometry.location.lat,
              result.geometry.location.lng,
            );

            Navigator.pop(context, latLng);
          }
        },
      ),
    );
  }
}
