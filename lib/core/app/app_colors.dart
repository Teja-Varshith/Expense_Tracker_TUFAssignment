import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // prevent instantiation

  // ── Backgrounds ──────────────────────────────────────────
  static const darkBg         = Color(0xFF0D0D0D);
  static const darkSurface    = Color(0xFF1A1A1A);
  static const darkCard       = Color(0xFF1E1E1E);

  static const lightBg        = Color(0xFFF5F6FA);
  static const lightSurface   = Color(0xFFFFFFFF);
  static const lightCard      = Color(0xFFFFFFFF);

  // ── Accents ───────────────────────────────────────────────
  static const purple         = Color(0xFF9B59FF);
  static const purpleLight    = Color(0xFFB47EFF);
  static const pink           = Color(0xFFFF4ECD);
  static const blue           = Color(0xFF3D5AF1);

  // ── Semantic ──────────────────────────────────────────────
  static const income         = Color(0xFF38EF7D);
  static const expense        = Color(0xFFFF4E6A);
  static const warning        = Color(0xFFFFC107);

  // ── Text ──────────────────────────────────────────────────
  static const darkTextPrimary   = Color(0xFFF5F5F5);
  static const darkTextSecondary = Color(0xFF8A8A9A);
  static const darkTextMuted     = Color(0xFF4A4A5A);

  static const lightTextPrimary   = Color(0xFF1A1A2E);
  static const lightTextSecondary = Color(0xFF5A5A7A);
  static const lightTextMuted     = Color(0xFFAAAAAA);

  // ── Gradients ─────────────────────────────────────────────
  static const primaryGradient = [Color(0xFF9B59FF), Color(0xFFFF4ECD)];  // purple → pink

  static const balanceCardGradient = [Color(0xFF1DB954), Color(0xFF2EC4B6)]; // teal card

  static const incomeGradient  = [Color(0xFF11998E), Color(0xFF38EF7D)];  // green
  static const expenseGradient = [Color(0xFFEB3349), Color(0xFFFF4E6A)];  // red

  static const donutGradient   = [Color(0xFF9B59FF), Color(0xFF3D5AF1), Color(0xFF38EF7D), Color(0xFFFFC107)];
  // used for pie/donut chart segments — one per category

  // ── Category Colors ───────────────────────────────────────
  static const catFood        = Color(0xFFFF6B6B);
  static const catTransport   = Color(0xFF4ECDC4);
  static const catShopping    = Color(0xFFFFE66D);
  static const catHealth      = Color(0xFF6BCB77);
  static const catEntertain   = Color(0xFF9B59FF);
  static const catBills       = Color(0xFFFF9A3C);
  static const catSalary      = Color(0xFF38EF7D);
  static const catFreelance   = Color(0xFF3D5AF1);
  static const catOther       = Color(0xFF8A8A9A);

  // ── Divider / Border ──────────────────────────────────────
  static const darkBorder     = Color(0xFF2A2A3A);
  static const lightBorder    = Color(0xFFE0E0E0);

  // ── Helper: gradient by category ─────────────────────────
  static Color categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':        return catFood;
      case 'transport':   return catTransport;
      case 'shopping':    return catShopping;
      case 'health':      return catHealth;
      case 'entertain':   return catEntertain;
      case 'bills':       return catBills;
      case 'salary':      return catSalary;
      case 'freelance':   return catFreelance;
      default:            return catOther;
    }
  }

  // ── Helper: balance card gradient based on balance ───────
  static List<Color> balanceGradient(double balance) {
    if (balance < 0) return expenseGradient;   // red when negative
    if (balance < 1000) return [Color(0xFFFFC107), Color(0xFFFF9A3C)]; // warning orange
    return balanceCardGradient;  // healthy teal
  }
}