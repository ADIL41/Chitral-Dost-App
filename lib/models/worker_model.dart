import 'package:chitral_dost_app/models/service_model.dart';

class WorkerModel {
  final String name;
  final ServiceModel service;
  final String phone;
  final String place;
  final String description;
  final double latitude;
  final double longitude;

  WorkerModel({
    required this.name,
    required this.phone,
    required this.service,
    required this.place,
    required this.description,
    required this.latitude,
    required this.longitude,
  });
}
