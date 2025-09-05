import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class PayMobileNumberScreen extends StatefulWidget {
  const PayMobileNumberScreen({super.key});

  @override
  _PayMobileNumberScreenState createState() => _PayMobileNumberScreenState();
}

class _PayMobileNumberScreenState extends State<PayMobileNumberScreen> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  void _onPayPressed() async {
    String name = _nameController.text.trim();
    String number = _numberController.text.trim();

    if (number.isEmpty) {
      _showMessage("Please enter mobile number.");
      return;
    }

    String? savedUpi = await _getSavedUpiId(number);

    if (savedUpi != null) {
      _initiateUpiPayment(name, savedUpi);
    } else {
      _askForUpiId(name, number);
    }
  }

  Future<void> _askForUpiId(String name, String number) async {
    final upiController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Enter UPI ID for $name"),
        content: TextField(
          controller: upiController,
          decoration: InputDecoration(hintText: "e.g., johndoe@oksbi"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              String upiId = upiController.text.trim();
              if (upiId.isNotEmpty) {
                _saveContactMapping(name, number, upiId);
                Navigator.of(context).pop();
                _initiateUpiPayment(name, upiId);
              } else {
                _showMessage("UPI ID cannot be empty");
              }
            },
            child: Text("Save & Pay"),
          ),
        ],
      ),
    );
  }

  Future<void> _saveContactMapping(String name, String number, String upiId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> contactMap = {
      "name": name,
      "number": number,
      "upi": upiId
    };
    await prefs.setString(number, jsonEncode(contactMap));
  }

  Future<String?> _getSavedUpiId(String number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(number)) {
      Map<String, dynamic> data = jsonDecode(prefs.getString(number)!);
      return data['upi'];
    }
    return null;
  }

  Future<void> _initiateUpiPayment(String name, String upiId) async {
    String amount = _amountController.text.trim();
    String note = _noteController.text.trim();

    if (amount.isEmpty) {
      _showMessage("Please enter amount.");
      return;
    }

    final uri = Uri.parse(
        "upi://pay?pa=$upiId&pn=$name&am=$amount&cu=INR&tn=$note");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showMessage("Could not launch UPI app.");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pay to Mobile Number"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _numberController,
              decoration: InputDecoration(labelText: "Mobile Number"),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: "Note"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onPayPressed,
              child: Text("Pay"),
            ),
          ],
        ),
      ),
    );
  }
}
