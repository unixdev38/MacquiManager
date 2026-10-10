import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/drink.dart';

class OrderLine extends StatelessWidget {
  final OrderItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;
  const OrderLine({super.key, required this.item, required this.onIncrement, required this.onDecrement, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(item.imageEmoji, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${item.drinkName} ${item.variantName}', style: AppTypography.titleSmall.copyWith(fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Row(children: [
                  Text('${item.unitPrice} F', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(width: 6),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1), decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(4)), child: Text(item.formatLabel, style: const TextStyle(fontSize: 10))),
                ]),
                const SizedBox(height: 4),
                Text('${item.subtotal} FCFA', style: AppTypography.priceSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _qtyBtn(Icons.remove_rounded, onDecrement),
              Container(width: 36, alignment: Alignment.center, child: Text('${item.quantity}', style: AppTypography.titleSmall)),
              _qtyBtn(Icons.add_rounded, onIncrement, isPrimary: true),
            ],
          ),
          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.textHint)),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, {bool isPrimary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(color: isPrimary ? AppColors.primary : AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 18, color: isPrimary ? Colors.white : AppColors.textPrimary),
      ),
    );
  }
}
