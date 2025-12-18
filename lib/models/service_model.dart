import 'package:flutter/material.dart';

class ServiceModel {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color avatarColor;

  ServiceModel({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.avatarColor,
  });

  static final List<ServiceModel> allServices = [
    ServiceModel(
      label: "Cleaning",
      icon: Icons.cleaning_services,
      backgroundColor: const Color(0xFFB0E0E6),
      avatarColor: Colors.blue,
    ),
    ServiceModel(
      label: "Plumbing",
      icon: Icons.plumbing,
      backgroundColor: const Color(0xFFF9C0C0),
      avatarColor: Colors.green,
    ),
    ServiceModel(
      label: "Electrician",
      icon: Icons.electrical_services,
      backgroundColor: const Color(0xFFFFDAB9),
      avatarColor: Colors.orange,
    ),
    ServiceModel(
      label: "Delivery",
      icon: Icons.local_shipping,
      backgroundColor: const Color(0xFFE6CCFF),
      avatarColor: Colors.purple,
    ),
    ServiceModel(
      label: "Police",
      icon: Icons.local_police,
      backgroundColor: const Color(0xFFFFCCCC),
      avatarColor: Colors.redAccent,
    ),
    ServiceModel(
      label: "Doctor",
      icon: Icons.medical_services,
      backgroundColor: const Color(0xFFCCFFCC),
      avatarColor: Colors.teal,
    ),
    ServiceModel(
      label: "Bike Rider",
      icon: Icons.pedal_bike,
      backgroundColor: const Color(0xFFCCCCFF),
      avatarColor: Colors.indigo,
    ),
    ServiceModel(
      label: "Carpenter",
      icon: Icons.handyman,
      backgroundColor: const Color(0xFFD2B48C),
      avatarColor: Colors.brown,
    ),
    ServiceModel(
      label: "Painter",
      icon: Icons.format_paint,
      backgroundColor: const Color(0xFFFFE0B2),
      avatarColor: Colors.deepOrange,
    ),
    ServiceModel(
      label: "Gardener",
      icon: Icons.grass,
      backgroundColor: const Color(0xFFE0FFE0),
      avatarColor: Colors.green,
    ),
    ServiceModel(
      label: "AC Technician",
      icon: Icons.ac_unit,
      backgroundColor: const Color(0xFFB3E5FC),
      avatarColor: Colors.lightBlue,
    ),
    ServiceModel(
      label: "Appliance Repair",
      icon: Icons.kitchen,
      backgroundColor: const Color(0xFFE0E0E0),
      avatarColor: Colors.indigo,
    ),
    ServiceModel(
      label: "Maid Service",
      icon: Icons.home_work,
      backgroundColor: const Color(0xFFFFC0CB),
      avatarColor: Colors.pink,
    ),
    ServiceModel(
      label: "Laundry",
      icon: Icons.local_laundry_service,
      backgroundColor: const Color(0xFFADD8E6),
      avatarColor: Colors.blueGrey,
    ),
    ServiceModel(
      label: "Cook",
      icon: Icons.restaurant,
      backgroundColor: const Color(0xFFFFD700),
      avatarColor: Colors.redAccent,
    ),
    ServiceModel(
      label: "Tutor",
      icon: Icons.menu_book,
      backgroundColor: const Color(0xFFF0F8FF),
      avatarColor: Colors.teal,
    ),
    ServiceModel(
      label: "Baby Sitter",
      icon: Icons.child_care,
      backgroundColor: const Color(0xFFFFFACD),
      avatarColor: Colors.purple,
    ),
    ServiceModel(
      label: "Driver",
      icon: Icons.drive_eta,
      backgroundColor: const Color(0xFFD3D3D3),
      avatarColor: Colors.blue,
    ),
    ServiceModel(
      label: "Security Guard",
      icon: Icons.security,
      backgroundColor: const Color(0xFF696969),
      avatarColor: Colors.black,
    ),
    ServiceModel(
      label: "Barber",
      icon: Icons.content_cut,
      backgroundColor: const Color(0xFFBA55D3),
      avatarColor: Colors.deepPurple,
    ),
  ];

  static final Map<String, ServiceModel> _serviceLookup = {
    for (var service in allServices) service.label: service,
  };

  factory ServiceModel.fromLabel(String label) {
    return _serviceLookup[label] ??
        ServiceModel(
          label: label,
          icon: Icons.error,
          backgroundColor: Colors.red,
          avatarColor: Colors.white,
        );
  }
}
