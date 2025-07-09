class TransactionModel {
  TransactionModel({
    required this.creditNumber,
    required this.created_at,
    required this.f_type,
    required this.amount,
  });

  final String creditNumber;
  final DateTime created_at;
  final String f_type;
  final double amount;

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      creditNumber: json['card_number'] as String? ?? '',
      f_type: json['f_type'] as String? ?? '',
      created_at: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'card_number': creditNumber,
    'f_type': f_type,
    'created_at': created_at.toIso8601String(),
    'amount': amount,
  };
}