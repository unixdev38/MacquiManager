import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../state/app_state.dart';
import '../widgets/order_card.dart';
import '../widgets/empty_state.dart';

class OrdersScreen extends StatelessWidget {
  final AppState appState;
  final Function(String orderId) onOrderTap;
  final VoidCallback onBack;
  const OrdersScreen({super.key, required this.appState, required this.onOrderTap, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text('Commandes en cours (${appState.orders.length})', style: AppTypography.titleMedium),
            leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: onBack),
          ),
          body: appState.orders.isEmpty
              ? EmptyState(emoji: '📋', title: 'Aucune commande', subtitle: 'Les commandes validées apparaîtront ici. Elles restent ouvertes jusqu\'au paiement.', actionLabel: 'Retour vente', onAction: onBack)
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: appState.orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (c, i) {
                    final order = appState.orders[i];
                    return OrderCard(order: order, onTap: () => onOrderTap(order.id));
                  },
                ),
        );
      },
    );
  }
}
