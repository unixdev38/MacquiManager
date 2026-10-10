import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../state/app_state.dart';
import '../widgets/drink_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/connection_indicator.dart';
import '../widgets/table_card.dart';
import '../models/table_model.dart';

class SaleScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onViewCart;
  final VoidCallback onOpenOrders;
  final VoidCallback onOpenMenu;
  const SaleScreen({super.key, required this.appState, required this.onViewCart, required this.onOpenOrders, required this.onOpenMenu});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  void _showTableSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 16),
                  Row(children: [
                    Text('Choisir une table', style: AppTypography.titleMedium),
                    const Spacer(),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                  ]),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.95),
                      itemCount: widget.appState.tables.length,
                      itemBuilder: (c, i) {
                        final table = widget.appState.tables[i];
                        return TableCard(
                          table: table,
                          isSelected: widget.appState.selectedTable?.id == table.id,
                          onTap: () {
                            widget.appState.selectTable(table);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        final variants = widget.appState.filteredVariants;
        final cartCount = widget.appState.cartCount;
        final cartTotal = widget.appState.cartTotal;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBar(
              backgroundColor: AppColors.surface,
              elevation: 0,
              leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: widget.onOpenMenu),
              title: Row(children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.local_bar_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 8),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.appState.maquisName, style: AppTypography.titleSmall.copyWith(fontSize: 14)),
                  ConnectionIndicator(isConnected: widget.appState.isConnected),
                ]),
              ]),
              actions: [
                Stack(
                  children: [
                    IconButton(onPressed: widget.onOpenOrders, icon: const Icon(Icons.receipt_long_rounded)),
                    if (widget.appState.openOrdersCount > 0)
                      Positioned(
                        right: 6, top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: Text('${widget.appState.openOrdersCount}', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
          body: Column(
            children: [
              // Table selector + categories
              Container(
                color: AppColors.surface,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Column(
                  children: [
                    // Selected table chip
                    GestureDetector(
                      onTap: _showTableSelector,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: widget.appState.selectedTable?.status == TableStatus.free ? AppColors.tableFreeBg : AppColors.tableBusyBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.table_restaurant_rounded, size: 18, color: widget.appState.selectedTable?.status == TableStatus.free ? AppColors.tableFree : AppColors.tableBusy),
                            ),
                            const SizedBox(width: 10),
                            Text('Table: ${widget.appState.selectedTable?.label ?? '-'}', style: AppTypography.titleSmall),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: widget.appState.selectedTable?.status == TableStatus.free ? AppColors.tableFree : AppColors.tableBusy,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(widget.appState.selectedTable?.status.label ?? '', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                            ),
                            const Spacer(),
                            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.appState.categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (c, i) {
                          final cat = widget.appState.categories[i];
                          return CategoryChip(
                            category: cat,
                            isSelected: widget.appState.selectedCategoryId == cat.id,
                            onTap: () => widget.appState.selectCategory(cat.id),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: variants.length,
                  itemBuilder: (c, i) {
                    final variant = variants[i];
                    final drink = widget.appState.drinks.firstWhere((d) => d.id == variant.drinkId);
                    final qty = widget.appState.getQuantityForVariant(variant.id);
                    return DrinkCard(
                      variant: variant,
                      drinkShortName: drink.shortName,
                      quantity: qty,
                      onTap: () {
                        widget.appState.addToCart(variant);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${drink.shortName} ${variant.name} ajouté'),
                            duration: const Duration(milliseconds: 700),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.textPrimary,
                          ),
                        );
                      },
                      onDoubleTap: () {
                        widget.appState.addMultipleToCart(variant, 2);
                      },
                      onPlus2: qty > 0 ? () => widget.appState.addMultipleToCart(variant, 2) : null,
                    );
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: cartCount > 0
              ? Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: MediaQuery.of(context).padding.bottom + 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: const Offset(0, -4))],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12)),
                        child: Row(children: [
                          const Icon(Icons.shopping_bag_rounded, size: 18, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text('$cartCount', style: AppTypography.titleMedium.copyWith(color: AppColors.primary)),
                          const SizedBox(width: 4),
                          Text('art.', style: AppTypography.bodySmall),
                        ]),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Total', style: AppTypography.bodySmall),
                          Text('$cartTotal FCFA', style: AppTypography.titleMedium.copyWith(color: AppColors.primary)),
                        ]),
                      ),
                      ElevatedButton(
                        onPressed: widget.onViewCart,
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: const Row(mainAxisSize: MainAxisSize.min, children: [
                          Text('Voir commande', style: TextStyle(fontWeight: FontWeight.w800)),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded, size: 18),
                        ]),
                      ),
                    ],
                  ),
                )
              : null,
        );
      },
    );
  }
}
