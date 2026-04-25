import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'messenger_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {

  final String did;

  const HomeScreen({super.key, required this.did});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    setupFCM();
  }

  void setupFCM() async {

    await FirebaseMessaging.instance.requestPermission();

    String? token = await FirebaseMessaging.instance.getToken();

    print("FCM TOKEN:");
    print(token);

    if(token != null){
      sendTokenToServer(token);
    }

  }

  Future<void> sendTokenToServer(String token) async {

    await http.post(
      Uri.parse("http://172.17.29.222:3000/student/update-token"),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode({
        "did": widget.did,
        "token": token
      }),
    );

  }

  @override
  Widget build(BuildContext context) {

    final screens = [

      /// WALLET TAB
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "Your DID",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height:10),

            Text(
              widget.did,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height:10),

            ElevatedButton(
              child: const Text("Copy DID"),
              onPressed: (){
                Clipboard.setData(
                  ClipboardData(text: widget.did)
                );
              },
            ),

            const SizedBox(height:20),

            QrImageView(
              data: widget.did,
              size: 220,
            ),

          ],
        ),
      ),

      /// MESSENGER TAB
      MessengerScreen(did: widget.did),

      /// PROFILE TAB
      ProfileScreen(did: widget.did),

    ];

    return Scaffold(

      appBar: AppBar(
        title: const Text("BLACK ID"),
      ),

      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: currentIndex,

        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: "Wallet",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Messages",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),

        ],

      ),

    );
  }
}