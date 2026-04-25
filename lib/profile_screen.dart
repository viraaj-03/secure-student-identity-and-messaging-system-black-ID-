import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {

  final String did;

  const ProfileScreen({super.key, required this.did});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Map student = {};

    Future<void> fetchProfile() async {

    final res = await http.get(
        Uri.parse("http://172.17.29.222:3000/student/resolve?did=${widget.did}")
    );

    print("PROFILE RESPONSE:");
    print(res.body);

    if (res.statusCode != 200) return;

    final data = jsonDecode(res.body);

    setState(() {
        student = data;
    });

    }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {

    if(student.isEmpty){
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(

      appBar: AppBar(title: const Text("Profile")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("Name: ${student["name"]}"),
            Text("Email: ${student["email"]}"),
            Text("Roll: ${student["roll"]}"),
            Text("DID: ${widget.did}"),

            const SizedBox(height:20),

            Text(
              student["kyc_verified"] == 1
                ? "KYC Status: VERIFIED"
                : "KYC Status: PENDING",
              style: const TextStyle(fontWeight: FontWeight.bold),
            )

          ],
        ),
      ),

    );
  }
}