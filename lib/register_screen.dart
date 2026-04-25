import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final name = TextEditingController();
  final email = TextEditingController();
  final aadhaar = TextEditingController();
  final pan = TextEditingController();
  final phone = TextEditingController();
  final roll = TextEditingController();

  bool loading = false;

  Future<void> register() async {

    if (name.text.isEmpty ||
        email.text.isEmpty ||
        aadhaar.text.isEmpty ||
        pan.text.isEmpty ||
        phone.text.isEmpty ||
        roll.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    try {

      final res = await http.post(
        Uri.parse("http://172.17.29.222:3000/student/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name.text,
          "email": email.text,
          "aadhaar": aadhaar.text,
          "pan": pan.text,
          "phone": phone.text,
          "roll": roll.text
        }),
      );

      print("SERVER RESPONSE:");
      print(res.body);

      if (res.statusCode != 200) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Server error")),
        );

        return;
      }

      final data = jsonDecode(res.body);

      if (data["did"] == null) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["error"] ?? "Registration failed")),
        );

        return;
      }

      final did = data["did"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("did", did);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(did: did),
        ),
      );

    } catch (e) {

      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connection error")),
      );

    } finally {

      setState(() {
        loading = false;
      });

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Student Registration")),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          TextField(
            controller: name,
            decoration: const InputDecoration(labelText: "Name"),
          ),

          TextField(
            controller: email,
            decoration: const InputDecoration(labelText: "Email"),
          ),

          TextField(
            controller: aadhaar,
            decoration: const InputDecoration(labelText: "Aadhaar"),
          ),

          TextField(
            controller: pan,
            decoration: const InputDecoration(labelText: "PAN"),
          ),

          TextField(
            controller: phone,
            decoration: const InputDecoration(labelText: "Phone"),
          ),

          TextField(
            controller: roll,
            decoration: const InputDecoration(labelText: "Roll Number"),
          ),

          const SizedBox(height: 30),

          loading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: register,
                  child: const Text("Register"),
                ),

        ],
      ),
    );
  }
}