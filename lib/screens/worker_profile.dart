import 'package:chitral_dost_app/screens/booking_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkerProfile extends StatelessWidget {
  final DocumentSnapshot worker;
  const WorkerProfile({super.key, required this.worker});
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    final workerData = worker.data() as Map<String, dynamic>;
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
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 0),
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff84fab0), Color(0xff8fd3f4)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 65), // space for avatar
                            Text(
                              workerData['name'] ?? 'no name',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.orangeAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              workerData['service'] ?? 'no service',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: Colors.orangeAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '📍  ${workerData['place'] ?? 'No Place'}',

                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.orangeAccent,
                              ),
                            ),

                            const SizedBox(height: 5),
                            Text(
                              '📞${workerData['phone'] ?? 'No Phone'}',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                      const Positioned(
                        top: 4,
                        child: CircleAvatar(
                          radius: 50,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 🆕 DESCRIPTION SECTION - ADDED HERE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
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
                      workerData['description'] ?? 'No Description',
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingDetail()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                fixedSize: Size(275, 45),
              ),
              child: InkWell(
                onTap: () => _makePhoneCall(workerData['phone']),
                child: const Text('Call Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
