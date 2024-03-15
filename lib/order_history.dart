// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  OrderHistoryScreen({super.key});

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
    {
      'name': 'Bob Johnson',
      'orderNumber': '#A1014',
      'orderPrice': 150,
      'orderType': 'DINE',
      'orderItems': [
        {'itemName': 'Sandwich', 'quantity': 2},
        {'itemName': 'Coffee', 'quantity': 1},
      ],
    },
    {
      'name': 'Eva White',
      'orderNumber': '#A1015',
      'orderPrice': 200,
      'orderType': 'TAKEOUT',
      'orderItems': [
        {'itemName': 'Steak', 'quantity': 1},
        {'itemName': 'Fries', 'quantity': 1},
      ],
    },
    {
      'name': 'Anuj Patel',
      'orderNumber': '#A1215',
      'orderPrice': 300,
      'orderType': 'TAKEOUT',
      'orderItems': [
        {'itemName': 'Frankie', 'quantity': 2},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Header Section
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6552FE),
                      borderRadius: BorderRadius.circular(11.0),
                    ),
                    padding: const EdgeInsets.all(6.0),
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${orders.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const Text(
                          'History',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40.0),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Order History',
                        style: TextStyle(
                          color: Color(0xFF919191),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 70.0),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                    ),
                    padding: const EdgeInsets.all(6.0),
                    child: const Icon(
                      Icons.arrow_downward,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // List of Orders Section
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Show pop-up with additional information
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            title: Text(
                              '${orders[index]['name']}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            content: Container(
                              color: Colors.white,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${orders[index]['orderNumber']} - ${orders[index]['orderType']}',
                                    style: const TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF6552FE),
                                    ),
                                  ),
                                  Text(
                                    'Rs. ${orders[index]['orderPrice']}',
                                    style: const TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Order Items:',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  for (var item in orders[index]['orderItems'])
                                    Text(
                                      '${item['itemName']}    -    ${item['quantity']}',
                                      style: const TextStyle(fontSize: 18.0),
                                    ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          // Handle "Ready" button action
                                          Navigator.of(context)
                                              .pop(); // Close the pop-up
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF6552FE),
                                        ),
                                        child: const Text(
                                          'Undo Ready',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      TextButton(
                                        onPressed: () {
                                          // Handle "Dispatch" button action
                                          Navigator.of(context)
                                              .pop(); // Close the pop-up
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFF19D20),
                                        ),
                                        child: const Text(
                                          'Undo Dispatch',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  TextButton(
                                    onPressed: () async {
                                      // Handle "Call" button action
                                      Navigator.of(context)
                                          .pop(); // Close the pop-up
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Text(
                                      'Call Support',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        child: Container(
                          width: 150.0,
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10.0),
                              Text(
                                '${orders[index]['name']}',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                'Order Number: ${orders[index]['orderNumber']}',
                                style: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6552FE),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                'Price: Rs. ${orders[index]['orderPrice']}',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
