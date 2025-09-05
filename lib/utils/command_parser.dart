Map<String, dynamic> parseCommand(String command) {
  final lowerCmd = command.toLowerCase().trim();

  // Pay command: "Pay 500 to Rahul"
  if (lowerCmd.contains("pay")) {
    final regExp = RegExp(r'pay\s+(\d+)\s*(to)?\s*(\w+)?');
    final match = regExp.firstMatch(lowerCmd);
    if (match != null) {
      return {
        "intent": "pay",
        "amount": match.group(1),
        "recipient": match.group(3) ?? "unknown",
      };
    }
    return {"intent": "pay"};
  }

  // Profile command
  if (lowerCmd.contains("profile") || lowerCmd.contains("account")) {
    return {"intent": "profile"};
  }

  // Transaction history command
  if (lowerCmd.contains("transaction") || lowerCmd.contains("history") || lowerCmd.contains("recent")) {
    return {"intent": "transactions"};
  }

  // Help command
  if (lowerCmd.contains("help") || lowerCmd.contains("what can you do")) {
    return {"intent": "help"};
  }

  // Default fallback
  return {"intent": "unknown"};
}
