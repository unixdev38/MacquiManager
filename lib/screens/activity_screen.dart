import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../state/app_state.dart';

class ActivityScreen extends StatelessWidget {
  final AppState appState;
  final VoidCallback onBack;
  const ActivityScreen({super.key, required this.appState, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: Text('Résumé d\'activité', style: AppTypography.titleMedium), leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: onBack)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  Expanded(child: _statCard('Ventes du jour', '${appState.totalSalesToday} F', Icons.payments_rounded, AppColors.primary)),
                  const SizedBox(width: 12),
                  Expanded(child: _statCard('Commandes', '${appState.openOrdersCount + appState.history.length}', Icons.receipt_long_rounded, AppColors.tableBusy)),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _statCard('En cours', '${appState.openOrdersCount}', Icons.restaurant_rounded, AppColors.warning)),
                  const SizedBox(width: 12),
                  Expanded(child: _statCard('À payer', '${appState.pendingPaymentCount}', Icons.warning_rounded, AppColors.tableBill)),
                ]),
                const SizedBox(height: 20),
                Text('Boissons les plus vendues', style: AppTypography.titleSmall),
                const SizedBox(height: 12),
                ...appState.topDrinks.map((e) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
                  child: Row(children: [
                    Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: const Center(child: Text('🍺', style: TextStyle(fontSize: 18)))),
                    const SizedBox(width: 10),
                    Expanded(child: Text(e.key, style: AppTypography.titleSmall.copyWith(fontSize: 13))),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)), child: Text('${e.value} vendus', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11))),
                  ]),
                )),
                const SizedBox(height: 20),
                Text('État du stock', style: AppTypography.titleSmall),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight)),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Total références', style: AppTypography.bodySmall), Text('${appState.stock.length}', style: AppTypography.titleSmall)]),
                    const Divider(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Stock faible', style: AppTypography.bodySmall), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.warningBg, borderRadius: BorderRadius.circular(6)), child: Text('${appState.stock.where((s) => s.isLow).length}', style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.w700)))]),
                    const Divider(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Critique', style: AppTypography.bodySmall), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(6)), child: Text('${appState.stock.where((s) => s.isCritical).length}', style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)))]),
                  ]),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    const Icon(Icons.info_rounded, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(child: Text('Données simulées en local. Connexion au central: ${appState.isConnected ? 'OK' : 'Hors ligne'} • ${appState.centralAddress}', style: AppTypography.bodySmall)),
                  ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 20)),
        const SizedBox(height: 12),
        Text(value, style: AppTypography.titleLarge.copyWith(fontSize: 18)),
        Text(label, style: AppTypography.bodySmall),
      ]),
    );
  }
}
