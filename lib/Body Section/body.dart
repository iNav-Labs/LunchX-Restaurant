// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:lunchx_canteen/orders/vertical_orders.dart';

class BodySection extends StatefulWidget {
  const BodySection({super.key});

  @override
  State<BodySection> createState() => _BodySectionState();
}

class _BodySectionState extends State<BodySection> {
  List<Map<String, dynamic>> orders = [
    {
      'name': 'Mansi Vora',
      'orderNumber': '#A1011',
      'orderPrice': 320,
      'orderType': 'DINE',
      'orderItems': [
        {'itemName': 'Burger', 'quantity': 1},
        {'itemName': 'Maggie', 'quantity': 1},
        {'itemName': 'Paratha', 'quantity': 2},
      ],
    },
    {
      'name': 'John Doe',
      'orderNumber': '#A1012',
      'orderPrice': 250,
      'orderType': 'TAKEOUT',
      'orderItems': [
        {'itemName': 'Pizza', 'quantity': 1},
        {'itemName': 'Salad', 'quantity': 1},
      ],
    },
    {
      'name': 'Alice Smith',
      'orderNumber': '#A1013',
      'orderPrice': 180,
      'orderType': 'DELIVERY',
      'orderItems': [
        {'itemName': 'Pasta', 'quantity': 1},
        {'itemName': 'Soda', 'quantity': 2},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: VerticalOrders(orders: orders),
          ),
        ],
      ),
    );
  }
}
