import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../state/app_state.dart';
import '../models/order.dart';
import '../widgets/primary_button.dart';

class OrderDetailScreen extends StatelessWidget {
  final AppState appState;
  final String orderId;
  final VoidCallback onBack;
  final VoidCallback onPay;
  final VoidCallback onAddItems;
  const OrderDetailScreen({super.key, required this.appState, required this.orderId, required this.onBack, required this.onPay, required this.onAddItems});

  @override
  Widget build(BuildContext context) {
    final order = [...appState.orders, ...appState.history].firstWhere((o) => o.id == orderId, orElse: () => appState.orders.first);
    final isHistory = appState.history.any((o) => o.id == orderId);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(order.reference, style: AppTypography.titleSmall),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: onBack),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: order.status == OrderStatus.paid ? AppColors.successBg : AppColors.warningBg, borderRadius: BorderRadius.circular(8)),
            child: Text(order.status.label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: order.status == OrderStatus.paid ? AppColors.success : AppColors.warning)),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
            child: Row(
              children: [
                _info(Icons.table_restaurant_rounded, 'Table', order.tableLabel),
                const SizedBox(width: 16),
                _info(Icons.access_time_rounded, 'Heure', '${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2,'0')}'),
                const SizedBox(width: 16),
                _info(Icons.person_rounded, 'Serveur', order.serverName ?? '-'),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: order.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (c, i) {
                final item = order.items[i];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
                  child: Row(
                    children: [
                      Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)), child: Center(child: Text(item.imageEmoji, style: const TextStyle(fontSize: 22)))),
                      const SizedBox(width: 10),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${item.drinkName} ${item.variantName}', style: AppTypography.titleSmall.copyWith(fontSize: 13)),
                        Text('${item.quantity} x ${item.unitPrice} F • ${item.formatLabel}', style: AppTypography.bodySmall),
                      ])),
                      Text('${item.subtotal} F', style: AppTypography.priceMedium.copyWith(fontSize: 14)),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).padding.bottom + 16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: const Offset(0,-4))]),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Total', style: AppTypography.titleMedium), Text('${order.total} FCFA', style: AppTypography.titleLarge.copyWith(color: AppColors.primary))]),
                if (isHistory && order.paymentMethod != null) ...[
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Payé via ${order.paymentMethod}', style: AppTypography.bodySmall), const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18)]),
                ],
                const SizedBox(height: 16),
                if (!isHistory) ...[
                  Row(children: [
                    Expanded(child: PrimaryButton(label: 'Ajouter', isSecondary: true, icon: Icons.add_rounded, onPressed: onAddItems)),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: PrimaryButton(label: 'Encaisser', icon: Icons.payments_rounded, onPressed: onPay)),
                  ]),
                ] else
                  PrimaryButton(label: 'Retour', isSecondary: true, onPressed: onBack),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, size: 16, color: AppColors.textSecondary),
      const SizedBox(width: 4),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
      ]),
    ]);
  }
}
