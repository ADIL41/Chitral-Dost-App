import 'package:chitral_dost_app/provider/service_provider.dart';
import 'package:chitral_dost_app/screens/worker_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:chitral_dost_app/screens/service_tile.dart';
import 'package:chitral_dost_app/screens/add_service_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notification_add, color: Colors.white),
            onPressed: () {},
          ),
          CircleAvatar(backgroundImage: AssetImage('assets/images/man.png')),
          SizedBox(width: 10),
        ],
        title: Text(
          'CHITRAL DOST',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.orangeAccent,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning, Adil!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'What service do you need today?',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.orangeAccent,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Explore Services',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12),

            // Service Grid
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff84fab0), Color(0xff8fd3f4)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(12),
              child: Consumer<ServiceProvider>(
                builder: (context, serviceProvider, child) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: serviceProvider.services.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final service = serviceProvider.services[index];
                      return ServiceTile(
                        icon: service.icon,
                        label: service.label,
                        backgroundColor: service.backgroundColor,
                        avatarColor: service.avatarColor,
                        onTap: () {
                          final provider = Provider.of<ServiceProvider>(
                            context,
                            listen: false,
                          );
                          provider.selectService(service);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WorkerListScreen(service: service),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 24),
            Text(
              'Add Services You  Here 👇 ',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12),

            // ServiceCard
            AddSerciveCard(),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
