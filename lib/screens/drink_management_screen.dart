import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../state/app_state.dart';
import '../widgets/primary_button.dart';

class DrinkManagementScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onBack;
  const DrinkManagementScreen({super.key, required this.appState, required this.onBack});

  @override
  State<DrinkManagementScreen> createState() => _DrinkManagementScreenState();
}

class _DrinkManagementScreenState extends State<DrinkManagementScreen> {
  String filter = 'all';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        final drinks = filter == 'all' ? widget.appState.drinks : widget.appState.drinks.where((d) => d.categoryId == filter).toList();
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text('Gestion boissons', style: AppTypography.titleMedium),
            leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: widget.onBack),
            actions: [IconButton(onPressed: () => _showAddDialog(), icon: const Icon(Icons.add_rounded))],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  children: [
                    _filterChip('Tout', 'all'),
                    ...widget.appState.categories.where((c) => c.id != 'all').map((c) => _filterChip(c.name, c.id)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: drinks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (c, i) {
                    final drink = drinks[i];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(drink.shortName, style: AppTypography.titleSmall),
                            const SizedBox(width: 8),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(6)), child: Text(drink.brand, style: const TextStyle(fontSize: 10))),
                            const Spacer(),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.edit_rounded, size: 18)),
                          ]),
                          const SizedBox(height: 8),
                          ...drink.variants.map((v) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: v.isActive ? AppColors.background : AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10), border: Border.all(color: v.isActive ? AppColors.borderLight : AppColors.border)),
                            child: Row(children: [
                              Text(v.imageEmoji, style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 10),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('${v.name} • ${v.formatLabel}', style: AppTypography.titleSmall.copyWith(fontSize: 12)),
                                Text('Achat: ${v.priceBuy}F • Vente: ${v.priceSell}F • ${v.bottlesPerCarton} btl/carton', style: AppTypography.bodySmall.copyWith(fontSize: 10)),
                              ])),
                              Switch(value: v.isActive, onChanged: (_) => widget.appState.toggleDrinkActive(v.id), activeColor: AppColors.primary),
                            ]),
                          )),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(onPressed: () => _showAddDialog(), label: const Text('Ajouter'), icon: const Icon(Icons.add_rounded)),
        );
      },
    );
  }

  Widget _filterChip(String label, String id) {
    final isSel = filter == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(label: Text(label, style: TextStyle(fontSize: 12, color: isSel ? Colors.white : AppColors.textPrimary)), selected: isSel, onSelected: (_) => setState(() => filter = id), selectedColor: AppColors.primary, backgroundColor: AppColors.surfaceVariant),
    );
  }

  void _showAddDialog() {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Ajouter une boisson'),
      content: const Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextField(decoration: InputDecoration(labelText: 'Nom (ex: Brakina)')),
        SizedBox(height: 12),
        TextField(decoration: InputDecoration(labelText: 'Format (ex: 33cl)')),
        SizedBox(height: 12),
        TextField(decoration: InputDecoration(labelText: 'Prix vente FCFA'), keyboardType: TextInputType.number),
        SizedBox(height: 12),
        TextField(decoration: InputDecoration(labelText: 'Bouteilles par carton'), keyboardType: TextInputType.number),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
        ElevatedButton(onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Boisson ajoutée (simulation)'))); }, child: const Text('Ajouter')),
      ],
    ));
  }
}
