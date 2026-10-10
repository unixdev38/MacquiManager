import 'package:flutter/material.dart';
import '../models/category.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;
  const CategoryChip({super.key, required this.category, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : category.bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(category.icon, size: 18, color: isSelected ? Colors.white : category.color),
            const SizedBox(width: 6),
            Text(category.name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: isSelected ? Colors.white : category.color)),
          ],
        ),
      ),
    );
  }
}
