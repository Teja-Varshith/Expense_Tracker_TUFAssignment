import 'package:expense_tracker_tuf/core/app/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;

  const CategoryIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 44,
    this.iconSize = 22,
  });

  factory CategoryIcon.fromCategory(String category) {
    final data = _categoryData(category);
    return CategoryIcon(icon: data.$1, color: data.$2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: color,
        size: iconSize,
      ),
    );
  }

  static (IconData, Color) _categoryData(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return (Icons.restaurant_rounded, AppColors.catFood);
      case 'transport':
        return (Icons.directions_car_rounded, AppColors.catTransport);
      case 'shopping':
        return (Icons.shopping_bag_rounded, AppColors.catShopping);
      case 'health':
        return (Icons.medical_services_rounded, AppColors.catHealth);
      case 'entertainment':
        return (Icons.movie_rounded, AppColors.catEntertain);
      case 'bills':
        return (Icons.receipt_long_rounded, AppColors.catBills);
      case 'education':
        return (Icons.school_rounded, AppColors.catEducation);
      case 'salary':
        return (Icons.work_rounded, AppColors.catSalary);
      case 'freelance':
        return (Icons.laptop_rounded, AppColors.catFreelance);
      case 'investment':
        return (Icons.trending_up_rounded, AppColors.catInvestment);
      case 'gift':
        return (Icons.card_giftcard_rounded, AppColors.catGift);
      default:
        return (Icons.more_horiz_rounded, AppColors.catOther);
    }
  }
}
