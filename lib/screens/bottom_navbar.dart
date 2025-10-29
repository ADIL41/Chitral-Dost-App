import 'package:chitral_dost_app/provider/worker_provider.dart';
import 'package:chitral_dost_app/screens/booking_detail.dart';
import 'package:chitral_dost_app/screens/home_screen.dart';
import 'package:chitral_dost_app/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.white,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return Consumer<WorkerProvider>(
          builder: (context, workerProvider, child) {
            return BookingDetail(workers: workerProvider.workers);
          },
        );
      case 2:
        return SettingsScreen();
      default:
        return HomeScreen();
    }
  }
}
