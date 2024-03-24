// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, deprecated_member_use

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunchx_canteen/canteen_dashboard.dart';
import 'add_items.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuManagerScreen extends StatefulWidget {
  const MenuManagerScreen({super.key});

  @override
  _MenuManagerScreenState createState() => _MenuManagerScreenState();
}

class _MenuManagerScreenState extends State<MenuManagerScreen> {
  late User _currentUser;
  late Map<String, dynamic> _userData = {};
  List<Map<String, dynamic>> menuItems = [];

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
      await _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    final userData = await FirebaseFirestore.instance
        .collection('LunchX')
        .doc('canteens')
        .collection('users')
        .doc(_currentUser.email)
        .get();
    setState(() {
      _userData = userData.data() as Map<String, dynamic>;
    });

    final itemsSnapshot = await FirebaseFirestore.instance
        .collection('LunchX')
        .doc('canteens')
        .collection('users')
        .doc(_currentUser.email)
        .collection('items')
        .get();

    setState(() {
      menuItems = itemsSnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to DashboardScreen when pressing the back button
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
        // Return false to prevent the default back button behavior
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              Text(
                _userData['canteenName'] ?? 'High Rise Hostel\n Mess',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 150,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6552FE),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Total Items: ${menuItems.length}',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddItemScreen()),
                  );
                },
                child: const Text('Add Items'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final menuItem = menuItems[index];
                    bool isAvailable = menuItem['availability'] ?? true;

                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Card(
                          color: Colors.white,
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          menuItem['name'],
                                          style: GoogleFonts.outfit(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          menuItem['description'],
                                          style: GoogleFonts.outfit(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            height: 1.15,
                                            color: const Color(0xFF858585),
                                          ),
                                        ),
                                        const SizedBox(height: 18),
                                        Row(children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0.0,
                                                horizontal: 10.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 2.0,
                                              ),
                                            ),
                                            child: Text(
                                              'Rs. ${menuItem['price']}',
                                              style: GoogleFonts.outfit(
                                                fontSize: 12.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                // Toggle the availability instantly
                                                menuItem['availability'] =
                                                    !isAvailable;
                                              });
                                              // Update availability status in Firestore
                                              FirebaseFirestore.instance
                                                  .collection('LunchX')
                                                  .doc('canteens')
                                                  .collection('users')
                                                  .doc(_currentUser.email)
                                                  .collection('items')
                                                  .doc(menuItem['name'])
                                                  .update({
                                                'availability': !isAvailable,
                                              });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0,
                                                      horizontal: 8.0),
                                              decoration: BoxDecoration(
                                                color: isAvailable
                                                    ? Colors.green
                                                    : Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: Text(
                                                isAvailable
                                                    ? 'Available'
                                                    : 'Not Available',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 12.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ), // Adjust as needed for spacing between text and image
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        menuItem['image'],
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                      context, menuItem['name']);
                                },
                                icon: const Icon(Icons.remove_circle,
                                    color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to show delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, String itemName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Delete',
            style: TextStyle(fontSize: 24),
          ),
          content: Text(
            'Are you sure you want to delete $itemName?',
            style: GoogleFonts.outfit(fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.outfit(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteItem(itemName);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'Delete',
                style: GoogleFonts.outfit(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  // Method to delete item
  void _deleteItem(String itemName) async {
    try {
      // Delete the item document from Firestore collection
      await FirebaseFirestore.instance
          .collection('LunchX')
          .doc('canteens')
          .collection('users')
          .doc(_currentUser.email)
          .collection('items')
          .doc(itemName)
          .delete();

      // Remove the item from the local list
      setState(() {
        menuItems.removeWhere((item) => item['name'] == itemName);
      });

      // Delete the image from Firebase Storage
      Reference storageRef =
          FirebaseStorage.instance.ref('image_menu/$itemName');
      await storageRef.delete();

      // Show a SnackBar to indicate successful deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Item $itemName deleted successfully.',
            style: const TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      // Show a SnackBar to indicate error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to delete item: $error',
            style: const TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
// Do not change in code
