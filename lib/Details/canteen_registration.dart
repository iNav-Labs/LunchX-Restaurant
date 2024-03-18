// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lunchx_canteen/canteen_dashboard.dart';

class CanteenRegistration extends StatelessWidget {
  CanteenRegistration({super.key});

  final _nameController = TextEditingController();
  final _canteenNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Regular expressions for validating email and phone numbers
  final RegExp _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp _phoneNumberRegExp = RegExp(r'^[0-9]{10}$');

  Future<void> _registerCanteen(BuildContext context) async {
    try {
      final email = _emailController.text;
      final phoneNumber = _phoneController.text;

      // Validate email format
      if (!_emailRegExp.hasMatch(email)) {
        throw 'Invalid email format';
      }

      // Validate phone number format
      if (!_phoneNumberRegExp.hasMatch(phoneNumber)) {
        throw 'Invalid phone number format';
      }

      // Check if email is already used
      final emailQuerySnapshot = await FirebaseFirestore.instance
          .collection('LunchX')
          .doc('canteens')
          .collection('users')
          .doc(email)
          .get();

      if (emailQuerySnapshot.exists) {
        throw 'Email already exists';
      }

      // Add data to Firestore
      await FirebaseFirestore.instance
          .collection('LunchX')
          .doc('canteens')
          .collection('users')
          .doc(email)
          .set({
        'name': _nameController.text,
        'canteenName': _canteenNameController.text,
        'email': email,
        'phoneNumber': phoneNumber,
      });

      // Show success popup
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Canteen Registration'),
            content:
                const Text('Your canteen registration is successfully done.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardScreen()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Show error popup
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to store data: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(80.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Canteen Registration',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _canteenNameController,
                    decoration: const InputDecoration(
                      labelText: 'Canteen Name',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Your Previous Email ID',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton.small(
                        backgroundColor: Colors.black,
                        onPressed: () {
                          _registerCanteen(context);
                        },
                        shape: const StadiumBorder(),
                        child: const Icon(
                          Icons.arrow_right_alt_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
