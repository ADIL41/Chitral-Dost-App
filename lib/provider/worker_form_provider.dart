import 'dart:async';

import 'package:chitral_dost_app/models/service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';

class WorkerFormProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final serviceController = TextEditingController();
  final phoneController = TextEditingController();
  final descriptionController = TextEditingController();

  ServiceModel? selectedService;

  bool isGettingLocation = false;
  String locationStatus = 'Tap to get location';
  double? latitude;
  double? longitude;
  String? address;
  String? place;

  WorkerFormProvider() {
    _getCurrentLocationInternal();
  }

  Future<void> _getCurrentLocationInternal() async {
    isGettingLocation = true;
    locationStatus = 'Getting location...';
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        locationStatus = 'Location services disabled';
        isGettingLocation = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationStatus = 'Location permission denied';
          isGettingLocation = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        locationStatus = 'Location permission permanently denied';
        isGettingLocation = false;
        notifyListeners();
        return;
      }

      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        latitude = position.latitude;
        longitude = position.longitude;
        address = _formatAddress(placemark);
        place =
            placemark.locality ??
            placemark.subLocality ??
            placemark.administrativeArea ??
            'Unknown Location';

        locationStatus = 'Location acquired ✓';
        isGettingLocation = false;
        notifyListeners();
      } else {
        locationStatus = 'Location acquired (no address details)';
        isGettingLocation = false;
        latitude = position.latitude;
        longitude = position.longitude;
        place =
            'Coordinates: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
        notifyListeners();
      }
    } catch (e) {
      locationStatus = 'Failed to get location';
      isGettingLocation = false;
      notifyListeners();
    }
  }

  Future<void> getCurrentLocation(BuildContext context) async {
    await _getCurrentLocationInternal();
    if (!context.mounted) return;

    if (locationStatus == 'Location services disabled') {
      _showLocationErrorDialog(context, 'Please enable location services');
    } else if (locationStatus == 'Location permission denied') {
      _showLocationErrorDialog(context, 'Location permission is required');
    } else if (locationStatus == 'Location permission permanently denied') {
      _showLocationErrorDialog(
        context,
        'Location permissions are permanently denied. Please enable them in app settings.',
      );
    } else if (locationStatus == 'Failed to get location') {
      _showManualLocationDialog(context);
    }
  }

  String _formatAddress(Placemark placemark) {
    List<String> addressParts = [];

    if (placemark.street != null && placemark.street!.isNotEmpty) {
      addressParts.add(placemark.street!);
    }
    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      addressParts.add(placemark.subLocality!);
    }
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      addressParts.add(placemark.locality!);
    }
    if (placemark.administrativeArea != null &&
        placemark.administrativeArea!.isNotEmpty) {
      addressParts.add(placemark.administrativeArea!);
    }

    return addressParts.join(', ');
  }

  void _showLocationErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Required'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              getCurrentLocation(context);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showManualLocationDialog(BuildContext context) {
    final manualPlaceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Location Manually'),
        content: TextField(
          controller: manualPlaceController,
          decoration: const InputDecoration(
            hintText: 'Enter your city/town/village',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (manualPlaceController.text.isNotEmpty) {
                place = manualPlaceController.text;
                locationStatus = 'Manual location entered';

                latitude = 35.8511;
                longitude = 71.7861;

                notifyListeners();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void selectService(ServiceModel? selected) {
    if (selected != null) {
      selectedService = selected;
      serviceController.text = selected.label;
      notifyListeners();
    }
  }

  Future<void> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    if (selectedService == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a service'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (place == null || latitude == null || longitude == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please get your location first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error: You must be logged in to register as a worker.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String workerId = currentUser.uid;

    final GeoPoint firestoreGeoPoint = GeoPoint(latitude!, longitude!);
    final GeoFirePoint geoFirePoint = GeoFirePoint(firestoreGeoPoint);

    try {
      await FirebaseFirestore.instance.collection('workers').doc(workerId).set({
        'name': nameController.text,
        'service': selectedService!.label,
        'phone': phoneController.text,
        'place': place,
        'description': descriptionController.text,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'geo': geoFirePoint.data,
        'workerUID': workerId,
        'createdAt': FieldValue.serverTimestamp(),
        'locationUpdatedAt': FieldValue.serverTimestamp(),
      });

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Worker registered successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      nameController.clear();
      serviceController.clear();
      phoneController.clear();
      descriptionController.clear();

      selectedService = null;
      place = null;
      latitude = null;
      longitude = null;
      address = null;
      locationStatus = 'Tap to get location';
      notifyListeners();

      await getCurrentLocation(context);
      if (!context.mounted) return;

      Navigator.pop(context);
    } on FirebaseException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error registering worker: ${error.message}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void disposeControllers() {
    nameController.dispose();
    serviceController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
  }
}
