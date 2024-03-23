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

  bool isAvailable = true; // Initial availability state

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
                                              // Toggle the color when tapped
                                              isAvailable = !isAvailable;
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
                                    width:
                                        8), // Adjust as needed for spacing between text and image
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

// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'add_items.dart';
// import 'manage_item.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MenuManagerScreen extends StatefulWidget {
//   const MenuManagerScreen({super.key});

//   @override
//   _MenuManagerScreenState createState() => _MenuManagerScreenState();
// }

// class _MenuManagerScreenState extends State<MenuManagerScreen> {
//   late User _currentUser;
//   late Map<String, dynamic> _userData = {};
//   List<Map<String, dynamic>> menuItems = [];

//   TextEditingController headingController = TextEditingController();
//   TextEditingController subHeadingController = TextEditingController();
//   bool availabilityStatus = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadCurrentUser();
//   }

//   Future<void> _loadCurrentUser() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         _currentUser = user;
//       });
//       await _loadUserData();
//     }
//   }

//   Future<void> _loadUserData() async {
//     final userData = await FirebaseFirestore.instance
//         .collection('LunchX')
//         .doc('canteens')
//         .collection('users')
//         .doc(_currentUser.email)
//         .get();
//     setState(() {
//       _userData = userData.data() as Map<String, dynamic>;
//     });

//     final itemsSnapshot = await FirebaseFirestore.instance
//         .collection('LunchX')
//         .doc('canteens')
//         .collection('users')
//         .doc(_currentUser.email)
//         .collection('items')
//         .get();

//     setState(() {
//       menuItems = itemsSnapshot.docs
//           .map((doc) => doc.data() as Map<String, dynamic>)
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           children: [
//             Text(
//               'PDEU', // Change this to 'High Rise Hostel\n Mess
//               // _userData['canteenName'] ?? 'PDEU',
//               style: GoogleFonts.outfit(
//                 fontSize: 18,
//                 color: const Color(0xFF6552FE),
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             Text(
//               _userData['canteenName'] ?? 'High Rise Hostel\n Mess',
//               style: GoogleFonts.outfit(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),

//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               padding:
//                   const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: const Color(0xFF6552FE),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: RichText(
//                 text: TextSpan(
//                   style: GoogleFonts.outfit(
//                     fontSize: 14,
//                     color: Colors.white,
//                   ),
//                   children: [
//                     const TextSpan(
//                       text: 'Total Items: ',
//                       style: TextStyle(fontWeight: FontWeight.w500),
//                     ),
//                     TextSpan(
//                       text: menuItems.length.toString(),
//                       style: const TextStyle(fontWeight: FontWeight.w900),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const AddItemScreen()),
//                   );
//                 },
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Add Items',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF6552FE),
//                       ),
//                     ),
//                     Icon(
//                       Icons.add,
//                       size: 20,
//                       color: Color(0xFF6552FE),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Vertical Scrolling Cards
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 margin: const EdgeInsets.all(20.0),
//                 color: Colors.white, // Set the background color to white
//                 child: ListView.builder(
//                   scrollDirection: Axis.vertical,
//                   itemCount: menuItems.length,
//                   itemBuilder: (context, index) {
//                     final menuItem = menuItems[index];
//                     return Card(
//                       color: Colors
//                           .white, // Set the card background color to white
//                       elevation: 0, // Remove the box shadow
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       // Navigate to ManageItemScreen on tap
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const ManageItemScreen()),
//                                       );
//                                     },
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           menuItem['name'],
//                                           style: GoogleFonts.outfit(
//                                             fontSize: 18.0,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 8),
//                                         Text(
//                                           menuItem['description'],
//                                           style: GoogleFonts.outfit(
//                                             fontSize: 14.0,
//                                             fontWeight: FontWeight.w400,
//                                             height: 1.15,
//                                             color: const Color(0xFF858585),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 16),
//                                   Row(
//                                     children: [
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 0.0, horizontal: 10.0),
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(12.0),
//                                           border: Border.all(
//                                             color: Colors.black,
//                                             width: 2.0,
//                                           ),
//                                         ),
//                                         child: Text(
//                                           'Rs. ${menuItem['price']}',
//                                           style: GoogleFonts.outfit(
//                                             fontSize: 14.0,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 5),
//                                       GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             menuItem['availability'] =
//                                                 !menuItem['availability'];

//                                             if (menuItem['availibity']) {
//                                               // Add your logic for available state
//                                             } else {
//                                               // Add your logic for not available state
//                                             }
//                                           });
//                                         },
//                                         child: Container(
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: 2.0, horizontal: 8.0),
//                                           decoration: BoxDecoration(
//                                             color: menuItem['availibity']
//                                                 ? Colors.green
//                                                 : Colors.red,
//                                             borderRadius:
//                                                 BorderRadius.circular(12.0),
//                                           ),
//                                           child: Text(
//                                             menuItem['availibity']
//                                                 ? 'Available'
//                                                 : 'Not Available',
//                                             style: GoogleFonts.outfit(
//                                               fontSize: 14.0,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 8),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(
//                                 width: 16), // Adjust as needed for spacing
//                             Image.asset(
//                               menuItem['image'],
//                               width: 150,
//                               height: 150,
//                               fit: BoxFit.cover,
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
