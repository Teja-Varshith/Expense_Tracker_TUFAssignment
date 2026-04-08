import 'package:expense_tracker_tuf/core/app/app_colors.dart';
import 'package:expense_tracker_tuf/core/theme/theme_provider.dart';
import 'package:expense_tracker_tuf/core/widgets/credit_card_widget.dart';
import 'package:expense_tracker_tuf/core/widgets/empty_state.dart';
import 'package:expense_tracker_tuf/core/widgets/transaction_tile.dart';
import 'package:expense_tracker_tuf/features/home/home_controller.dart';
import 'package:expense_tracker_tuf/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _header()),
            SliverToBoxAdapter(child: _cardDeck()),
            SliverToBoxAdapter(child: _cardSwipeHint()),
            SliverToBoxAdapter(child: _summaryStrip()),
            SliverToBoxAdapter(child: _transactionHeader()),
            _transactionList(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(userProvider);
    final firstName = user?.fullName.split(' ').first ?? 'User';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PayUForward',
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
          const SizedBox(height: 20),
          Text(
            'HEY, ${firstName.toUpperCase()}',
            style: GoogleFonts.dmSans(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'TRACK YOUR MONEY',
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

  List<Widget> _buildCards() {
    final user = ref.watch(userProvider);
    final holderName = user?.fullName ?? 'USER';

    return [
      CreditCardWidget(
        bankName: 'ADRBank',
        cardNumber: '8763111122220329',
        holderName: holderName,
        expiry: '10/28',
        gradient: AppColors.balanceCardGradient,
      ),
      CreditCardWidget(
        bankName: 'PayU Card',
        cardNumber: '4521987600123456',
        holderName: holderName,
        expiry: '03/29',
        gradient: AppColors.primaryGradient,
      ),
      CreditCardWidget(
        bankName: 'FinServ',
        cardNumber: '5678123409876543',
        holderName: holderName,
        expiry: '06/27',
        gradient: AppColors.incomeGradient,
      ),
    ];
  }

  Widget _cardDeck() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: ClipRect(
        child: Theme(
          data: Theme.of(context).copyWith(
            shadowColor: Colors.transparent,
            cardTheme: Theme.of(
              context,
            ).cardTheme.copyWith(elevation: 0, shadowColor: Colors.transparent),
          ),
          child: SizedBox(
            height: 230,
            child: _SwipeCardDeck(cards: _buildCards()),
          ),
        ),
      ),
    );
  }

  Widget _cardSwipeHint() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.swipe_rounded,
            size: 13,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
          const SizedBox(width: 5),
          Text(
            'Swipe to change card',
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryStrip() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final income = ref.watch(monthlyIncomeProvider);
    final expense = ref.watch(monthlyExpenseProvider);
    final balance = ref.watch(monthlyBalanceProvider);

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
            _summaryCell(
              label: 'INCOME',
              value: '₹${income.toStringAsFixed(0)}',
              color: AppColors.income,
              isDark: isDark,
            ),
            Container(
              width: 1,
              height: 72,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
            ),
            _summaryCell(
              label: 'SPENT',
              value: '₹${expense.toStringAsFixed(0)}',
              color: AppColors.expense,
              isDark: isDark,
            ),
            Container(
              width: 1,
              height: 72,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
            ),
            _summaryCell(
              label: 'BALANCE',
              value: '₹${balance.toStringAsFixed(0)}',
              color: balance >= 0 ? AppColors.income : AppColors.expense,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCell({
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
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final transactions = ref.watch(monthlyTransactionsProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECENT ACTIVITY',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  letterSpacing: 2.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                ),
                child: Text(
                  '${transactions.length}',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.swipe_left_rounded,
                size: 13,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
              const SizedBox(width: 5),
              Text(
                'Slide left to delete',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteDialog() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Transaction',
          style: GoogleFonts.dmSans(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this transaction? This action cannot be undone.',
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            height: 1.5,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.expense.withValues(alpha: 0.12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.expense,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Widget _transactionList() {
    final transactions = ref.watch(monthlyTransactionsProvider);
    final recent = transactions.take(15).toList();

    if (recent.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyState(
          icon: Icons.receipt_long_rounded,
          title: 'No transactions yet',
          subtitle: 'Tap + to add your first transaction',
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
      sliver: SliverList.separated(
        itemCount: recent.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final tx = recent[index];

          return Dismissible(
            key: ValueKey(tx.id),
            direction: DismissDirection.endToStart,

            confirmDismiss: (_) => _showDeleteDialog(),

            onDismissed: (_) {
              ref.read(transactionProvider.notifier).delete(tx.id);
            },

            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: AppColors.expense.withValues(alpha: 0.12),
              child: Icon(
                Icons.delete_outline_rounded,
                color: AppColors.expense,
                size: 22,
              ),
            ),

            child: TransactionTile(transaction: tx),
          );
        },
      ),
    );
  }
}


class _SwipeCardDeck extends StatefulWidget {
  final List<Widget> cards;
  const _SwipeCardDeck({required this.cards});

  @override
  State<_SwipeCardDeck> createState() => _SwipeCardDeckState();
}

class _SwipeCardDeckState extends State<_SwipeCardDeck>
    with SingleTickerProviderStateMixin {
  int _current = 0;
  double _dragDx = 0;
  bool _dragging = false;
  late AnimationController _dismissCtrl;
  late Animation<double> _dismissAnim;

  @override
  void initState() {
    super.initState();
    _dismissCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _dismissAnim = CurvedAnimation(
      parent: _dismissCtrl,
      curve: Curves.easeInOut,
    );
    _dismissCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        setState(() {
          _current = (_current + 1) % widget.cards.length;
          _dragDx = 0;
          _dragging = false;
        });
        _dismissCtrl.reset();
      }
    });
  }

  @override
  void dispose() {
    _dismissCtrl.dispose();
    super.dispose();
  }

  int _idx(int offset) => (_current + offset) % widget.cards.length;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        _buildBackCard(_idx(2), scale: 0.86, yOffset: 18, opacity: 1),
        _buildBackCard(_idx(1), scale: 0.93, yOffset: 30, opacity: 1),
        _buildFrontCard(),
      ],
    );
  }

  Widget _buildBackCard(
    int idx, {
    required double scale,
    required double yOffset,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(0, yOffset),
        child: Transform.scale(
          scale: scale,
          alignment: Alignment.topCenter,
          child: widget.cards[idx],
        ),
      ),
    );
  }

  Widget _buildFrontCard() {
    return GestureDetector(
      onHorizontalDragStart: (_) => setState(() => _dragging = true),
      onHorizontalDragUpdate: (d) => setState(() => _dragDx += d.delta.dx),
      onHorizontalDragEnd: (_) {
        if (_dragDx.abs() > 80) {
          _dismissCtrl.forward();
        } else {
          setState(() {
            _dragDx = 0;
            _dragging = false;
          });
        }
      },
      child: AnimatedBuilder(
        animation: _dismissAnim,
        builder: (_, child) {
          final totalDx =
              _dragDx + (_dismissAnim.value * 500 * (_dragDx >= 0 ? 1 : -1));
          return Transform.translate(
            offset: Offset(totalDx, 0),
            child: Transform.rotate(angle: totalDx * 0.0012, child: child),
          );
        },
        child: widget.cards[_current],
      ),
    );
  }
}
