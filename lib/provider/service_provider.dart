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
        address: 'Drosh',
      ),
      ServiceModel(
        label: "Plumbing",
        icon: Icons.plumbing,
        backgroundColor: Colors.white,
        avatarColor: Colors.green,
        address: 'Chitral',
      ),
      ServiceModel(
        label: "Electrician",
        icon: Icons.electrical_services,
        backgroundColor: Colors.white,
        avatarColor: Colors.orange,
        address: 'Serdur',
      ),
      ServiceModel(
        label: "Delivery",
        icon: Icons.local_shipping,
        backgroundColor: Colors.white,
        avatarColor: Colors.purple,
        address: 'Shamsabad',
      ),
      ServiceModel(
        label: "Police",
        icon: Icons.local_police,
        backgroundColor: Colors.white,
        avatarColor: Colors.redAccent,
        address: 'Town Chitral',
      ),
      ServiceModel(
        label: "Doctor",
        icon: Icons.medical_services,
        backgroundColor: Colors.white,
        avatarColor: Colors.teal,
        address: 'Kesu Drosh',
      ),
      ServiceModel(
        label: "Bike Rider",
        icon: Icons.pedal_bike,
        backgroundColor: Colors.white,
        avatarColor: Colors.indigo,
        address: 'Kalkatak',
      ),
      ServiceModel(
        label: "Carpenter",
        icon: Icons.handyman,
        backgroundColor: Colors.white,
        avatarColor: Colors.brown,
        address: 'Sheshi',
      ),
      ServiceModel(
        label: "Painter",
        icon: Icons.format_paint,
        backgroundColor: Colors.white,
        avatarColor: Colors.deepOrange,
        address: 'Drosh',
      ),
      ServiceModel(
        label: "Gardener",
        icon: Icons.grass,
        backgroundColor: Colors.white,
        avatarColor: Colors.green,
        address: 'Sheshi',
      ),
      ServiceModel(
        label: "AC Technician",
        icon: Icons.ac_unit,
        backgroundColor: Colors.white,
        avatarColor: Colors.lightBlue,
        address: 'Chitral',
      ),
      ServiceModel(
        label: "Appliance Repair",
        icon: Icons.kitchen,
        backgroundColor: Colors.white,
        avatarColor: Colors.indigo,
        address: 'Drosh',
      ),
      ServiceModel(
        label: "Maid Service",
        icon: Icons.cleaning_services,
        backgroundColor: Colors.white,
        avatarColor: Colors.pink,
        address: 'Drosh',
      ),
      ServiceModel(
        label: "Laundry",
        icon: Icons.local_laundry_service,
        backgroundColor: Colors.white,
        avatarColor: Colors.blueGrey,
        address: 'Drosh',
      ),
      ServiceModel(
        label: "Cook",
        icon: Icons.restaurant,
        backgroundColor: Colors.white,
        avatarColor: Colors.redAccent,
        address: 'Drosh',
      ),
      ServiceModel(
        label: "Tutor",
        icon: Icons.menu_book,
        backgroundColor: Colors.white,
        avatarColor: Colors.teal,
        address: 'Drosh',
      ),
      ServiceModel(
        label: "Baby Sitter",
        icon: Icons.child_care,
        backgroundColor: Colors.white,
        avatarColor: Colors.purple,
        address: 'Drosh',
      ),
      ServiceModel(
        label: "Driver",
        icon: Icons.drive_eta,
        backgroundColor: Colors.white,
        avatarColor: Colors.blue,
        address: 'Drosh',
      ),
      ServiceModel(
        label: "Security Guard",
        icon: Icons.security,
        backgroundColor: Colors.white,
        avatarColor: Colors.black,
        address: 'Drosh',
      ),
      ServiceModel(
        label: "Barber",
        icon: Icons.content_cut,
        backgroundColor: Colors.white,
        avatarColor: Colors.deepPurple,
        address: 'Drosh',
      ),
      ServiceModel(
        label: 'Restaurant',
        icon: Icons.restaurant,
        backgroundColor: Colors.white,
        avatarColor: Colors.green,
        address: 'Drosh',
      ),
    ];
  }

  void selectService(ServiceModel service) {
    _selectedService = service;
    notifyListeners();
  }

  
}
