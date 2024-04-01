// ignore_for_file: use_build_context_synchronously, sized_box_for_whitespace, library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunchx_canteen/orders/accepted_orders.dart';

class VerticalOrders extends StatefulWidget {
  const VerticalOrders({super.key});

  @override
  _VerticalOrdersState createState() => _VerticalOrdersState();
}

class _VerticalOrdersState extends State<VerticalOrders> {
  late List<Map<String, dynamic>> orders = [];
  String email = FirebaseAuth.instance.currentUser!.email!;
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
          .collection('present_orders');

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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
              const SizedBox(width: 40.0),
              Expanded(
                child: Center(
                  child: Text(
                    'Requests',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF919191),
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20.0),
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
        ),
        SizedBox(
          height: 140,
          child: SizedBox(
            height: 300,
            width: double.infinity,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: orders.map((order) {
                return Container(
                  width: 200, // Set a fixed width for each item
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          DocumentSnapshot orderSnapshot = await FirebaseFirestore
                              .instance
                              .collection('LunchX')
                              .doc('customers')
                              .collection('canteen_orders_queue')
                              .doc(
                                  'Order #${order['orderNumber']}') // Assuming 'orderNumber' is unique
                              .get();

                          if (orderSnapshot.exists) {
                            String status = (orderSnapshot.data()
                                    as Map<String, dynamic>)['accept?'] ??
                                '';

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                if (status == 'pending') {
                                  return AlertDialog(
                                    title: const Text('Order Details'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Order Number: ${order['orderNumber']}'),
                                        Text('User Name: ${order['userName']}'),
                                        Text(
                                            'Total Price: Rs. ${order['totalPrice']}'),
                                        const SizedBox(height: 10),
                                        const Text('Order Items:'),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: (order['cartItems']
                                                  as List<dynamic>)
                                              .map((item) {
                                            return Text(
                                                '${item['name']} - ${item['count']}');
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      if (status == 'pending') ...[
                                        TextButton(
                                          onPressed: () async {
                                            // Action for 'Accept' button
                                            try {
                                              print(email);
                                              // Update the status of the order to 'accept' in Firestore
                                              await FirebaseFirestore.instance
                                                  .collection('LunchX')
                                                  .doc('customers')
                                                  .collection(
                                                      'canteen_orders_queue')
                                                  .doc(
                                                      'Order #${order['orderNumber']}')
                                                  .update(
                                                      {'accept?': 'accept'});
                                              // Move the order to the AcceptedOrders collection
                                              await FirebaseFirestore.instance
                                                  .collection('LunchX')
                                                  .doc('canteens')
                                                  .collection('users')
                                                  .doc(email)
                                                  .collection('AcceptedOrders')
                                                  .doc(
                                                      'Order #${order['orderNumber']}')
                                                  .set({
                                                ...order,
                                                'accept?': 'accept'
                                              });
                                              // Update status at customer side
                                              await FirebaseFirestore.instance
                                                  .collection('LunchX')
                                                  .doc('customers')
                                                  .collection('users')
                                                  .doc(order['email'])
                                                  .collection('current_orders')
                                                  .doc(
                                                      'Order #${order['orderNumber']}')
                                                  .update(
                                                      {'accept?': 'accept'});

                                              // Remove the order from the presentOrders collection
                                              await FirebaseFirestore.instance
                                                  .collection('LunchX')
                                                  .doc('canteens')
                                                  .collection('users')
                                                  .doc(email)
                                                  .collection('present_orders')
                                                  .doc(
                                                      'Order #${order['orderNumber']}')
                                                  .delete();
                                              fetchOrderDetails();

                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            } catch (error) {
                                              print(
                                                  'Error updating order status: $error');
                                            }
                                          },
                                          child: const Text('Accept'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            // Action for 'Reject' button
                                            try {
                                              print(email);
                                              // Update the status of the order to 'reject' in Firestore
                                              await FirebaseFirestore.instance
                                                  .collection('LunchX')
                                                  .doc('customers')
                                                  .collection(
                                                      'canteen_orders_queue')
                                                  .doc(
                                                      'Order #${order['orderNumber']}')
                                                  .update(
                                                      {'accept?': 'reject'});

                                              // Move the order to the RejectedOrders collection
                                              await FirebaseFirestore.instance
                                                  .collection('LunchX')
                                                  .doc('canteens')
                                                  .collection('users')
                                                  .doc(email)
                                                  .collection('RejectedOrders')
                                                  .doc(
                                                      'Order #${order['orderNumber']}')
                                                  .set({
                                                ...order,
                                                'accept?': 'reject'
                                              });

                                              // Update status at customer data
                                              await FirebaseFirestore.instance
                                                  .collection('LunchX')
                                                  .doc('customers')
                                                  .collection('users')
                                                  .doc(order['email'])
                                                  .collection('current_orders')
                                                  .doc(
                                                      'Order #${order['orderNumber']}')
                                                  .update(
                                                      {'accept?': 'reject'});

                                              // Remove the order from the presentOrders collection
                                              await FirebaseFirestore.instance
                                                  .collection('LunchX')
                                                  .doc('canteens')
                                                  .collection('users')
                                                  .doc(email)
                                                  .collection('present_orders')
                                                  .doc(
                                                      'Order #${order['orderNumber']}')
                                                  .delete();

                                              // Move order to OrderHistory in canteen's user collection
                                              await FirebaseFirestore.instance
                                                  .collection('LunchX')
                                                  .doc('canteens')
                                                  .collection('users')
                                                  .doc(email)
                                                  .collection('OrderHistory')
                                                  .doc(
                                                      'Order #${order['orderNumber']}')
                                                  .set(order);
                                              await FirebaseFirestore.instance
                                                  .collection('LunchX')
                                                  .doc('canteens')
                                                  .collection('users')
                                                  .doc(email)
                                                  .collection('OrderHistory')
                                                  .doc(
                                                      'Order #${order['orderNumber']}')
                                                  .update(
                                                      {'accept?': 'reject'});

                                              fetchOrderDetails();

                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            } catch (error) {
                                              print(
                                                  'Error updating order status: $error');
                                            }
                                          },
                                          child: const Text('Reject'),
                                        ),
                                      ],
                                    ],
                                  );
                                } else {
                                  return AlertDialog(
                                    title: const Text('Order Details'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Order Number: ${order['orderNumber']}'),
                                        Text('User Name: ${order['userName']}'),
                                        Text(
                                            'Total Price: Rs. ${order['totalPrice']}'),
                                        const SizedBox(height: 10),
                                        const Text('Order Items:'),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: (order['cartItems']
                                                  as List<dynamic>)
                                              .map((item) {
                                            return Text(
                                                '${item['name']} - ${item['count']}');
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            );
                          } else {
                            // Handle if order document doesn't exist
                            print('Order document does not exist');
                          }
                        } catch (error) {
                          print('Error fetching order details: $error');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
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
                              '${order['userName']}',
                              style: GoogleFonts.outfit(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              'Order No. #${order['orderNumber']}',
                              style: GoogleFonts.outfit(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF6552FE),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              'Rs. ${order['totalPrice']}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),

        // Load AcceptedOrders widget from accepted_orders.dart
        const AcceptedOrders(), // Use AcceptedOrders widget here
      ],
    );
  }
}
