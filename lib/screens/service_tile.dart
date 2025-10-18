import 'package:flutter/material.dart';

class ServiceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color avatarColor;
  final VoidCallback? onTap;

  const ServiceTile({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.avatarColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff5f7fa), Color(0xffc3cfe2)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: avatarColor,
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
