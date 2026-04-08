import 'package:expense_tracker_tuf/core/app/app_colors.dart';
import 'package:expense_tracker_tuf/core/widgets/category_icon.dart';
import 'package:expense_tracker_tuf/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isIncome = transaction.type == TransactionType.income;

    final tile = GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            CategoryIcon.fromCategory(transaction.category),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.category.toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (transaction.note.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      transaction.note,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 2),
                  Text(
                    DateFormat.MMMd().format(transaction.date),
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),

            Text(
              '${isIncome ? '+' : '-'}Rs ${transaction.amount.toStringAsFixed(0)}',
              style: TextStyle(
                color: isIncome ? AppColors.income : AppColors.expense,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );

    if (onDelete != null) {
      return Dismissible(
        key: ValueKey(transaction.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete!(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: AppColors.expense.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.delete_rounded,
            color: AppColors.expense,
          ),
        ),
        child: tile,
      );
    }

    return tile;
  }
}
