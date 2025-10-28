import 'package:chitral_dost_app/models/worker_model.dart';
import 'package:chitral_dost_app/screens/booking_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkerProfile extends StatelessWidget {
  final WorkerModel worker;
  const WorkerProfile({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Worker Profile',
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.orangeAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.notification_add, color: Colors.white),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/man.png'),
            ),
          ),
          const SizedBox(width: 10),
        ],
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
                            const SizedBox(height: 60), // space for avatar
                            Text(
                              worker.name,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.orangeAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              worker.service.label,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: Colors.orangeAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              worker.place,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.orangeAccent,
                              ),
                            ),

                            const SizedBox(height: 5),
                            Text(
                              '📞${worker.phone}',
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
                        top: 0,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/man.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetail(workers: [worker]),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                fixedSize: Size(275, 45),
              ),
              child: Text('Booking Now'),
            ),
          ],
        ),
      ),
    );
  }
}
