import 'package:flutter/material.dart';

class WorkerCard extends StatelessWidget {
  const WorkerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 180, // Slightly reduced height
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.teal[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find a Worker Now',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Flexible(
                child: Text(
                  'Connect with available skilled professionals. ',
                  style: TextStyle(fontSize: 13, color: Colors.white54),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    textStyle: TextStyle(fontSize: 13),
                  ),
                  child: Text('Get Started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
