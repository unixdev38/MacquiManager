import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../state/app_state.dart';
import '../widgets/empty_state.dart';
import '../models/stock.dart';

class StockScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onBack;
  const StockScreen({super.key, required this.appState, required this.onBack});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text('Stock', style: AppTypography.titleMedium),
            leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: widget.onBack),
            bottom: TabBar(controller: _tabController, tabs: const [Tab(text: 'Stock actuel'), Tab(text: 'Mouvements')]),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _stockList(),
              _movementList(),
            ],
          ),
        );
      },
    );
  }

  Widget _stockList() {
    final stock = widget.appState.stock;
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: stock.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (c, i) {
        final item = stock[i];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: item.isLow ? AppColors.warning : AppColors.borderLight, width: item.isLow ? 1.5 : 1)),
          child: Row(
            children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)), child: Center(child: Text(item.imageEmoji, style: const TextStyle(fontSize: 24)))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${item.drinkName} ${item.variantName}', style: AppTypography.titleSmall.copyWith(fontSize: 13)),
                Text('${item.formatLabel} • ${item.bottlesPerCarton} btl/carton', style: AppTypography.bodySmall),
                const SizedBox(height: 4),
                Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: item.isCritical ? AppColors.errorBg : (item.isLow ? AppColors.warningBg : AppColors.successBg), borderRadius: BorderRadius.circular(8)), child: Text('${item.quantityRemaining} btl', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: item.isCritical ? AppColors.error : (item.isLow ? AppColors.warning : AppColors.success)))),
                  const SizedBox(width: 6),
                  Text('${item.cartonsRemaining} cartons', style: AppTypography.bodySmall),
                  if (item.isLow) ...[const SizedBox(width: 6), const Icon(Icons.warning_rounded, size: 14, color: AppColors.warning)],
                ]),
              ])),
              Column(children: [
                IconButton(onPressed: () => _showReceptionDialog(item), icon: const Icon(Icons.add_box_rounded, color: AppColors.primary), tooltip: 'Réception'),
                IconButton(onPressed: () => _showCorrectionDialog(item), icon: const Icon(Icons.edit_rounded, size: 18), tooltip: 'Corriger'),
              ]),
            ],
          ),
        );
      },
    );
  }

  Widget _movementList() {
    final movements = widget.appState.movements;
    if (movements.isEmpty) return const EmptyState(emoji: '📦', title: 'Aucun mouvement', subtitle: 'Les réceptions et ventes apparaîtront ici.');
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: movements.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (c, i) {
        final m = movements[i];
        Color color;
        IconData icon;
        switch (m.type) {
          case StockMovementType.reception: color = AppColors.success; icon = Icons.inventory_rounded; break;
          case StockMovementType.sale: color = AppColors.primary; icon = Icons.point_of_sale_rounded; break;
          case StockMovementType.correction: color = AppColors.warning; icon = Icons.edit_rounded; break;
          case StockMovementType.loss: color = AppColors.error; icon = Icons.delete_rounded; break;
        }
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
          child: Row(children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 18)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(m.drinkLabel, style: AppTypography.titleSmall.copyWith(fontSize: 12)),
              Text('${m.type.label} • ${m.quantity > 0 ? '+' : ''}${m.quantity} btl ${m.cartons > 0 ? '(${m.cartons} cartons)' : ''}', style: AppTypography.bodySmall),
              Text('${m.date.hour}:${m.date.minute.toString().padLeft(2,'0')} • ${m.serverName ?? ''} ${m.note != null ? '• ${m.note}' : ''}', style: AppTypography.bodySmall.copyWith(fontSize: 10)),
            ])),
          ]),
        );
      },
    );
  }

  void _showReceptionDialog(StockItem item) {
    int cartons = 1;
    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setSt) => AlertDialog(
      title: Text('Réception ${item.drinkName}'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('${item.bottlesPerCarton} bouteilles par carton', style: AppTypography.bodySmall),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(onPressed: () => setSt(() => cartons = (cartons - 1).clamp(1, 100)), icon: const Icon(Icons.remove_circle_rounded)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)), child: Text('$cartons cartons', style: AppTypography.titleSmall)),
          IconButton(onPressed: () => setSt(() => cartons++), icon: const Icon(Icons.add_circle_rounded)),
        ]),
        const SizedBox(height: 12),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.successBg, borderRadius: BorderRadius.circular(10)), child: Text('${cartons * item.bottlesPerCarton} bouteilles reçues', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.success))),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
        ElevatedButton(onPressed: () { widget.appState.receiveStock(item.variantId, cartons); Navigator.pop(ctx); }, child: const Text('Confirmer')),
      ],
    )));
  }

  void _showCorrectionDialog(StockItem item) {
    final ctrl = TextEditingController(text: '${item.quantityRemaining}');
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Corriger le stock'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Stock actuel: ${item.quantityRemaining} bouteilles', style: AppTypography.bodySmall),
        const SizedBox(height: 12),
        TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Nouvelle quantité (btl)', border: OutlineInputBorder())),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
        ElevatedButton(onPressed: () { final newQty = int.tryParse(ctrl.text) ?? item.quantityRemaining; widget.appState.correctStock(item.variantId, newQty); Navigator.pop(ctx); }, child: const Text('Corriger')),
      ],
    ));
  }
}
