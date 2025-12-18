import 'package:chitral_dost_app/provider/worker_provider.dart';
import 'package:chitral_dost_app/screens/booking_detail.dart';
import 'package:chitral_dost_app/screens/home_screen.dart';
import 'package:chitral_dost_app/screens/profile_screen.dart';
import 'package:chitral_dost_app/screens/setting_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
      extendBody: true,
      body: _getPage(_selectedIndex),

      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 55.0,

        color: Colors.teal.shade800,
        buttonBackgroundColor: Colors.deepOrange.shade400,
        backgroundColor: Colors.transparent,

        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),

        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: _selectedIndex == 0 ? Colors.white : Colors.white,
          ),
          Icon(
            Icons.book_online,
            size: 30,
            color: _selectedIndex == 1 ? Colors.white : Colors.white,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: _selectedIndex == 2 ? Colors.white : Colors.white,
          ),
          Icon(
            Icons.settings,
            size: 30,
            color: _selectedIndex == 3 ? Colors.white : Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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
            return BookingDetail();
          },
        );
      case 2:
        return ProfileScreen();
      case 3:
        return SettingsScreen();
      default:
        return HomeScreen();
    }
  }
}
