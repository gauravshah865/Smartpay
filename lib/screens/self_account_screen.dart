// lib/screens/self_account_screen.dart
import 'package:flutter/material.dart';

class SelfAccountScreen extends StatelessWidget {
  const SelfAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Account")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("UPI ID: yourname@bank", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Account No: 1234567890", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Image.asset("assets/qr_sample.png", height: 200), // Add a sample QR image
            SizedBox(height: 20),
            Text("Scan this QR to pay", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
