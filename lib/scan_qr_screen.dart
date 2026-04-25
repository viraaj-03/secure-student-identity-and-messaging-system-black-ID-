import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {

  bool scanned = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Scan Student QR")),

      body: MobileScanner(

        onDetect: (barcode, args) {

          if(scanned) return;

          final String? code = barcode.rawValue;

          if(code != null){

            scanned = true;

            Navigator.pop(context, code);

          }

        },

      ),

    );
  }
}