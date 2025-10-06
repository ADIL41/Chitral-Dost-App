import 'package:chitral_dost_app/screens/service_tile.dart';
import 'package:chitral_dost_app/screens/worker_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        centerTitle: true,
        actions: [
          Icon(Icons.notification_add, color: Colors.white),
          SizedBox(width: 10),
          SizedBox(
            width: 50,
            child: CircleAvatar(
              backgroundColor: Colors.orangeAccent[200],
              child: Icon(Icons.person, color: Colors.white, size: 30),
            ),
          ),
        ],
        title: Text(
          'CHITRAL DOST',

          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orangeAccent,
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              'Good Morning,Adil!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'What service do you need today?',
              style: TextStyle(fontSize: 16),
            ),
          ),

          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Explore Services',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    itemCount: 20,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
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
              ),
            ),
          ),

          SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Need Urgent Help?',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 15),

          //worker card
          WorkerCard(),

          //bottomNavigationBar
          BottomNavigationBar(
            iconSize: 25,
            fixedColor: Colors.teal[800],

            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.orangeAccent),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_online, color: Colors.orangeAccent),
                label: 'Booking',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.orangeAccent),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history, color: Colors.orangeAccent),
                label: 'History',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
