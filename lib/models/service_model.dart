import 'package:flutter/material.dart';

class ServiceModel {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color avatarColor;
  final String place;

  ServiceModel({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.avatarColor,
    required this.place,
  });
}
