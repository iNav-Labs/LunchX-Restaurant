// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:lunchx_canteen/orders/vertical_orders.dart';

class BodySection extends StatefulWidget {
  const BodySection({super.key});

  @override
  State<BodySection> createState() => _BodySectionState();
}

class _BodySectionState extends State<BodySection> {
  late List<Map<String, dynamic>> orders;
  // List<Map<String, dynamic>> orders = [
  //   {
  //     'name': 'Mansi Vora',
  //     'orderNumber': '#A1011',
  //     'orderPrice': 320,
  //     'orderType': 'DINE',
  //     'orderItems': [
  //       {'itemName': 'Burger', 'quantity': 1},
  //       {'itemName': 'Maggie', 'quantity': 1},
  //       {'itemName': 'Paratha', 'quantity': 2},
  //     ],
  //   },
  //   {
  //     'name': 'John Doe',
  //     'orderNumber': '#A1012',
  //     'orderPrice': 250,
  //     'orderType': 'TAKEOUT',
  //     'orderItems': [
  //       {'itemName': 'Pizza', 'quantity': 1},
  //       {'itemName': 'Salad', 'quantity': 1},
  //     ],
  //   },
  //   {
  //     'name': 'Alice Smith',
  //     'orderNumber': '#A1013',
  //     'orderPrice': 180,
  //     'orderType': 'DELIVERY',
  //     'orderItems': [
  //       {'itemName': 'Pasta', 'quantity': 1},
  //       {'itemName': 'Soda', 'quantity': 2},
  //     ],
  //   },
  // ];

  // Future<List<Map<String, dynamic>>> fetchOrderDetails() async {
  //   List<Map<String, dynamic>> orders = [];
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     print('email: ${user!.email}');

  //     // Initialize Firestore reference properly
  //     CollectionReference currentUserOrdersRef = FirebaseFirestore.instance
  //         .collection('LunchX')
  //         .doc('canteens')
  //         .collection('users')
  //         .doc(user.email)
  //         .collection('present_orders');

  //     // Fetch documents from Firestore
  //     QuerySnapshot querySnapshot = await currentUserOrdersRef.get();
  //     orders = querySnapshot.docs
  //         .map((doc) => doc.data() as Map<String, dynamic>)
  //         .toList();

  //     print('Fetched orders: $orders');
  //   } catch (error) {
  //     print('Error fetching orders: $error');
  //   }

  //   return orders;
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Expanded(
            child: VerticalOrders(),
          ),
        ],
      ),
    );
  }
}
