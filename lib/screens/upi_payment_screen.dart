import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpiPaymentScreen extends StatelessWidget {
  final String upiId;
  final String name;
  final String? amount;

  const UpiPaymentScreen({
    super.key,
    required this.upiId,
    required this.name,
    this.amount,
  });

  void _launchUpiUri(BuildContext context) async {
    final uri = Uri.parse(
      'upi://pay?pa=$upiId&pn=$name&${amount != null ? 'am=$amount&' : ''}cu=INR',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch UPI app")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirm UPI Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Payee Name: $name", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("UPI ID: $upiId", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            if (amount != null)
              Text("Amount: ₹$amount", style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _launchUpiUri(context),
                icon: Icon(Icons.send),
                label: Text("Pay Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
