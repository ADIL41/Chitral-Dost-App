import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal[800],
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 20,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      //fetching data from firebase firestore
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = snapshot.data!.data() as Map<String, dynamic>;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.teal.shade200,
                    child: Icon(Icons.person, size: 60, color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user['name'] ?? 'No Name',

                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Info Card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.teal.shade200, width: 1.5),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.phone, color: Colors.teal[700]),
                            title: Text(
                              user['phone'] ?? 'No Phone',

                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Icon(Icons.email, color: Colors.teal[700]),
                            title: Text(
                              user['email'] ?? 'no email',
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
