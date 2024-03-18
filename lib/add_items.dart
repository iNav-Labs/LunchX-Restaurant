// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _AddItemScreenState createState() => _AddItemScreenState();
}

// DO NOT WORKING ABHI FILE PICKER - FIX IT !!

class _AddItemScreenState extends State<AddItemScreen> {
  File? _image; // Variable to store the selected image file

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

  // DO NOT WORKING ABHI FILE PICKER - FIX IT !!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Add Item'),
        actions: const [
          // You can add more actions here if needed
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your UI components for adding an item go here
              // Your UI components for adding an item go here
              const Text(
                'Food Item Photo:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              // File uploader goes here
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
              // File uploader goes here

              const SizedBox(height: 20),

              // Name Text Input
              const Text(
                'Name:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const TextField(
                  // Add your text field properties here
                  ),

              const SizedBox(height: 20),

              // Description Text Input
              const Text(
                'Description:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const TextField(
                  // Add your text field properties here
                  ),

              const SizedBox(height: 20),

              // Price Numeric Input
              const Text(
                'Price:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 150.0,
                child: const TextField(
                  keyboardType: TextInputType.number,
                  // Add your text field properties here
                ),
              ),

              const SizedBox(height: 20.0),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  // Add functionality to handle saving the item
                  // This is just a placeholder; you'll need to implement your logic
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
