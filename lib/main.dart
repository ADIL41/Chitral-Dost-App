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
  // 1. Ensure Flutter bindings are initialized
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // 2. Preserve the native splash screen while initialization runs
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 3. Initialize Firebase (must be done before runApp)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Variable to hold the screen determined by SharedPreferences
  Widget? _initialScreen;

  @override
  void initState() {
    super.initState();
    // Start the process of determining the first screen
    _determineInitialScreen();
  }

  Future<void> _determineInitialScreen() async {
    // Optional: Add a short delay to ensure minimum logo display time (e.g., 500ms)
    await Future.delayed(const Duration(milliseconds: 500));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstTime = prefs.getBool('isFirstTime');
    bool? isLoggedIn = prefs.getBool('isLoggedIn');

    if (isFirstTime == null || isFirstTime == true) {
      // First time → show Welcome
      await prefs.setBool('isFirstTime', false);
      _initialScreen = const WelcomeScreen();
    } else if (isLoggedIn == true) {
      // Already logged in → go to home
      _initialScreen = const BottomNavbar();
    } else {
      // Not first time, but logged out → go to login
      _initialScreen = const LoginScreen();
    }

    // 4. Initialization complete, remove the native splash screen
    FlutterNativeSplash.remove();
    // 5. Trigger a rebuild to show the correct initial screen
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // If _initialScreen is null, we show a basic loading screen
    // while initialization is still running after the native splash is gone.
    if (_initialScreen == null) {
      // Return a simple, un-themed loading widget
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    // Once _initialScreen is set, build the main app structure
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
        // Use the determined screen as the home widget
        home: _initialScreen,
      ),
    );
  }
}
