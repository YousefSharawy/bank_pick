class CardModel {
  CardModel({
    required this.cardNumber,
    required this.expireDate,
    required this.cardHolderName,
    required this.cvvCode,
    this.limit = 0,
  });

  final String cardNumber;
  final double limit;
  final String expireDate;
  final String cardHolderName;
  final String cvvCode;

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      cardNumber: json['card_number'] as String? ?? '',
      cardHolderName: json['card_holder'] as String? ?? '',
      cvvCode: json['cvv'] as String? ?? '',
      expireDate: json['expire_date'] as String? ?? '',
      limit: (json['limit'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'card_number': cardNumber,
        'card_holder': cardHolderName,
        'cvv': cvvCode,
        'expire_date': expireDate,
        'limit': limit,
      };
}