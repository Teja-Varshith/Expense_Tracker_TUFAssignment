import 'package:expense_tracker_tuf/models/transaction_model.dart';
import 'package:expense_tracker_tuf/services/hive_service.dart';
import 'package:uuid/uuid.dart';

class TransactionRepository {
  const TransactionRepository();

  List<TransactionModel> fetchAll() => HiveService.getAllTransactions();

  List<TransactionModel> fetchByMonth(int year, int month) =>
      HiveService.getTransactionsByMonth(year, month);

  Future<TransactionModel> add({
    required double amount,
    required String category,
    required TransactionType type,
    String note = '',
    DateTime? date,
  }) async {
    final tx = TransactionModel(
      id: const Uuid().v4(),
      amount: amount,
      category: category,
      type: type,
      note: note,
      date: date ?? DateTime.now(),
    );
    await HiveService.addTransaction(tx);
    return tx;
  }

  Future<void> update(TransactionModel tx) => HiveService.updateTransaction(tx);

  Future<void> delete(String id) => HiveService.deleteTransaction(id);
}
