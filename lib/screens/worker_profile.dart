import 'package:chitral_dost_app/models/service_model.dart';
import 'package:chitral_dost_app/models/worker_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkerProfile extends StatelessWidget {
  final WorkerModel worker;
  const WorkerProfile({super.key, required this.worker});

  // Updated to use the recommended modern approach (canLaunchUrl, launchUrl)
  Future<void> _makePhoneCall(String phoneNumber) async {
    // Safely create the Uri
    final Uri launchUri = Uri.parse('tel:$phoneNumber');

    // Check if the URL can be launched
    if (!await launchUrl(launchUri)) {
      throw Exception('Could not launch $launchUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- REQUIRED FIXES ARE HERE ---
    final String name = worker.name;
    final ServiceModel serviceModel = worker.service;

    // 1. FIX: Initialize the service label by accessing the .label property of serviceModel
    final String serviceLabel = serviceModel.label;

    final String place = worker.place;
    final String phone = worker.phone;
    final String description = worker.description;
    final String? profilePictureUrl = worker.profilePictureUrl;
    // --- END REQUIRED FIXES ---

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Worker Profile',
          style: GoogleFonts.poppins(
            fontSize: 18,
            // You may need to replace secondaryHeaderColor with a defined color
            color: Theme.of(context).secondaryHeaderColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[800],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 0),
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xff84fab0), Color(0xff8fd3f4)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 65), // space for avatar
                            Text(
                              // Using the correct local variable 'name'
                              name,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.orangeAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              // 2. FIX: Use the correctly initialized 'serviceLabel' variable
                              serviceLabel,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: Colors.orangeAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              // Using the correct local variable 'place'
                              '📍  $place',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.orangeAccent,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              // Using the correct local variable 'phone'
                              '📞$phone',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                      // ... (Avatar remains the same)
                      // ✅ NEW CODE WITH PROFILE PICTURE LOGIC:
                      Positioned(
                        top: 4,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors
                              .white, // Add a background color for contrast
                          // Check if the URL is not null and not empty
                          backgroundImage:
                              (profilePictureUrl != null &&
                                  profilePictureUrl.isNotEmpty)
                              // If a URL exists, use NetworkImage to fetch the picture
                              ? NetworkImage(profilePictureUrl)
                                    as ImageProvider<Object>?
                              : null,

                          // The child widget (the Icon) only shows if backgroundImage is null
                          // (i.e., no picture URL found)
                          child:
                              (profilePictureUrl == null ||
                                  profilePictureUrl.isEmpty)
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.black,
                                )
                              : null, // No child needed if the image is loading/loaded
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // DESCRIPTION SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff84fab0), Color(0xff8fd3f4)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About My Service',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      // Using the correct local variable 'description'
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 50),

            // Call button functionality is correct
            ElevatedButton(
              onPressed: () =>
                  _makePhoneCall(phone), // Calls function with phone variable
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                fixedSize: const Size(275, 45),
              ),
              child: const Text('Call Now'),
            ),
          ],
        ),
      ),
    );
  }
}
