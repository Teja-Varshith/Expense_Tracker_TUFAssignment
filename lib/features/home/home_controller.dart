import 'package:expense_tracker_tuf/features/home/home_repository.dart';
import 'package:expense_tracker_tuf/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Transaction state and monthly analytics providers for Home.
final transactionRepositoryProvider = Provider<TransactionRepository>(
  (_) => const TransactionRepository(),
);

final transactionProvider =
    NotifierProvider<TransactionController, List<TransactionModel>>(
  TransactionController.new,
);

class TransactionController extends Notifier<List<TransactionModel>> {
  TransactionRepository get _repo => ref.read(transactionRepositoryProvider);

  @override
  List<TransactionModel> build() => _repo.fetchAll();

  void _refresh() => state = _repo.fetchAll();

  Future<void> add({
    required double amount,
    required String category,
    required TransactionType type,
    String note = '',
    DateTime? date,
  }) async {
    await _repo.add(
      amount: amount,
      category: category,
      type: type,
      note: note,
      date: date,
    );
    _refresh();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _refresh();
  }

  Future<void> update(TransactionModel tx) async {
    await _repo.update(tx);
    _refresh();
  }
}

final selectedMonthProvider =
    NotifierProvider<SelectedMonthNotifier, DateTime>(
  SelectedMonthNotifier.new,
);

class SelectedMonthNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void setMonth(DateTime dt) => state = dt;
  void previousMonth() => state = DateTime(state.year, state.month - 1);
  void nextMonth() => state = DateTime(state.year, state.month + 1);
}

// Derived providers used by dashboard cards and charts.
final monthlyTransactionsProvider = Provider<List<TransactionModel>>((ref) {
  final all = ref.watch(transactionProvider);
  final selected = ref.watch(selectedMonthProvider);
  return all
      .where(
          (tx) => tx.date.year == selected.year && tx.date.month == selected.month)
      .toList();
});

final monthlyIncomeProvider = Provider<double>((ref) {
  final txs = ref.watch(monthlyTransactionsProvider);
  return txs
      .where((tx) => tx.type == TransactionType.income)
      .fold(0.0, (sum, tx) => sum + tx.amount);
});

final monthlyExpenseProvider = Provider<double>((ref) {
  final txs = ref.watch(monthlyTransactionsProvider);
  return txs
      .where((tx) => tx.type == TransactionType.expense)
      .fold(0.0, (sum, tx) => sum + tx.amount);
});

final monthlyBalanceProvider = Provider<double>((ref) {
  return ref.watch(monthlyIncomeProvider) - ref.watch(monthlyExpenseProvider);
});

final categoryBreakdownProvider = Provider<Map<String, double>>((ref) {
  final txs = ref.watch(monthlyTransactionsProvider);
  final map = <String, double>{};
  for (final tx in txs.where((t) => t.type == TransactionType.expense)) {
    map[tx.category] = (map[tx.category] ?? 0) + tx.amount;
  }
  return map;
});

final totalBalanceProvider = Provider<double>((ref) {
  final all = ref.watch(transactionProvider);
  double balance = 0;
  for (final tx in all) {
    if (tx.type == TransactionType.income) {
      balance += tx.amount;
    } else {
      balance -= tx.amount;
    }
  }
  return balance;
});

final totalSpentProvider = Provider<double>((ref) {
  final all = ref.watch(transactionProvider);
  return all
      .where((tx) => tx.type == TransactionType.expense)
      .fold(0.0, (sum, tx) => sum + tx.amount);
});
