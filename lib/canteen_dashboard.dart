// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunchx_canteen/Body%20Section/body.dart';
import 'package:lunchx_canteen/food_dashboard.dart';
import 'package:lunchx_canteen/login.dart';
import 'package:lunchx_canteen/order_history.dart';
import 'package:lunchx_canteen/menu_manager.dart';

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
              widget.onShopStatusChanged(value);
            },
            contentPadding: const EdgeInsets.all(40),
            activeTrackColor: Colors.green[500],
            inactiveTrackColor: Colors.red[800],
            inactiveThumbColor: Colors.white,
          ),
          _buildDrawerItem(context, 'Menu Manage', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MenuManagerScreen()),
            );
          }),
          _buildDrawerItem(context, 'Order History', () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
            );
          }),
          _buildDrawerItem(context, 'Analytics', () {
            Navigator.pop(context);
            // Handle analytics navigation
          }),
          _buildDrawerItem(context, 'Logout', () {
            // Perform logout
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const Login()), // Navigate to login screen
              (route) => false, // Remove all routes until login screen
            );
          }),
          Container(
            margin: const EdgeInsets.only(top: 300.0),
            child: Image.asset(
              'assets/logo2.png',
              height: 50.0,
              width: 50.0,
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
          Text(
            '+91 9408393005',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
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
