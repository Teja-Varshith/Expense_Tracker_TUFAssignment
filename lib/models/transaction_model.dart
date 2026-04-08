enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final double amount;
  final String category;
  final TransactionType type;
  final String note;
  final DateTime date;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.category,
    required this.type,
    this.note = '',
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'amount': amount,
        'category': category,
        'type': type.index,
        'note': note,
        'date': date.toIso8601String(),
      };

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      type: TransactionType.values[map['type'] as int],
      note: (map['note'] as String?) ?? '',
      date: DateTime.parse(map['date'] as String),
    );
  }

  TransactionModel copyWith({
    String? id,
    double? amount,
    String? category,
    TransactionType? type,
    String? note,
    DateTime? date,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      type: type ?? this.type,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }

  @override
  String toString() =>
      'TransactionModel(id: $id, amount: $amount, category: $category, type: $type, date: $date)';
}
