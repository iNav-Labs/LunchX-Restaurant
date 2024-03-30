import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FoodDashboard extends StatelessWidget {
  const FoodDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Dashboard'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAcceptedOrders(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return FoodItemList(orders: snapshot.data!);
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}

class FoodItemList extends StatelessWidget {
  final List<Map<String, dynamic>> orders;

  const FoodItemList({required this.orders, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        String itemName = orders[index]['name'] ?? '';
        int itemCount = orders[index]['count'] ?? 0;
        return Card(
          elevation: 0,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Image
              FutureBuilder<String>(
                future: _getImage(itemName),
                builder: (context, AsyncSnapshot<String> imageSnapshot) {
                  if (imageSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (imageSnapshot.hasError) {
                    return const Icon(Icons.error);
                  }
                  if (imageSnapshot.hasData) {
                    return Image.network(
                      imageSnapshot.data!,
                      width: 100, // Adjust the width as needed
                      height: 100, // Adjust the height as needed
                    );
                  }
                  return const SizedBox();
                },
              ),
              // Item Name
              Text(
                itemName,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Small Container with Number
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF6552FE),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  itemCount.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> _getImage(String itemName) async {
    try {
      // Get a reference to the root of the images folder
      final ref = FirebaseStorage.instance.ref().child('image_menu');

      // List all items under the images folder
      final items = await ref.listAll();

      // Iterate through the items to find a match based on item name
      for (var item in items.items) {
        if (item.name.contains(itemName)) {
          // If a matching item is found, get its download URL and return
          final url = await item.getDownloadURL();
          return url;
        }
      }

      // If no matching item is found, return an empty string
      return '';
    } catch (e) {
      // ////print error if any occurs while fetching image
      ////print('Error fetching image: $e');
      return '';
    }
  }
}

Future<List<Map<String, dynamic>>> fetchAcceptedOrders() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference currentUserOrdersRef = FirebaseFirestore.instance
          .collection('LunchX')
          .doc('canteens')
          .collection('users')
          .doc(user.email)
          .collection('AcceptedOrders');

      QuerySnapshot querySnapshot = await currentUserOrdersRef.get();

      // Map to store the food items and their counts
      Map<String, int> foodItemsCount = {};

      // Iterate over each document to extract cart items and count them
      for (var doc in querySnapshot.docs) {
        List<dynamic> cartItems = doc['cartItems'];
        for (var item in cartItems) {
          String itemName = item['name'];
          int itemCount = item['count'];

          // Update the count of the food item in the map
          foodItemsCount.update(
            itemName,
            (value) => value + itemCount,
            ifAbsent: () => itemCount,
          );
        }
      }

      // Convert the map into a list of maps with keys 'name' and 'count'
      List<Map<String, dynamic>> orders = foodItemsCount.entries
          .map((entry) => {'name': entry.key, 'count': entry.value})
          .toList();

      return orders;
    }
  } catch (error) {
    ////print('Error fetching orders: $error');
  }

  return []; // Return empty list in case of errors
}
