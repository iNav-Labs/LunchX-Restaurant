// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:lunchx_canteen/canteen_dashboard.dart';

// class CanteenRegistration extends StatelessWidget {
//   CanteenRegistration({super.key});

//   final _nameController = TextEditingController();
//   final _canteenNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();

//   // Regular expressions for validating email and phone numbers
//   final RegExp _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//   final RegExp _phoneNumberRegExp = RegExp(r'^[0-9]{10}$');

//   Future<void> _registerCanteen(BuildContext context) async {
//     try {
//       final email = _emailController.text;
//       final phoneNumber = _phoneController.text;

//       // Validate email format
//       if (!_emailRegExp.hasMatch(email)) {
//         throw 'Invalid email format';
//       }

//       // Validate phone number format
//       if (!_phoneNumberRegExp.hasMatch(phoneNumber)) {
//         throw 'Invalid phone number format';
//       }

//       // Check if email is already used
//       final emailQuerySnapshot = await FirebaseFirestore.instance
//           .collection('LunchX')
//           .doc('canteens')
//           .collection('users')
//           .doc(email)
//           .get();

//       if (emailQuerySnapshot.exists) {
//         throw 'Email already exists';
//       }

//       // Add data to Firestore
//       await FirebaseFirestore.instance
//           .collection('LunchX')
//           .doc('canteens')
//           .collection('users')
//           .doc(email)
//           .set({
//         'name': _nameController.text,
//         'canteenName': _canteenNameController.text,
//         'email': email,
//         'phoneNumber': phoneNumber,
//       });

//       // Show success popup
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Canteen Registration'),
//             content:
//                 const Text('Your canteen registration is successfully done.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const DashboardScreen()),
//                   );
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     } catch (e) {
//       // Show error popup
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Error'),
//             content: Text('Failed to store data: $e'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//       ),
//       body: ListView(
//         children: [
//           const SizedBox(height: 50.0),
//           Padding(
//             padding: const EdgeInsets.all(80.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Canteen Registration',
//                   style: TextStyle(
//                     fontSize: 32.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 TextField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Name',
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 TextField(
//                   controller: _canteenNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Canteen Name',
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 TextField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter Your Previous Email ID',
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//                 const SizedBox(height: 16.0),
//                 TextField(
//                   controller: _phoneController,
//                   decoration: const InputDecoration(
//                     labelText: 'Phone Number',
//                   ),
//                   keyboardType: TextInputType.phone,
//                 ),
//                 const SizedBox(height: 30.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     FloatingActionButton.small(
//                       backgroundColor: Colors.black,
//                       onPressed: () {
//                         _registerCanteen(context);
//                       },
//                       shape: const StadiumBorder(),
//                       child: const Icon(
//                         Icons.arrow_right_alt_rounded,
//                         size: 40,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, library_prefixes, unnecessary_string_interpolations

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
// import 'package:image_picker/image_picker.dart'; // Import Image Picker
// import 'package:path/path.dart' as Path; // Import path package
// import 'package:lunchx_canteen/canteen_dashboard.dart';

// class CanteenRegistration extends StatefulWidget {
//   const CanteenRegistration({super.key});

//   @override
//   _CanteenRegistrationState createState() => _CanteenRegistrationState();
// }

// class _CanteenRegistrationState extends State<CanteenRegistration> {
//   final _nameController = TextEditingController();
//   final _canteenNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   File? _image; // Variable to store the selected image file

//   // Image picker method
//   Future<void> _getImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   // Regular expressions for validating email and phone numbers
//   final RegExp _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//   final RegExp _phoneNumberRegExp = RegExp(r'^[0-9]{10}$');

//   Future<void> _registerCanteen(BuildContext context) async {
//     try {
//       final email = _emailController.text;
//       final phoneNumber = _phoneController.text;

//       // Validate email format
//       if (!_emailRegExp.hasMatch(email)) {
//         throw 'Invalid email format';
//       }

//       // Validate phone number format
//       if (!_phoneNumberRegExp.hasMatch(phoneNumber)) {
//         throw 'Invalid phone number format';
//       }

//       // Check if email is already used
//       final emailQuerySnapshot = await FirebaseFirestore.instance
//           .collection('LunchX')
//           .doc('canteens')
//           .collection('users')
//           .doc(email)
//           .get();

//       if (emailQuerySnapshot.exists) {
//         throw 'Email already exists';
//       }

//       // Upload image to Firebase Storage
//       String imagePath = '';
//       if (_image != null) {
//         Reference storageRef = FirebaseStorage.instance
//             .ref()
//             .child('canteen_images')
//             .child('${Path.basename(_image!.path)}');
//         UploadTask uploadTask = storageRef.putFile(_image!);
//         TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
//         imagePath = await storageRef.getDownloadURL();
//       }

//       // Add data to Firestore
//       await FirebaseFirestore.instance
//           .collection('LunchX')
//           .doc('canteens')
//           .collection('users')
//           .doc(email)
//           .set({
//         'name': _nameController.text,
//         'canteenName': _canteenNameController.text,
//         'email': email,
//         'phoneNumber': phoneNumber,
//         'imagePath': imagePath,
//       });

//       // Show success popup
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Canteen Registration'),
//             content:
//                 const Text('Your canteen registration is successfully done.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const DashboardScreen(),
//                     ),
//                   );
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     } catch (e) {
//       // Show error popup
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Error'),
//             content: Text('Failed to store data: $e'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//       ),
//       body: ListView(
//         children: [
//           const SizedBox(height: 50.0),
//           Padding(
//             padding: const EdgeInsets.all(80.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Canteen Registration',
//                   style: TextStyle(
//                     fontSize: 32.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 TextField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Name',
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 TextField(
//                   controller: _canteenNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Canteen Name',
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 TextField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter Your Previous Email ID',
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//                 const SizedBox(height: 16.0),
//                 TextField(
//                   controller: _phoneController,
//                   decoration: const InputDecoration(
//                     labelText: 'Phone Number',
//                   ),
//                   keyboardType: TextInputType.phone,
//                 ),
//                 const SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: _getImage, // Call image picker method
//                   child:
//                       Text(_image == null ? 'Select Image' : 'Image Selected'),
//                 ),
//                 const SizedBox(height: 30.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     FloatingActionButton.small(
//                       backgroundColor: Colors.black,
//                       onPressed: () {
//                         _registerCanteen(context);
//                       },
//                       shape: const StadiumBorder(),
//                       child: const Icon(
//                         Icons.arrow_right_alt_rounded,
//                         size: 40,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
