import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/table_model.dart';

class TableCard extends StatelessWidget {
  final TableModel table;
  final bool isSelected;
  final VoidCallback onTap;
  const TableCard({super.key, required this.table, this.isSelected = false, required this.onTap});

  Color _bg() {
    switch (table.status) {
      case TableStatus.free: return AppColors.tableFreeBg;
      case TableStatus.busy: return AppColors.tableBusyBg;
      case TableStatus.billPending: return AppColors.tableBillBg;
    }
  }
  Color _fg() {
    switch (table.status) {
      case TableStatus.free: return AppColors.tableFree;
      case TableStatus.busy: return AppColors.tableBusy;
      case TableStatus.billPending: return AppColors.tableBill;
    }
  }
  IconData _icon() {
    switch (table.status) {
      case TableStatus.free: return Icons.check_circle_rounded;
      case TableStatus.busy: return Icons.restaurant_rounded;
      case TableStatus.billPending: return Icons.receipt_long_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? _fg() : _bg(),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? _fg() : _fg().withOpacity(0.2), width: isSelected ? 2.5 : 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_icon(), color: isSelected ? Colors.white : _fg(), size: 28),
            const SizedBox(height: 8),
            Text(table.label, style: AppTypography.titleMedium.copyWith(color: isSelected ? Colors.white : _fg(), fontWeight: FontWeight.w800, fontSize: 20)),
            const SizedBox(height: 2),
            Text(table.status.label, style: TextStyle(color: isSelected ? Colors.white.withOpacity(0.9) : _fg(), fontSize: 11, fontWeight: FontWeight.w600)),
            if (table.currentOrderCount != null && table.currentOrderCount! > 0)
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: isSelected ? Colors.white : _fg(), borderRadius: BorderRadius.circular(10)),
                child: Text('${table.currentOrderCount} art.', style: TextStyle(color: isSelected ? _fg() : Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
              ),
          ],
        ),
      ),
    );
  }
}
