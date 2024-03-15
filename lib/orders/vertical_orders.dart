import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerticalOrders extends StatelessWidget {
  final List<Map<String, dynamic>> orders;

  const VerticalOrders({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                    'Incoming Orders',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF919191),
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
        Expanded(
          child: Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text(
                            '${orders[index]['name']}',
                            style: GoogleFonts.outfit(
                                fontSize: 18.0, fontWeight: FontWeight.w600),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${orders[index]['orderNumber']} - ${orders[index]['orderType']}',
                                style: GoogleFonts.outfit(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF6552FE)),
                              ),
                              Text(
                                'Rs. ${orders[index]['orderPrice']}',
                                style: GoogleFonts.outfit(
                                    fontSize: 24.0,
                                    color: const Color(0x00000000),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Order Items:',
                                style: GoogleFonts.outfit(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              for (var item in orders[index]['orderItems'])
                                Text(
                                  '${item['itemName']}    -    ${item['quantity']}',
                                  style: GoogleFonts.outfit(fontSize: 18.0),
                                ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the pop-up
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xFF6552FE),
                                    ),
                                    child: const Text(
                                      'Ready',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the pop-up
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xFFF19D20),
                                    ),
                                    child: const Text(
                                      'Dispatch',
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
                              'Name: ${orders[index]['name']}',
                              style: GoogleFonts.outfit(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              'Order Number: ${orders[index]['orderNumber']}',
                              style: GoogleFonts.outfit(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF6552FE),
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
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2.0,
                                      ),
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 12.0),
                                    child: const Text(
                                      'Accept',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2.0,
                                      ),
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 8.0),
                                    child: Text(
                                      'Reject',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
    );
  }
}
