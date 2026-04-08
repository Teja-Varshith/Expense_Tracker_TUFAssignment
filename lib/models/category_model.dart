import 'package:expense_tracker_tuf/core/app/app_colors.dart';
import 'package:expense_tracker_tuf/models/transaction_model.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final IconData icon;
  final Color color;
  final TransactionType type;

  const CategoryModel({
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });

  static const List<CategoryModel> expenseCategories = [
    CategoryModel(
      name: 'Food',
      icon: Icons.restaurant_rounded,
      color: AppColors.catFood,
      type: TransactionType.expense,
    ),
    CategoryModel(
      name: 'Transport',
      icon: Icons.directions_car_rounded,
      color: AppColors.catTransport,
      type: TransactionType.expense,
    ),
    CategoryModel(
      name: 'Shopping',
      icon: Icons.shopping_bag_rounded,
      color: AppColors.catShopping,
      type: TransactionType.expense,
    ),
    CategoryModel(
      name: 'Health',
      icon: Icons.medical_services_rounded,
      color: AppColors.catHealth,
      type: TransactionType.expense,
    ),
    CategoryModel(
      name: 'Entertainment',
      icon: Icons.movie_rounded,
      color: AppColors.catEntertain,
      type: TransactionType.expense,
    ),
    CategoryModel(
      name: 'Bills',
      icon: Icons.receipt_long_rounded,
      color: AppColors.catBills,
      type: TransactionType.expense,
    ),
    CategoryModel(
      name: 'Education',
      icon: Icons.school_rounded,
      color: AppColors.catEducation,
      type: TransactionType.expense,
    ),
    CategoryModel(
      name: 'Other',
      icon: Icons.more_horiz_rounded,
      color: AppColors.catOther,
      type: TransactionType.expense,
    ),
  ];

  static const List<CategoryModel> incomeCategories = [
    CategoryModel(
      name: 'Salary',
      icon: Icons.work_rounded,
      color: AppColors.catSalary,
      type: TransactionType.income,
    ),
    CategoryModel(
      name: 'Freelance',
      icon: Icons.laptop_rounded,
      color: AppColors.catFreelance,
      type: TransactionType.income,
    ),
    CategoryModel(
      name: 'Investment',
      icon: Icons.trending_up_rounded,
      color: AppColors.catInvestment,
      type: TransactionType.income,
    ),
    CategoryModel(
      name: 'Gift',
      icon: Icons.card_giftcard_rounded,
      color: AppColors.catGift,
      type: TransactionType.income,
    ),
    CategoryModel(
      name: 'Other',
      icon: Icons.more_horiz_rounded,
      color: AppColors.catOther,
      type: TransactionType.income,
    ),
  ];

  static List<CategoryModel> categoriesFor(TransactionType type) {
    return type == TransactionType.income
        ? incomeCategories
        : expenseCategories;
  }

  static CategoryModel? find(String name, TransactionType type) {
    final list = categoriesFor(type);
    try {
      return list.firstWhere(
        (c) => c.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
