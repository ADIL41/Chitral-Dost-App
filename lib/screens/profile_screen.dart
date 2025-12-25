import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitral_dost_app/provider/profile_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showEditProfileDialog({
    required BuildContext context,
    required bool isWorker,
    required ProfileProvider profileProvider,
    required String currentName,
    required String currentPhone,
  }) {
    final nameController = TextEditingController(text: currentName);
    final phoneController = TextEditingController(text: currentPhone);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await profileProvider.updateProfileFields(
                  context: ctx,
                  isWorker: isWorker,
                  name: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                );
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Center(child: Text('Please log in.'));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal[800],
        title: Text(
          'Profile Management',
          style: GoogleFonts.poppins(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 20,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<bool>(
        future: Provider.of<ProfileProvider>(context, listen: false).isWorker(),
        builder: (context, workerSnapshot) {
          final bool isWorker = workerSnapshot.data ?? false;

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection(isWorker ? 'workers' : 'users')
                .doc(currentUser.uid)
                .snapshots(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting ||
                  workerSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return const Center(child: Text('Profile data not found.'));
              }

              final userData =
                  userSnapshot.data!.data() as Map<String, dynamic>;
              final String? profilePictureUrl =
                  userData['profilePictureUrl'] as String?;

              final String userName = userData['name'] ?? 'No Name';
              final String userPhone = userData['phone'] ?? 'No Phone';
              final String userEmail =
                  userData['email'] ?? currentUser.email ?? 'no email';

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (isWorker)
                        Consumer<ProfileProvider>(
                          builder: (context, profileProvider, _) {
                            return Chip(
                              avatar: const Icon(
                                Icons.engineering,
                                color: Colors.white,
                                size: 18,
                              ),
                              label: profileProvider.isDeletingWorker
                                  ? const Text(
                                      'Deleting...',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : const Text(
                                      'Worker Account',
                                      style: TextStyle(color: Colors.white),
                                    ),
                              backgroundColor: Colors.red[700],
                              deleteIcon: profileProvider.isDeletingWorker
                                  ? const SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.delete_forever,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                              onDeleted: profileProvider.isDeletingWorker
                                  ? null
                                  : () => profileProvider
                                        .showDeleteConfirmationDialog(context),
                            );
                          },
                        ),
                      const SizedBox(height: 10),

                      Consumer<ProfileProvider>(
                        builder: (context, profileProvider, _) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.teal.shade200,
                                backgroundImage: profilePictureUrl != null
                                    ? CachedNetworkImageProvider(
                                            profilePictureUrl,
                                          )
                                          as ImageProvider
                                    : null,
                                child: profilePictureUrl == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.black,
                                      )
                                    : null,
                              ),
                              if (profileProvider.isUploading)
                                const Positioned.fill(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: profileProvider.isUploading
                                      ? null
                                      : () => profileProvider
                                            .changeProfilePicture(
                                              context: context,
                                              isWorker: isWorker,
                                            ),
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.teal[800],
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 16),
                      Text(
                        userName,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Text(
                            'Contact Info',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Consumer<ProfileProvider>(
                            builder: (context, profileProvider, _) {
                              return IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () {
                                  _showEditProfileDialog(
                                    context: context,
                                    isWorker: isWorker,
                                    profileProvider: profileProvider,
                                    currentName: userName,
                                    currentPhone: userPhone,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.teal.shade200,
                            width: 1.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.phone,
                                  color: Colors.teal[700],
                                ),
                                title: Text(
                                  userPhone,
                                  style: GoogleFonts.poppins(fontSize: 16),
                                ),
                              ),
                              const Divider(),
                              ListTile(
                                leading: Icon(
                                  Icons.email,
                                  color: Colors.teal[700],
                                ),
                                title: Text(
                                  userEmail,
                                  style: GoogleFonts.poppins(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
