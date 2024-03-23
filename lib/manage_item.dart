// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lunchx_canteen/menu_manager.dart';

class ManageItemScreen extends StatefulWidget {
  const ManageItemScreen({super.key});

  @override
  _ManageItemScreenState createState() => _ManageItemScreenState();
}

class _ManageItemScreenState extends State<ManageItemScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Delete',
            style: GoogleFonts.outfit(
              fontSize: 24,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this item?',
            style: GoogleFonts.outfit(
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteItem();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: Text(
                'Delete',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem() async {
    try {
      if (_currentUser != null) {
        final itemRef = FirebaseFirestore.instance
            .collection('LunchX')
            .doc('canteens')
            .collection('users')
            .doc(_currentUser!.email) // Use the current user's email
            .collection('items')
            .doc('name'); // Use the item name as the document ID

        await itemRef.delete();

        Navigator.pop(context); // Close the dialog
        Navigator.pop(context); // Close the manage item screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const MenuManagerScreen()), // Navigate to the MenuManagerScreen
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item deleted successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Item'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Are you sure you want to delete this item?',
              style: GoogleFonts.outfit(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                _showDeleteConfirmationDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Background color of the button
              ),
              child: Text(
                'Delete Item',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Backend Remaining ...