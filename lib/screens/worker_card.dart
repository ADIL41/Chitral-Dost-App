import 'package:flutter/material.dart';

class WorkerCard extends StatelessWidget {
  const WorkerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade800, Colors.teal.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find a Worker Now',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Connect with available skilled professionals for immediate service requests.',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: Colors.white54,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  textStyle: TextStyle(fontSize: screenWidth * 0.035),
                ),
                child: Text('Get Started'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
