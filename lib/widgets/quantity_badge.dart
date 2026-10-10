import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class QuantityBadge extends StatelessWidget {
  final int quantity;
  final double size;
  const QuantityBadge({super.key, required this.quantity, this.size = 26});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(size/2),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 6, offset: const Offset(0,2))],
      ),
      child: Center(child: Text('$quantity', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13))),
    );
  }
}
class LargeQuantityBadge extends StatelessWidget {
  final int quantity;
  const LargeQuantityBadge({super.key, required this.quantity});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
      child: Text('x$quantity', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
    );
  }
}
