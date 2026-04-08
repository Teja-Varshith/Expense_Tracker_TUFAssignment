import 'package:expense_tracker_tuf/features/balances/balances_repository.dart';
import 'package:expense_tracker_tuf/features/home/home_controller.dart';
import 'package:expense_tracker_tuf/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final balancesRepositoryProvider = Provider<BalancesRepository>(
  (_) => const BalancesRepository(),
);

final balancesSelectedMonthProvider =
    NotifierProvider<BalancesSelectedMonthNotifier, DateTime>(
  BalancesSelectedMonthNotifier.new,
);

class BalancesSelectedMonthNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void previousMonth() => state = DateTime(state.year, state.month - 1);

  void nextMonth() => state = DateTime(state.year, state.month + 1);

  void setMonth(DateTime month) => state = DateTime(month.year, month.month);
}

final balancesMonthlyTransactionsProvider = Provider<List<TransactionModel>>((
  ref,
) {
  final all = ref.watch(transactionProvider);
  final month = ref.watch(balancesSelectedMonthProvider);
  final repo = ref.watch(balancesRepositoryProvider);

  return repo.monthlyTransactions(all, month);
});

final balancesSummaryProvider = Provider<BalanceSummary>((ref) {
  final txs = ref.watch(balancesMonthlyTransactionsProvider);
  final repo = ref.watch(balancesRepositoryProvider);
  return repo.summary(txs);
});

final balancesDailyExpenseProvider = Provider<List<DailyExpensePoint>>((ref) {
  final txs = ref.watch(balancesMonthlyTransactionsProvider);
  final repo = ref.watch(balancesRepositoryProvider);
  return repo.dailyExpenses(txs);
});

final balancesCategoryBreakdownProvider = Provider<Map<String, double>>((ref) {
  final txs = ref.watch(balancesMonthlyTransactionsProvider);
  final repo = ref.watch(balancesRepositoryProvider);
  return repo.categoryBreakdown(txs);
});

final balancesTopCategoryProvider = Provider<MapEntry<String, double>?>((ref) {
  final txs = ref.watch(balancesMonthlyTransactionsProvider);
  final repo = ref.watch(balancesRepositoryProvider);
  return repo.topExpenseCategory(txs);
});
