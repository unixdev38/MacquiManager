import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../widgets/primary_button.dart';
import '../models/order.dart';

class ConfirmationScreen extends StatelessWidget {
  final Order order;
  final VoidCallback onBackToSale;
  const ConfirmationScreen({super.key, required this.order, required this.onBackToSale});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 88, height: 88,
                decoration: BoxDecoration(color: AppColors.successBg, shape: BoxShape.circle, border: Border.all(color: AppColors.success, width: 2)),
                child: const Icon(Icons.check_rounded, size: 48, color: AppColors.success),
              ),
              const SizedBox(height: 24),
              Text('Commande enregistrée', style: AppTypography.displayLarge.copyWith(fontSize: 24), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text('La commande a été envoyée au central', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
                child: Column(
                  children: [
                    _row('Référence', order.reference, isBold: true),
                    const Divider(height: 24),
                    _row('Table', order.tableLabel),
                    const SizedBox(height: 12),
                    _row('Heure', '${order.createdAt.hour.toString().padLeft(2,'0')}:${order.createdAt.minute.toString().padLeft(2,'0')}'),
                    const SizedBox(height: 12),
                    _row('Articles', '${order.itemsCount}'),
                    const Divider(height: 24),
                    _row('Montant total', '${order.total} FCFA', isTotal: true),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(label: 'Retour à la vente', icon: Icons.storefront_rounded, onPressed: onBackToSale),
              const SizedBox(height: 12),
              Text('Prête en cuisine • ${order.serverName ?? ''}', style: AppTypography.bodySmall, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false, bool isTotal = false}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: isTotal ? AppTypography.titleMedium : AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
      Text(value, style: isTotal ? AppTypography.titleLarge.copyWith(color: AppColors.primary) : (isBold ? AppTypography.titleSmall : AppTypography.bodyMedium)),
    ]);
  }
}
