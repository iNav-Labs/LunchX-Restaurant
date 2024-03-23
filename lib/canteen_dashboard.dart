// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunchx_canteen/Body%20Section/body.dart';
import 'package:lunchx_canteen/food_dashboard.dart';
import 'package:lunchx_canteen/login.dart';
import 'package:lunchx_canteen/order_history.dart';
import 'package:lunchx_canteen/menu_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YourDrawer extends StatefulWidget {
  final Function(bool) onShopStatusChanged;
  final bool isShopOpen;

  const YourDrawer({
    super.key,
    required this.onShopStatusChanged,
    required this.isShopOpen,
  });

  @override
  _YourDrawerState createState() => _YourDrawerState();
}

class _YourDrawerState extends State<YourDrawer> {
  late User _currentUser;
  late Map<String, dynamic> _userData = {};
  late final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  }

  Widget _buildPersonalDetails(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Future<void> _updateShopStatus(bool status) async {
    try {
      await _firestore
          .collection('LunchX')
          .doc('canteens')
          .collection('users')
          .doc(_currentUser.email)
          .update({'shopOpen': status});
      // ignore: empty_catches
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          SwitchListTile(
            title: Text(
              'Shop Status',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            value: widget.isShopOpen,
            onChanged: (value) {
              setState(() {
                widget.onShopStatusChanged(value);
                _updateShopStatus(value);
              });
            },
            contentPadding: const EdgeInsets.all(40),
            activeTrackColor: Colors.green[500],
            inactiveTrackColor: Colors.red[800],
            inactiveThumbColor: Colors.white,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 50.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildPersonalDetails('Name', _userData['name'] ?? 'N/A'),
                _buildPersonalDetails(
                    'Canteen Name', _userData['canteenName'] ?? 'N/A'),
                _buildPersonalDetails('Email ID', _userData['email'] ?? 'N/A'),
                _buildPersonalDetails(
                    'Phone Number', _userData['phoneNumber'] ?? 'N/A'),
              ],
            ),
          ),
          _buildDrawerItem(context, 'Manage Menu', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MenuManagerScreen(),
              ),
            );
          }),
          _buildDrawerItem(context, 'Order History', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderHistoryScreen(),
              ),
            );
          }),
          _buildDrawerItem(context, 'Logout', () {
            // Perform logout
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Login(),
              ), // Navigate to login screen
              (route) => false, // Remove all routes until login screen
            );
          }),
          Container(
            margin: const EdgeInsets.only(top: 150.0),
            child: Image.asset(
              'assets/logo2.png', // Adjust the path accordingly
              height: 50.0,
              width: 40.0,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Customer Support',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          // "graby.go" text
          Text(
            '+91 9408393005',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isShopOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Image.asset(
                'assets/logo2.png',
                width: 110.0,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodDashboard()),
                );
              },
              child: Container(
                height: 30.0,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFF6552FE),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'SORT BY FOOD',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF6552FE),
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      endDrawer: YourDrawer(
        isShopOpen: isShopOpen,
        onShopStatusChanged: (status) {
          setState(() {
            isShopOpen = status;
          });
        },
      ),
      body: const BodySection(),
    );
  }
}
// Do not change in the code
