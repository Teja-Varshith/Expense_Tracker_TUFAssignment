import 'package:expense_tracker_tuf/core/app/app_colors.dart';
import 'package:expense_tracker_tuf/core/widgets/animated_toggle.dart';
import 'package:expense_tracker_tuf/core/widgets/app_snackbar.dart';
import 'package:expense_tracker_tuf/core/theme/theme_provider.dart';
import 'package:expense_tracker_tuf/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  int _tabIndex = 0;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  final _signInEmail = TextEditingController();
  final _signInPassword = TextEditingController();

  final _signUpName = TextEditingController();
  final _signUpEmail = TextEditingController();
  final _signUpPassword = TextEditingController();
  final _signUpConfirm = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _signInEmail.dispose();
    _signInPassword.dispose();
    _signUpName.dispose();
    _signUpEmail.dispose();
    _signUpPassword.dispose();
    _signUpConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 56),
                _headerSection(isDark),
                const SizedBox(height: 36),
                _authCard(isDark),
                const SizedBox(height: 28),
                _footerTerms(isDark),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PayUForward',
              style: GoogleFonts.dmSans(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                letterSpacing: -1.2,
                height: 1.1,
              ),
            ),
            IconButton(
              onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: Text(
            _tabIndex == 0 ? 'WELCOME BACK' : 'START TRACKING TODAY',
            key: ValueKey<int>(_tabIndex),
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              letterSpacing: 2.5,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _authCard(bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkAuthCard : AppColors.lightAuthCard,
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GET STARTED',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                _tabIndex == 0
                    ? 'sign in to your account'
                    : 'create a new account',
                key: ValueKey('subtitle_$_tabIndex'),
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ),
            const SizedBox(height: 22),
            AnimatedToggle(
              labels: const ['Sign In', 'Sign Up'],
              selectedIndex: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
            ),
            const SizedBox(height: 26),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axisAlignment: -1,
                    child: child,
                  ),
                );
              },
              child: _tabIndex == 0 ? _signInForm(isDark) : _signUpForm(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _signInForm(bool isDark) {
    return Column(
      key: const ValueKey('sign_in'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Email', isDark),
        const SizedBox(height: 6),
        TextFormField(
          controller: _signInEmail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'you@example.com'),
          validator: _validateEmail,
        ),
        const SizedBox(height: 20),
        _label('Password', isDark),
        const SizedBox(height: 6),
        TextFormField(
          controller: _signInPassword,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: '••••••••',
            suffixIcon: _visibilityToggle(
              obscure: _obscurePassword,
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          validator: _validatePassword,
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Forgot password?',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _neoPopSubmitButton(
          label: 'Sign In',
          onPressed: _handleSignIn,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _signUpForm(bool isDark) {
    return Column(
      key: const ValueKey('sign_up'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Full Name', isDark),
        const SizedBox(height: 6),
        TextFormField(
          controller: _signUpName,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'Jane Doe'),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Name is required' : null,
        ),
        const SizedBox(height: 20),
        _label('Email', isDark),
        const SizedBox(height: 6),
        TextFormField(
          controller: _signUpEmail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(hintText: 'you@example.com'),
          validator: _validateEmail,
        ),
        const SizedBox(height: 20),
        _label('Password', isDark),
        const SizedBox(height: 6),
        TextFormField(
          controller: _signUpPassword,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: '••••••••',
            suffixIcon: _visibilityToggle(
              obscure: _obscurePassword,
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          validator: _validatePassword,
        ),
        const SizedBox(height: 20),
        _label('Confirm Password', isDark),
        const SizedBox(height: 6),
        TextFormField(
          controller: _signUpConfirm,
          obscureText: _obscureConfirm,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: '••••••••',
            suffixIcon: _visibilityToggle(
              obscure: _obscureConfirm,
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Please confirm password';
            if (v != _signUpPassword.text) return 'Passwords do not match';
            return null;
          },
        ),
        const SizedBox(height: 24),
        _neoPopSubmitButton(
          label: 'Create Account',
          onPressed: _handleSignUp,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _label(String text, bool isDark) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _visibilityToggle({
    required bool obscure,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(
        obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
        size: 20,
        color: AppColors.darkTextMuted,
      ),
      onPressed: onPressed,
      splashRadius: 18,
    );
  }

  Widget _neoPopSubmitButton({
    required String label,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    final buttonColor = isDark ? Colors.white : AppColors.purple;
    final textColor = isDark ? const Color(0xFF0D0D0D) : Colors.white;
    final rightShadow = isDark
        ? Colors.white.withValues(alpha: 0.3)
        : AppColors.purple.withValues(alpha: 0.4);
    final bottomShadow = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : AppColors.purple.withValues(alpha: 0.2);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _isLoading ? 0.7 : 1.0,
      child: NeoPopButton(
        color: buttonColor,
        onTapUp: _isLoading ? () {} : onPressed,
        onTapDown: () {},
        parentColor: isDark ? AppColors.darkAuthCard : AppColors.lightAuthCard,
        buttonPosition: Position.center,
        depth: 4,
        rightShadowColor: rightShadow,
        bottomShadowColor: bottomShadow,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(textColor),
                    ),
                  )
                : Text(
                    label.toUpperCase(),
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      letterSpacing: 1.8,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _footerTerms(bool isDark) {
    return Center(
      child: Text(
        'I HAVE TAKEN CREDs APP DESIGN AS INSPIRATION TO MAKE THIS',
        textAlign: TextAlign.center,
        style: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          letterSpacing: 1.2,
          height: 1.6,
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Minimum 6 characters';
    return null;
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ref
          .read(userProvider.notifier)
          .signIn(email: _signInEmail.text.trim());
      if (mounted) {
        AppSnackbar.success(
          context,
          title: 'Welcome back',
          message: 'Signed in successfully.',
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.failure(
          context,
          title: 'Sign in failed',
          message: e.toString().replaceFirst('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ref
          .read(userProvider.notifier)
          .signUp(
            fullName: _signUpName.text.trim(),
            email: _signUpEmail.text.trim(),
          );
      if (mounted) {
        AppSnackbar.success(
          context,
          title: 'Account created',
          message: 'Sign up completed successfully.',
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.failure(
          context,
          title: 'Sign up failed',
          message: e.toString().replaceFirst('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
