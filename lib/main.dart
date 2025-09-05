import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/transaction_history.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartPayApp());
}

class SmartPayApp extends StatefulWidget {
  const SmartPayApp({super.key});

  @override
  State<SmartPayApp> createState() => _SmartPayAppState();
}

class _SmartPayAppState extends State<SmartPayApp> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onCommandDetected: _handleNavigationCommand,
      ),
      const TransactionScreen(),
      const ProfileScreen(),
    ];
  }

  // Handle voice-based navigation
  void _handleNavigationCommand(String command) {
    setState(() {
      if (command == "Pay") {
        _selectedIndex = 0;
      } else if (command == "Transactions") {
        _selectedIndex = 1;
      } else if (command == "Profile") {
        _selectedIndex = 2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartPay',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SmartPay'),
          
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() => _selectedIndex = index);
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.history), label: 'Transactions'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
