import 'package:chitral_dost_app/models/service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerModel {
  // 1. ADD MISSING ID FIELD
  final String id;
  final String name;
  final ServiceModel service;
  final String phone;
  final String place;
  final String description;
  final double latitude;
  final double longitude;
  final double? distanceInKm;

  WorkerModel({
    required this.id,
    required this.name,
    required this.service,
    required this.phone,
    required this.place,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.distanceInKm,
  });

  // Factory to create from Firestore Document
  factory WorkerModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    double? calculatedDistance,
  }) {
    final data = doc.data()!;
    final serviceLabelFromDB = data['service'] as String? ?? 'Default';

    // Helper function to safely cast int/double to double
    double safeToDouble(dynamic value) {
      if (value is int) {
        return value.toDouble();
      }
      return (value ?? 0.0) as double;
    }

    return WorkerModel(
      id: doc.id, // Correctly using the document ID
      name: data['name'] ?? '',
      // REMOVED: 'serviceLabel: data['service'] ?? '', ' -> This field doesn't exist in the class
      phone: data['phone'] ?? '',
      place: data['place'] ?? '',
      description: data['description'] ?? '',
      // Safely casting to double
      latitude: safeToDouble(data['latitude']),
      longitude: safeToDouble(data['longitude']),

      // Correctly initializing the ServiceModel object
      service: ServiceModel.fromLabel(serviceLabelFromDB),

      distanceInKm: calculatedDistance,
    );
  }
}
