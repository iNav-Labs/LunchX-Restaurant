// ignore_for_file: library_private_types_in_public_api, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart'; // Import this for TextInputFormatter
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class ManageItemScreen extends StatefulWidget {
  const ManageItemScreen({super.key});

  @override
  _ManageItemScreenState createState() => _ManageItemScreenState();
}

class _ManageItemScreenState extends State<ManageItemScreen> {
  File? _image; // Variable to store the selected image file
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  late User _currentUser; // Current user

  @override
  void initState() {
    super.initState();
    _loadCurrentUser(); // Load current user on initialization
  }

  // Function to load the current user
  Future<void> _loadCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  // Function to open the image picker
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

  // Function to validate if all fields are filled
  bool _validateFields() {
    if (_image == null ||
        _nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty) {
      return false;
    }
    return true;
  }

  // Function to show alert with a message
  void _showAlertDialog(bool saved, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(saved ? 'Success' : 'Alert'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              if (saved) {
                _saveDataToFirestore(); // Save data to Firestore
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Function to save data to Firestore
  void _saveDataToFirestore() async {
    try {
      // Get data from controllers
      String name = _nameController.text;
      String description = _descriptionController.text;
      double price = double.parse(_priceController.text);

      // Get the path of the selected image asset
      String imagePath =
          _image!.path; // Assuming the image is picked from the device

      // Reference to the Firestore collection
      CollectionReference itemsCollection = FirebaseFirestore.instance
          .collection('LunchX') // Your top-level collection name
          .doc('canteens') // Document ID
          .collection('users') // Sub-collection
          .doc(_currentUser
              .email!) // Document ID (use the current user's email here)
          .collection('items'); // Sub-collection for items

      // Create a document with the name as the document ID
      DocumentReference newItemRef = itemsCollection.doc(name);
      // Add data to Firestore
      await newItemRef.set({
        'image': imagePath, // Add the image asset path here
        'name': name,
        'description': description,
        'price': price,
      });

      // Clear input fields
      setState(() {
        _image = null;
        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
      });

      // Show success message
      _showAlertDialog(true, 'Food item is saved!');
    } catch (e) {
      // Show error message
      _showAlertDialog(false, 'Failed to save food item.');
    }
  }

  // Function to delete data from Firestore
  void _deleteDataFromFirestore() async {
    try {
      // Get the name of the item to be deleted
      String name = _nameController.text;

      // Reference to the Firestore collection
      CollectionReference itemsCollection = FirebaseFirestore.instance
          .collection('LunchX') // Your top-level collection name
          .doc('canteens') // Document ID
          .collection('users') // Sub-collection
          .doc(_currentUser
              .email!) // Document ID (use the current user's email here)
          .collection('items'); // Sub-collection for items

      // Delete the document with the specified name
      await itemsCollection.doc(name).delete();

      // Clear input fields
      setState(() {
        _image = null;
        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
      });

      // Show success message
      _showAlertDialog(true, 'Food item is deleted!');
    } catch (e) {
      // Show error message
      _showAlertDialog(false, 'Failed to delete food item.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Item'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Food Item Photo:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150.0,
                width: 150.0,
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
            const Text(
              'Name:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Price:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly // Allow only digits
              ],
              decoration: const InputDecoration(
                hintText: 'Enter price',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_validateFields()) {
                  _showAlertDialog(true, 'Are you sure you want to save?');
                } else {
                  _showAlertDialog(false, 'Please fill in all fields.');
                }
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 10.0), // Add some spacing
            ElevatedButton(
              onPressed: () {
                // Add functionality to handle deleting the item
                _deleteDataFromFirestore();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Set button color to red
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
