// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class HorizontalOrders extends StatelessWidget {
//   final List<Map<String, dynamic>> orders;

//   const HorizontalOrders({super.key, required this.orders});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Center(
//           child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 10.0),
//             color: const Color.fromARGB(255, 255, 255, 255),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   width: 60,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF6552FE),
//                     borderRadius: BorderRadius.circular(11.0),
//                   ),
//                   padding: const EdgeInsets.all(6.0),
//                   margin: const EdgeInsets.only(left: 20.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         '${orders.length}', // Replace with the actual number of pending orders
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                       const Text(
//                         'Pending',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 9,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: -0.4,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 40.0),
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       'Requested Orders',
//                       style: GoogleFonts.outfit(
//                         color: const Color(0xFF919191),
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 70.0),
//                 Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(8.0),
//                       bottomRight: Radius.circular(8.0),
//                     ),
//                   ),
//                   padding: const EdgeInsets.all(6.0),
//                   child: const Icon(
//                     Icons.arrow_forward,
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Container(
//           height: 200.0,
//           color: Colors.white,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: orders.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   // Show pop-up with additional information
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         backgroundColor: Colors.white,
//                         title: Text(
//                           '${orders[index]['name']}',
//                           style: GoogleFonts.outfit(
//                               fontSize: 18, fontWeight: FontWeight.w600),
//                         ),
//                         content: SingleChildScrollView(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 '${orders[index]['orderNumber']}   ~   ${orders[index]['orderType']}',
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               Text(
//                                 'Rs. ${orders[index]['orderPrice']}',
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 24,
//                                   color: const Color(0xFF6552FE),
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               Text(
//                                 'Order Items:',
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               for (var item in orders[index]['orderItems'])
//                                 Text(
//                                   '${item['itemName']}    -    ${item['quantity']}',
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               // Handle "Yes" button action
//                               // You can add your logic here
//                               Navigator.of(context).pop(); // Close the pop-up
//                             },
//                             style: TextButton.styleFrom(
//                               backgroundColor: Colors.green,
//                             ),
//                             child: const Text(
//                               'Yes',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               // Handle "No" button action
//                               // You can add your logic here
//                               Navigator.of(context).pop(); // Close the pop-up
//                             },
//                             style: TextButton.styleFrom(
//                               backgroundColor: Colors.red,
//                             ),
//                             child: const Text(
//                               'No',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Card(
//                     child: Container(
//                       width: 150.0,
//                       padding: const EdgeInsets.all(15.0),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12.0),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.3),
//                             spreadRadius: 2,
//                             blurRadius: 5,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Container(
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 10.0),
//                             Text(
//                               '${orders[index]['name']}',
//                               style: GoogleFonts.outfit(
//                                 fontSize: 18.0,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                               textAlign: TextAlign.left,
//                             ),
//                             const SizedBox(height: 20.0),
//                             Text(
//                               '${orders[index]['orderNumber']}',
//                               style: GoogleFonts.outfit(
//                                 fontSize: 14.0,
//                                 fontWeight: FontWeight.w600,
//                                 color: const Color.fromARGB(255, 0, 0, 0),
//                               ),
//                             ),
//                             Text(
//                               'Rs. ${orders[index]['orderPrice']}',
//                               style: GoogleFonts.outfit(
//                                 fontSize: 24.0,
//                                 fontWeight: FontWeight.w600,
//                                 color: const Color(0xFF6552FE),
//                               ),
//                             ),
//                             Text(
//                               '${orders[index]['orderType']}',
//                               style: GoogleFonts.outfit(
//                                 fontSize: 14.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
