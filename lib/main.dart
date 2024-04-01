import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lunchx_canteen/canteen_dashboard.dart';
import 'package:lunchx_canteen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyBnMab_6AM-IxVVwabLK_DHZZPdFL55WJU",
    projectId: "lunchx-8a27e",
    storageBucket: "lunchx-8a27e.appspot.com",
    messagingSenderId: "751125177646",
    appId: "1:751125177646:web:bc1ff3ef2a368f1241c6bf",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // or a loading widget
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            // User is logged in, navigate to your home screen
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home:
                  DashboardScreen(), // Replace HomeScreen with your actual home screen
            );
          } else {
            // User is not logged in, navigate to login screen
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SplashScreen(),
            );
          }
        }
      },
    );
  }
}
