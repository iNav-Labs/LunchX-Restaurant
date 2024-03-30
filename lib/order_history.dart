// ignore_for_file: unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderHistoryScreenCanteen extends StatefulWidget {
  const OrderHistoryScreenCanteen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrderHistoryScreenCanteenState createState() =>
      _OrderHistoryScreenCanteenState();
}

class _OrderHistoryScreenCanteenState extends State<OrderHistoryScreenCanteen> {
  late List<Map<String, dynamic>> fetchedOrders = [];

  @override
  void initState() {
    super.initState();
    fetchOrderHistory();
  }

// Function to show order details
// Function to show order details
  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Details',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Order Number: ${order['orderNumber']}',
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Total Price: Rs. ${order['totalPrice']}',
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Accept Status:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  '${order['accept?'] == 'accept' ? 'Accept' : 'Reject'}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: order['accept?'] == 'accept'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: const Color(0xFF6552FE),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  height: 200.0, // Specify a smaller height for the purple area
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cart Items:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: order['cartItems'].length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                order['cartItems'][index]['name'],
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'Quantity: ${order['cartItems'][index]['count']}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                    height: 10.0), // Add some additional space at the bottom
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchOrderHistory() async {
    try {
      final String? userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail != null) {
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('LunchX')
            .doc('canteens')
            .collection('users')
            .doc(userEmail)
            .collection('OrderHistory')
            .get();
        final List<Map<String, dynamic>> orders = [];
        for (var doc in querySnapshot.docs) {
          orders.add(doc.data() as Map<String, dynamic>);
        }
        setState(() {
          fetchedOrders = orders;
        });
      } else {
        throw 'User not logged in';
      }
    } catch (error) {
      //print('Error fetching orders: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Order History'),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
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
                        '${fetchedOrders.length}',
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
                      '',
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

          // List of Orders Section
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: fetchedOrders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        // Show order details and cart items
                        _showOrderDetails(context, fetchedOrders[index]);
                      },
                      child: Card(
                        child: Container(
                          width: double.infinity,
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
                              Text(
                                'Order No. #${fetchedOrders[index]['orderNumber']}',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6552FE),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                'Price: Rs. ${fetchedOrders[index]['totalPrice']}',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                '${fetchedOrders[index]['accept?'] == 'accept' ? 'Accept' : 'Reject'}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: fetchedOrders[index]['accept?'] ==
                                          'accept'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
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
