import 'package:flutter/material.dart';
import 'openai_service.dart';
import '../widgets/voice_assistant.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:smartpay_fixed/screens/profile_screen.dart';
import 'package:smartpay_fixed/screens/pay_mobile_number.dart';
import 'package:smartpay_fixed/screens/pay_contacts.dart';
import 'package:smartpay_fixed/screens/scan_qr_screen.dart';
import 'package:smartpay_fixed/screens/self_account_screen.dart';
import 'package:smartpay_fixed/screens/transaction_history.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) onCommandDetected;

  const HomeScreen({super.key, required this.onCommandDetected});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OpenAIService _openAIService = OpenAIService();
  String _response = '';

  void _handleVoiceCommand(String command) async {
    command = command.toLowerCase();

    if (command.contains('pay mobile') ||
        command.contains('मोबाइल भुगतान') ||
        command.contains('మొబైల్ చెల్లించు')) {
      widget.onCommandDetected("Pay Mobile Number");
      Navigator.push(context, MaterialPageRoute(builder: (_) => PayMobileNumberScreen()));
    } else if (command.contains('pay contacts') ||
        command.contains('संपर्कों को भुगतान') ||
        command.contains('కాంటాక్ట్ చెల్లించు')) {
      widget.onCommandDetected("Pay Contacts");
      Navigator.push(context, MaterialPageRoute(builder: (_) => PayContactsScreen()));
    } else if (command.contains('transactions') ||
        command.contains('लेन-देन') ||
        command.contains('లావాదేవీలు')) {
      widget.onCommandDetected("Transactions");
      Navigator.push(context, MaterialPageRoute(builder: (_) => TransactionScreen()));
    } else if (command.contains('check balance') ||
        command.contains('बैलेंस चेक') ||
        command.contains('శేషం చూపించు')) {
      widget.onCommandDetected("Check Balance");
      _showBalanceDialog();
    } else if (command.contains('bank account') ||
        command.contains('बैंक खाता') ||
        command.contains('బ్యాంక్ ఖాతా')) {
      widget.onCommandDetected("Bank Account");
      _showBankAccountDialog();
    } else if (command.contains('self account') ||
        command.contains('स्वयं खाता') ||
        command.contains('సెల్ఫ్ అకౌంట్')) {
      widget.onCommandDetected("Self Account");
      Navigator.push(context, MaterialPageRoute(builder: (_) => SelfAccountScreen()));
    } else if (command.contains('scan qr') ||
        command.contains('क्यूआर कोड स्कैन') ||
        command.contains('క్యూఆర్ స్కాన్')) {
      widget.onCommandDetected("Scan QR");
      Navigator.push(context, MaterialPageRoute(builder: (_) => ScanQRScreen()));
    } else if (command.contains('profile') ||
        command.contains('प्रोफ़ाइल') ||
        command.contains('ప్రొఫైల్')) {
      widget.onCommandDetected("Profile");
      Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
    } else if (command.contains('pay') ||
        command.contains('भुगतान') ||
        command.contains('చెల్లించు')) {
      widget.onCommandDetected("Pay");
      Navigator.push(context, MaterialPageRoute(builder: (_) => PayContactsScreen()));
    } else {
      String chatResponse = await _openAIService.getChatGPTResponse(command);
      setState(() {
        _response = chatResponse;
      });
      _speakResponse(chatResponse);
    }
  }

  void _speakResponse(String response) async {
    await FlutterTts().speak(response);
  }

  void _showBalanceDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Check Balance"),
        content: Text("Your current balance is: ₹1000.00"),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Close"))],
      ),
    );
  }

  void _showBankAccountDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Bank Account"),
        content: Text("Bank Account details: XXXX1234, IFSC: ABCD0123456"),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Close"))],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.blue.withAlpha((0.2 * 255).toInt()),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.indigo.shade100,
                radius: 30,
                child: Icon(icon, size: 30, color: Colors.indigo),
              ),
              SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Your VoiceAssistant widget with an attractive mic icon internally
            VoiceAssistant(onCommandDetected: _handleVoiceCommand),

            SizedBox(height: 20),

            if (_response.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "ChatGPT: $_response",
                  style: TextStyle(fontSize: 16),
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildIconButton(Icons.qr_code_scanner, "Scan QR", () {
                    widget.onCommandDetected("Scan QR");
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ScanQRScreen()));
                  }),
                  _buildIconButton(Icons.payment, "Pay Contacts", () {
                    widget.onCommandDetected("Pay Contacts");
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PayContactsScreen()));
                  }),
                  _buildIconButton(Icons.phone_android, "Pay Mobile", () {
                    widget.onCommandDetected("Pay Mobile");
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PayMobileNumberScreen()));
                  }),
                  _buildIconButton(Icons.account_balance, "Bank Account", () {
                    widget.onCommandDetected("Bank Account");
                    _showBankAccountDialog();
                  }),
                  _buildIconButton(Icons.account_circle, "Self Account", () {
                    widget.onCommandDetected("Self Account");
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SelfAccountScreen()));
                  }),
                  _buildIconButton(Icons.wallet, "Check Balance", () {
                    widget.onCommandDetected("Check Balance");
                    _showBalanceDialog();
                  }),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
