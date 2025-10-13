import 'package:flutter/material.dart';
import 'package:chitral_dost_app/screens/service_tile.dart';
import 'package:chitral_dost_app/screens/worker_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  // ignore: unused_field
  final List<Widget> _screens = [
    Center(child: Text("Home Screen")),
    Center(child: Text("Booking Screen")),
    Center(child: Text("Profile Screen")),
    Center(child: Text("History Screen")),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Map<String, dynamic>> serviceData = [
    {
      "icon": Icons.cleaning_services,
      "label": "Cleaning",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.blue,
    },
    {
      "icon": Icons.plumbing,
      "label": "Plumbing",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.green,
    },
    {
      "icon": Icons.electrical_services,
      "label": "Electrician",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.orange,
    },
    {
      "icon": Icons.local_shipping,
      "label": "Delivery",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.purple,
    },

    {
      "icon": Icons.local_police,
      "label": "Police",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.redAccent,
    },
    {
      "icon": Icons.medical_services,
      "label": "Doctor",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.teal,
    },
    {
      "icon": Icons.pedal_bike,
      "label": "Bike Rider",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.indigo,
    },
    {
      "icon": Icons.handyman,
      "label": "Carpenter",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.brown,
    },
    {
      "icon": Icons.format_paint,
      "label": "Painter",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.deepOrange,
    },
    {
      "icon": Icons.grass,
      "label": "Gardener",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.green,
    },
    {
      "icon": Icons.ac_unit,
      "label": "AC Technician",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.lightBlue,
    },
    {
      "icon": Icons.kitchen,
      "label": "Appliance Repair",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.indigo,
    },
    {
      "icon": Icons.cleaning_services,
      "label": "Maid Service",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.pink,
    },
    {
      "icon": Icons.local_laundry_service,
      "label": "Laundry",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.blueGrey,
    },
    {
      "icon": Icons.restaurant,
      "label": "Cook",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.redAccent,
    },
    {
      "icon": Icons.menu_book,
      "label": "Tutor",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.teal,
    },
    {
      "icon": Icons.child_care,
      "label": "Baby Sitter",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.purple,
    },
    {
      "icon": Icons.drive_eta,
      "label": "Driver",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.blue,
    },
    {
      "icon": Icons.security,
      "label": "Security Guard",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.black,
    },
    {
      "icon": Icons.content_cut,
      "label": "Barber",
      "backgroundColor": Colors.white,
      "avatarColor": Colors.deepPurple,
    },
  ];

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
          CircleAvatar(backgroundImage: AssetImage('assets/images/man.png')),
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
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: serviceData.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final service = serviceData[index];
                  return ServiceTile(
                    icon: service["icon"],
                    label: service["label"],
                    backgroundColor: service['backgroundColor'],
                    avatarColor: service['avatarColor'],
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
                color: Colors.black,
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.teal[800],
        backgroundColor: Colors.teal[800],
        showSelectedLabels: true,
        showUnselectedLabels: true,
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
