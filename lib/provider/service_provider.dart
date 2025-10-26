import 'package:chitral_dost_app/models/service_model.dart';
import 'package:flutter/material.dart';

class ServiceProvider with ChangeNotifier {
  //sate
  List<ServiceModel> _services = [];
  ServiceModel? _selectedService;

  //getters
  List<ServiceModel> get services => _services;
  ServiceModel? get selectedService => _selectedService;

  ServiceProvider() {
    _loadServices();
  }

  void _loadServices() {
    _services = [
      ServiceModel(
        label: "Cleaning",
        icon: Icons.cleaning_services,
        backgroundColor: Colors.white,
        avatarColor: Colors.blue,
        address: 'Drosh',
      ),
      ServiceModel(
        label: "Plumbing",
        icon: Icons.plumbing,
        backgroundColor: Colors.white,
        avatarColor: Colors.green,
        address: 'Chitral',
      ),
    ];
  }

  void selectService(ServiceModel service) {
    _selectedService = service;
    notifyListeners();
  }

  void clearSelection() {
    _selectedService = null;
    notifyListeners();
  }
}
