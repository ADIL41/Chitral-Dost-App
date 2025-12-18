import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitral_dost_app/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = "English";
  bool _isLoggingOut = false;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<bool> _isWorker() async {
    final userId = currentUser?.uid;
    if (userId == null) return false;
    final workerDoc = await FirebaseFirestore.instance
        .collection('workers')
        .doc(userId)
        .get();
    return workerDoc.exists;
  }

  Future<void> _logoutUser() async {
    if (_isLoggingOut) return;

    setState(() => _isLoggingOut = true);

    try {
      await FirebaseAuth.instance.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('userId');
      await prefs.remove('userEmail');

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
    if (currentUser == null) {
      return const Center(child: Text("Please log in."));
    }

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

      body: FutureBuilder<bool>(
        future: _isWorker(),
        builder: (context, workerSnapshot) {
          if (workerSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final bool isWorker = workerSnapshot.data ?? false;
          final String collectionName = isWorker ? 'workers' : 'users';

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection(collectionName)
                .doc(currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data?.data() == null) {
                return const Center(child: Text("No user data found"));
              }

              final user = snapshot.data!.data() as Map<String, dynamic>;
              final String? profilePictureUrl =
                  user['profilePictureUrl'] as String?;

              return ListView(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.teal.shade200,
                      backgroundImage:
                          profilePictureUrl != null &&
                              profilePictureUrl.isNotEmpty
                          ? CachedNetworkImageProvider(profilePictureUrl)
                          : null,
                      child:
                          (profilePictureUrl == null ||
                              profilePictureUrl.isEmpty)
                          ? const Icon(Icons.person, color: Colors.black)
                          : null,
                    ),
                    title: Text(user['name'] ?? 'No Name'),
                    subtitle: Text(user['email'] ?? 'no email'),
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text("Language"),
                    trailing: DropdownButton<String>(
                      value: _selectedLanguage,
                      items: const [
                        DropdownMenuItem(
                          value: "English",
                          child: Text("English"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                      },
                    ),
                  ),

                  const Divider(),

                  const ListTile(
                    leading: Icon(Icons.help),
                    title: Text("Help & Support"),
                  ),

                  const ListTile(
                    leading: Icon(Icons.info),
                    title: Text("About"),
                  ),

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
                        ? Text(
                            "Logging out...",
                            style: TextStyle(color: Colors.red),
                          )
                        : const Text(
                            "Logout",
                            style: TextStyle(color: Colors.red),
                          ),
                    onTap: _isLoggingOut ? null : _logoutUser,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
