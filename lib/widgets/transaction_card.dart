import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: transaction.isSuccess ? Colors.green : Colors.red,
          child: Icon(
            transaction.isSuccess ? Icons.check : Icons.close,
            color: Colors.white,
          ),
        ),
        title: Text(transaction.name),
        subtitle: Text(
          transaction.date,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey, // You can adjust this color
          ),
        ),

        trailing: Text(
          '₹ ${transaction.amount.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
