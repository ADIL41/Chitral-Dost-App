import 'package:chitral_dost_app/models/service_model.dart';

class WorkerModel {
  final String name;
  final ServiceModel service;
  final String phone;
  final String place;

  WorkerModel(
    {
    required this.name,
    required this.phone,
    required this.service,
    required this.place,
  });
}
