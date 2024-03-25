// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart'; // Import this for TextInputFormatter
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lunchx_canteen/menu_manager.dart'; // Import Firestore
// ignore: unused_import
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
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

  // Function to show alert indicating success or failure
  void _showAlertDialog(bool saved) async {
    String message =
        saved ? 'Food item is saved!' : 'Failed to save food item.';
    String title = saved ? 'Success' : 'Error';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              if (saved) {
                // Navigate directly to MenuManagerPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MenuManagerScreen()),
                );
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
      double price = double.tryParse(_priceController.text) ?? 0.0;

      // Ensure that an image is selected
      if (_image == null) {
        throw 'Please select an image.';
      }

      // Get the path of the selected image asset
      String imagePath = _image!.path;

      // Upload image to Firebase Storage
      Reference storageRef = FirebaseStorage.instance.ref('image_menu/$name');
      await storageRef.putFile(File(imagePath));

      // Get download URL for the uploaded image
      String imageUrl = await storageRef.getDownloadURL();

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
        'image': imageUrl, // Add the image download URL here
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
      _showAlertDialog(true); // Moved this line outside the try-catch block
    } catch (e) {
      // Show error message
      _showAlertDialog(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
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
                  // Add functionality to handle saving the item
                  _saveDataToFirestore();
                } else {
                  _showAlertDialog(false);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
// Do not change in the code
