import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/cloudinary_config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State to manage the upload process loading indicator
  bool _isUploading = false;
  bool _isDeletingWorker = false;

  // HELPER: Check if user has a worker document
  Future<bool> _isWorker() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return false;
    final workerDoc = await FirebaseFirestore.instance
        .collection('workers')
        .doc(userId)
        .get();
    return workerDoc.exists;
  }

  // CORE LOGIC: Worker Profile Deletion
  Future<void> _deleteWorkerProfile() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    setState(() {
      _isDeletingWorker = true;
    });
    try {
      // 1. Delete the worker document from Firestore
      await FirebaseFirestore.instance
          .collection('workers')
          .doc(currentUser.uid)
          .delete();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Worker profile deleted successfully. You are now a standard user.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete worker profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDeletingWorker = false;
        });
      }
    }
  } // 💡 FIX: Closing brace for _deleteWorkerProfile 💡

  Future<void> _showDeleteConfirmationDialog() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
            textAlign: TextAlign.center,
            'Are you sure you want to delete your Worker Service Profile? This action is permanent and cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _deleteWorkerProfile();
    }
  }

  // UPLOAD LOGIC: Dynamically targets 'workers' or 'users' collection
  Future<void> _changeProfilePicture({required bool isWorker}) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    // 💡 FIX: Restoring image picking logic 💡
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;
    // -------------------------------------

    setState(() {
      _isUploading = true;
    });

    // Determine the collection folder based on the user's role for Cloudinary
    final String folderName = isWorker ? 'worker_profiles' : 'user_profiles';
    final db = FirebaseFirestore.instance;
    final uid = currentUser.uid;

    try {
      // 1. Upload to Cloudinary
      final response = await CloudinaryConfig.cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          pickedFile.path,
          folder: folderName,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      final String imageUrl = response.secureUrl;

      // 2. SYNCHRONIZATION: Update Firebase using an Atomic Batch Write
      if (imageUrl.isNotEmpty) {
        // Initialize the Batch
        final batch = db.batch();

        // Data to be written to both collections
        final updateData = {
          'profilePictureUrl': imageUrl,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        // A. ALWAYS Update the 'users' collection document
        final userDocRef = db.collection('users').doc(uid);
        // Use .set with merge: true to update the document, or create it if missing
        batch.set(userDocRef, updateData, SetOptions(merge: true));

        // B. CONDITIONAL: Update the 'workers' collection document if it exists
        // The `isWorker` flag tells us if the document is present.
        if (isWorker) {
          final workerDocRef = db.collection('workers').doc(uid);
          // Use .update() which requires the document to exist
          batch.update(workerDocRef, updateData);
        }

        // Commit the Batch (all or nothing)
        await batch.commit();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated and synced!')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      // Log error for debugging

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Upload failed. Check console and internet connection.',
          ),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return const Center(child: Text('Please log in.'));

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

      // Use FutureBuilder to check the user's role first
      body: FutureBuilder<bool>(
        future: _isWorker(),
        builder: (context, workerSnapshot) {
          final bool isWorker = workerSnapshot.data ?? false;

          // Use StreamBuilder to fetch data from the correct collection
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection(
                  isWorker ? 'workers' : 'users',
                ) // Dynamic collection selection
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

              // Extract data for display
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
                      // --- Role Status Chip ---
                      if (isWorker)
                        Chip(
                          avatar: const Icon(
                            Icons.engineering,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: _isDeletingWorker
                              ? const Text(
                                  'Deleting...',
                                  style: TextStyle(color: Colors.white),
                                )
                              : const Text(
                                  'Worker Account',
                                  style: TextStyle(color: Colors.white),
                                ),
                          backgroundColor: Colors.red[700],
                          deleteIcon: _isDeletingWorker
                              ? const SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.delete_forever,
                                  color: Colors.white,
                                  size: 18,
                                ),
                          onDeleted: _isDeletingWorker
                              ? null
                              : _showDeleteConfirmationDialog, // Trigger confirmation dialog
                        ),
                      const SizedBox(height: 10),

                      // PROFILE PICTURE AREA WITH UPLOAD FUNCTIONALITY
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.teal.shade200,
                            backgroundImage: profilePictureUrl != null
                                ? CachedNetworkImageProvider(profilePictureUrl)
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

                          // Loading indicator when uploading
                          if (_isUploading)
                            const Positioned.fill(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),

                          // Camera Icon Button (Tap to upload)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: _isUploading
                                  ? null
                                  : () => _changeProfilePicture(
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

                      // Info Card
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
