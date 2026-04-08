import 'package:expense_tracker_tuf/core/app/app_colors.dart';
import 'package:expense_tracker_tuf/features/balances/screens/balances_screen.dart';
import 'package:expense_tracker_tuf/features/home/screens/homepage.dart';
import 'package:expense_tracker_tuf/features/profile/screens/profile_screen.dart';
import 'package:expense_tracker_tuf/features/transactions/screens/add_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomePage(),
    BalancesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _bottomNavBar(),
      floatingActionButton: _fab(),
    );
  }

  Widget _bottomNavBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkNavBar : AppColors.lightNavBar,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.home_rounded, 'HOME'),
              _navItem(1, Icons.account_balance_wallet_rounded, 'BALANCES'),
              _navItem(2, Icons.person_rounded, 'PROFILE'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeColor = isDark ? Colors.white : AppColors.purple;
    final inactiveColor =
        isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: isSelected
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: activeColor,
                    width: 2,
                  ),
                ),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.dmSans(
                color: isSelected ? activeColor : inactiveColor,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: _openAddTransaction,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isDark ? Colors.white : AppColors.purple,
          border: isDark
              ? Border.all(
                  color: Colors.white.withValues(alpha: 0.2), width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.15)
                  : AppColors.purple.withValues(alpha: 0.4),
              offset: const Offset(4, 4),
              blurRadius: 0,
            ),
            BoxShadow(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : AppColors.purple.withValues(alpha: 0.2),
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Icon(
          Icons.add_rounded,
          size: 28,
          color: isDark ? AppColors.darkBg : Colors.white,
        ),
      ),
    );
  }

  void _openAddTransaction() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTransactionScreen(),
    );
  }
}
