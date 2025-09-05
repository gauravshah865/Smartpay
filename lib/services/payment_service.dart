// payment_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  static Future<Map<String, dynamic>> initiatePayment(
      String name, String upiId, double amount) async {
    // For Android Emulator use 10.0.2.2 instead of localhost
    final url = Uri.parse("http://192.168.224.240:5000/api/pay");

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'name': name,
      'upiId': upiId,
      'amount': amount,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      print("➡️ Request sent to: $url");
      print("📨 Response status: ${response.statusCode}");
      print("📨 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else {
        throw Exception("❌ Failed to make payment: ${response.body}");
      }
    } catch (e) {
      print("🚨 Exception in PaymentService: $e");
      throw Exception("Payment service error: $e");
    }
  }
}
