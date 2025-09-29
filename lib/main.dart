import 'package:chitral_dost_app/theme/app_theme.dart';
import 'package:chitral_dost_app/screens/splash_scree.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chitral Dost',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
