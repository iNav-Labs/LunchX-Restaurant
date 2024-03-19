// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_items.dart';
import 'manage_item.dart';

class MenuManagerScreen extends StatefulWidget {
  const MenuManagerScreen({super.key});

  @override
  _MenuManagerScreenState createState() => _MenuManagerScreenState();
}

class _MenuManagerScreenState extends State<MenuManagerScreen> {
  TextEditingController headingController = TextEditingController();
  TextEditingController subHeadingController = TextEditingController();
  bool availabilityStatus = true;

  List<Map<String, dynamic>> menuItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(
              subHeadingController.text.isNotEmpty
                  ? subHeadingController.text
                  : 'PDEU',
              style: GoogleFonts.outfit(
                fontSize: 18,
                color: Color(0xFF6552FE),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              headingController.text.isNotEmpty
                  ? headingController.text
                  : 'High Rise Hostel\n Mess',
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xFF6552FE),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: 'Total Items  ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: '4',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddItemScreen()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Add Items',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6552FE),
                      ),
                    ),
                    Icon(
                      Icons.add,
                      size: 20,
                      color: Color(0xFF6552FE),
                    ),
                  ],
                ),
              ),
            ),

            // Vertical Scrolling Cards
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
                color: Colors.white, // Set the background color to white
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final menuItem = menuItems[index];
                    return Card(
                      color: Colors
                          .white, // Set the card background color to white
                      elevation: 0, // Remove the box shadow
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to ManageItemScreen on tap
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ManageItemScreen()),
                                      );
                                    },
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
                                        SizedBox(height: 8),
                                        Text(
                                          menuItem['description'],
                                          style: GoogleFonts.outfit(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            height: 1.15,
                                            color: Color(0xFF858585),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
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
                                            fontSize: 14.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            menuItem['availibity'] =
                                                !menuItem['availibity'];

                                            if (menuItem['availibity']) {
                                              // Add your logic for available state
                                            } else {
                                              // Add your logic for not available state
                                            }
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0, horizontal: 8.0),
                                          decoration: BoxDecoration(
                                            color: menuItem['availibity']
                                                ? Colors.green
                                                : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Text(
                                            menuItem['availibity']
                                                ? 'Available'
                                                : 'Not Available',
                                            style: GoogleFonts.outfit(
                                              fontSize: 14.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                ],
                              ),
                            ),
                            SizedBox(width: 16), // Adjust as needed for spacing
                            Image.asset(
                              menuItem['image'],
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
