import 'dart:async';  // Import async utilities for delays
import 'package:http/http.dart' as http;
import 'dart:convert';

class OpenAIService {
  // API Key directly included in the code (you can later move it to .env or a safer method)
  final String _apiKey = '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';  
  final String _baseUrl = "https://api.openai.com/v1/chat/completions";  

  // Retry Logic in the API call
  Future<String> getChatGPTResponse(String prompt) async {
    if (_apiKey.isEmpty) {
      return "API Key is missing!";
    }

    int retries = 3;  // Number of retries
    int retryDelay = 2;  // Initial delay before retrying (in seconds)

    for (int attempt = 0; attempt < retries; attempt++) {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "user", "content": prompt}
          ],
          "max_tokens": 100
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"].trim();
      } else if (response.statusCode == 429) {
        // If rate limit exceeded, wait and retry
        if (attempt < retries - 1) {
          await Future.delayed(Duration(seconds: retryDelay)); // Wait before retry
          retryDelay *= 2;  // Exponential backoff: Increase delay for next retry
        } else {
          return "Sorry, you're sending requests too fast or have exceeded your quota (Error 429). Please try again later.";
        }
      } else {
        return "Sorry, there was an error: ${response.statusCode}";
      }
    }
    return "An unexpected error occurred.";
  }
}
