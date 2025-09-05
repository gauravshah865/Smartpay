import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final Map<String, String> tx;

  const TransactionTile({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Icon(Icons.account_circle)),
      title: Text(tx['name']!),
      subtitle: Text(tx['status']!),
      trailing: Text(tx['amount']!,
          style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
