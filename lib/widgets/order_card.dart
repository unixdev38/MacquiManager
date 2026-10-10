import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;
  const OrderCard({super.key, required this.order, required this.onTap});

  Color _statusColor() {
    switch (order.status) {
      case OrderStatus.open: return AppColors.tableBusy;
      case OrderStatus.pendingPayment: return AppColors.tableBill;
      case OrderStatus.paid: return AppColors.tableFree;
      case OrderStatus.cancelled: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: const Offset(0,2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: _statusColor().withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text(order.status.label, style: TextStyle(color: _statusColor(), fontWeight: FontWeight.w700, fontSize: 11)),
                ),
                const Spacer(),
                Text(order.reference, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _iconBox(Icons.table_restaurant_rounded, order.tableLabel),
                const SizedBox(width: 10),
                _iconBox(Icons.access_time_rounded, '${order.createdAt.hour.toString().padLeft(2,'0')}:${order.createdAt.minute.toString().padLeft(2,'0')}'),
                const SizedBox(width: 10),
                _iconBox(Icons.inventory_2_rounded, '${order.itemsCount} art.'),
                const Spacer(),
                Text('${order.total} F', style: AppTypography.priceMedium),
              ],
            ),
            if (order.serverName != null) ...[
              const SizedBox(height: 8),
              Text('Serveur: ${order.serverName}', style: AppTypography.bodySmall),
            ],
          ],
        ),
      ),
    );
  }

  Widget _iconBox(IconData icon, String label) {
    return Row(children: [
      Icon(icon, size: 14, color: AppColors.textSecondary),
      const SizedBox(width: 4),
      Text(label, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500)),
    ]);
  }
}
