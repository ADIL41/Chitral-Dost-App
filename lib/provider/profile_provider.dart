import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/cloudinary_config.dart';

class ProfileProvider with ChangeNotifier {
  bool isUploading = false;
  bool isDeletingWorker = false;

  Future<bool> isWorker() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return false;
    final workerDoc = await FirebaseFirestore.instance
        .collection('workers')
        .doc(userId)
        .get();
    return workerDoc.exists;
  }

  Future<void> deleteWorkerProfile(BuildContext context) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    isDeletingWorker = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('workers')
          .doc(currentUser.uid)
          .delete();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Worker profile deleted successfully. You are now a standard user.',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete worker profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isDeletingWorker = false;
      notifyListeners();
    }
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context) async {
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

    if (!context.mounted) return;

    if (confirm == true) {
      await deleteWorkerProfile(context);
    }
  }

  Future<void> changeProfilePicture({
    required BuildContext context,
    required bool isWorker,
  }) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;

    isUploading = true;
    notifyListeners();

    final String folderName = isWorker ? 'worker_profiles' : 'user_profiles';
    final db = FirebaseFirestore.instance;
    final uid = currentUser.uid;

    try {
      final response = await CloudinaryConfig.cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          pickedFile.path,
          folder: folderName,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      final String imageUrl = response.secureUrl;

      if (imageUrl.isNotEmpty) {
        final batch = db.batch();

        final updateData = {
          'profilePictureUrl': imageUrl,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        final userDocRef = db.collection('users').doc(uid);
        batch.set(userDocRef, updateData, SetOptions(merge: true));

        if (isWorker) {
          final workerDocRef = db.collection('workers').doc(uid);
          batch.update(workerDocRef, updateData);
        }

        await batch.commit();
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated and synced!')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Upload failed. Check console and internet connection.',
          ),
        ),
      );
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> profileStream({
    required bool isWorker,
    required String uid,
  }) {
    return FirebaseFirestore.instance
        .collection(isWorker ? 'workers' : 'users')
        .doc(uid)
        .snapshots();
  }

  Future<void> updateProfileFields({
    required BuildContext context,
    required bool isWorker,
    required String name,
    required String phone,
  }) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final db = FirebaseFirestore.instance;
      final uid = currentUser.uid;

      final updateData = {
        'name': name,
        'phone': phone,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await db
          .collection('users')
          .doc(uid)
          .set(updateData, SetOptions(merge: true));

      if (isWorker) {
        await db
            .collection('workers')
            .doc(uid)
            .set(updateData, SetOptions(merge: true));
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
