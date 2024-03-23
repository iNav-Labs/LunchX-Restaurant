// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_items.dart';
import 'manage_item.dart';
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
    return Scaffold(
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
                  bool isAvailable =
                      menuItem['availability'] ?? true; // Fetch availability
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
                            contentPadding: EdgeInsets
                                .zero, // Remove default ListTile padding
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
                                              vertical: 0.0, horizontal: 10.0),
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
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2.0, horizontal: 8.0),
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
                                    child: Image.asset(
                                      menuItem['image'],
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ManageItemScreen(),
                                ),
                              );
                            },
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
    );
  }
}
// Do not change in the code.
