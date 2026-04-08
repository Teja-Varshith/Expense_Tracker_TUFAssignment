import 'package:expense_tracker_tuf/models/transaction_model.dart';

class BalanceSummary {
  final double income;
  final double expense;

  const BalanceSummary({required this.income, required this.expense});

  double get balance => income - expense;
}

class DailyExpensePoint {
  final int day;
  final double amount;

  const DailyExpensePoint({required this.day, required this.amount});
}

class BalancesRepository {
  const BalancesRepository();

  List<TransactionModel> monthlyTransactions(
    List<TransactionModel> all,
    DateTime month,
  ) {
    return all
        .where(
          (tx) => tx.date.year == month.year && tx.date.month == month.month,
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  BalanceSummary summary(List<TransactionModel> txs) {
    final income = txs
        .where((tx) => tx.type == TransactionType.income)
        .fold(0.0, (sum, tx) => sum + tx.amount);

    final expense = txs
        .where((tx) => tx.type == TransactionType.expense)
        .fold(0.0, (sum, tx) => sum + tx.amount);

    return BalanceSummary(income: income, expense: expense);
  }

  List<DailyExpensePoint> dailyExpenses(List<TransactionModel> txs) {
    final map = <int, double>{};

    for (final tx in txs) {
      if (tx.type != TransactionType.expense) {
        continue;
      }
      map[tx.date.day] = (map[tx.date.day] ?? 0) + tx.amount;
    }

    final list = map.entries
        .map((e) => DailyExpensePoint(day: e.key, amount: e.value))
        .toList()
      ..sort((a, b) => a.day.compareTo(b.day));

    return list;
  }

  Map<String, double> categoryBreakdown(List<TransactionModel> txs) {
    final map = <String, double>{};

    for (final tx in txs) {
      if (tx.type != TransactionType.expense) {
        continue;
      }
      map[tx.category] = (map[tx.category] ?? 0) + tx.amount;
    }

    return map;
  }

  MapEntry<String, double>? topExpenseCategory(List<TransactionModel> txs) {
    final categories = categoryBreakdown(txs);
    if (categories.isEmpty) {
      return null;
    }

    final sorted = categories.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first;
  }
}
