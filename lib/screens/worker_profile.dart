import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitral_dost_app/models/service_model.dart';
import 'package:chitral_dost_app/models/worker_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkerProfile extends StatelessWidget {
  final WorkerModel worker;
  const WorkerProfile({super.key, required this.worker});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri.parse('tel:$phoneNumber');

    if (!await launchUrl(launchUri)) {
      throw Exception('Could not launch $launchUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = worker.name;
    final ServiceModel serviceModel = worker.service;

    final String serviceLabel = serviceModel.label;

    final String place = worker.place;
    final String phone = worker.phone;
    final String description = worker.description;
    final String? profilePictureUrl = worker.profilePictureUrl;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Worker Profile',
          style: GoogleFonts.poppins(
            fontSize: 18,

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
                            const SizedBox(height: 65),
                            Text(
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
                              serviceLabel,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: Colors.orangeAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '📍  $place',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.orangeAccent,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
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

                      Positioned(
                        top: 4,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,

                          backgroundImage:
                              (profilePictureUrl != null &&
                                  profilePictureUrl.isNotEmpty)
                              ? CachedNetworkImageProvider(profilePictureUrl)
                                    as ImageProvider<Object>?
                              : null,

                          child:
                              (profilePictureUrl == null ||
                                  profilePictureUrl.isEmpty)
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.black,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

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

            ElevatedButton(
              onPressed: () => _makePhoneCall(phone),
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
