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
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height, // Ensure the Column takes up the full height
              child: const VerticalOrders(),
            ),
          ],
        ),
      ),
    );
  }
}
