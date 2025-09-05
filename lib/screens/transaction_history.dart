import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/transaction_card.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  final List<Transaction> transactions = const [
    const Transaction(name: 'Aman', date: 'April 6, 2025', amount: 1200, isSuccess: true),
    const Transaction(name: 'Flipkart', date: 'April 4, 2025', amount: 899.99, isSuccess: true),
    const Transaction(name: 'Netflix', date: 'April 2, 2025', amount: 499.00, isSuccess: false),
    const Transaction(name: 'Riya', date: 'March 29, 2025', amount: 200, isSuccess: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return TransactionCard(transaction: transactions[index]);
        },
      ),
    );
  }
}
