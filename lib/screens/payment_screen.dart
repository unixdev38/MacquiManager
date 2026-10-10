import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../state/app_state.dart';
import '../models/order.dart';
import '../widgets/primary_button.dart';
import '../core/constants.dart';

class PaymentScreen extends StatefulWidget {
  final AppState appState;
  final String orderId;
  final VoidCallback onBack;
  final VoidCallback onPaid;
  const PaymentScreen({super.key, required this.appState, required this.orderId, required this.onBack, required this.onPaid});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = AppConstants.paymentMethods.first;
  bool isPaid = false;

  @override
  Widget build(BuildContext context) {
    final order = widget.appState.orders.firstWhere((o) => o.id == widget.orderId, orElse: () => widget.appState.history.firstWhere((o) => o.id == widget.orderId));
    final remaining = order.remaining;
    if (isPaid) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 88, height: 88, decoration: const BoxDecoration(color: AppColors.successBg, shape: BoxShape.circle), child: const Icon(Icons.check_rounded, size: 48, color: AppColors.success)),
              const SizedBox(height: 20),
              Text('Paiement confirmé', style: AppTypography.titleLarge),
              const SizedBox(height: 8),
              Text('${order.total} FCFA payé via $selectedMethod', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 32),
              PrimaryButton(label: 'Retour à la vente', icon: Icons.storefront_rounded, onPressed: widget.onPaid),
            ]),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Paiement'), leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: widget.onBack)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Commande', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)), Text(order.reference, style: AppTypography.titleSmall)]),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Table', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)), Text(order.tableLabel, style: AppTypography.titleSmall)]),
                const Divider(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Total à payer', style: AppTypography.titleMedium), Text('${order.total} FCFA', style: AppTypography.titleLarge.copyWith(color: AppColors.primary))]),
                if (order.amountPaid != null && order.amountPaid! > 0) ...[
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Déjà payé', style: AppTypography.bodySmall), Text('${order.amountPaid} F', style: AppTypography.bodySmall)]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Reste', style: AppTypography.titleSmall), Text('$remaining F', style: AppTypography.titleSmall.copyWith(color: AppColors.error))]),
                ],
              ]),
            ),
            const SizedBox(height: 20),
            Text('Mode de paiement', style: AppTypography.titleSmall),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.6),
              itemCount: AppConstants.paymentMethods.length,
              itemBuilder: (c, i) {
                final method = AppConstants.paymentMethods[i];
                final isSelected = selectedMethod == method;
                IconData icon;
                switch (method) {
                  case 'Espèces': icon = Icons.payments_rounded; break;
                  case 'Mobile Money': icon = Icons.phone_iphone_rounded; break;
                  case 'Wave': icon = Icons.waves_rounded; break;
                  default: icon = Icons.credit_card_rounded;
                }
                return GestureDetector(
                  onTap: () => setState(() => selectedMethod = method),
                  child: Container(
                    decoration: BoxDecoration(color: isSelected ? AppColors.primary : AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: isSelected ? 2 : 1)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(icon, color: isSelected ? Colors.white : AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(method, style: TextStyle(fontWeight: FontWeight.w700, color: isSelected ? Colors.white : AppColors.textPrimary)),
                    ]),
                  ),
                );
              },
            ),
            const Spacer(),
            PrimaryButton(label: 'Confirmer le paiement • ${remaining > 0 ? remaining : order.total} F', icon: Icons.check_circle_rounded, onPressed: () {
              widget.appState.payOrder(order.id, selectedMethod, remaining > 0 ? remaining : order.total);
              setState(() => isPaid = true);
            }),
          ],
        ),
      ),
    );
  }
}
