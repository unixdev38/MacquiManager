import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../state/app_state.dart';
import '../widgets/order_card.dart';
import '../widgets/empty_state.dart';

class HistoryScreen extends StatefulWidget {
  final AppState appState;
  final Function(String orderId) onOrderTap;
  final VoidCallback onBack;
  const HistoryScreen({super.key, required this.appState, required this.onOrderTap, required this.onBack});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String filter = 'today';

  bool _matchesFilter(DateTime date) {
    final now = DateTime.now();
    if (filter == 'today') return date.day == now.day && date.month == now.month && date.year == now.year;
    if (filter == 'yesterday') { final y = now.subtract(const Duration(days: 1)); return date.day == y.day && date.month == y.month && date.year == y.year; }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        final filtered = widget.appState.history.where((o) => _matchesFilter(o.createdAt)).toList();
        final total = filtered.fold(0, (sum, o) => sum + o.total);
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: Text('Historique des ventes', style: AppTypography.titleMedium), leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: widget.onBack)),
          body: Column(
            children: [
              Container(
                color: AppColors.surface,
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _filterBtn('Aujourd\'hui', 'today'),
                        const SizedBox(width: 8),
                        _filterBtn('Hier', 'yesterday'),
                        const SizedBox(width: 8),
                        _filterBtn('Tout', 'all'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12)),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${filtered.length} ventes', style: AppTypography.titleSmall), Text('Filtre: $filter', style: AppTypography.bodySmall)]),
                        Text('$total FCFA', style: AppTypography.titleMedium.copyWith(color: AppColors.primary)),
                      ]),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? EmptyState(emoji: '📊', title: 'Aucune vente', subtitle: 'Aucune vente trouvée pour cette période.')
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (c, i) => OrderCard(order: filtered[i], onTap: () => widget.onOrderTap(filtered[i].id)),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterBtn(String label, String id) {
    final sel = filter == id;
    return Expanded(child: GestureDetector(onTap: () => setState(() => filter = id), child: Container(padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: sel ? AppColors.primary : AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)), child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: sel ? Colors.white : AppColors.textPrimary)))));
  }
}
