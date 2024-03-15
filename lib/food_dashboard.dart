// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodDashboard extends StatelessWidget {
  FoodDashboard({super.key});

  // Dummy data for the scrolling cards
  List<Map<String, dynamic>> menuItems = [
    {
      'name': 'Veg Burger',
      'description':
          'Veggie Burger in Every Bite: Crunchy Garden-fresh Goodness with our Signature Veg Burger!',
      'price': 79,
      'image': 'assets/image5.png',
      'availibity': true,
    },
    {
      'name': 'Cheese Burger',
      'description':
          'Savor the Taste of our Juicy Cheese Burger: Made with 100% Pure Beef and Topped with Melted Cheese!',
      'price': 99,
      'image': 'assets/image5.png',
      'availibity': false,
    },
    {
      'name': 'Chicken Sandwich',
      'description':
          'Grilled Chicken Sandwich: Soft Bread, Grilled Chicken Breast, Fresh Lettuce, Tomatoes, and Mayo.',
      'price': 129,
      'image': 'assets/image5.png',
      'availibity': true,
    },
    {
      'name': 'Fish and Chips',
      'description':
          'Crispy Fried Fish and Thick-Cut Chips: Served with Tartar Sauce and Lemon Wedges.',
      'price': 189,
      'image': 'assets/image5.png',
      'availibity': false,
    },
    {
      'name': 'Veg Pizza',
      'description':
          'Fresh Veggie Pizza: Topped with Tomato Sauce, Mozzarella Cheese, Bell Peppers, Onions, and Mushrooms.',
      'price': 199,
      'image': 'assets/image5.png',
      'availibity': true,
    },
    {
      'name': 'Chocolate Cake',
      'description':
          'Rich and Moist Chocolate Cake: Layers of Chocolate Sponge and Velvety Chocolate Icing.',
      'price': 89,
      'image': 'assets/image5.png',
      'availibity': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                color: Color.fromARGB(255, 255, 255, 255),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6552FE),
                        borderRadius: BorderRadius.circular(11.0),
                      ),
                      padding: EdgeInsets.all(6.0),
                      margin: EdgeInsets.only(left: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '10',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Pending',
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
                    SizedBox(width: 40.0),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Items',
                          style: GoogleFonts.outfit(
                            color: Color(0xFF919191),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 70.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        ),
                      ),
                      padding: EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.arrow_downward,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
                height:
                    20.0), // Add spacing between the existing content and the grid of cards

            // Grid of Cards
            Container(
              color: Colors.white,
              height: maxHeight,
              margin: EdgeInsets.only(left: 20.0, right: 20),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        // Image
                        Image.asset(
                          menuItems[index]['image'],
                          width: 100, // Adjust the width as needed
                          height: 100, // Adjust the height as needed
                        ),
                        // Item Name
                        Text(
                          menuItems[index]['name'],
                          style: GoogleFonts.outfit(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Small Container with Number
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 15.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF6552FE),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Text(
                            '10',
                            style: GoogleFonts.outfit(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
