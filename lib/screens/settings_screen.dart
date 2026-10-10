import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../state/app_state.dart';

class SettingsScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onBack;
  const SettingsScreen({super.key, required this.appState, required this.onBack});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: Text('Paramètres', style: AppTypography.titleMedium), leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: widget.onBack)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _section('Maquis'),
              _tile(Icons.store_rounded, 'Nom du maquis', widget.appState.maquisName, () => _editText('Nom du maquis', widget.appState.maquisName, (v) => setState(() => widget.appState.maquisName = v))),
              _tile(Icons.person_rounded, 'Serveur / Téléphone', widget.appState.serverName, () => _editText('Serveur', widget.appState.serverName, (v) => setState(() => widget.appState.serverName = v))),
              const SizedBox(height: 16),
              _section('Connexion centrale'),
              _tile(Icons.computer_rounded, 'Adresse centrale', widget.appState.centralAddress, () => _editText('Adresse centrale', widget.appState.centralAddress, (v) => setState(() => widget.appState.centralAddress = v))),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
                child: Row(children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: widget.appState.isConnected ? AppColors.success : AppColors.error, shape: BoxShape.circle)),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('État connexion', style: AppTypography.titleSmall.copyWith(fontSize: 13)), Text(widget.appState.isConnected ? 'Connecté au système central (simulé)' : 'Hors ligne - mode local', style: AppTypography.bodySmall)])),
                  Switch(value: widget.appState.isConnected, onChanged: (v) => setState(() => widget.appState.isConnected = v), activeColor: AppColors.success),
                ]),
              ),
              const SizedBox(height: 16),
              _section('Préférences'),
              _switchTile(Icons.volume_up_rounded, 'Sons', 'Bip à l\'ajout d\'article', widget.appState.soundEnabled, (v) => setState(() => widget.appState.soundEnabled = v)),
              _switchTile(Icons.vibration_rounded, 'Vibration', 'Vibration légère à l\'ajout', widget.appState.vibrationEnabled, (v) => setState(() => widget.appState.vibrationEnabled = v)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.textSecondary), const SizedBox(width: 6), Text('À propos', style: AppTypography.titleSmall)]),
                  const SizedBox(height: 8),
                  Text('Maquis Manager v1.0.0 - Maquette Flutter IMAGE FIRST. Données locales simulées. Aucune connexion réelle au central dans cette version.', style: AppTypography.bodySmall),
                  const SizedBox(height: 8),
                  Text('Architecture prévue: ordinateur central dans le maquis, téléphones en Wi-Fi local.', style: AppTypography.bodySmall.copyWith(fontStyle: FontStyle.italic)),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _section(String title) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1, color: AppColors.textSecondary)));

  Widget _tile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: ListTile(leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 18)), title: Text(title, style: AppTypography.titleSmall.copyWith(fontSize: 13)), subtitle: Text(subtitle, style: AppTypography.bodySmall), trailing: const Icon(Icons.chevron_right_rounded, size: 18), onTap: onTap),
    );
  }

  Widget _switchTile(IconData icon, String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: ListTile(leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 18)), title: Text(title, style: AppTypography.titleSmall.copyWith(fontSize: 13)), subtitle: Text(subtitle, style: AppTypography.bodySmall), trailing: Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary)),
    );
  }

  void _editText(String label, String initial, Function(String) onSave) {
    final ctrl = TextEditingController(text: initial);
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text(label),
      content: TextField(controller: ctrl, decoration: InputDecoration(labelText: label, border: const OutlineInputBorder())),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')), ElevatedButton(onPressed: () { onSave(ctrl.text); Navigator.pop(ctx); }, child: const Text('Enregistrer'))],
    ));
  }
}
