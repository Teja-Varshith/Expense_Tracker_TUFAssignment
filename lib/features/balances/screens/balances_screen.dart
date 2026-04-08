import 'package:expense_tracker_tuf/core/app/app_colors.dart';
import 'package:expense_tracker_tuf/core/theme/theme_provider.dart';
import 'package:expense_tracker_tuf/features/balances/balances_controller.dart';
import 'package:expense_tracker_tuf/features/balances/balances_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BalancesScreen extends ConsumerWidget {
  const BalancesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final summary = ref.watch(balancesSummaryProvider);
    final selectedMonth = ref.watch(balancesSelectedMonthProvider);
    final dailyPoints = ref.watch(balancesDailyExpenseProvider);
    final breakdown = ref.watch(balancesCategoryBreakdownProvider);
    final topCategory = ref.watch(balancesTopCategoryProvider);
    final monthlyTxCount = ref.watch(balancesMonthlyTransactionsProvider).length;
    final activeDays = dailyPoints.length;
    final avgSpendPerActiveDay = activeDays == 0
      ? 0.0
      : summary.expense / activeDays;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _header(context, ref)),
            SliverToBoxAdapter(
              child: _overviewStrip(
                context,
                isDark,
                monthlyTxCount,
                activeDays,
                avgSpendPerActiveDay,
              ),
            ),
            SliverToBoxAdapter(
              child: _monthSelector(context, ref, selectedMonth, isDark),
            ),
            SliverToBoxAdapter(
              child: _spendingTrendCard(context, dailyPoints, selectedMonth),
            ),
            SliverToBoxAdapter(
              child: _categorySplitCard(context, breakdown),
            ),
            SliverToBoxAdapter(
              child: _insightCards(context, summary.balance, topCategory, isDark),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 96)),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BALANCE',
                style: GoogleFonts.dmSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  letterSpacing: -0.8,
                ),
              ),
              Row(
                children: [
                  _iconBtn(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    isDark,
                    onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
                  ),
                  _iconBtn(Icons.search_rounded, isDark),
                  Stack(
                    children: [
                      _iconBtn(Icons.notifications_outlined, isDark),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.badgeRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
         
          Text(
            'BALANCES OVERVIEW',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              letterSpacing: 2.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, bool isDark, {VoidCallback? onPressed}) {
    return IconButton(
      icon: Icon(
        icon,
        color: isDark ? Colors.white : AppColors.lightTextPrimary,
        size: 22,
      ),
      onPressed: onPressed ?? () {},
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _overviewStrip(
    BuildContext context,
    bool isDark,
    int monthlyTxCount,
    int activeDays,
    double avgSpendPerActiveDay,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            _metricCell(
              label: 'TXNS',
              value: monthlyTxCount.toString(),
              color: AppColors.teal,
              isDark: isDark,
            ),
            _divider(isDark),
            _metricCell(
              label: 'ACTIVE DAYS',
              value: activeDays.toString(),
              color: AppColors.warning,
              isDark: isDark,
            ),
            _divider(isDark),
            _metricCell(
              label: 'AVG SPEND',
              value: _formatMoney(avgSpendPerActiveDay),
              color: AppColors.expense,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Container(
      width: 1,
      height: 72,
      color: isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.06),
    );
  }

  Widget _metricCell({
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          children: [
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.dmSans(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _monthSelector(
    BuildContext context,
    WidgetRef ref,
    DateTime selectedMonth,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => ref
                  .read(balancesSelectedMonthProvider.notifier)
                  .previousMonth(),
              icon: Icon(
                Icons.chevron_left_rounded,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    DateFormat.MMMM().format(selectedMonth).toUpperCase(),
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.8,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${selectedMonth.year}',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => ref
                  .read(balancesSelectedMonthProvider.notifier)
                  .nextMonth(),
              icon: Icon(
                Icons.chevron_right_rounded,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _spendingTrendCard(
    BuildContext context,
    List<DailyExpensePoint> points,
    DateTime selectedMonth,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MONTHLY TREND',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                letterSpacing: 1.8,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${DateFormat.MMMM().format(selectedMonth)} expenses by day',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 14),
            if (points.isEmpty)
              _emptyCard(context, 'No expense data for this month')
            else
              SizedBox(
                height: 190,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: (points
                                .map((e) => e.amount)
                                .reduce((a, b) => a > b ? a : b) *
                            1.25)
                        .clamp(100.0, double.infinity),
                    barTouchData: BarTouchData(enabled: true),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles:
                          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles:
                          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          getTitlesWidget: (value, meta) {
                            if (value % 5 != 0) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                value.toInt().toString(),
                                style: GoogleFonts.dmSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? AppColors.darkTextMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: points
                        .map(
                          (point) => BarChartGroupData(
                            x: point.day,
                            barRods: [
                              BarChartRodData(
                                toY: point.amount,
                                width: 12,
                                borderRadius: BorderRadius.circular(6),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.teal.withValues(alpha: 0.6),
                                    AppColors.teal,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _categorySplitCard(BuildContext context, Map<String, double> breakdown) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CATEGORY SPLIT',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                letterSpacing: 1.8,
              ),
            ),
            const SizedBox(height: 14),
            if (breakdown.isEmpty)
              _emptyCard(context, 'Add expense transactions to see category split')
            else
              _pieAndLegend(context, breakdown),
          ],
        ),
      ),
    );
  }

  Widget _pieAndLegend(BuildContext context, Map<String, double> breakdown) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final entries = breakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = entries.fold(0.0, (sum, e) => sum + e.value);

    return SizedBox(
      height: 210,
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 44,
                sections: entries.map((entry) {
                  final percentage = total == 0 ? 0 : (entry.value / total) * 100;
                  return PieChartSectionData(
                    color: AppColors.categoryColor(entry.key),
                    value: entry.value,
                    title: '${percentage.toStringAsFixed(0)}%',
                    radius: 54,
                    titleStyle: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
            ),
          ),
          const SizedBox(width: 14),
          SizedBox(
            width: 120,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length > 5 ? 5 : entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.categoryColor(entry.key),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.key,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _insightCards(
    BuildContext context,
    double balance,
    MapEntry<String, double>? topCategory,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NET STATUS',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                      letterSpacing: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    balance >= 0 ? 'Healthy' : 'Overspent',
                    style: GoogleFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: balance >= 0 ? AppColors.income : AppColors.expense,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOP EXPENSE',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                      letterSpacing: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    topCategory?.key ?? 'None',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    topCategory == null ? '-' : _formatMoney(topCategory.value),
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.expense,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyCard(BuildContext context, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 130,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightCardAlt,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color:
              isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  String _formatMoney(double amount) {
    return 'Rs ${amount.toStringAsFixed(0)}';
  }
}
