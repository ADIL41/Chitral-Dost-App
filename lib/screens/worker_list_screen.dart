import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkerListScreen extends StatelessWidget {
  final String serviceLabel; // The selected service from HomeScreen
  const WorkerListScreen({super.key, required this.serviceLabel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$serviceLabel Workers',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal[800],
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('workers')
            .where('service', isEqualTo: serviceLabel)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No workers found.'));
          }

          final workers = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: workers.length,
            itemBuilder: (context, index) {
              final worker = workers[index];
              return Container(
                width: double.infinity,
                color: Colors.yellow,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(worker['name']),
                  subtitle: Text(
                    '${worker['description']}\nPhone: ${worker['phone']}\nPlace: ${worker['place']}',
                  ),
                  isThreeLine: true,
                  leading: const Icon(Icons.person, color: Colors.teal),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
