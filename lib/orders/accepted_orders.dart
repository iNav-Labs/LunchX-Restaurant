// ignore_for_file: use_build_context_synchronously, unused_local_variable, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AcceptedOrders extends StatefulWidget {
  const AcceptedOrders({super.key});

  @override
  _AcceptedOrdersState createState() => _AcceptedOrdersState();
}

class _AcceptedOrdersState extends State<AcceptedOrders> {
  List<Map<String, dynamic>> orders = [];
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  void _refresh() {
    setState(() {
      _isRefreshing = true;
    });

    // Simulating network fetch with a delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isRefreshing = false;
      });
      fetchOrderDetails(); // Your fetchOrderDetails function
    });
  }

  Future<void> markOrderAsReady(Map<String, dynamic> order) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      User? user = FirebaseAuth.instance.currentUser;
      // print('email: ${user!.email}');

      // Update 'ready' status in canteen_orders_queue
      final canteenOrderRef = FirebaseFirestore.instance
          .collection('LunchX')
          .doc('customers')
          .collection('canteen_orders_queue')
          .doc('Order #${order['orderNumber']}');
      batch.update(canteenOrderRef, {'ready': true});

      // Update 'ready' status in current_orders for customer app data
      final customerOrderRef = FirebaseFirestore.instance
          .collection('LunchX')
          .doc('customers')
          .collection('users')
          .doc(order['email'])
          .collection('current_orders')
          .doc('Order #${order['orderNumber']}');
      batch.update(customerOrderRef, {'ready': true});

      // Update 'ready' status in AcceptedOrders for canteen app data
      final canteenAcceptedOrderRef = FirebaseFirestore.instance
          .collection('LunchX')
          .doc('canteens')
          .collection('users')
          .doc(user!.email) // Assuming canteenEmail is provided in order
          .collection('AcceptedOrders')
          .doc('Order #${order['orderNumber']}');
      batch.update(canteenAcceptedOrderRef, {'ready': true});

      fetchOrderDetails();

      await batch.commit();
      print('Order ${order['orderNumber']} marked as ready successfully.');
    } catch (error) {
      print('Error marking order ${order['orderNumber']} as ready: $error');
    }
  }

  Future<void> markOrderAsDispatch(Map<String, dynamic> order) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      User? user = FirebaseAuth.instance.currentUser;
      // print('email: ${user!.email}');

      // Update 'dispatch' status in canteen_orders_queue
      final canteenOrderRef = FirebaseFirestore.instance
          .collection('LunchX')
          .doc('customers')
          .collection('canteen_orders_queue')
          .doc('Order #${order['orderNumber']}');
      batch.update(canteenOrderRef, {'dispatch': true});

      // Update 'dispatch' status in current_orders for customer app data
      final customerOrderRef = FirebaseFirestore.instance
          .collection('LunchX')
          .doc('customers')
          .collection('users')
          .doc(order['email'])
          .collection('current_orders')
          .doc('Order #${order['orderNumber']}');
      batch.update(customerOrderRef, {'dispatch': true});

      // Update 'dispatch' status in AcceptedOrders for canteen app data
      final canteenAcceptedOrderRef = FirebaseFirestore.instance
          .collection('LunchX')
          .doc('canteens')
          .collection('users')
          .doc(user!.email) // Assuming canteenEmail is provided in order
          .collection('AcceptedOrders')
          .doc('Order #${order['orderNumber']}');
      batch.update(canteenAcceptedOrderRef, {'dispatch': true});
      fetchOrderDetails();
