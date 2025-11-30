import 'package:chitral_dost_app/models/service_model.dart';
import 'package:flutter/material.dart';

class ServiceProvider with ChangeNotifier {
  List<ServiceModel> _services = [];
  ServiceModel? _selectedService;

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
        address: '',
      ),
      ServiceModel(
        label: "Plumbing",
        icon: Icons.plumbing,
        backgroundColor: Colors.white,
        avatarColor: Colors.green,
        address: '',
      ),
      ServiceModel(
        label: "Electrician",
        icon: Icons.electrical_services,
        backgroundColor: Colors.white,
        avatarColor: Colors.orange,
        address: '',
      ),
      ServiceModel(
        label: "Delivery",
        icon: Icons.local_shipping,
        backgroundColor: Colors.white,
        avatarColor: Colors.purple,
        address: '',
      ),
      ServiceModel(
        label: "Police",
        icon: Icons.local_police,
        backgroundColor: Colors.white,
        avatarColor: Colors.redAccent,
        address: '',
      ),
      ServiceModel(
        label: "Doctor",
        icon: Icons.medical_services,
        backgroundColor: Colors.white,
        avatarColor: Colors.teal,
        address: '',
      ),
      ServiceModel(
        label: "Bike Rider",
        icon: Icons.pedal_bike,
        backgroundColor: Colors.white,
        avatarColor: Colors.indigo,
        address: '',
      ),
      ServiceModel(
        label: "Carpenter",
        icon: Icons.handyman,
        backgroundColor: Colors.white,
        avatarColor: Colors.brown,
        address: '',
      ),
      ServiceModel(
        label: "Painter",
        icon: Icons.format_paint,
        backgroundColor: Colors.white,
        avatarColor: Colors.deepOrange,
        address: '',
      ),
      ServiceModel(
        label: "Gardener",
        icon: Icons.grass,
        backgroundColor: Colors.white,
        avatarColor: Colors.green,
        address: '',
      ),
      ServiceModel(
        label: "AC Technician",
        icon: Icons.ac_unit,
        backgroundColor: Colors.white,
        avatarColor: Colors.lightBlue,
        address: '',
      ),
      ServiceModel(
        label: "Appliance Repair",
        icon: Icons.kitchen,
        backgroundColor: Colors.white,
        avatarColor: Colors.indigo,
        address: '',
      ),
      ServiceModel(
        label: "Maid Service",
        icon: Icons.cleaning_services,
        backgroundColor: Colors.white,
        avatarColor: Colors.pink,
        address: '',
      ),
      ServiceModel(
        label: "Laundry",
        icon: Icons.local_laundry_service,
        backgroundColor: Colors.white,
        avatarColor: Colors.blueGrey,
        address: '',
      ),
      ServiceModel(
        label: "Cook",
        icon: Icons.restaurant,
        backgroundColor: Colors.white,
        avatarColor: Colors.redAccent,
        address: '',
      ),
      ServiceModel(
        label: "Tutor",
        icon: Icons.menu_book,
        backgroundColor: Colors.white,
        avatarColor: Colors.teal,
        address: '',
      ),
      ServiceModel(
        label: "Baby Sitter",
        icon: Icons.child_care,
        backgroundColor: Colors.white,
        avatarColor: Colors.purple,
        address: '',
      ),
      ServiceModel(
        label: "Driver",
        icon: Icons.drive_eta,
        backgroundColor: Colors.white,
        avatarColor: Colors.blue,
        address: '',
      ),
      ServiceModel(
        label: "Security Guard",
        icon: Icons.security,
        backgroundColor: Colors.white,
        avatarColor: Colors.black,
        address: '',
      ),
      ServiceModel(
        label: "Barber",
        icon: Icons.content_cut,
        backgroundColor: Colors.white,
        avatarColor: Colors.deepPurple,
        address: '',
      ),
      ServiceModel(
        label: 'Restaurant',
        icon: Icons.restaurant,
        backgroundColor: Colors.white,
        avatarColor: Colors.green,
        address: '',
      ),
      ServiceModel(
        label: 'Hotel',
        icon: Icons.hotel,
        backgroundColor: Colors.white,
        avatarColor: Colors.brown,
        address: '',
      ),
      ServiceModel(
        label: 'Cafe',
        icon: Icons.coffee,
        backgroundColor: Colors.white,
        avatarColor: Colors.orange,
        address: '',
      ),
      ServiceModel(
        label: 'Labour',
        icon: Icons.work,
        backgroundColor: Colors.white,
        avatarColor: Colors.indigo,
        address: '',
      ),
    ];
  }

  void selectService(ServiceModel service) {
    _selectedService = service;
    notifyListeners();
  }
}
