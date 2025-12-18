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

  factory WorkerModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    double? calculatedDistance,
  }) {
    final data = doc.data()!;
    final serviceLabelFromDB = data['service'] as String? ?? 'Default';

    double safeToDouble(dynamic value) {
      if (value is int) {
        return value.toDouble();
      }

      return (value ?? 0.0) as double;
    }

    return WorkerModel(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      place: data['place'] ?? '',
      description: data['description'] ?? '',

      latitude: safeToDouble(data['latitude']),
      longitude: safeToDouble(data['longitude']),

      service: ServiceModel.fromLabel(serviceLabelFromDB),

      profilePictureUrl: data['profilePictureUrl'] as String?,

      distanceInKm: calculatedDistance,
    );
  }
}
