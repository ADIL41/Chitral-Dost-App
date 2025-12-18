import 'dart:async';

import 'package:chitral_dost_app/firebase_options.dart';
import 'package:chitral_dost_app/provider/service_provider.dart';
import 'package:chitral_dost_app/provider/worker_provider.dart';
import 'package:chitral_dost_app/screens/bottom_navbar.dart';
import 'package:chitral_dost_app/screens/login_screen.dart';
import 'package:chitral_dost_app/screens/welcome_screen.dart';
import 'package:chitral_dost_app/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? _initialScreen;

  @override
  void initState() {
    super.initState();

    _determineInitialScreen();
  }

  Future<void> _determineInitialScreen() async {
    await Future.delayed(const Duration(milliseconds: 500));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstTime = prefs.getBool('isFirstTime');
    bool? isLoggedIn = prefs.getBool('isLoggedIn');

    if (isFirstTime == null || isFirstTime == true) {
      await prefs.setBool('isFirstTime', false);
      _initialScreen = const WelcomeScreen();
    } else if (isLoggedIn == true) {
      _initialScreen = const BottomNavbar();
    } else {
      _initialScreen = const LoginScreen();
    }

    FlutterNativeSplash.remove();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_initialScreen == null) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ServiceProvider()),
        ChangeNotifierProvider(create: (context) => WorkerProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chitral Dost',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.system,

        home: _initialScreen,
      ),
    );
  }
}
