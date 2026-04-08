import 'package:expense_tracker_tuf/core/app/app_colors.dart';
import 'package:expense_tracker_tuf/core/theme/theme_provider.dart';
import 'package:expense_tracker_tuf/core/widgets/app_snackbar.dart';
import 'package:expense_tracker_tuf/core/widgets/animated_toggle.dart';
import 'package:expense_tracker_tuf/providers/transaction_provider.dart';
import 'package:expense_tracker_tuf/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _tabIndex = 0;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(userProvider);
    final spent = ref.watch(totalSpentProvider);
    final balance = ref.watch(totalBalanceProvider);

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _profileHeader()),
              SliverToBoxAdapter(child: _heroCard(user?.fullName ?? 'User', isDark)),
              SliverToBoxAdapter(child: _summaryStrip(spent, balance, isDark)),
              SliverToBoxAdapter(child: _toggleSection(user, isDark)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 18, 24, 120),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    child: _tabIndex == 0
                        ? _preview(user?.email ?? '-', spent, balance, isDark)
                        : _edit(isDark),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileHeader() {
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
                'PROFILE',
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
                  IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                      size: 22,
                    ),
                    onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
                    visualDensity: VisualDensity.compact,
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          size: 22,
                        ),
                        onPressed: () {},
                        visualDensity: VisualDensity.compact,
                      ),
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
        
          const SizedBox(height: 6),
          Text(
            'PROFILE OVERVIEW',
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

  Widget _heroCard(String name, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.purple.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  name.isEmpty ? 'U' : name[0].toUpperCase(),
                  style: GoogleFonts.dmSans(
                    color: AppColors.purple,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your account details',
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
          ],
        ),
      ),
    );
  }

  Widget _summaryStrip(double spent, double balance, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
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
              label: 'SPENT',
              value: 'Rs ${spent.toStringAsFixed(0)}',
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
              value: 'Rs ${balance.toStringAsFixed(0)}',
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
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleSection(dynamic user, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACCOUNT PANEL',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedToggle(
            labels: const ['Preview', 'Edit'],
            selectedIndex: _tabIndex,
            onChanged: (i) {
              if (i == 1 && user != null) {
                _nameCtrl.text = user.fullName;
                _emailCtrl.text = user.email;
              }
              setState(() => _tabIndex = i);
            },
          ),
        ],
      ),
    );
  }

  Widget _preview(String email, double spent, double balance, bool isDark) {
    return Container(
      key: const ValueKey('preview'),
      padding: const EdgeInsets.all(16),
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
          _detailRow('Email', email, isDark),
          const SizedBox(height: 14),
          _detailRow('Total spending', 'Rs ${spent.toStringAsFixed(0)}', isDark),
          const SizedBox(height: 14),
          _detailRow('Current balance', 'Rs ${balance.toStringAsFixed(0)}', isDark),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: NeoPopButton(
              color: AppColors.expense,
              onTapUp: () => ref.read(userProvider.notifier).signOut(),
              onTapDown: () {},
              parentColor: isDark ? AppColors.darkCard : AppColors.lightCard,
              buttonPosition: Position.center,
              depth: 3,
              rightShadowColor: AppColors.expense.withValues(alpha: 0.45),
              bottomShadowColor: AppColors.expense.withValues(alpha: 0.25),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Center(
                  child: Text(
                    'SIGN OUT',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _edit(bool isDark) {
    return Column(
      key: const ValueKey('edit'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _lbl('FULL NAME', isDark),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameCtrl,
          decoration: const InputDecoration(hintText: 'Enter your full name'),
        ),
        const SizedBox(height: 18),
        _lbl('EMAIL', isDark),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailCtrl,
          decoration: const InputDecoration(hintText: 'Enter your email'),
        ),
        const SizedBox(height: 18),
        _lbl('PASSWORD', isDark),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passCtrl,
          obscureText: _obscure,
          decoration: InputDecoration(
            hintText: 'Create a password',
            suffixIcon: IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 20,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
        ),
        const SizedBox(height: 18),
        _lbl('CONFIRM PASSWORD', isDark),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmCtrl,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Confirm your password'),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: NeoPopButton(
            color: isDark ? Colors.white : AppColors.purple,
            onTapUp: _save,
            onTapDown: () {},
            parentColor: isDark ? AppColors.darkBg : AppColors.lightBg,
            buttonPosition: Position.center,
            depth: 4,
            rightShadowColor: isDark
                ? Colors.white.withValues(alpha: 0.3)
                : AppColors.purple.withValues(alpha: 0.4),
            bottomShadowColor: isDark
                ? Colors.white.withValues(alpha: 0.15)
                : AppColors.purple.withValues(alpha: 0.2),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Center(
                child: Text(
                  'UPDATE DETAILS',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkBg : Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _lbl(String t, bool isDark) {
    return Text(
      t,
      style: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        letterSpacing: 1.3,
      ),
    );
  }

  void _save() {
    final n = _nameCtrl.text.trim();
    final e = _emailCtrl.text.trim();
    if (n.isNotEmpty || e.isNotEmpty) {
      ref.read(userProvider.notifier).updateUser(fullName: n.isEmpty ? null : n, email: e.isEmpty ? null : e);
      setState(() => _tabIndex = 0);
      AppSnackbar.success(
        context,
        title: 'Profile updated',
        message: 'Your details were saved.',
      );
    }
  }
}
