import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SavedContactsScreen extends StatefulWidget {
  const SavedContactsScreen({super.key});

  @override
  _SavedContactsScreenState createState() => _SavedContactsScreenState();
}

class _SavedContactsScreenState extends State<SavedContactsScreen> {
  Map<String, dynamic> savedContacts = {};

  @override
  void initState() {
    super.initState();
    _loadSavedContacts();
  }

  Future<void> _loadSavedContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> allData = {};
    Set<String> keys = prefs.getKeys();

    for (String key in keys) {
      try {
        var data = jsonDecode(prefs.getString(key)!);
        allData[key] = data;
      } catch (_) {
        // skip non-contact data
      }
    }

    setState(() {
      savedContacts = allData;
    });
  }

  Future<void> _deleteContact(String number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(number);
    await _loadSavedContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saved Contacts")),
      body: savedContacts.isEmpty
          ? Center(child: Text("No saved contacts found."))
          : ListView.builder(
              itemCount: savedContacts.length,
              itemBuilder: (context, index) {
                String number = savedContacts.keys.elementAt(index);
                Map<String, dynamic> data = savedContacts[number];

                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(data['name'] ?? ''),
                  subtitle: Text("UPI: ${data['upi']}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteContact(number),
                  ),
                );
              },
            ),
    );
  }
}
