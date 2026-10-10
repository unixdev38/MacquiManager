import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/drink.dart';
import 'quantity_badge.dart';

class DrinkCard extends StatelessWidget {
  final DrinkVariant variant;
  final String drinkShortName;
  final int quantity;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onPlus2;

  const DrinkCard({
    super.key,
    required this.variant,
    required this.drinkShortName,
    required this.quantity,
    required this.onTap,
    this.onDoubleTap,
    this.onPlus2,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = quantity > 0;
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image zone - IMAGE FIRST
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          variant.imageEmoji,
                          style: const TextStyle(fontSize: 42),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Info
                  Text(
                    drinkShortName,
                    style: AppTypography.titleSmall.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(variant.formatLabel, style: AppTypography.bodySmall.copyWith(fontSize: 10, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 4),
                      Text(variant.name, style: AppTypography.bodySmall.copyWith(fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${variant.priceSell} F',
                      style: AppTypography.priceMedium.copyWith(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (onPlus2 != null && isSelected) ...[
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: onPlus2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('+2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11), textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: QuantityBadge(quantity: quantity),
              ),
            if (!variant.isActive)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(Icons.block_rounded, color: AppColors.error, size: 28),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
