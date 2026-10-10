import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../state/app_state.dart';
import '../widgets/order_line.dart';
import '../widgets/empty_state.dart';
import '../widgets/primary_button.dart';

class CartScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback onContinue;
  final VoidCallback onValidate;
  const CartScreen({super.key, required this.appState, required this.onContinue, required this.onValidate});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final cart = appState.currentCart;
        if (cart.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Commande'), leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: onContinue)),
            body: EmptyState(
              emoji: '🛒',
              title: 'Panier vide',
              subtitle: 'Touchez les images des boissons pour ajouter des articles à la commande.',
              actionLabel: 'Retour à la vente',
              onAction: onContinue,
            ),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Row(children: [
              Text('Commande', style: AppTypography.titleMedium),
              const SizedBox(width: 8),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)), child: Text('${appState.cartCount} art.', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
            ]),
            leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: onContinue),
            actions: [
              TextButton(onPressed: () => appState.clearCart(), child: const Text('Vider', style: TextStyle(color: AppColors.error))),
            ],
          ),
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
                child: Row(children: [
                  const Icon(Icons.table_restaurant_rounded, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('Table: ${appState.selectedTable?.label ?? '-'}', style: AppTypography.titleSmall),
                  const Spacer(),
                  Text('${appState.selectedTable?.status.label ?? ''}', style: AppTypography.bodySmall),
                ]),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: cart.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (c, i) {
                    final item = cart[i];
                    return OrderLine(
                      item: item,
                      onIncrement: () => appState.incrementCartItem(item.variantId),
                      onDecrement: () => appState.decrementCartItem(item.variantId),
                      onDelete: () => appState.removeFromCart(item.variantId),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).padding.bottom + 16),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: const Offset(0,-4))]),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Sous-total', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      Text('${appState.cartTotal} F', style: AppTypography.bodyMedium),
                    ]),
                    const SizedBox(height: 6),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Total à payer', style: AppTypography.titleMedium),
                      Text('${appState.cartTotal} FCFA', style: AppTypography.titleLarge.copyWith(color: AppColors.primary)),
                    ]),
                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(child: PrimaryButton(label: 'Continuer', isSecondary: true, onPressed: onContinue, icon: Icons.add_rounded)),
                      const SizedBox(width: 12),
                      Expanded(flex: 2, child: PrimaryButton(label: 'Valider la commande', onPressed: onValidate, icon: Icons.check_rounded)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
