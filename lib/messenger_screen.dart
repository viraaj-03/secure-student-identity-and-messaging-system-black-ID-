import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class MessengerScreen extends StatefulWidget {

  final String did;

  const MessengerScreen({super.key, required this.did});

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {

  List messages = [];
  Timer? timer;

  Future<void> fetchMessages() async {

    var res = await http.get(
      Uri.parse("http://172.17.29.222:3000/message?did=${widget.did}")
    );

    var data = jsonDecode(res.body);

    setState(() {
      messages = data;
    });

  }

  @override
  void initState() {
    super.initState();

    fetchMessages();

    timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => fetchMessages(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: const Text("Messenger")),

      body: messages.isEmpty
          ? const Center(child: Text("No messages yet"))
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, i) {

                return ListTile(

                  title: Text(
                    messages[i]["subject"],
                    style: TextStyle(
                      fontWeight: messages[i]["read"] == 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),

                  subtitle: Text(messages[i]["body"]),

                  trailing: Text(messages[i]["company"]),

                  onTap: () async {

                    await http.post(
                      Uri.parse("http://192.168.29.203:3000/message/read"),
                      headers: {"Content-Type": "application/json"},
                      body: jsonEncode({"id": messages[i]["id"]}),
                    );

                    fetchMessages();

                  },

                );

              },
            ),
    );
  }
}