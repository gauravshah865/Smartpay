import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smartpay_fixed/screens/upi_payment_screen.dart';
class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  _ScanQRScreenState createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  //final bool _isScanned = false; // Add this line

  @override
  void initState() {
    super.initState();
    requestCameraPermission();
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

 void _handleQRCode(String code) {
  print("Scanned QR Code: $code");  // Log the scanned code
  final uri = Uri.tryParse(code);

  if (uri != null && uri.scheme == 'upi') {
    final upiId = uri.queryParameters['pa'];
    final name = uri.queryParameters['pn'] ?? 'Unknown';
    final amount = uri.queryParameters['am'];

    if (upiId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UpiPaymentScreen(
            upiId: upiId,
            name: name,
            amount: amount,
          ),
        ),
      );
    } else {
      _showInvalidQRDialog();
    }
  } else {
    _showInvalidQRDialog();
  }
}

void _showInvalidQRDialog() {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Invalid QR Code'),
      content: Text('The scanned code is not a valid UPI QR code.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        )
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: MobileScanner(
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;
            if (code != null) {
              _handleQRCode(code);
              break;
            }
          }
        },
      ),
    );
  }
}
