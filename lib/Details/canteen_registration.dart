// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lunchx_canteen/canteen_dashboard.dart';

class CanteenRegistration extends StatefulWidget {
  const CanteenRegistration({super.key});

  @override
  _CanteenRegistrationState createState() => _CanteenRegistrationState();
}

class _CanteenRegistrationState extends State<CanteenRegistration> {
  File? _image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _canteenNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  bool _validateFields() {
    return _image != null &&
        _nameController.text.isNotEmpty &&
        _canteenNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty;
  }

  void _showAlertDialog(bool saved) async {
    String message = saved
        ? 'Canteen registration is saved!'
        : 'Please fill all fields and upload an image.';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(saved ? 'Success' : 'Alert'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (saved) {
                _registerCanteen();
                // Navigate to dashboard screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const DashboardScreen(), // Replace DashboardScreen with your actual dashboard screen
                  ),
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _registerCanteen() async {
    try {
      String imagePath = _image!.path;

      await FirebaseFirestore.instance
          .collection('LunchX')
          .doc('canteens')
          .collection('users')
          .doc(_emailController.text)
          .set({
        'name': _nameController.text,
        'canteenName': _canteenNameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneController.text,
        'imagePath': imagePath,
      });

      setState(() {
        _image = null;
        _nameController.clear();
        _canteenNameController.clear();
        _emailController.clear();
        _phoneController.clear();
      });

      _showAlertDialog(true);
    } catch (e) {
      _showAlertDialog(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canteen Registration'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 20.0),
          const Text(
            'Upload Canteen Image:',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 150.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: _image == null
                  ? const Center(
                      child: Icon(Icons.camera_alt, size: 50.0),
                    )
                  : Image.file(_image!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 20.0),
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
          ElevatedButton(
            onPressed: () {
              if (_validateFields()) {
                _registerCanteen();
              } else {
                _showAlertDialog(false);
              }
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
// Do not change in the code
