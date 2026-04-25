import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'register_screen.dart';
import 'home_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const BlackIDApp());
}

class BlackIDApp extends StatelessWidget {
  const BlackIDApp({super.key});

  Future<String?> getStoredDID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("did");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BLACK ID",

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: FutureBuilder<String?>(
        future: getStoredDID(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final did = snapshot.data;

          if (did == null) {
            return const RegisterScreen();
          } else {
            return HomeScreen(did: did);
          }

        },
      ),
    );
  }
}