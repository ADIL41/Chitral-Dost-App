import 'package:chitral_dost_app/models/service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerModel {
  final String id;
  final String name;
  final ServiceModel service;
  final String phone;
  final String place;
  final String description;
  final double latitude;
  final double longitude;
  final double? distanceInKm;
  // 💡 NEW/UPDATED: profilePictureUrl field
  String? profilePictureUrl;

  WorkerModel({
    required this.id,
    required this.name,
    required this.service,
    required this.phone,
    required this.place,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.distanceInKm,
    this.profilePictureUrl,
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
      // Assuming coordinates are stored under 'latitude'/'longitude' keys
      return (value ?? 0.0) as double;
    }

    return WorkerModel(
      // The document ID (UID) is the authoritative ID for the model
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      place: data['place'] ?? '',
      description: data['description'] ?? '',

      latitude: safeToDouble(data['latitude']),
      longitude: safeToDouble(data['longitude']),

      service: ServiceModel.fromLabel(serviceLabelFromDB),

      // 💡 KEY FIX: Read the profile picture URL
      profilePictureUrl: data['profilePictureUrl'] as String?,

      distanceInKm: calculatedDistance,
    );
  }
}
