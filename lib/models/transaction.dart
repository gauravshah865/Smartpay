class Transaction {
  final String name;
  final String date;
  final double amount;
  final bool isSuccess;

  const Transaction({
    required this.name,
    required this.date,
    required this.amount,
    required this.isSuccess,
  });
}
