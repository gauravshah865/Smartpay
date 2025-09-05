import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
class PayContactsScreen extends StatefulWidget {
  const PayContactsScreen({super.key});

  @override
  _PayContactsScreenState createState() => _PayContactsScreenState();
}

class _PayContactsScreenState extends State<PayContactsScreen> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  void _fetchContacts() async {
    final status = await Permission.contacts.status;

    if (!status.isGranted) {
      final result = await Permission.contacts.request();
      if (!result.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Permission not granted to access contacts.")),
        );
        return;
      }
    }

    if (await FlutterContacts.requestPermission()) {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        _contacts = contacts;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("FlutterContacts permission denied")),
      );
    }
  }
void _onContactTap(Contact contact) {
  String name = contact.displayName;
  String phone = contact.phones.isNotEmpty ? contact.phones.first.number : "";

  if (phone.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Selected contact has no phone number.")),
    );
    return;
  }

  TextEditingController upiController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Pay $name"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Phone: $phone"),
          SizedBox(height: 10),
          TextField(
            controller: upiController,
            decoration: InputDecoration(
              labelText: "Enter UPI ID (e.g. name@bank)",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            String upiId = upiController.text.trim();

            if (upiId.isEmpty || !upiId.contains("@")) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("❗ Please enter a valid UPI ID.")),
              );
              return;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Processing payment...")),
            );

            try {
              // Initiate UPI Intent Redirect
              final uri = Uri.parse(
                "upi://pay?pa=$upiId&pn=${Uri.encodeComponent(name)}&am=1.00&cu=INR",
              );

              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                throw "Could not launch UPI app";
              }
            } catch (e) {
              print("❌ Payment failed: $e");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("❌ Payment failed: $e")),
              );
            }
          },
          child: Text("Pay"),
        ),
      ],
    ),
  );
}

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pay Contacts")),
      body: _contacts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                Contact contact = _contacts[index];
                return ListTile(
                  title: Text(contact.displayName),
                  subtitle: Text(
                    contact.phones.isNotEmpty
                        ? contact.phones.first.number
                        : "No number",
                  ),
                  onTap: () => _onContactTap(contact),
                );
              },
            ),
    );
  }
}
