import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const ActionCard({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.indigo[100],
          child: Icon(icon, color: Colors.indigo, size: 30),
        ),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
