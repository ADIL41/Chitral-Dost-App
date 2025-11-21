import 'package:chitral_dost_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = "English";
  bool _isLoggingOut = false;

  Future<void> _logoutUser() async {
    if (_isLoggingOut) return;

    setState(() => _isLoggingOut = true);

    try {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 20,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[800],
      ),
      body: ListView(
        children: [
          // Profile Info
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage("assets/user.png"),
            ),
            title: const Text("User Name"),
            subtitle: const Text("user@email.com"),
          ),

          const Divider(),

          // Language
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              items: const [
                DropdownMenuItem(value: "English", child: Text("English")),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
          ),

          const Divider(),

          // Help & Support
          const ListTile(
            leading: Icon(Icons.help),
            title: Text("Help & Support"),
          ),

          // About App
          const ListTile(leading: Icon(Icons.info), title: Text("About")),

          const Divider(),

          // Logout
          ListTile(
            leading: _isLoggingOut
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.red,
                    ),
                  )
                : const Icon(Icons.logout, color: Colors.red),
            title: _isLoggingOut
                ? Text("Logging out...", style: TextStyle(color: Colors.red))
                : const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: _isLoggingOut ? null : _logoutUser,
          ),
        ],
      ),
    );
  }
}