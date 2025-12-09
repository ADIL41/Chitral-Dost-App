import 'dart:async';

import 'package:chitral_dost_app/screens/bottom_navbar.dart';
import 'package:chitral_dost_app/screens/login_screen.dart';
import 'package:chitral_dost_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2)); // splash delay

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstTime = prefs.getBool('isFirstTime');
    bool? isLoggedIn = prefs.getBool('isLoggedIn');

    if (!mounted) return;

    if (isFirstTime == null || isFirstTime == true) {
      //  First time → show Welcome
      await prefs.setBool('isFirstTime', false);
      if (!mounted) return; // mark as not first time anymore
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    } else if (isLoggedIn == true) {
      //  Already logged in → go to home
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavbar()),
      );
    } else { 
      // Not first time, but logged out → go to login
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 150),
            const SizedBox(height: 20),
            Text(
              "Chitral Dost",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Your Trusted Partner for Home Services",
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(), // loader while deciding
          ],
        ),
      ),
    );
  }
}
