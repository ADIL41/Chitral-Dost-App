import 'package:flutter/material.dart';
import 'package:chitral_dost_app/screens/service_tile.dart';
import 'package:chitral_dost_app/screens/worker_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notification_add, color: Colors.white),
            onPressed: () {},
          ),
          CircleAvatar(
            backgroundColor: Colors.orangeAccent[200],
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          SizedBox(width: 10),
        ],
        title: Text(
          'CHITRAL DOST',
          style: TextStyle(
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
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'What service do you need today?',
              style: TextStyle(fontSize: 16, color: Colors.orangeAccent),
            ),
            SizedBox(height: 20),
            Text(
              'Explore Services',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal[900],
              ),
            ),
            SizedBox(height: 12),

            // Service Grid
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return ServiceTile(
                    icon: Icons.miscellaneous_services,
                    label: 'Service ${index + 1}',
                    backgroundColor: Colors.teal.shade800,
                    avatarColor: Colors.blue.shade200,
                  );
                },
              ),
            ),

            SizedBox(height: 24),
            Text(
              'Need Urgent Help?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal[900],
              ),
            ),
            SizedBox(height: 12),

            // Worker Card
            WorkerCard(),

            SizedBox(height: 20),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.teal[800],
        showSelectedLabels: true,
        showUnselectedLabels: false,
        iconSize: 25,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Booking',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