// Check if both 'ready' and 'dispatch' are true
      if (order['ready'] == true && order['dispatch'] == true) {
        // Move order to OrderHistory in canteen's user collection
        final orderHistoryRef = FirebaseFirestore.instance
            .collection('LunchX')
            .doc('canteens')
            .collection('users')
            .doc(user.email)
            .collection('OrderHistory')
            .doc('Order #${order['orderNumber']}');
        batch.set(orderHistoryRef, order);

// adding to customer orde history
        final orderHistoryRefCustomer = FirebaseFirestore.instance
            .collection('LunchX')
            .doc('customers')
            .collection('users')
            .doc(order['email'])
            .collection('OrderHistory')
            .doc('Order #${order['orderNumber']}');
        batch.set(orderHistoryRefCustomer, order);

        // Delete order from current_orders
        final deleteCurrentOrders = FirebaseFirestore.instance
            .collection('LunchX')
            .doc('customers')
            .collection('users')
            .doc(order['email'])
            .collection('current_orders')
            .doc('Order #${order['orderNumber']}');
        batch.delete(deleteCurrentOrders);

        // Delete order from AcceptedOrders
        batch.delete(canteenAcceptedOrderRef);
        fetchOrderDetails();
      }

      await batch.commit();
      print('Order ${order['orderNumber']} marked as dispatch successfully.');
    } catch (error) {
      print('Error marking order ${order['orderNumber']} as dispatch: $error');
    }
  }

  Future<void> fetchOrderDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      // print('email: ${user!.email}');

      // Initialize Firestore reference properly
      CollectionReference currentUserOrdersRef = FirebaseFirestore.instance
          .collection('LunchX')
          .doc('canteens')
          .collection('users')
          .doc(user!.email)
          .collection('AcceptedOrders');

      // Fetch documents from Firestore
      QuerySnapshot querySnapshot = await currentUserOrdersRef.get();

      setState(() {
        orders = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
      orders.sort((a, b) => b['orderNumber'].compareTo(a['orderNumber']));
      // print('Fetched orders: $orders');
    } catch (error) {
      print('Error fetching orders: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                      'Orders',
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
              const SizedBox(width: 70.0),
              Expanded(
                child: Center(
                  child: Text(
                    'Orders',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF919191),
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 50.0),
              GestureDetector(
                onTap: _refresh,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: 30.0,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
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
                  child: _isRefreshing
                      ? const Center(
                          child: CupertinoActivityIndicator(
                            radius:
                                10, // Adjust the size as per your preference
                          ),
                        )
                      : const Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.refresh, color: Color(0xFF6552FE)),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 30.0),
            ],
          ),
//.
//.
//.
//.
//.
//.
//.
//.

          SizedBox(
            height: 500,
            width: 500,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: orders.map((order) {
                bool isReady = order['ready'] ?? false;
                bool isDispatched = order['dispatch'] ?? false;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        DocumentSnapshot orderSnapshot =
                            await FirebaseFirestore.instance
                                .collection('LunchX') // Update collection name
                                .doc('canteens')
                                .collection('users')
                                .doc(order['userEmail']) // Use order userEmail
                                .collection('AcceptedOrders')
                                .doc('Order #${order['orderNumber']}')
                                .get();

                        // Show alert dialog with order details
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Order Details'),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Name: ${order['userName']}'),
                                  Text('Order Number: ${order['orderNumber']}'),
                                  Text('Price: Rs. ${order['totalPrice']}'),
                                  const Text('Order Items'),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        (order['cartItems'] as List<dynamic>)
                                            .map((item) {
                                      return Text(
                                          '${item['name']} - ${item['count']}');
                                    }).toList(),
                                  ),
                                  // Add more order details here if needed
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    markOrderAsReady(order);

                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Text('Ready'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    markOrderAsDispatch(order);
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Text('Dispatch'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Handle 'Call' button action
                                  },
                                  child: const Text('Call'),
                                ),
                              ],
                            );
                          },
                        );
                      } catch (error) {
                        print('Error fetching order details: $error');
                      }
                    },
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
                          const SizedBox(height: 10.0),
                          Text(
                            'Name: ${order['userName']}',
                            style: GoogleFonts.outfit(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            'Order Number: ${order['orderNumber']}',
                            style: GoogleFonts.outfit(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6552FE),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            'Price: Rs. ${order['totalPrice']}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            children: [
                              if (isReady)
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Text(
                                    'Ready',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              if (isDispatched)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Text(
                                    'Dispatched',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
